/**
 * Rustkey Core C API Header
 * Pure Vietnamese Telex composition engine.
 * https://namtr.dev
 */

#ifndef RUSTKEY_H
#define RUSTKEY_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct RustkeyTelex RustkeyTelex;

/**
 * Creates a new Telex composition state.
 * @param modern_orthography false: hòa, khỏe, thúy. true: hoà, khoẻ, thuý.
 * @param auto_restore_english Restore English words on word boundary.
 */
RustkeyTelex* rustkey_telex_new(bool modern_orthography, bool auto_restore_english);

/**
 * Frees a Telex instance.
 */
void rustkey_telex_free(RustkeyTelex* telex);

/**
 * Resets the composition state (e.g. on cursor move, focus change).
 */
void rustkey_telex_reset(RustkeyTelex* telex);

/**
 * Sets the input method: 0 = Telex, 1 = VNI.
 */
void rustkey_telex_set_input_method(RustkeyTelex* telex, uint32_t method);

/**
 * Configures modern orthography (false: hòa, khỏe; true: hoà, khoẻ).
 */
void rustkey_telex_set_modern_orthography(RustkeyTelex* telex, bool modern);

/**
 * Configures automatic restoration of English words on word boundaries.
 */
void rustkey_telex_set_auto_restore_english(RustkeyTelex* telex, bool enable);

/**
 * Enables or disables macro expansion.
 */
void rustkey_telex_set_macro_enabled(RustkeyTelex* telex, bool enable);

/**
 * Adds a macro shortcut mapping.
 */
void rustkey_telex_add_macro(RustkeyTelex* telex, const char* key, const char* value);

/**
 * Clears all macro shortcut mappings.
 */
void rustkey_telex_clear_macros(RustkeyTelex* telex);

/**
 * Adds an English/foreign custom word to avoid accents.
 */
void rustkey_telex_add_custom_word(RustkeyTelex* telex, const char* word);

/**
 * Clears all custom words.
 */
void rustkey_telex_clear_custom_words(RustkeyTelex* telex);

/**
 * Checks if the composition buffer is empty.
 */
bool rustkey_telex_is_empty(RustkeyTelex* telex);

/**
 * Gets the currently displayed preedit composition text.
 * Text that does not fit is cut at a UTF-8 character boundary.
 * @return Bytes written to out_buf, excluding the terminating null byte.
 */
size_t rustkey_telex_get_displayed(RustkeyTelex* telex, char* out_buf, size_t out_buf_len);

/**
 * Processes a single character key press.
 * @param ch Unicode codepoint.
 * @param out_handled Set to true if the key was handled by the engine.
 * @param out_backspaces Number of characters to delete before the cursor.
 * @param out_commit Buffer to receive the UTF-8 text to insert.
 * @param out_commit_capacity Size of out_commit buffer.
 * @return true if handled, false if passed to the app.
 */
bool rustkey_telex_key(
    RustkeyTelex* telex,
    uint32_t ch,
    bool* out_handled,
    size_t* out_backspaces,
    char* out_commit,
    size_t out_commit_capacity
);

/**
 * Processes a backspace key.
 * @return true if handled, false if passed to the app.
 */
bool rustkey_telex_backspace(
    RustkeyTelex* telex,
    bool* out_handled,
    size_t* out_backspaces,
    char* out_commit,
    size_t out_commit_capacity
);

/**
 * Feeds a string of keys and writes the composed output to out_buf.
 * Output that does not fit is cut at a UTF-8 character boundary.
 * @return Bytes written to out_buf, excluding the terminating null byte.
 *         Less than the full output length when it was truncated.
 */
size_t rustkey_telex_feed(
    RustkeyTelex* telex,
    const char* input,
    char* out_buf,
    size_t out_buf_len
);

/**
 * Returns the version string of rustkey-core.
 */
const char* rustkey_version(void);

#ifdef __cplusplus
}
#endif

#endif /* RUSTKEY_H */
