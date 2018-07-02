Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:41276 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752808AbeGBVXb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 17:23:31 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v7 2/6] cx25840: add kernel-doc description of struct cx25840_state
Date: Mon,  2 Jul 2018 23:23:22 +0200
Message-Id: <761723d6712a2fe01b8118acfd9444ab9bcf917f.1530565770.git.mail@maciej.szmigiero.name>
In-Reply-To: <cover.1530565770.git.mail@maciej.szmigiero.name>
References: <cover.1530565770.git.mail@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit describes a device instance private data of the driver
(struct cx25840_state) in a kernel-doc style comment.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/i2c/cx25840/cx25840-core.h | 33 ++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index fb13a624d2e3..c323b1af1f83 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -45,6 +45,35 @@ enum cx25840_media_pads {
 	CX25840_NUM_PADS
 };
 
+/**
+ * struct cx25840_state - a device instance private data
+ * @c:			i2c_client struct representing this device
+ * @sd:		our V4L2 sub-device
+ * @hdl:		our V4L2 control handler
+ * @volume:		audio volume V4L2 control (non-cx2583x devices only)
+ * @mute:		audio mute V4L2 control (non-cx2583x devices only)
+ * @pvr150_workaround:	whether we enable workaround for Hauppauge PVR150
+ *			hardware bug (audio dropping out)
+ * @radio:		set if we are currently in the radio mode, otherwise
+ *			the current mode is non-radio (that is, video)
+ * @std:		currently set video standard
+ * @vid_input:		currently set video input
+ * @aud_input:		currently set audio input
+ * @audclk_freq:	currently set audio sample rate
+ * @audmode:		currently set audio mode (when in non-radio mode)
+ * @vbi_line_offset:	vbi line number offset
+ * @id:		exact device model
+ * @rev:		raw device id read from the chip
+ * @is_initialized:	whether we have already loaded firmware into the chip
+ *			and initialized it
+ * @vbi_regs_offset:	offset of vbi regs
+ * @fw_wait:		wait queue to wake an initalization function up when
+ *			firmware loading (on a separate workqueue) finishes
+ * @fw_work:		a work that actually loads the firmware on a separate
+ *			workqueue
+ * @ir_state:		a pointer to chip IR controller private data
+ * @pads:		array of supported chip pads (currently only a stub)
+ */
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
@@ -66,8 +95,8 @@ struct cx25840_state {
 	u32 rev;
 	int is_initialized;
 	unsigned vbi_regs_offset;
-	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
-	struct work_struct fw_work;   /* work entry for fw load */
+	wait_queue_head_t fw_wait;
+	struct work_struct fw_work;
 	struct cx25840_ir_state *ir_state;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_pad	pads[CX25840_NUM_PADS];
