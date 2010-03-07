Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:49890 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0CGGdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 01:33:49 -0500
Message-ID: <4B9348C9.3020809@freemail.hu>
Date: Sun, 07 Mar 2010 07:33:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca cpia1: make local functions static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Make the local functions static. Note that the function command_setlights() is
currently not called from anywhere.

This will remove the following sparse warnings (see "make C=1"):
 * symbol 'command_setformat' was not declared. Should it be static?
 * symbol 'command_setcolourparams' was not declared. Should it be static?
 * symbol 'command_setapcor' was not declared. Should it be static?
 * symbol 'command_setvloffset' was not declared. Should it be static?
 * symbol 'command_setexposure' was not declared. Should it be static?
 * symbol 'command_setcolourbalance' was not declared. Should it be static?
 * symbol 'command_setcompressiontarget' was not declared. Should it be static?
 * symbol 'command_setyuvtresh' was not declared. Should it be static?
 * symbol 'command_setcompressionparams' was not declared. Should it be static?
 * symbol 'command_setcompression' was not declared. Should it be static?
 * symbol 'command_setsensorfps' was not declared. Should it be static?
 * symbol 'command_setflickerctrl' was not declared. Should it be static?
 * symbol 'command_setecptiming' was not declared. Should it be static?
 * symbol 'command_pause' was not declared. Should it be static?
 * symbol 'command_resume' was not declared. Should it be static?
 * symbol 'command_setlights' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e50bb36f881c linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Sat Mar 06 22:29:29 2010 -0300
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sun Mar 07 07:32:57 2010 +0100
@@ -861,7 +861,7 @@
 	return do_command(gspca_dev, CPIA_COMMAND_GetExposure, 0, 0, 0, 0);
 }

-int command_setformat(struct gspca_dev *gspca_dev)
+static int command_setformat(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int ret;
@@ -878,7 +878,7 @@
 			  sd->params.roi.rowStart, sd->params.roi.rowEnd);
 }

-int command_setcolourparams(struct gspca_dev *gspca_dev)
+static int command_setcolourparams(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	return do_command(gspca_dev, CPIA_COMMAND_SetColourParams,
@@ -887,7 +887,7 @@
 			  sd->params.colourParams.saturation, 0);
 }

-int command_setapcor(struct gspca_dev *gspca_dev)
+static int command_setapcor(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	return do_command(gspca_dev, CPIA_COMMAND_SetApcor,
@@ -897,7 +897,7 @@
 			  sd->params.apcor.gain8);
 }

-int command_setvloffset(struct gspca_dev *gspca_dev)
+static int command_setvloffset(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	return do_command(gspca_dev, CPIA_COMMAND_SetVLOffset,
@@ -907,7 +907,7 @@
 			  sd->params.vlOffset.gain8);
 }

-int command_setexposure(struct gspca_dev *gspca_dev)
+static int command_setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int ret;
@@ -943,7 +943,7 @@
 	return ret;
 }

-int command_setcolourbalance(struct gspca_dev *gspca_dev)
+static int command_setcolourbalance(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -973,7 +973,7 @@
 	return -EINVAL;
 }

-int command_setcompressiontarget(struct gspca_dev *gspca_dev)
+static int command_setcompressiontarget(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -983,7 +983,7 @@
 			  sd->params.compressionTarget.targetQ, 0);
 }

-int command_setyuvtresh(struct gspca_dev *gspca_dev)
+static int command_setyuvtresh(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -992,7 +992,7 @@
 			  sd->params.yuvThreshold.uvThreshold, 0, 0);
 }

-int command_setcompressionparams(struct gspca_dev *gspca_dev)
+static int command_setcompressionparams(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1009,7 +1009,7 @@
 			    sd->params.compressionParams.decimationThreshMod);
 }

-int command_setcompression(struct gspca_dev *gspca_dev)
+static int command_setcompression(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1018,7 +1018,7 @@
 			  sd->params.compression.decimation, 0, 0);
 }

-int command_setsensorfps(struct gspca_dev *gspca_dev)
+static int command_setsensorfps(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1027,7 +1027,7 @@
 			  sd->params.sensorFps.baserate, 0, 0);
 }

-int command_setflickerctrl(struct gspca_dev *gspca_dev)
+static int command_setflickerctrl(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1038,7 +1038,7 @@
 			  0);
 }

-int command_setecptiming(struct gspca_dev *gspca_dev)
+static int command_setecptiming(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1046,12 +1046,12 @@
 			  sd->params.ecpTiming, 0, 0, 0);
 }

-int command_pause(struct gspca_dev *gspca_dev)
+static int command_pause(struct gspca_dev *gspca_dev)
 {
 	return do_command(gspca_dev, CPIA_COMMAND_EndStreamCap, 0, 0, 0, 0);
 }

-int command_resume(struct gspca_dev *gspca_dev)
+static int command_resume(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1059,7 +1059,7 @@
 			  0, sd->params.streamStartLine, 0, 0);
 }

-int command_setlights(struct gspca_dev *gspca_dev)
+static int command_setlights(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int ret, p1, p2;
