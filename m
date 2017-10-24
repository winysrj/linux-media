Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-painless.mh.aa.net.uk ([81.187.30.51]:34645 "EHLO
        a-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdJXUoe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 16:44:34 -0400
From: Adam Sampson <ats@offog.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, linux-media@vger.kernel.org,
        Adam Sampson <ats@offog.org>
Subject: [PATCH] media: usbtv: fix brightness and contrast controls
Date: Tue, 24 Oct 2017 21:14:46 +0100
Message-Id: <20171024201446.30021-1-ats@offog.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Because the brightness and contrast controls share a register,
usbtv_s_ctrl needs to read the existing values for both controls before
inserting the new value. However, the code accidentally wrote to the
registers (from an uninitialised stack array), rather than reading them.

The user-visible effect of this was that adjusting the brightness would
also set the contrast to a random value, and vice versa -- so it wasn't
possible to correctly adjust the brightness of usbtv's video output.

Tested with an "EasyDAY" UTV007 device.

Fixes: c53a846c48f2 ("usbtv: add video controls")
Signed-off-by: Adam Sampson <ats@offog.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 95b5f43..3668a04 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -718,8 +718,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 	 */
 	if (ctrl->id == V4L2_CID_BRIGHTNESS || ctrl->id == V4L2_CID_CONTRAST) {
 		ret = usb_control_msg(usbtv->udev,
-			usb_sndctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
-			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			usb_rcvctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
 		if (ret < 0)
 			goto error;
-- 
2.1.4
