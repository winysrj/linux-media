Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaAFM0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 07:26:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx: prevent registering wrong interfaces for audio-only
Date: Mon,  6 Jan 2014 07:22:54 -0200
Message-Id: <1389000175-7301-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389000175-7301-1-git-send-email-m.chehab@samsung.com>
References: <1389000175-7301-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few devices (em2860) use a separate interface for audio only
Audio Vendor Class USB. That interface should not be used by
Remote Controller, Analog TV or Digital TV.

Prevents initializing all non-audio extensions for the audio
only interface.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c   | 10 ++++++++++
 drivers/media/usb/em28xx/em28xx-input.c | 10 ++++++++++
 drivers/media/usb/em28xx/em28xx-video.c | 10 ++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 7fa1c804c34c..5c6be66ac858 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -992,6 +992,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	int result = 0, mfe_shared = 0;
 	struct em28xx_dvb *dvb;
 
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
 		return 0;
@@ -1431,6 +1436,11 @@ static inline void prevent_sleep(struct dvb_frontend_ops *ops)
 
 static int em28xx_dvb_fini(struct em28xx *dev)
 {
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
 		return 0;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index f3b629dd57ae..9a5dad96ff08 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -673,6 +673,11 @@ static int em28xx_ir_init(struct em28xx *dev)
 	u64 rc_type;
 	u16 i2c_rc_dev_addr = 0;
 
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	if (dev->board.buttons)
 		em28xx_init_buttons(dev);
 
@@ -802,6 +807,11 @@ static int em28xx_ir_fini(struct em28xx *dev)
 {
 	struct em28xx_IR *ir = dev->ir;
 
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	em28xx_shutdown_buttons(dev);
 
 	/* skip detach on non attached boards */
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 856f18f9daea..ac3986b67201 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1877,6 +1877,11 @@ static int em28xx_v4l2_open(struct file *filp)
 */
 static int em28xx_v4l2_fini(struct em28xx *dev)
 {
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	if (!dev->has_video) {
 		/* This device does not support the v4l2 extension */
 		return 0;
@@ -2208,6 +2213,11 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	unsigned int maxw;
 	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 
+	if (dev->is_audio_only) {
+		/* Shouldn't initialize IR for this interface */
+		return 0;
+	}
+
 	if (!dev->has_video) {
 		/* This device does not support the v4l2 extension */
 		return 0;
-- 
1.8.3.1

