#ifndef TURING_STREAM_H_
#define TURING_STREAM_H_

#include <stdio.h>
#include "Turing.h"
#include "happyfile.h"

typedef struct
{
    int cipher_pos;
    int cipher_len;

    int block_id;
    char stream_id;


    void * internal;
    char cipher_data[MAXSTREAM];
} turing_state_stream;

typedef struct
{
	char turingkey[20];

	turing_state_stream * active;

	turing_state_stream state_e0;
	turing_state_stream state_c0;
} turing_state;

off_t setup_turing_key(turing_state * turing, happy_file * tivofile, char * mak);
void prepare_frame(turing_state * turing, unsigned char stream_id, int block_id);
void decrypt_buffer(turing_state * turing, char * buffer, size_t buffer_length);

#endif // TURING_STREAM_H_

