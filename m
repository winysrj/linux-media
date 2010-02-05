Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab0BENmg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 08:42:36 -0500
Message-ID: <4B6C204C.1010407@redhat.com>
Date: Fri, 05 Feb 2010 14:42:36 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Luc Saillard <luc@saillard.org>,
	Thomas Kaiser <v4l@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH libv4l tree, RFC] libv4l: skip false Pixart markers with
 buffer copy
References: <4B67466F.1030301@freemail.hu> <4B6751F3.3040407@freemail.hu> <4B67FEAF.8050603@redhat.com> <4B6A83A9.4070500@freemail.hu>
In-Reply-To: <4B6A83A9.4070500@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/04/2010 09:22 AM, Németh Márton wrote:
> Hi,
>
> This is a proof-of-concept patch to try to decode the JPEG with PixArt markers.
>
> Please check whether it is working at your side. My experience is that the
> number of frames with glitch are reduced.
>

Hi,

Good job! I never noticed the ff ff ff xx markers where spaced a certain numbers
of bytes apart. Based on that I've written a different filtering function, which
at least for me completely removes all glitches!!

See:
http://linuxtv.org/hg/~hgoede/libv4l/rev/1fa67e17b77c

Thanks !!!

Regards,

Hans


> Regards,
>
> 	Márton Németh
>
> ---
> From: Márton Németh<nm127@freemail.hu>
>
> Before trying to decode the image data filter the PixArt markers out.
>
> Signed-off-by: Márton Németh<nm127@freemail.hu>
> ---
> diff -r 966f60c672e9 v4l2-apps/libv4l/libv4lconvert/tinyjpeg-internal.h
> --- a/v4l2-apps/libv4l/libv4lconvert/tinyjpeg-internal.h	Tue Feb 02 11:34:06 2010 +0100
> +++ b/v4l2-apps/libv4l/libv4lconvert/tinyjpeg-internal.h	Thu Feb 04 09:13:24 2010 +0100
> @@ -91,8 +91,11 @@
>     /* Private variables */
>     const unsigned char *stream_begin, *stream_end;
>     unsigned int stream_length;
> +  unsigned char *stream_begin_filtered, *stream_end_filtered;
> +  unsigned int stream_length_filtered;
>
>     const unsigned char *stream;	/* Pointer to the current stream */
> +  unsigned char *stream_filtered;
>     unsigned int reservoir, nbits_in_reservoir;
>
>     struct component component_infos[COMPONENTS];
> diff -r 966f60c672e9 v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c
> --- a/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Tue Feb 02 11:34:06 2010 +0100
> +++ b/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Thu Feb 04 09:13:24 2010 +0100
> @@ -312,19 +312,18 @@
>
>   /* Special Pixart versions of the *_nbits functions, these remove the special
>      ff ff ff xx sequences pixart cams insert from the bitstream */
> -#define pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,nbits_wanted) \
> +#define pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,stream_end,nbits_wanted) \
>   do { \
>      while (nbits_in_reservoir<nbits_wanted) \
>       { \
>         unsigned char c; \
> -      if (stream>= priv->stream_end) { \
> +      if (stream>= stream_end) { \
>   	snprintf(priv->error_string, sizeof(priv->error_string), \
>   	  "fill_nbits error: need %u more bits\n", \
>   	  nbits_wanted - nbits_in_reservoir); \
>   	longjmp(priv->jump_state, -EIO); \
>         } \
>         c = *stream++; \
> -      reservoir<<= 8; \
>         if (c == 0xff) { \
>   	switch (stream[0]) { \
>   	  case 0x00: \
> @@ -332,7 +331,7 @@
>   	    break; \
>   	  case 0xd9: /* EOF marker */ \
>   	    stream++; \
> -	    if (stream != priv->stream_end) { \
> +	    if (stream != stream_end) { \
>   	      snprintf(priv->error_string, sizeof(priv->error_string), \
>   		"Pixart JPEG error: premature EOF\n"); \
>   	      longjmp(priv->jump_state, -EIO); \
> @@ -340,14 +339,22 @@
>   	    break; \
>   	  case 0xff: \
>   	    if (stream[1] == 0xff) { \
> -		if (stream[2]<  7) { \
> +		if (stream[2] == 0) { \
> +		    stream += 3; \
> +		    c = *stream++; \
> +		    break; \
> +		} else if (stream[2] == 1) { \
> +		    stream += 3; \
> +		    c = *stream++; \
> +		    break; \
> +		} else if (stream[2] == 2) { \
>   		    stream += 3; \
>   		    c = *stream++; \
>   		    break; \
>   		} else if (stream[2] == 0xff) { \
> -		    /* four 0xff in a row: the first belongs to the image data */ \
> +		    /* four 0xff in a row: the first belongs to the image */ \
>   		    break; \
> -		}\
> +		} \
>   	    } \
>   	    /* Error fall through */ \
>   	  default: \
> @@ -358,15 +365,16 @@
>   	    longjmp(priv->jump_state, -EIO); \
>   	} \
>         } \
> +      reservoir<<= 8; \
>         reservoir |= c; \
>         nbits_in_reservoir+=8; \
>       } \
>   }  while(0);
>
>   /* Signed version !!!! */
> -#define pixart_get_nbits(reservoir,nbits_in_reservoir,stream,nbits_wanted,result) \
> +#define pixart_get_nbits(reservoir,nbits_in_reservoir,stream,stream_end,nbits_wanted,result) \
>   do { \
> -   pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,(nbits_wanted)); \
> +   pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,stream_end,(nbits_wanted)); \
>      result = ((reservoir)>>(nbits_in_reservoir-(nbits_wanted))); \
>      nbits_in_reservoir -= (nbits_wanted);  \
>      reservoir&= ((1U<<nbits_in_reservoir)-1); \
> @@ -374,9 +382,9 @@
>          result += (0xFFFFFFFFUL<<(nbits_wanted))+1; \
>   }  while(0);
>
> -#define pixart_look_nbits(reservoir,nbits_in_reservoir,stream,nbits_wanted,result) \
> +#define pixart_look_nbits(reservoir,nbits_in_reservoir,stream,stream_end,nbits_wanted,result) \
>   do { \
> -   pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,(nbits_wanted)); \
> +   pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,stream_end,(nbits_wanted)); \
>      result = ((reservoir)>>(nbits_in_reservoir-(nbits_wanted))); \
>   }  while(0);
>
> @@ -443,7 +451,8 @@
>     unsigned int extra_nbits, nbits;
>     uint16_t *slowtable;
>
> -  pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, HUFFMAN_HASH_NBITS, hcode);
> +  pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream_filtered,
> +		    priv->stream_end_filtered, HUFFMAN_HASH_NBITS, hcode);
>     value = huffman_table->lookup[hcode];
>     if (value>= 0)
>     {
> @@ -457,7 +466,8 @@
>      {
>        nbits = HUFFMAN_HASH_NBITS + 1 + extra_nbits;
>
> -     pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, nbits, hcode);
> +     pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream_filtered,
> +			priv->stream_end_filtered, nbits, hcode);
>        slowtable = huffman_table->slowtable[extra_nbits];
>        /* Search if the code is in this array */
>        while (slowtable[0]) {
> @@ -557,7 +567,8 @@
>     /* DC coefficient decoding */
>     huff_code = pixart_get_next_huffman_code(priv, c->DC_table);
>     if (huff_code) {
> -     pixart_get_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, huff_code, DCT[0]);
> +     pixart_get_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream_filtered,
> +		priv->stream_end_filtered, huff_code, DCT[0]);
>        DCT[0] += c->previous_DC;
>        c->previous_DC = DCT[0];
>     } else {
> @@ -585,7 +596,8 @@
>         {
>   	j += count_0;	/* skip count_0 zeroes */
>   	if (j<  64 ) {
> -	  pixart_get_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, size_val, DCT[j]);
> +	  pixart_get_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream_filtered,
> +			priv->stream_end_filtered, size_val, DCT[j]);
>   	  j++;
>   	}
>         }
> @@ -1611,8 +1623,8 @@
>   {
>     unsigned char marker;
>
> -  pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream,
> -		    8, marker);
> +  pixart_look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream_filtered,
> +		    priv->stream_end_filtered, 8, marker);
>     /* I think the marker indicates which quantization table to use, iow
>        a Pixart JPEG may have a different quantization table per MCU, most
>        MCU's have 0x44 as marker for which our special Pixart quantization
> @@ -2342,6 +2354,97 @@
>
>   int tinyjpeg_decode_planar(struct jdec_private *priv, int pixfmt);
>
> +static int memcpy_filter(unsigned char *dest, const unsigned char *src, int n)
> +{
> +	int i = 0;
> +	int j = 0;
> +	int state = 0;
> +	int last_i = 0;
> +
> +	i = 0;
> +	j = 0;
> +
> +	/* 5 bytes are already dropped in kernel: 0xff 0xff 0x00 0xff 0x96 */
> +	/* Copy the rest of 1024 bytes */
> +	memcpy(&(dest[j]),&(src[i]), 1024-5);
> +	i += 1024-5;
> +	j += 1024-5;
> +
> +	while (i<  n) {
> +		switch (state) {
> +			case 0:
> +				if (src[i] == 0xff)
> +					state = 1;
> +				else {
> +					state = 0;
> +					dest[j++] = src[i];
> +				}
> +				break;
> +			case 1:
> +				if (src[i] == 0xff)
> +					state = 2;
> +				else {
> +					state = 0;
> +					dest[j++] = src[i-1];
> +					dest[j++] = src[i];
> +				}
> +				break;
> +			case 2:
> +				switch (src[i]) {
> +					case 0xff:
> +						state = 3;
> +						break;
> +					default:
> +						state = 0;
> +						dest[j++] = src[i-2];
> +						dest[j++] = src[i-1];
> +						dest[j++] = src[i];
> +				}
> +				break;
> +			case 3:
> +				switch (src[i]) {
> +					case 0:
> +						/* found 0xff 0xff 0xff 0x00 */
> +						state = 0;
> +						break;
> +					case 1:
> +						/* found 0xff 0xff 0xff 0x01 */
> +						last_i = i+1;
> +						memcpy(&(dest[j]),&(src[i+1]), 1024);
> +						i += 1024;
> +						j += 1024;
> +						state = 0;
> +						break;
> +					case 2:
> +						/* found 0xff 0xff 0xff 0x02 */
> +						last_i = i+1;
> +						memcpy(&(dest[j]),&(src[i+1]), 512);
> +						i += 512;
> +						j += 512;
> +						state = 0;
> +						break;
> +					case 0xff:
> +						printf(" ! ");
> +						dest[j++] = src[i-3];
> +						state = 3;
> +						break;
> +
> +					default:
> +						state = 0;
> +						dest[j++] = src[i-3];
> +						dest[j++] = src[i-2];
> +						dest[j++] = src[i-1];
> +						dest[j++] = src[i];
> +				
> +				}
> +		}
> +		i++;
> +	}
> +
> +	return j;
> +}
> +
> +
>   /**
>    * Decode and convert the jpeg image into @pixfmt@ image
>    *
> @@ -2356,8 +2459,10 @@
>     const convert_colorspace_fct *colorspace_array_conv;
>     convert_colorspace_fct convert_to_pixfmt;
>
> -  if (setjmp(priv->jump_state))
> +  if (setjmp(priv->jump_state)) {
> +    printf("ERROR: %s\n", priv->error_string);
>       return -1;
> +  }
>
>     if (priv->flags&  TINYJPEG_FLAGS_PLANAR_JPEG)
>       return tinyjpeg_decode_planar(priv, pixfmt);
> @@ -2369,8 +2474,20 @@
>     bytes_per_blocklines[2] = 0;
>
>     decode_mcu_table = decode_mcu_3comp_table;
> -  if (priv->flags&  TINYJPEG_FLAGS_PIXART_JPEG)
> +  if (priv->flags&  TINYJPEG_FLAGS_PIXART_JPEG) {
> +    int len_filtered = 0;
> +
> +    priv->stream_begin_filtered = malloc(priv->stream_end - priv->stream);
> +    if (priv->stream_begin_filtered) {
> +	memset(priv->stream_begin_filtered, 0, priv->stream_end - priv->stream);
> +	priv->stream_filtered = priv->stream_begin_filtered;
> +	len_filtered = memcpy_filter(priv->stream_filtered,
> +			priv->stream, priv->stream_end - priv->stream);
> +    }
> +    priv->stream_end_filtered = priv->stream_filtered + len_filtered;
> +
>       decode_mcu_table = pixart_decode_mcu_3comp_table;
> +  }
>
>     switch (pixfmt) {
>        case TINYJPEG_FMT_YUV420P:
> @@ -2487,8 +2604,12 @@
>
>     if (priv->flags&  TINYJPEG_FLAGS_PIXART_JPEG) {
>       /* Additional sanity check for funky Pixart format */
> -    if ((priv->stream_end - priv->stream)>  5)
> +    if ((priv->stream_end_filtered - priv->stream_filtered)>  5)
>         error("Pixart JPEG error, stream does not end with EOF marker\n");
> +
> +    free(priv->stream_begin_filtered);
> +    priv->stream_filtered = NULL;
> +    priv->stream_end_filtered = NULL;
>     }
>
>     return 0;
