Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61872 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3ASQdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:33:43 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: hans.verkuil@cisco.com, jrnieder@gmail.com, peter.senna@gmail.com,
	emilgoode@gmail.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 01/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:04 -0200
Message-Id: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_VIDEO_CX88_DVB) || \
     defined(CONFIG_VIDEO_CX88_DVB_MODULE)
with:
 #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)

This change was made for: CONFIG_VIDEO_CX88_DVB,
CONFIG_VIDEO_CX88_BLACKBIRD, CONFIG_VIDEO_CX88_VP3054

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/cx88/cx88.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index ba0dba4..feff53c 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -363,7 +363,7 @@ struct cx88_core {
 	unsigned int               tuner_formats;
 
 	/* config info -- dvb */
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
 	int 			   (*prev_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
 #endif
 	void			   (*gate_ctrl)(struct cx88_core  *core, int open);
@@ -562,8 +562,7 @@ struct cx8802_dev {
 
 	/* for blackbird only */
 	struct list_head           devlist;
-#if defined(CONFIG_VIDEO_CX88_BLACKBIRD) || \
-    defined(CONFIG_VIDEO_CX88_BLACKBIRD_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
 	struct video_device        *mpeg_dev;
 	u32                        mailbox;
 	int                        width;
@@ -574,13 +573,12 @@ struct cx8802_dev {
 	struct cx2341x_handler     cxhdl;
 #endif
 
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
 	/* for dvb only */
 	struct videobuf_dvb_frontends frontends;
 #endif
 
-#if defined(CONFIG_VIDEO_CX88_VP3054) || \
-    defined(CONFIG_VIDEO_CX88_VP3054_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
 	/* For VP3045 secondary I2C bus support */
 	struct vp3054_i2c_state	   *vp3054;
 #endif
-- 
1.7.11.7

