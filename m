Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37630 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751119AbeBAHgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 02:36:37 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix incorrect capabilities for radio
Message-ID: <3c2f8a95-9e1c-30ac-e3bf-320b46ba485b@xs4all.nl>
Date: Thu, 1 Feb 2018 08:36:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivid driver has two custom controls that change the behavior of RDS.
Depending on the control setting the V4L2_CAP_READWRITE capability is toggled.
However, after an earlier commit the capability was no longer set correctly.
This is now fixed.

Fixes: 9765a32cd8 ("vivid: set device_caps in video_device")

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 3f9d354827af..c586c2ab9b31 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1208,6 +1208,7 @@ static int vivid_radio_rx_s_ctrl(struct v4l2_ctrl *ctrl)
 		v4l2_ctrl_activate(dev->radio_rx_rds_ta, dev->radio_rx_rds_controls);
 		v4l2_ctrl_activate(dev->radio_rx_rds_tp, dev->radio_rx_rds_controls);
 		v4l2_ctrl_activate(dev->radio_rx_rds_ms, dev->radio_rx_rds_controls);
+		dev->radio_rx_dev.device_caps = dev->radio_rx_caps;
 		break;
 	case V4L2_CID_RDS_RECEPTION:
 		dev->radio_rx_rds_enabled = ctrl->val;
@@ -1282,6 +1283,7 @@ static int vivid_radio_tx_s_ctrl(struct v4l2_ctrl *ctrl)
 		dev->radio_tx_caps &= ~V4L2_CAP_READWRITE;
 		if (!dev->radio_tx_rds_controls)
 			dev->radio_tx_caps |= V4L2_CAP_READWRITE;
+		dev->radio_tx_dev.device_caps = dev->radio_tx_caps;
 		break;
 	case V4L2_CID_RDS_TX_PTY:
 		if (dev->radio_rx_rds_controls)
