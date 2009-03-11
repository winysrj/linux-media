Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZCKNXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 09:23:54 -0400
Message-ID: <49B7BB7F.7020802@redhat.com>
Date: Wed, 11 Mar 2009 14:24:15 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4lconvert support for SQ905C decompression (revised)
References: <alpine.LNX.2.00.0903041730550.23054@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903041730550.23054@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 
> Hans,
> 
>  From an abundance of caution, I thought I had better run the v4lconvert 
> patch which supports the SQ905C compressed format through the 
> checkpatch.pl process, too. The result of that process appears here, 
> below the signed-off-by line.
> 
> Theodore Kilgore
> 

Thanks applied to me tree:
http://linuxtv.org/hg/~hgoede/libv4l

I expect to release libv4l-0.5.9 with this in, soon.

Regards,

Hans

> ---------- Forwarded message ----------
> Date: Sun, 1 Mar 2009 17:45:32 -0600 (CST)
> From: kilgota@banach.math.auburn.edu
> To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
> Subject: [PATCH] libv4lconvert support for SQ905C decompression
> 
> Hans,
> 
> Below is a patch for libv4lconvert, to support the decompression used by 
> the SQ905C cameras (0x2770:0x905C) and some other related cameras. There 
> is at the moment no support module for these cameras in streaming mode, 
> but I intend to submit one.
> 
> This contribution was created in whole by me, based upon code in 
> libgphoto2 which was created in whole by me, and which was licensed for
> libgphoto2 under the LGPL license.
> 
> Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
> 
> -----------------------------------------------------------------------
> diff -uprN libv4lconvert-old/Makefile libv4lconvert-new/Makefile
> --- libv4lconvert-old/Makefile    2009-03-01 15:37:38.000000000 -0600
> +++ libv4lconvert-new/Makefile    2009-03-04 16:22:52.000000000 -0600
> @@ -12,7 +12,7 @@ endif
> 
>  CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o sn9c10x.o sn9c20x.o pac207.o \
>          mr97310a.o flip.o crop.o jidctflt.o spca561-decompress.o \
> -        rgbyuv.o spca501.o bayer.o
> +        rgbyuv.o spca501.o sq905c.o bayer.o
>  TARGETS       = $(CONVERT_LIB) libv4lconvert.pc
>  INCLUDES      = ../include/libv4lconvert.h
> 
> diff -uprN libv4lconvert-old/libv4lconvert-priv.h 
> libv4lconvert-new/libv4lconvert-priv.h
> --- libv4lconvert-old/libv4lconvert-priv.h    2009-03-01 
> 15:37:38.000000000 -0600
> +++ libv4lconvert-new/libv4lconvert-priv.h    2009-03-04 
> 16:22:52.000000000 -0600
> @@ -47,6 +47,10 @@
>  #define V4L2_PIX_FMT_MR97310A v4l2_fourcc('M','3','1','0')
>  #endif
> 
> +#ifndef V4L2_PIX_FMT_SQ905C
> +#define V4L2_PIX_FMT_SQ905C v4l2_fourcc('9', '0', '5', 'C')
> +#endif
> +
>  #ifndef V4L2_PIX_FMT_PJPG
>  #define V4L2_PIX_FMT_PJPG v4l2_fourcc('P', 'J', 'P', 'G')
>  #endif
> @@ -180,6 +184,9 @@ void v4lconvert_decode_pac207(const unsi
>  void v4lconvert_decode_mr97310a(const unsigned char *src, unsigned char 
> *dst,
>    int width, int height);
> 
> +void v4lconvert_decode_sq905c(const unsigned char *src, unsigned char 
> *dst,
> +  int width, int height);
> +
>  void v4lconvert_bayer_to_rgb24(const unsigned char *bayer,
>    unsigned char *rgb, int width, int height, unsigned int pixfmt);
> 
> diff -uprN libv4lconvert-old/libv4lconvert.c 
> libv4lconvert-new/libv4lconvert.c
> --- libv4lconvert-old/libv4lconvert.c    2009-03-01 15:37:38.000000000 
> -0600
> +++ libv4lconvert-new/libv4lconvert.c    2009-03-04 16:22:52.000000000 
> -0600
> @@ -61,6 +61,7 @@ static const struct v4lconvert_pixfmt su
>    { V4L2_PIX_FMT_SN9C10X,      V4LCONVERT_COMPRESSED },
>    { V4L2_PIX_FMT_PAC207,       V4LCONVERT_COMPRESSED },
>    { V4L2_PIX_FMT_MR97310A,     V4LCONVERT_COMPRESSED },
> +  { V4L2_PIX_FMT_SQ905C,       V4LCONVERT_COMPRESSED },
>    { V4L2_PIX_FMT_PJPG,         V4LCONVERT_COMPRESSED },
>  };
> 
> @@ -608,6 +609,7 @@ static int v4lconvert_convert_pixfmt(str
>      case V4L2_PIX_FMT_SN9C10X:
>      case V4L2_PIX_FMT_PAC207:
>      case V4L2_PIX_FMT_MR97310A:
> +    case V4L2_PIX_FMT_SQ905C:
>      {
>        unsigned char *tmpbuf;
> 
> @@ -633,6 +635,10 @@ static int v4lconvert_convert_pixfmt(str
>        v4lconvert_decode_mr97310a(src, tmpbuf, width, height);
>        src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
>        break;
> +    case V4L2_PIX_FMT_SQ905C:
> +      v4lconvert_decode_sq905c(src, tmpbuf, width, height);
> +      src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
> +      break;
>        }
>        src = tmpbuf;
>        /* Deliberate fall through to raw bayer fmt code! */
> diff -uprN libv4lconvert-old/sq905c.c libv4lconvert-new/sq905c.c
> --- libv4lconvert-old/sq905c.c    1969-12-31 18:00:00.000000000 -0600
> +++ libv4lconvert-new/sq905c.c    2009-03-04 16:27:17.000000000 -0600
> @@ -0,0 +1,217 @@
> +/*
> + * sq905c.c
> + *
> + * Here is the decompression function for the SQ905C cameras. The 
> functions
> + * used are adapted from the libgphoto2 functions for the same cameras,
> + * which was
> + * Copyright (c) 2005 and 2007 Theodore Kilgore <kilgota@auburn.edu>
> + * This version for libv4lconvert is
> + * Copyright (c) 2009 Theodore Kilgore <kilgota@auburn.edu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License as 
> published by
> + * the Free Software Foundation; either version 2.1 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public 
> License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  
> 02111-1307  USA
> + */
> +
> +#include <stdlib.h>
> +
> +#include "libv4lconvert-priv.h"
> +
> +
> +#define CLIP(x) ((x) < 0 ? 0 : ((x) > 0xff) ? 0xff : (x))
> +
> +
> +static int
> +sq905c_first_decompress(unsigned char *output, unsigned char *input,
> +                        unsigned int outputsize)
> +{
> +    unsigned char parity = 0;
> +    unsigned char nibble_to_keep[2];
> +    unsigned char temp1 = 0, temp2 = 0;
> +    unsigned char input_byte;
> +    unsigned char lookup = 0;
> +    unsigned int i = 0;
> +    unsigned int bytes_used = 0;
> +    unsigned int bytes_done = 0;
> +    unsigned int bit_counter = 8;
> +    unsigned int cycles = 0;
> +    int table[9] = { -1, 0, 2, 6, 0x0e, 0x0e, 0x0e, 0x0e, 0xfb};
> +    unsigned char lookup_table[16]
> +             = {0, 2, 6, 0x0e, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4,
> +            0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb};
> +    unsigned char translator[16] = {8, 7, 9, 6, 10, 11, 12, 13,
> +                    14, 15, 5, 4, 3, 2, 1, 0};
> +
> +    nibble_to_keep[0] = 0;
> +    nibble_to_keep[1] = 0;
> +
> +    while (bytes_done < outputsize) {
> +        while (parity < 2) {
> +            while (lookup > table[cycles]) {
> +                if (bit_counter == 8) {
> +                    input_byte = input[bytes_used];
> +                    bytes_used++;
> +                    temp1 = input_byte;
> +                    bit_counter = 0;
> +                }
> +                input_byte = temp1;
> +                temp2 = (temp2 << 1) & 0xFF;
> +                input_byte = input_byte >> 7;
> +                temp2 = temp2 | input_byte;
> +                temp1 = (temp1 << 1) & 0xFF;
> +                bit_counter++;
> +                cycles++;
> +                if (cycles > 9)
> +                    return -1;
> +                lookup = temp2 & 0xff;
> +            }
> +            temp2 = 0;
> +            for (i = 0; i < 17; i++) {
> +                if (lookup == lookup_table[i]) {
> +                    nibble_to_keep[parity] = translator[i];
> +                    break;
> +                }
> +                if (i == 16)
> +                    return -1;
> +            }
> +            cycles = 0;
> +            parity++;
> +        }
> +        output[bytes_done] = (nibble_to_keep[0]<<4)|nibble_to_keep[1];
> +        bytes_done++;
> +        parity = 0;
> +    }
> +    return 0;
> +}
> +
> +static int
> +sq905c_second_decompress(unsigned char *uncomp, unsigned char *in,
> +                            int width, int height)
> +{
> +    int diff = 0;
> +    int tempval = 0;
> +    int i, m, parity;
> +    unsigned char delta_left = 0;
> +    unsigned char delta_right = 0;
> +    int input_counter = 0;
> +    int delta_table[] = {-144, -110, -77, -53, -35, -21, -11, -3,
> +                2, 10, 20, 34, 52, 76, 110, 144};
> +    unsigned char *templine_red;
> +    unsigned char *templine_green;
> +    unsigned char *templine_blue;
> +    templine_red = malloc(width);
> +    if (!templine_red) {
> +        free(templine_red);
> +        return -1;
> +    }
> +    for (i = 0; i < width; i++)
> +        templine_red[i] = 0x80;
> +    templine_green = malloc(width);
> +    if (!templine_green) {
> +        free(templine_green);
> +        return -1;
> +    }
> +    for (i = 0; i < width; i++)
> +        templine_green[i] = 0x80;
> +    templine_blue = malloc(width);
> +    if (!templine_blue) {
> +        free(templine_blue);
> +        return -1;
> +    }
> +    for (i = 0; i < width; i++)
> +        templine_blue[i] = 0x80;
> +    for (m = 0; m < height/2; m++) {
> +        /* First we do an even-numbered line */
> +        for (i = 0; i < width/2; i++) {
> +            parity = i&1;
> +            delta_right = in[input_counter] & 0x0f;
> +            delta_left = (in[input_counter]>>4)&0xff;
> +            input_counter++;
> +            /* left pixel (red) */
> +            diff = delta_table[delta_left];
> +            if (!i)
> +                tempval = templine_red[0] + diff;
> +            else
> +                tempval = (templine_red[i]
> +                    + uncomp[2*m*width+2*i-2])/2 + diff;
> +            tempval = CLIP(tempval);
> +            uncomp[2*m*width+2*i] = tempval;
> +            templine_red[i] = tempval;
> +            /* right pixel (green) */
> +            diff = delta_table[delta_right];
> +            if (!i)
> +                tempval = templine_green[1] + diff;
> +            else if (2*i == width - 2)
> +                tempval = (templine_green[i]
> +                        + uncomp[2*m*width+2*i-1])/2
> +                            + diff;
> +            else
> +                tempval = (templine_green[i+1]
> +                        + uncomp[2*m*width+2*i-1])/2
> +                            + diff;
> +            tempval = CLIP(tempval);
> +            uncomp[2*m*width+2*i+1] = tempval;
> +            templine_green[i] = tempval;
> +        }
> +        /* then an odd-numbered line */
> +        for (i = 0; i < width/2; i++) {
> +            delta_right = in[input_counter] & 0x0f;
> +            delta_left = (in[input_counter]>>4) & 0xff;
> +            input_counter++;
> +            /* left pixel (green) */
> +            diff = delta_table[delta_left];
> +            if (!i)
> +                tempval = templine_green[0] + diff;
> +            else
> +                tempval = (templine_green[i]
> +                    + uncomp[(2*m+1)*width+2*i-2])/2
> +                        + diff;
> +            tempval = CLIP(tempval);
> +            uncomp[(2*m+1)*width+2*i] = tempval;
> +            templine_green[i] = tempval;
> +            /* right pixel (blue) */
> +            diff = delta_table[delta_right];
> +            if (!i)
> +                tempval = templine_blue[0] + diff;
> +            else
> +                tempval = (templine_blue[i]
> +                        + uncomp[(2*m+1)*width+2*i-1])/2
> +                        + diff;
> +            tempval = CLIP(tempval);
> +            uncomp[(2*m+1)*width+2*i+1] = tempval;
> +            templine_blue[i] = tempval;
> +        }
> +    }
> +    free(templine_green);
> +    free(templine_red);
> +    free(templine_blue);
> +    return 0;
> +}
> +
> +void v4lconvert_decode_sq905c(const unsigned char *src, unsigned char 
> *dst,
> +  int width, int height)
> +{
> +    int size;
> +    unsigned char *temp_data;
> +    unsigned char *raw;
> +    /* here we get rid of the 0x50 bytes of header in src. */
> +    raw = src + 0x50;
> +    size = width*height/2;
> +    temp_data = malloc(size);
> +    if (!temp_data)
> +        goto out;
> +    sq905c_first_decompress(temp_data, raw, size);
> +    sq905c_second_decompress(dst, temp_data, width, height);
> +out:
> +    free(temp_data);
> +}
