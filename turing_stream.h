/*
 * tivodecode, (c) 2006, Jeremy Drake
 * See COPYING file for license terms
 */

#ifndef TURING_STREAM_H_
#define TURING_STREAM_H_
#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include "Turing.h"
#include "tivo-parse.h"

typedef struct turing_state_stream
{
    int cipher_pos;
    int cipher_len;

    int block_id;
    unsigned char stream_id;

    struct turing_state_stream * next;

    void * internal;
    unsigned char cipher_data[MAXSTREAM];
} turing_state_stream;

typedef struct
{
	unsigned char turingkey[20];

	turing_state_stream * active;
} turing_state;

unsigned int init_turing_from_file(turing_state * turing, void * tivofile, read_func_t read_handler, char * mak);
void setup_metadata_key(turing_state * turing, tivo_stream_chunk * xml, char * mak);
void setup_turing_key(turing_state * turing, tivo_stream_chunk * xml, char * mak);
void prepare_frame(turing_state * turing, unsigned char stream_id, int block_id);
void decrypt_buffer(turing_state * turing, unsigned char * buffer, size_t buffer_length);
void skip_turing_data(turing_state * turing, size_t bytes_to_skip);
void destruct_turing(turing_state * turing);

#ifdef __cplusplus
}
#endif
#endif // TURING_STREAM_H_

