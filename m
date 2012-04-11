Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34919 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2DKIm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 04:42:27 -0400
Date: Wed, 11 Apr 2012 10:43:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] tinyjpeg: Dynamic luminance quantization table for Pixart
 JPEG
Message-ID: <20120411104312.35d8a7b5@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In PJPG blocks, a marker gives the quantization tables to use for image
decoding. This patch dynamically updates the luminance table when the
marker changes.

Note that the values of this table have been guessed from a small
number of images and that they may not work fine in some situations,
but, in most cases, the images are better rendered.

Signed-off-by: Jean-François Moine <moinejf@free.fr>

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
index 2c2d4af..d986a45 100644
--- a/lib/libv4lconvert/tinyjpeg.c
+++ b/lib/libv4lconvert/tinyjpeg.c
@@ -1376,6 +1376,8 @@ static void decode_MCU_2x1_3planes(struct jdec_private *priv)
 	IDCT(&priv->component_infos[cCr], priv->Cr, 8);
 }
 
+static void build_quantization_table(float *qtable, const unsigned char *ref_table);
+
 static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
 {
 	unsigned char marker;
@@ -1384,10 +1386,8 @@ static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
 	/* I think the marker indicates which quantization table to use, iow
 	   a Pixart JPEG may have a different quantization table per MCU, most
 	   MCU's have 0x44 as marker for which our special Pixart quantization
-	   tables are correct. Unfortunately with a 7302 some blocks also have 0x48,
-	   and sometimes even other values. As 0x48 is quite common too, we really
-	   need to find out the correct table for that, as currently the blocks
-	   with a 0x48 marker look wrong. During normal operation the marker stays
+	   tables are correct. [jfm: snip]
+	   During normal operation the marker stays
 	   within the range below, if it gets out of this range we're most likely
 	   decoding garbage */
 	if (marker < 0x20 || marker > 0x7f) {
@@ -1396,6 +1396,53 @@ static void pixart_decode_MCU_2x1_3planes(struct jdec_private *priv)
 				(unsigned int)marker);
 		longjmp(priv->jump_state, -EIO);
 	}
+
+	/* rebuild the Y quantization table when the marker changes */
+	if (marker != priv->marker) {
+		unsigned char quant_new[64];
+		int i, j;
+		/*
+		 * table to rebuild the Y quantization table
+		 * 	index 1 = marker / 4
+		 *	index 2 = 4 end indexes in the quantization table
+		 *	values = 0x08, 0x10, 0x20, 0x40, 0x63
+		 * jfm: The values have been guessed from 4 images, so,
+		 *	better values may be found...
+		 */
+		static const unsigned char q_tb[12][4] = {
+			{ 6, 28, 43, 64 },	/* 68 */
+			{ 6, 24, 40, 60 },
+			{ 4, 18, 30, 55 },
+			{ 2, 10, 20, 50 },	/* 80 */
+			{ 1,  6, 15, 46 },
+			{ 1,  4, 15, 37 },
+			{ 1,  3, 15, 30 },
+			{ 1,  2, 15, 21 },
+			{ 1,  1, 15, 18 },	/* 100 */
+			{ 1,  1, 15, 16 },
+			{ 1,  1, 15, 15 },
+			{ 1,  1, 10, 10 },
+		};
+
+		priv->marker = marker;
+		j = marker - 68;
+		if (j < 0)
+			j = 0;
+		j >>= 2;
+		if (j > sizeof q_tb / sizeof q_tb[0])
+			j = sizeof q_tb / sizeof q_tb[0] - 1;
+		for (i = 0; i < q_tb[j][0]; i++)
+			quant_new[i] = 0x08;
+		for (; i < q_tb[j][1]; i++)
+			quant_new[i] = 0x10;
+		for (; i < q_tb[j][2]; i++)
+			quant_new[i] = 0x20;
+		for (; i < q_tb[j][3]; i++)
+			quant_new[i] = 0x40;
+		for (; i < 64; i++)
+			quant_new[i] = 0x63;
+		build_quantization_table(priv->Q_tables[0], quant_new);
+	}
 	skip_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, 8);
 
 	// Y
@@ -1948,6 +1995,7 @@ static int parse_JFIF(struct jdec_private *priv, const unsigned char *stream)
 		if (!priv->default_huffman_table_initialized) {
 			build_quantization_table(priv->Q_tables[0], pixart_quantization[0]);
 			build_quantization_table(priv->Q_tables[1], pixart_quantization[1]);
+			priv->marker = 68;	/* common starting marker */
 		}
 	}
 

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
t
