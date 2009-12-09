Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:52731 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216AbZLITXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 14:23:44 -0500
Date: Wed, 9 Dec 2009 20:23:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 5/12] drivers/media/video/uvc: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092023310.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/uvc/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -145,7 +145,7 @@ static int uvc_get_video_ctrl(struct uvc
 		uvc_warn_once(stream->dev, UVC_WARN_MINMAX, "UVC non "
 			"compliance - GET_MIN/MAX(PROBE) incorrectly "
 			"supported. Enabling workaround.\n");
-		memset(ctrl, 0, sizeof ctrl);
+		memset(ctrl, 0, sizeof *ctrl);
 		ctrl->wCompQuality = le16_to_cpup((__le16 *)data);
 		ret = 0;
 		goto out;
