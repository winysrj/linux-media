Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3411 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3BIKB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 25/26] cx231xx: fix big-endian problems.
Date: Sat,  9 Feb 2013 11:00:55 +0100
Message-Id: <0ac33a4bb589982c717afbf986543f2241d3a9e3.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested on my big-endian ppc-based test machine.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c   |    4 ++--
 drivers/media/usb/cx231xx/cx231xx-avcore.c  |    8 ++++----
 drivers/media/usb/cx231xx/cx231xx-cards.c   |   16 ++++++++--------
 drivers/media/usb/cx231xx/cx231xx-core.c    |    2 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c |    2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index b40360b..81a1d97 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -704,8 +704,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 					    audio_index + 1];
 
 	adev->end_point_addr =
-	    le16_to_cpu(uif->altsetting[0].endpoint[isoc_pipe].desc.
-			bEndpointAddress);
+	    uif->altsetting[0].endpoint[isoc_pipe].desc.
+			bEndpointAddress;
 
 	adev->num_alt = uif->num_altsetting;
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 4706ed3..3f26f64 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2221,7 +2221,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (status < 0)
 		return status;
 
-	tmp = *((u32 *) value);
+	tmp = le32_to_cpu(*((u32 *) value));
 
 	switch (mode) {
 	case POLARIS_AVMODE_ENXTERNAL_AV:
@@ -2442,7 +2442,7 @@ int cx231xx_power_suspend(struct cx231xx *dev)
 	if (status > 0)
 		return status;
 
-	tmp = *((u32 *) value);
+	tmp = le32_to_cpu(*((u32 *) value));
 	tmp &= (~PWR_MODE_MASK);
 
 	value[0] = (u8) tmp;
@@ -2470,7 +2470,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	if (status < 0)
 		return status;
 
-	tmp = *((u32 *) value);
+	tmp = le32_to_cpu(*((u32 *) value));
 	tmp |= ep_mask;
 	value[0] = (u8) tmp;
 	value[1] = (u8) (tmp >> 8);
@@ -2495,7 +2495,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	if (status < 0)
 		return status;
 
-	tmp = *((u32 *) value);
+	tmp = le32_to_cpu(*((u32 *) value));
 	tmp &= (~ep_mask);
 	value[0] = (u8) tmp;
 	value[1] = (u8) (tmp >> 8);
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 62d104b..b7b1acd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1189,8 +1189,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	uif = udev->actconfig->interface[dev->current_pcb_config.
 		       hs_config_info[0].interface_info.video_index + 1];
 
-	dev->video_mode.end_point_addr = le16_to_cpu(uif->altsetting[0].
-			endpoint[isoc_pipe].desc.bEndpointAddress);
+	dev->video_mode.end_point_addr = uif->altsetting[0].
+			endpoint[isoc_pipe].desc.bEndpointAddress;
 
 	dev->video_mode.num_alt = uif->num_altsetting;
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
@@ -1223,8 +1223,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				       vanc_index + 1];
 
 	dev->vbi_mode.end_point_addr =
-	    le16_to_cpu(uif->altsetting[0].endpoint[isoc_pipe].desc.
-			bEndpointAddress);
+	    uif->altsetting[0].endpoint[isoc_pipe].desc.
+			bEndpointAddress;
 
 	dev->vbi_mode.num_alt = uif->num_altsetting;
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
@@ -1258,8 +1258,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 				       hanc_index + 1];
 
 	dev->sliced_cc_mode.end_point_addr =
-	    le16_to_cpu(uif->altsetting[0].endpoint[isoc_pipe].desc.
-			bEndpointAddress);
+	    uif->altsetting[0].endpoint[isoc_pipe].desc.
+			bEndpointAddress;
 
 	dev->sliced_cc_mode.num_alt = uif->num_altsetting;
 	cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
@@ -1294,8 +1294,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 					       ts1_index + 1];
 
 		dev->ts1_mode.end_point_addr =
-		    le16_to_cpu(uif->altsetting[0].endpoint[isoc_pipe].
-				desc.bEndpointAddress);
+		    uif->altsetting[0].endpoint[isoc_pipe].
+				desc.bEndpointAddress;
 
 		dev->ts1_mode.num_alt = uif->num_altsetting;
 		cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 05358d4..4ba3ce0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1488,7 +1488,7 @@ int cx231xx_mode_register(struct cx231xx *dev, u16 address, u32 mode)
 	if (status < 0)
 		return status;
 
-	tmp = *((u32 *) value);
+	tmp = le32_to_cpu(*((u32 *) value));
 	tmp |= mode;
 
 	value[0] = (u8) tmp;
diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index 7473c33..d7308ab 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -672,7 +672,7 @@ u32 initialize_cx231xx(struct cx231xx *dev)
 	pcb config it is related to */
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);
 
-	config_info = *((u32 *) data);
+	config_info = le32_to_cpu(*((u32 *) data));
 	usb_speed = (u8) (config_info & 0x1);
 
 	/* Verify this device belongs to Bus power or Self power device */
-- 
1.7.10.4

