Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:63966 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2HJLVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:34 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 4/8] v4l2-ctrls.c: add support for the new DV controls.
Date: Fri, 10 Aug 2012 13:21:20 +0200
Message-Id: <d349804d4366abc957966169f39f9bdbfce1cd78.1344592468.git.hans.verkuil@cisco.com>
In-Reply-To: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
References: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index b6a2ee7..6a34c30 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -425,6 +425,18 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Gray",
 		NULL,
 	};
+	static const char * const dv_tx_mode[] = {
+		"DVI-D",
+		"HDMI",
+		NULL,
+	};
+	static const char * const dv_rgb_range[] = {
+		"Automatic",
+		"RGB limited range (16-235)",
+		"RGB full range (0-255)",
+		NULL,
+	};
+
 
 	switch (id) {
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
@@ -502,6 +514,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg4_profile;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
+	case V4L2_CID_DV_TX_MODE:
+		return dv_tx_mode;
+	case V4L2_CID_DV_TX_RGB_RANGE:
+	case V4L2_CID_DV_RX_RGB_RANGE:
+		return dv_rgb_range;
 
 	default:
 		return NULL;
@@ -733,6 +750,16 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 
+	/* DV controls */
+	case V4L2_CID_DV_CLASS:			return "Digital Video Controls";
+	case V4L2_CID_DV_TX_HOTPLUG:		return "Hotplug Present";
+	case V4L2_CID_DV_TX_RXSENSE:		return "RxSense Present";
+	case V4L2_CID_DV_TX_EDID_PRESENT:	return "EDID Present";
+	case V4L2_CID_DV_TX_MODE:		return "Transmit Mode";
+	case V4L2_CID_DV_TX_RGB_RANGE:		return "Tx RGB Quantization Range";
+	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
+	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
+
 	default:
 		return NULL;
 	}
@@ -832,6 +859,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 	case V4L2_CID_EXPOSURE_METERING:
 	case V4L2_CID_SCENE_MODE:
+	case V4L2_CID_DV_TX_MODE:
+	case V4L2_CID_DV_TX_RGB_RANGE:
+	case V4L2_CID_DV_RX_RGB_RANGE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -853,6 +883,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_JPEG_CLASS:
 	case V4L2_CID_IMAGE_SOURCE_CLASS:
 	case V4L2_CID_IMAGE_PROC_CLASS:
+	case V4L2_CID_DV_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -869,6 +900,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_JPEG_ACTIVE_MARKER:
 	case V4L2_CID_3A_LOCK:
 	case V4L2_CID_AUTO_FOCUS_STATUS:
+	case V4L2_CID_DV_TX_HOTPLUG:
+	case V4L2_CID_DV_TX_RXSENSE:
+	case V4L2_CID_DV_TX_EDID_PRESENT:
+	case V4L2_CID_DV_RX_POWER_PRESENT:
 		*type = V4L2_CTRL_TYPE_BITMASK;
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
@@ -933,6 +968,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STATUS:
 	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
+	case V4L2_CID_DV_TX_HOTPLUG:
+	case V4L2_CID_DV_TX_RXSENSE:
+	case V4L2_CID_DV_TX_EDID_PRESENT:
+	case V4L2_CID_DV_RX_POWER_PRESENT:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	}
-- 
1.7.10.4

