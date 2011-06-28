Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab1F1Qbu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 12:31:50 -0400
Date: Mon, 27 Jun 2011 23:17:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 04/13] [media] pwc: Use the default version for
 VIDIOC_QUERYCAP
Message-ID: <20110627231723.4d59c2e0@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After discussing with Hans, change pwc to use the default version
control.

The only version ever used for pwc driver is 10.0.12, due to
commit 2b455db6d456ef2d44808a8377fd3bc832e08317.

Changing it to 3.x.y won't conflict with the old version.
There's no namespace conflicts in any predictable future.

Even on the remote far-away case where we might have a conflict,
it will be on just one specific stable Kernel release (Kernel 10.0.12),
if we ever have such stable release.

So, it is safe and consistent on using 3.x.y numering schema for
it.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index f85c512..059bd95 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -349,7 +349,6 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	strcpy(cap->driver, PWC_NAME);
 	strlcpy(cap->card, vdev->name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->version = PWC_VERSION_CODE;
 	cap->capabilities =
 		V4L2_CAP_VIDEO_CAPTURE	|
 		V4L2_CAP_STREAMING	|
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index 78185c6..98950de 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -44,12 +44,7 @@
 #include <media/pwc-ioctl.h>
 
 /* Version block */
-#define PWC_MAJOR	10
-#define PWC_MINOR	0
-#define PWC_EXTRAMINOR	15
-
-#define PWC_VERSION_CODE KERNEL_VERSION(PWC_MAJOR, PWC_MINOR, PWC_EXTRAMINOR)
-#define PWC_VERSION __stringify(PWC_MAJOR) "." __stringify(PWC_MINOR) "." __stringify(PWC_EXTRAMINOR)
+#define PWC_VERSION	"10.0.15"
 #define PWC_NAME 	"pwc"
 #define PFX		PWC_NAME ": "
 
-- 
1.7.1


