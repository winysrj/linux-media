Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab2JXN3G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 09:29:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: stable@kernel.org
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
Date: Wed, 24 Oct 2012 11:28:59 -0200
Message-Id: <1351085339-826-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Devin Heitmueller <dheitmueller@kernellabs.com>

We weren't checking whether the resource was in use before calling
res_free(), so applications which called STREAMOFF on a v4l2 device that
wasn't already streaming would cause a BUG() to be hit (MythTV).

Reported-by: Larry Finger <larry.finger@lwfinger.net>
Reported-by: Jay Harbeston <jharbestonus@gmail.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

Upstream commit: a595c1ce4c9d572cf53513570b9f1a263d7867f2
Fixes Fedora BZ: https://bugzilla.redhat.com/show_bug.cgi?id=819321

 drivers/media/video/au0828/au0828-video.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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
1.7.11.7

