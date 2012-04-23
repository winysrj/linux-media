Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab2DWVbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 17:31:45 -0400
Message-ID: <4F95CACD.5010403@redhat.com>
Date: Mon, 23 Apr 2012 23:34:05 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] tinyjpeg: Dynamic luminance quantization table for
 Pixart JPEG
References: <20120412122017.0c808009@tele>
In-Reply-To: <20120412122017.0c808009@tele>
Content-Type: multipart/mixed;
 boundary="------------090608050703070205050906"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090608050703070205050906
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 04/12/2012 12:20 PM, Jean-Francois Moine wrote:
> In PJPG blocks, a marker gives the quantization tables to use for image
> decoding. This patch dynamically updates the luminance table when the
> marker changes.
>
> Note that the values of this table have been guessed from a small
> number of images and that they may not work fine in some situations,
> but, in most cases, the images are better.

Thanks for your work on this! I've just spend almost 4 days wrestling
which the Pixart JPEG decompression code to try to better understand
these cams, and I have learned quite a bit and eventually came up
with a different approach.

But your effort is appreciated! After spending so much time on this
myself, I can imagine that it took you quite some time to come up
with your solution.

Attach is a 4 patch patchset which I plan to push to v4l-utils
tomorrow (after running some more tests in daylight). I'll also try
to do some kernel patches tomorrow to match...

Thanks & Regards,

Hans


>
> Signed-off-by: Jean-François Moine<moinejf@free.fr>
>
> diff --git a/lib/libv4lconvert/tinyjpeg-internal.h b/lib/libv4lconvert/tinyjpeg-internal.h
> index 702a2a2..4041251 100644
> --- a/lib/libv4lconvert/tinyjpeg-internal.h
> +++ b/lib/libv4lconvert/tinyjpeg-internal.h
> @@ -103,6 +103,7 @@ struct jdec_private {
>   #if SANITY_CHECK
>   	unsigned int current_cid;			/* For planar JPEG */
>   #endif
> +	unsigned char marker;			/* for PJPG (Pixart JPEG) */
>
>   	/* Temp space used after the IDCT to store each components */
>   	uint8_t Y[64 * 4], Cr[64], Cb[64];
> diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
> index 2c2d4af..d986a45 100644
> --- a/lib/libv4lconvert/tinyjpeg.c
> +++ b/lib/libv4lconvert/tinyjpeg.c
> @@ -1376,6 +1376,8 @@ static void decode_MCU_2x1_3planes(struct jdec_private *priv)
>   	IDCT(&priv->component_infos[cCr], priv->Cr, 8);
>   }
>
> +static void build_quantization_table(float *qtable, const unsigned char *ref_table);
> +
>   static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
>   {
>   	unsigned char marker;
> @@ -1384,10 +1386,8 @@ static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
>   	/* I think the marker indicates which quantization table to use, iow
>   	   a Pixart JPEG may have a different quantization table per MCU, most
>   	   MCU's have 0x44 as marker for which our special Pixart quantization
> -	   tables are correct. Unfortunately with a 7302 some blocks also have 0x48,
> -	   and sometimes even other values. As 0x48 is quite common too, we really
> -	   need to find out the correct table for that, as currently the blocks
> -	   with a 0x48 marker look wrong. During normal operation the marker stays
> +	   tables are correct. [jfm: snip]
> +	   During normal operation the marker stays
>   	   within the range below, if it gets out of this range we're most likely
>   	   decoding garbage */
>   	if (marker<  0x20 || marker>  0x7f) {
> @@ -1396,6 +1396,53 @@ static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
>   				(unsigned int)marker);
>   		longjmp(priv->jump_state, -EIO);
>   	}
> +
> +	/* rebuild the Y quantization table when the marker changes */
> +	if (marker != priv->marker) {
> +		unsigned char quant_new[64];
> +		int i, j;
> +		/*
> +		 * table to rebuild the Y quantization table
> +		 * 	index 1 = marker / 4
> +		 *	index 2 = 4 end indexes in the quantization table
> +		 *	values = 0x08, 0x10, 0x20, 0x40, 0x63
> +		 * jfm: The values have been guessed from 4 images, so,
> +		 *	better values may be found...
> +		 */
> +		static const unsigned char q_tb[12][4] = {
> +			{ 64, 64, 64, 64 },	/* 68 */
> +			{  8, 32, 64, 64 },
> +			{  1, 16, 50, 64 },
> +			{  1, 16, 30, 60 },	/* 80 */
> +			{  1,  8, 16, 32 },
> +			{  1,  4, 16, 31 },
> +			{  1,  3, 16, 30 },
> +			{  1,  2, 16, 21 },
> +			{  1,  1, 16, 18 },	/* 100 */
> +			{  1,  1, 16, 17 },
> +			{  1,  1, 16, 16 },
> +			{  1,  1, 15, 15 },
> +		};
> +
> +		priv->marker = marker;
> +		j = marker - 68;
> +		if (j<  0)
> +			j = 0;
> +		j>>= 2;
> +		if (j>  sizeof q_tb / sizeof q_tb[0])
> +			j = sizeof q_tb / sizeof q_tb[0] - 1;
> +		for (i = 0; i<  q_tb[j][0]; i++)
> +			quant_new[i] = 0x08;
> +		for (; i<  q_tb[j][1]; i++)
> +			quant_new[i] = 0x10;
> +		for (; i<  q_tb[j][2]; i++)
> +			quant_new[i] = 0x20;
> +		for (; i<  q_tb[j][3]; i++)
> +			quant_new[i] = 0x40;
> +		for (; i<  64; i++)
> +			quant_new[i] = 0x63;
> +		build_quantization_table(priv->Q_tables[0], quant_new);
> +	}
>   	skip_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, 8);
>
>   	// Y
> @@ -1948,6 +1995,7 @@ static int parse_JFIF(struct jdec_private *priv, const unsigned char *stream)
>   		if (!priv->default_huffman_table_initialized) {
>   			build_quantization_table(priv->Q_tables[0], pixart_quantization[0]);
>   			build_quantization_table(priv->Q_tables[1], pixart_quantization[1]);
> +			priv->marker = 68;	/* common starting marker */
>   		}
>   	}
>
>

