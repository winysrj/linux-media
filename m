Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1404 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbbKVR43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2015 12:56:29 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Andy Walls <awalls@md.metrocast.net>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx231xx: constify cx2341x_handler_ops structures
Date: Sun, 22 Nov 2015 18:44:38 +0100
Message-Id: <1448214278-5261-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx2341x_handler_ops structures are never modified, so declare them as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/cx18/cx18-controls.c  |    2 +-
 drivers/media/pci/cx18/cx18-controls.h  |    2 +-
 drivers/media/pci/ivtv/ivtv-controls.c  |    2 +-
 drivers/media/pci/ivtv/ivtv-controls.h  |    2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index f59a6f1..66b1b00 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1901,7 +1901,7 @@ static int cx231xx_s_audio_sampling_freq(struct cx2341x_handler *cxhdl, u32 idx)
 	return 0;
 }
 
-static struct cx2341x_handler_ops cx231xx_ops = {
+static const struct cx2341x_handler_ops cx231xx_ops = {
 	/* needed for the video clock freq */
 	.s_audio_sampling_freq = cx231xx_s_audio_sampling_freq,
 	/* needed for setting up the video resolution */
diff --git a/drivers/media/pci/cx18/cx18-controls.c b/drivers/media/pci/cx18/cx18-controls.c
index 71227a1..adb5a8c 100644
--- a/drivers/media/pci/cx18/cx18-controls.c
+++ b/drivers/media/pci/cx18/cx18-controls.c
@@ -126,7 +126,7 @@ static int cx18_s_audio_mode(struct cx2341x_handler *cxhdl, u32 val)
 	return 0;
 }
 
-struct cx2341x_handler_ops cx18_cxhdl_ops = {
+const struct cx2341x_handler_ops cx18_cxhdl_ops = {
 	.s_audio_mode = cx18_s_audio_mode,
 	.s_audio_sampling_freq = cx18_s_audio_sampling_freq,
 	.s_video_encoding = cx18_s_video_encoding,
diff --git a/drivers/media/pci/cx18/cx18-controls.h b/drivers/media/pci/cx18/cx18-controls.h
index cb5dfc7..3267948 100644
--- a/drivers/media/pci/cx18/cx18-controls.h
+++ b/drivers/media/pci/cx18/cx18-controls.h
@@ -21,4 +21,4 @@
  *  02111-1307  USA
  */
 
-extern struct cx2341x_handler_ops cx18_cxhdl_ops;
+extern const struct cx2341x_handler_ops cx18_cxhdl_ops;
diff --git a/drivers/media/pci/ivtv/ivtv-controls.c b/drivers/media/pci/ivtv/ivtv-controls.c
index 8a55ccb..9666ca0 100644
--- a/drivers/media/pci/ivtv/ivtv-controls.c
+++ b/drivers/media/pci/ivtv/ivtv-controls.c
@@ -96,7 +96,7 @@ static int ivtv_s_audio_mode(struct cx2341x_handler *cxhdl, u32 val)
 	return 0;
 }
 
-struct cx2341x_handler_ops ivtv_cxhdl_ops = {
+const struct cx2341x_handler_ops ivtv_cxhdl_ops = {
 	.s_audio_mode = ivtv_s_audio_mode,
 	.s_audio_sampling_freq = ivtv_s_audio_sampling_freq,
 	.s_video_encoding = ivtv_s_video_encoding,
diff --git a/drivers/media/pci/ivtv/ivtv-controls.h b/drivers/media/pci/ivtv/ivtv-controls.h
index 3999e63..ea397ba 100644
--- a/drivers/media/pci/ivtv/ivtv-controls.h
+++ b/drivers/media/pci/ivtv/ivtv-controls.h
@@ -21,7 +21,7 @@
 #ifndef IVTV_CONTROLS_H
 #define IVTV_CONTROLS_H
 
-extern struct cx2341x_handler_ops ivtv_cxhdl_ops;
+extern const struct cx2341x_handler_ops ivtv_cxhdl_ops;
 extern const struct v4l2_ctrl_ops ivtv_hdl_out_ops;
 int ivtv_g_pts_frame(struct ivtv *itv, s64 *pts, s64 *frame);
 

