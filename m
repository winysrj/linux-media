Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46425
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750728AbdESMKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 6/6] [media] uvcvideo: annotate a switch fall through
Date: Fri, 19 May 2017 09:10:04 -0300
Message-Id: <af3a8480646cf5816528c44210dd4a70fb2026e9.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without annotations, gcc 7.1 will complain.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index a29f39d4e05b..fb86d6af398d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1323,7 +1323,7 @@ static void uvc_video_complete(struct urb *urb)
 	default:
 		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
 			"completion handler.\n", urb->status);
-
+		/* fall through */
 	case -ENOENT:		/* usb_kill_urb() called. */
 		if (stream->frozen)
 			return;
-- 
2.9.3
