Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:59558 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0C0MZl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 08:25:41 -0400
Received: from kabelnet-194-37.juropnet.hu ([91.147.194.37])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NvV56-0006i3-AH
	for linux-media@vger.kernel.org; Sat, 27 Mar 2010 13:25:38 +0100
Message-ID: <4BADFAA4.9050001@mailbox.hu>
Date: Sat, 27 Mar 2010 13:31:32 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: fix checks for analog TV inputs
Content-Type: multipart/mixed;
 boundary="------------060505050600090604000602"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505050600090604000602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The following patch fixes code that checks for CX88_VMUX_TELEVISION,
but not CX88_VMUX_CABLE. This prevented for example the audio standard
from being set when using the cable input.

Signed-off-by: Istvan Varga <istvanv@users.sourceforge.net>

--------------060505050600090604000602
Content-Type: text/x-patch;
 name="cx88-input-cable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx88-input-cable.patch"

diff -r -d -N -U4 v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-core.c v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-core.c
--- v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-core.c	2010-03-23 03:39:52.000000000 +0100
+++ v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-core.c	2010-03-23 19:07:26.000000000 +0100
@@ -871,9 +871,10 @@
 static int set_tvaudio(struct cx88_core *core)
 {
 	v4l2_std_id norm = core->tvnorm;
 
-	if (CX88_VMUX_TELEVISION != INPUT(core->input).type)
+	if (CX88_VMUX_TELEVISION != INPUT(core->input).type &&
+	    CX88_VMUX_CABLE != INPUT(core->input).type)
 		return 0;
 
 	if (V4L2_STD_PAL_BG & norm) {
 		core->tvaudio = WW_BG;
diff -r -d -N -U4 v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-video.c v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-video.c
--- v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-video.c	2010-03-23 03:39:52.000000000 +0100
+++ v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-video.c	2010-03-23 19:07:26.000000000 +0100
@@ -426,14 +426,15 @@
 		   routes for different inputs. HVR-1300 surely does */
 		if (core->board.audio_chip &&
 		    core->board.audio_chip == V4L2_IDENT_WM8775) {
 			call_all(core, audio, s_routing,
-					INPUT(input).audioroute, 0, 0);
+				 INPUT(input).audioroute, 0, 0);
 		}
 		/* cx2388's C-ADC is connected to the tuner only.
 		   When used with S-Video, that ADC is busy dealing with
 		   chroma, so an external must be used for baseband audio */
-		if (INPUT(input).type != CX88_VMUX_TELEVISION ) {
+		if (INPUT(input).type != CX88_VMUX_TELEVISION &&
+		    INPUT(input).type != CX88_VMUX_CABLE) {
 			/* "I2S ADC mode" */
 			core->tvaudio = WW_I2SADC;
 			cx88_set_tvaudio(core);
 		} else {

--------------060505050600090604000602--
