Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33014 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0A3Puh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 10:50:37 -0500
Received: from [192.168.1.2] (02-147.155.popsite.net [66.217.132.147])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id o0UFoVQZ028856
	for <linux-media@vger.kernel.org>; Sat, 30 Jan 2010 10:50:32 -0500 (EST)
Subject: [PATCH 1/2] cx18: Add support for component video inputs
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 30 Jan 2010 10:50:17 -0500
Message-Id: <1264866617.4748.48.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx18: Add support for component video inputs

From: Andy Walls <awalls@radix.net>

Priority: normal

Signed-off-by: Andy Walls <awalls@radix.net>

diff -r ad62ab7e4325 -r 9d3394f49a90 linux/drivers/media/video/cx18/cx18-av-core.c
--- a/linux/drivers/media/video/cx18/cx18-av-core.c	Sun Jan 03 21:28:18 2010 -0500
+++ b/linux/drivers/media/video/cx18/cx18-av-core.c	Fri Jan 08 23:01:47 2010 -0500
@@ -579,6 +579,7 @@
 
 	u8 afe_mux_cfg;
 	u8 adc2_cfg;
+	u8 input_mode;
 	u32 afe_cfg;
 	int i;
 
@@ -589,6 +590,30 @@
 	    vid_input <= CX18_AV_COMPOSITE8) {
 		afe_mux_cfg = 0xf0 + (vid_input - CX18_AV_COMPOSITE1);
 		ch[0] = CVBS;
+		input_mode = 0x0;
+	} else if (vid_input >= CX18_AV_COMPONENT_LUMA1) {
+		int luma = vid_input & 0xf000;
+		int r_chroma = vid_input & 0xf0000;
+		int b_chroma = vid_input & 0xf00000;
+
+		if ((vid_input & ~0xfff000) ||
+		    luma < CX18_AV_COMPONENT_LUMA1 ||
+		    luma > CX18_AV_COMPONENT_LUMA8 ||
+		    r_chroma < CX18_AV_COMPONENT_R_CHROMA4 ||
+		    r_chroma > CX18_AV_COMPONENT_R_CHROMA6 ||
+		    b_chroma < CX18_AV_COMPONENT_B_CHROMA7 ||
+		    b_chroma > CX18_AV_COMPONENT_B_CHROMA8) {
+			CX18_ERR_DEV(sd, "0x%06x is not a valid video input!\n",
+				     vid_input);
+			return -EINVAL;
+		}
+		afe_mux_cfg = (luma - CX18_AV_COMPONENT_LUMA1) >> 12;
+		ch[0] = Y;
+		afe_mux_cfg |= (r_chroma - CX18_AV_COMPONENT_R_CHROMA4) >> 12;
+		ch[1] = Pr;
+		afe_mux_cfg |= (b_chroma - CX18_AV_COMPONENT_B_CHROMA7) >> 14;
+		ch[2] = Pb;
+		input_mode = 0x6;
 	} else {
 		int luma = vid_input & 0xf0;
 		int chroma = vid_input & 0xf00;
@@ -598,7 +623,7 @@
 		    luma > CX18_AV_SVIDEO_LUMA8 ||
 		    chroma < CX18_AV_SVIDEO_CHROMA4 ||
 		    chroma > CX18_AV_SVIDEO_CHROMA8) {
-			CX18_ERR_DEV(sd, "0x%04x is not a valid video input!\n",
+			CX18_ERR_DEV(sd, "0x%06x is not a valid video input!\n",
 				     vid_input);
 			return -EINVAL;
 		}
@@ -613,8 +638,8 @@
 			afe_mux_cfg |= (chroma - CX18_AV_SVIDEO_CHROMA4) >> 4;
 			ch[1] = C;
 		}
+		input_mode = 0x2;
 	}
