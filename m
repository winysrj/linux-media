Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:58710 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751706AbdIUTYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 15:24:22 -0400
Subject: [PATCH 1/3] [media] uvcvideo: Use common error handling code in
 uvc_ioctl_g_ext_ctrls()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <20a8d1a5-45f1-2f98-e4b3-cfc24e9c04b0@users.sourceforge.net>
Message-ID: <76eb5628-7f9b-c5b7-9341-0904cd719abd@users.sourceforge.net>
Date: Thu, 21 Sep 2017 21:24:16 +0200
MIME-Version: 1.0
In-Reply-To: <20a8d1a5-45f1-2f98-e4b3-cfc24e9c04b0@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 20:47:02 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..6ec2b255c44a 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -998,10 +998,8 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 			struct v4l2_queryctrl qc = { .id = ctrl->id };
 
 			ret = uvc_query_v4l2_ctrl(chain, &qc);
-			if (ret < 0) {
-				ctrls->error_idx = i;
-				return ret;
-			}
+			if (ret < 0)
+				goto set_index;
 
 			ctrl->value = qc.default_value;
 		}
@@ -1017,14 +1015,17 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 		ret = uvc_ctrl_get(chain, ctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
-			ctrls->error_idx = i;
-			return ret;
+			goto set_index;
 		}
 	}
 
 	ctrls->error_idx = 0;
 
 	return uvc_ctrl_rollback(handle);
+
+set_index:
+	ctrls->error_idx = i;
+	return ret;
 }
 
 static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
-- 
2.14.1
