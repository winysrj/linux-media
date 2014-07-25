Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4201 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGYLUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 07:20:18 -0400
Message-ID: <53D23D5A.1020700@xs4all.nl>
Date: Fri, 25 Jul 2014 13:19:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: fix potential null dereference
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/solo6x10/solo6x10-disp.c:221 solo_set_motion_block() error: potential null dereference 
'buf'.  (kzalloc returns null)

Also propagate this error up the chain.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>

diff --git a/drivers/media/pci/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
index ed88ab4..5ea9cac 100644
--- a/drivers/media/pci/solo6x10/solo6x10-disp.c
+++ b/drivers/media/pci/solo6x10/solo6x10-disp.c
@@ -216,6 +216,8 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 	int ret = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
 			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 2e07b49..d12083f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -1137,11 +1137,13 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 		solo_enc->motion_enabled = ctrl->val > V4L2_DETECT_MD_MODE_DISABLED;
 		if (ctrl->val) {
 			if (solo_enc->motion_global)
-				solo_set_motion_threshold(solo_dev, solo_enc->ch,
+				err = solo_set_motion_threshold(solo_dev, solo_enc->ch,
 					solo_enc->motion_thresh);
 			else
-				solo_set_motion_block(solo_dev, solo_enc->ch,
+				err = solo_set_motion_block(solo_dev, solo_enc->ch,
 					solo_enc->md_thresholds->p_cur.p_u16);
+			if (err)
+				return err;
 		}
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
@@ -1152,8 +1154,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_OSD_TEXT:
 		strcpy(solo_enc->osd_text, ctrl->p_new.p_char);
-		err = solo_osd_print(solo_enc);
-		return err;
+		return solo_osd_print(solo_enc);
 	default:
 		return -EINVAL;
 	}