-	/* TODO: LeadTek WinFast DVR3100 H & WinFast PVR2100 can do Y/Pb/Pr */
 
 	switch (aud_input) {
 	case CX18_AV_AUDIO_SERIAL1:
@@ -650,8 +675,8 @@
 
 	/* Set up analog front end multiplexers */
 	cx18_av_write_expect(cx, 0x103, afe_mux_cfg, afe_mux_cfg, 0xf7);
-	/* Set INPUT_MODE to Composite (0) or S-Video (1) */
-	cx18_av_and_or(cx, 0x401, ~0x6, ch[0] == CVBS ? 0 : 0x02);
+	/* Set INPUT_MODE to Composite, S-Video, or Component */
+	cx18_av_and_or(cx, 0x401, ~0x6, input_mode);
 
 	/* Set CH_SEL_ADC2 to 1 if input comes from CH3 */
 	adc2_cfg = cx18_av_read(cx, 0x102);
diff -r ad62ab7e4325 -r 9d3394f49a90 linux/drivers/media/video/cx18/cx18-av-core.h
--- a/linux/drivers/media/video/cx18/cx18-av-core.h	Sun Jan 03 21:28:18 2010 -0500
+++ b/linux/drivers/media/video/cx18/cx18-av-core.h	Fri Jan 08 23:01:47 2010 -0500
@@ -61,6 +61,25 @@
 	CX18_AV_SVIDEO2 = 0x620,
 	CX18_AV_SVIDEO3 = 0x730,
 	CX18_AV_SVIDEO4 = 0x840,
+
+	/* Component Video inputs consist of one luma input (In1-In8) ORed
+	   with a red chroma (In4-In6) and blue chroma input (In7-In8) */
+	CX18_AV_COMPONENT_LUMA1 = 0x1000,
+	CX18_AV_COMPONENT_LUMA2 = 0x2000,
+	CX18_AV_COMPONENT_LUMA3 = 0x3000,
+	CX18_AV_COMPONENT_LUMA4 = 0x4000,
+	CX18_AV_COMPONENT_LUMA5 = 0x5000,
+	CX18_AV_COMPONENT_LUMA6 = 0x6000,
+	CX18_AV_COMPONENT_LUMA7 = 0x7000,
+	CX18_AV_COMPONENT_LUMA8 = 0x8000,
+	CX18_AV_COMPONENT_R_CHROMA4 = 0x40000,
+	CX18_AV_COMPONENT_R_CHROMA5 = 0x50000,
+	CX18_AV_COMPONENT_R_CHROMA6 = 0x60000,
+	CX18_AV_COMPONENT_B_CHROMA7 = 0x700000,
+	CX18_AV_COMPONENT_B_CHROMA8 = 0x800000,
+
+	/* Component Video aliases for common combinations */
+	CX18_AV_COMPONENT1 = 0x861000,
 };
 
 enum cx18_av_audio_input {
diff -r ad62ab7e4325 -r 9d3394f49a90 linux/drivers/media/video/cx18/cx18-cards.c
--- a/linux/drivers/media/video/cx18/cx18-cards.c	Sun Jan 03 21:28:18 2010 -0500
+++ b/linux/drivers/media/video/cx18/cx18-cards.c	Fri Jan 08 23:01:47 2010 -0500
@@ -491,7 +491,7 @@
 		"S-Video 2",
 		"Composite 1",
 		"Composite 2",
-		"Composite 3"
+		"Component 1"
 	};
 
 	memset(input, 0, sizeof(*input));
diff -r ad62ab7e4325 -r 9d3394f49a90 linux/drivers/media/video/cx18/cx18-cards.h
--- a/linux/drivers/media/video/cx18/cx18-cards.h	Sun Jan 03 21:28:18 2010 -0500
+++ b/linux/drivers/media/video/cx18/cx18-cards.h	Fri Jan 08 23:01:47 2010 -0500
@@ -43,7 +43,7 @@
 #define	CX18_CARD_INPUT_SVIDEO2 	3
 #define	CX18_CARD_INPUT_COMPOSITE1 	4
 #define	CX18_CARD_INPUT_COMPOSITE2 	5
-#define	CX18_CARD_INPUT_COMPOSITE3 	6
+#define	CX18_CARD_INPUT_COMPONENT1 	6
 
 /* audio inputs */
 #define	CX18_CARD_INPUT_AUD_TUNER	1
@@ -62,7 +62,7 @@
 struct cx18_card_video_input {
 	u8  video_type; 	/* video input type */
 	u8  audio_index;	/* index in cx18_card_audio_input array */
-	u16 video_input;	/* hardware video input */
+	u32 video_input;	/* hardware video input */
 };
 
 struct cx18_card_audio_input {


