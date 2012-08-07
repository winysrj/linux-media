Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2HGCsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:00 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:59 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 13/24] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
Date: Mon,  6 Aug 2012 22:47:03 -0400
Message-Id: <1344307634-11673-14-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We weren't checking whether the resource was in use before calling res_free(),
so applications which called STREAMOFF on a v4l2 device that wasn't already
streaming would cause a BUG() to be hit (MythTV).

Reported-by: Larry Finger <larry.finger@lwfinger.net>
Reported-by: Jay Harbeston <jharbestonus@gmail.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-video.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index df92322..4d5b670 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1702,14 +1702,18 @@ static int vidioc_streamoff(struct file *file, void *priv,
 			(AUVI_INPUT(i).audio_setup)(dev, 0);
 		}
 
-		videobuf_streamoff(&fh->vb_vidq);
-		res_free(fh, AU0828_RESOURCE_VIDEO);
+		if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
+			videobuf_streamoff(&fh->vb_vidq);
+			res_free(fh, AU0828_RESOURCE_VIDEO);
+		}
 	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		dev->vbi_timeout_running = 0;
 		del_timer_sync(&dev->vbi_timeout);
 
-		videobuf_streamoff(&fh->vb_vbiq);
-		res_free(fh, AU0828_RESOURCE_VBI);
+		if (res_check(fh, AU0828_RESOURCE_VBI)) {
+			videobuf_streamoff(&fh->vb_vbiq);
+			res_free(fh, AU0828_RESOURCE_VBI);
+		}
 	}
 
 	return 0;
-- 
1.7.1