--------------090608050703070205050906
Content-Type: text/x-patch;
 name="0001-libv4lconvert-Fix-decoding-of-160x120-Pixart-JPEG-im.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-libv4lconvert-Fix-decoding-of-160x120-Pixart-JPEG-im.pa";
 filename*1="tch"

>From 296a2827375732346776357ec59d2cf446128095 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 23 Apr 2012 19:43:07 +0200
Subject: [PATCH 1/4] libv4lconvert: Fix decoding of 160x120 Pixart JPEG
 images

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4lconvert/tinyjpeg.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
index 2c2d4af..d2a7d3f 100644
--- a/lib/libv4lconvert/tinyjpeg.c
+++ b/lib/libv4lconvert/tinyjpeg.c
@@ -2101,7 +2101,17 @@ static int pixart_filter(struct jdec_private *priv, unsigned char *dest,
 {
 	int chunksize, copied = 0;
 
-	/* Skip mysterious first data byte */
+	/* The first data bytes encodes the image size:
+	   0x60: 160x120
+	   0x61: 320x240
+	   0x62: 640x480
+	   160x120 images are not chunked due to their small size!
+	*/
+	if (src[0] == 0x60) {
+			memcpy(dest, src + 1, n - 1);
+			return n - 1;
+	}
+
 	src++;
 	n--;
 
@@ -2124,8 +2134,8 @@ kernel: 0xff 0xff 0x00 0xff 0x96, and we skip one unknown byte */
 
 		if (src[0] != 0xff || src[1] != 0xff || src[2] != 0xff)
 			error("Missing Pixart ff ff ff xx header, "
-					"got: %02x %02x %02x %02x\n",
-					src[0], src[1], src[2], src[3]);
+			      "got: %02x %02x %02x %02x, copied sofar: %d\n",
+			      src[0], src[1], src[2], src[3], copied);
 		if (src[3] > 6)
 			error("Unexpected Pixart chunk size: %d\n", src[3]);
 
-- 
1.7.10


--------------090608050703070205050906
Content-Type: text/x-patch;
 name="0002-Revert-tinyjpeg-Better-luminance-quantization-table-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-Revert-tinyjpeg-Better-luminance-quantization-table-.pa";
 filename*1="tch"

>From 3cc0517f88d07a44638b38115f76b33c31c17fd1 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 21 Apr 2012 14:39:58 +0200
Subject: [PATCH 2/4] Revert "tinyjpeg: Better luminance quantization table
 for Pixart JPEG"

This reverts commit e186777daeaa717b7d919e932f7d3be10156d572.
---
 lib/libv4lconvert/tinyjpeg.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
index d2a7d3f..756ad9c 100644
--- a/lib/libv4lconvert/tinyjpeg.c
+++ b/lib/libv4lconvert/tinyjpeg.c
@@ -206,14 +206,14 @@ static const unsigned char val_ac_chrominance[] = {
 };
 
 const unsigned char pixart_quantization[][64] = { {
-		0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10,
-		0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
-		0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10,
-		0x10, 0x10, 0x10, 0x10, 0x20, 0x20, 0x20, 0x20,
-		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
-		0x20, 0x20, 0x20, 0x40, 0x40, 0x40, 0x40, 0x40,
-		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
-		0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
+		0x07, 0x07, 0x08, 0x0a, 0x09, 0x07, 0x0d, 0x0b,
+		0x0c, 0x0d, 0x11, 0x10, 0x0f, 0x12, 0x17, 0x27,
+		0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
+		0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
+		0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
+		0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
+		0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
+		0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63,
 	},
 	{
 		0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
-- 
1.7.10


--------------090608050703070205050906
Content-Type: text/x-patch;
 name="0003-libv4lconvert-Dynamic-quantization-tables-for-Pixart.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0003-libv4lconvert-Dynamic-quantization-tables-for-Pixart.pa";
 filename*1="tch"

>From 8e3907391bd4e413742fe448d27b053c82146904 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 23 Apr 2012 23:03:40 +0200
Subject: [PATCH 3/4] libv4lconvert: Dynamic quantization tables for Pixart
 JPEG
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Inspired by a patch from Jean-François Moine <moinejf@free.fr>, I've spend
4 days on a row investigating (through trial and error) Pixart's JPEG
compression. This patch accumulates what I've learned from this, giving 2
important improvements:
1) Support for properly decompressing pac7302 generated images where some
   of the MCU-s are compressed with a lower quality / higher quantization
   values
2) Proper chrominance quantization tables for Pixart JPEG, getting rid of
   the sometimes horribly over saturation our decompression code was causing

The support for dynamic quantization tables this patch adds also allows us to
enable lower compression ratios in the kernel driver when running at a lower
framerate, resulting in better image quality.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4lconvert/tinyjpeg-internal.h |    1 +
 lib/libv4lconvert/tinyjpeg.c          |   77 ++++++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/lib/libv4lconvert/tinyjpeg-internal.h b/lib/libv4lconvert/tinyjpeg-internal.h
index 702a2a2..4041251 100644
--- a/lib/libv4lconvert/tinyjpeg-internal.h
+++ b/lib/libv4lconvert/tinyjpeg-internal.h
@@ -103,6 +103,7 @@ struct jdec_private {
 #if SANITY_CHECK
 	unsigned int current_cid;			/* For planar JPEG */
 #endif
+	unsigned char marker;			/* for PJPG (Pixart JPEG) */
 
 	/* Temp space used after the IDCT to store each components */
 	uint8_t Y[64 * 4], Cr[64], Cb[64];
diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
index 756ad9c..dd77d0f 100644
--- a/lib/libv4lconvert/tinyjpeg.c
+++ b/lib/libv4lconvert/tinyjpeg.c
@@ -205,9 +205,11 @@ static const unsigned char val_ac_chrominance[] = {
 	0xf9, 0xfa
 };
 
-const unsigned char pixart_quantization[][64] = { {
-		0x07, 0x07, 0x08, 0x0a, 0x09, 0x07, 0x0d, 0x0b,
-		0x0c, 0x0d, 0x11, 0x10, 0x0f, 0x12, 0x17, 0x27,
+/* Standard JPEG quantization tables from Annex K of the JPEG standard.
+   Note unlike in Annex K the entries here are in zigzag order! */
+const unsigned char standard_quantization[][64] = { {
+		0x10, 0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e,
+		0x0d, 0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28,
 		0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
 		0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
 		0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
@@ -1376,25 +1378,57 @@ static void decode_MCU_2x1_3planes(struct jdec_private *priv)
 	IDCT(&priv->component_infos[cCr], priv->Cr, 8);
 }
 
+static void build_quantization_table(float *qtable, const unsigned char *ref_table);
+
 static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
 {
 	unsigned char marker;
 
-	look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, 8, marker);
-	/* I think the marker indicates which quantization table to use, iow
-	   a Pixart JPEG may have a different quantization table per MCU, most
-	   MCU's have 0x44 as marker for which our special Pixart quantization
-	   tables are correct. Unfortunately with a 7302 some blocks also have 0x48,
-	   and sometimes even other values. As 0x48 is quite common too, we really
-	   need to find out the correct table for that, as currently the blocks
-	   with a 0x48 marker look wrong. During normal operation the marker stays
-	   within the range below, if it gets out of this range we're most likely
-	   decoding garbage */
-	if (marker < 0x20 || marker > 0x7f) {
-		snprintf(priv->error_string, sizeof(priv->error_string),
-				"Pixart JPEG error: invalid MCU marker: 0x%02x\n",
-				(unsigned int)marker);
-		longjmp(priv->jump_state, -EIO);
+	look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream,
+		   8, marker);
+
+	/* Pixart JPEG MCU-s are preceded by a marker indicating the quality
+	   setting with which the MCU is compressed, IOW the MCU-s may have a
+	   different quantization table per MCU. So if the marker changes we
+	   need to rebuild the quantization tables. */
+	if (marker != priv->marker) {
+		int i, j, comp;
+		unsigned char qt[64];
+		/* These values have been found by trial and error and seem to
+		   work reasonably. Markers with index 0 - 7 are never
+		   generated by the hardware, so they are likely wrong. */
+		const int qfactor[32] = {
+			 10,   12,  14,  16,  18,  20,  22,  24,
+			 25,   30,  35,  40,  45,  50,  55,  60,
+			 64,   68,  80,  90, 100, 120, 140, 160,
+			180,  200, 220, 240, 260, 280, 300, 320
+		};
+
+		i = (marker & 0x7c) >> 2; /* Bits 0 and 1 are always 0 */
+		comp = qfactor[i];
+
+		/* And another special Pixart feature, the DC quantization
+		   factor is fixed! */
+		qt[0] = 7; 
+		for (i = 1; i < 64; i++) {
+			j = (standard_quantization[0][i] * comp + 50) / 100;
+			qt[i] = (j < 255) ? j : 255;
+		}
+		build_quantization_table(priv->Q_tables[0], qt);
+
+		/* And yet another Pixart JPEG special feature, Pixart JPEG
+		   uses the luminance table for chrominance too! Either
+		   as is or with all values multiplied by 2, this is encoded
+		   in bit 7 of the marker. */
+		if (!(marker & 0x80)) {
+			for (i = 0; i < 64; i++) {
+				j = qt[i] * 2;
+				qt[i] = (j < 255) ? j : 255;
+			}
+		}
+		build_quantization_table(priv->Q_tables[1], qt);
+
+		priv->marker = marker;
 	}
 	skip_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, 8);
 
@@ -1944,13 +1978,6 @@ static int parse_JFIF(struct jdec_private *priv, const unsigned char *stream)
 			(!dqt_marker_found && !(priv->flags & TINYJPEG_FLAGS_PIXART_JPEG)))
 		goto bogus_jpeg_format;
 
-	if (priv->flags & TINYJPEG_FLAGS_PIXART_JPEG) {
-		if (!priv->default_huffman_table_initialized) {
-			build_quantization_table(priv->Q_tables[0], pixart_quantization[0]);
-			build_quantization_table(priv->Q_tables[1], pixart_quantization[1]);
-		}
-	}
-
 	if (!dht_marker_found) {
 		trace("No Huffman table loaded, using the default one\n");
 		if (build_default_huffman_tables(priv))
-- 
1.7.10


--------------090608050703070205050906
Content-Type: text/x-patch;
 name="0004-libv4lconvert-Drop-Pixart-JPEG-frames-with-changing-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-libv4lconvert-Drop-Pixart-JPEG-frames-with-changing-.pa";
 filename*1="tch"

>From eb436c4dbcb0c0985beb78ae33e8c767e6695309 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 23 Apr 2012 23:18:24 +0200
Subject: [PATCH 4/4] libv4lconvert: Drop Pixart JPEG frames with changing
 chrominance setting

Sometimes the pac7302 switches chrominance setting halfway though a
frame, with a quite ugly looking result, so lets drop such frames.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4lconvert/tinyjpeg-internal.h |    1 +
 lib/libv4lconvert/tinyjpeg.c          |   11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/lib/libv4lconvert/tinyjpeg-internal.h b/lib/libv4lconvert/tinyjpeg-internal.h
index 4041251..dcbcf27 100644
--- a/lib/libv4lconvert/tinyjpeg-internal.h
+++ b/lib/libv4lconvert/tinyjpeg-internal.h
@@ -104,6 +104,7 @@ struct jdec_private {
 	unsigned int current_cid;			/* For planar JPEG */
 #endif
 	unsigned char marker;			/* for PJPG (Pixart JPEG) */
+	unsigned char first_marker;		/* for PJPG (Pixart JPEG) */
 
 	/* Temp space used after the IDCT to store each components */
 	uint8_t Y[64 * 4], Cr[64], Cb[64];
diff --git a/lib/libv4lconvert/tinyjpeg.c b/lib/libv4lconvert/tinyjpeg.c
index dd77d0f..8fc484e 100644
--- a/lib/libv4lconvert/tinyjpeg.c
+++ b/lib/libv4lconvert/tinyjpeg.c
@@ -1387,6 +1387,16 @@ static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
 	look_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream,
 		   8, marker);
 
+	/* Sometimes the pac7302 switches chrominance setting halfway though a
+	   frame, with a quite ugly looking result, so we drop such frames. */
+	if (priv->first_marker == 0)
+		priv->first_marker = marker;
+	else if ((marker & 0x80) != (priv->first_marker & 0x80)) {
+		snprintf(priv->error_string, sizeof(priv->error_string),
+			"Pixart JPEG error: chrominance changed halfway\n");
+		longjmp(priv->jump_state, -EIO);
+	}
+
 	/* Pixart JPEG MCU-s are preceded by a marker indicating the quality
 	   setting with which the MCU is compressed, IOW the MCU-s may have a
 	   different quantization table per MCU. So if the marker changes we
@@ -2224,6 +2234,7 @@ int tinyjpeg_decode(struct jdec_private *priv, int pixfmt)
 			return length;
 		priv->stream = priv->stream_filtered;
 		priv->stream_end = priv->stream + length;
+		priv->first_marker = 0;
 
 		decode_mcu_table = pixart_decode_mcu_3comp_table;
 	}
-- 
1.7.10


--------------090608050703070205050906--
