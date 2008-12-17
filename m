Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHIj69W024477
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:45:06 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHIiOwv013042
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:44:27 -0500
Date: Wed, 17 Dec 2008 19:44:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812171935040.8733@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 1/4] pxa-camera: call try_fmt() camera device method with
 correct pixel format
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

With the introduction of the format conversion support in soc-camera, we now
also have to take care to pass the correct pixel format to the camera driver
when calling its try_fmt() method.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

These 4 patches are for everyone to review / comment upon. They are in my 
stack since a while, but I haven't sent them to the list yet. They are 
otherwise not related, and will probably not apply well to any existing 
state. To test one needs all the other patches currently on the queue:

http://gross-embedded.homelinux.org/~lyakh/v4l-20081217/

Magnus, you probably want to add a similar work-around for 
sh_mobile_ceu_camera.c

 drivers/media/video/pxa_camera.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index f72851e..56f972f 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1218,6 +1218,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	__u32 pixfmt = pix->pixelformat;
+	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
@@ -1240,8 +1241,13 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	pix->sizeimage = pix->height * pix->bytesperline;
 
+	/* camera has to see its format, but the user the original one */
+	pix->pixelformat = xlate->cam_fmt->fourcc;
 	/* limit to sensor capabilities */
-	return icd->ops->try_fmt(icd, f);
+	ret = icd->ops->try_fmt(icd, f);
+	pix->pixelformat = xlate->host_fmt->fourcc;
+
+	return ret;
 }
 
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
