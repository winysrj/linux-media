Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:54720 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdBFG5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 01:57:43 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Federico Simoncelli <fsimonce@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [media] usbtv: add sharpness control
Date: Mon,  6 Feb 2017 07:47:36 +0100
Message-Id: <20170206064736.17187-1-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/usb/usbtv/usbtv-video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index d3b6d3d..8135614 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -757,6 +757,12 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 			data[1] = -ctrl->val & 0xff;
 		}
 		break;
+	case V4L2_CID_SHARPNESS:
+		index = USBTV_BASE + 0x0239;
+		data[0] = 0;
+		data[1] = ctrl->val;
+		size = 2;
+		break;
 	default:
 		kfree(data);
 		return -EINVAL;
@@ -825,6 +831,8 @@ int usbtv_video_init(struct usbtv *usbtv)
 			V4L2_CID_SATURATION, 0, 0x3ff, 1, 0x200);
 	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
 			V4L2_CID_HUE, -0xdff, 0xdff, 1, 0x000);
+	v4l2_ctrl_new_std(&usbtv->ctrl, &usbtv_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0x0, 0xff, 1, 0x60);
 	ret = usbtv->ctrl.error;
 	if (ret < 0) {
 		dev_warn(usbtv->dev, "Could not initialize controls\n");
-- 
2.9.3

