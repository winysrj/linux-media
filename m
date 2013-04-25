Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab3DYTIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 15:08:07 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PJ86b7018965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 15:08:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] cx25821-video: remove maxw from cx25821_vidioc_try_fmt_vid_cap
Date: Thu, 25 Apr 2013 16:08:00 -0300
Message-Id: <1366916882-3565-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
References: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After cx25821-video cleanup, this var is not used anymore:

drivers/media/pci/cx25821/cx25821-video.c: In function 'cx25821_vidioc_try_fmt_vid_cap':
drivers/media/pci/cx25821/cx25821-video.c:591:15: warning: variable 'maxw' set but not used [-Wunused-but-set-variable]

as the code now checks the max width as the default case for the
range check.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx25821/cx25821-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index b194138..3ba856a 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -588,13 +588,12 @@ static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct cx25821_dev *dev = chan->dev;
 	const struct cx25821_fmt *fmt;
 	enum v4l2_field field = f->fmt.pix.field;
-	unsigned int maxw, maxh;
+	unsigned int maxh;
 	unsigned w;
 
 	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
 	if (NULL == fmt)
 		return -EINVAL;
-	maxw = 720;
 	maxh = (dev->tvnorm & V4L2_STD_625_50) ? 576 : 480;
 
 	w = f->fmt.pix.width;
-- 
1.8.1.4

