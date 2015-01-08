Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47553 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbAHKHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 05:07:36 -0500
Date: Thu, 8 Jan 2015 13:07:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] coda: improve safety in coda_register_device()
Message-ID: <20150108100708.GA10597@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "i" variable is used as an offset into both the dev->vfd[] and the
dev->devtype->vdevs[] arrays.  The second array is smaller so we should
use that as a limit instead of ARRAY_SIZE(dev->vfd).  Also the original
check was off by one.

We should use a format string as well in case the ->name has any funny
characters and also to stop static checkers from complaining.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 39330a7..5dd6cae 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1844,10 +1844,11 @@ static int coda_register_device(struct coda_dev *dev, int i)
 {
 	struct video_device *vfd = &dev->vfd[i];
 
-	if (i > ARRAY_SIZE(dev->vfd))
+	if (i >= dev->devtype->num_vdevs)
 		return -EINVAL;
 
-	snprintf(vfd->name, sizeof(vfd->name), dev->devtype->vdevs[i]->name);
+	snprintf(vfd->name, sizeof(vfd->name), "%s",
+		 dev->devtype->vdevs[i]->name);
 	vfd->fops	= &coda_fops;
 	vfd->ioctl_ops	= &coda_ioctl_ops;
 	vfd->release	= video_device_release_empty,
