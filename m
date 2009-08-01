Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54087 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZHATtG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Aug 2009 15:49:06 -0400
Date: Sat, 1 Aug 2009 21:49:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: laurent.pinchart@skynet.be, linux-media@vger.kernel.org,
	linux-uvc-devel@lists.berlios.de, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/media/video/uvc: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908012148420.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 87cb9cc..6edaaf6 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -95,7 +95,7 @@ static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
 		const __u32 max = frame->dwFrameInterval[1];
 		const __u32 step = frame->dwFrameInterval[2];
 
-		interval = min + (interval - min + step/2) / step * step;
+		interval = min + DIV_ROUND_CLOSEST(interval-min, step) * step;
 		if (interval > max)
 			interval = max;
 	}
