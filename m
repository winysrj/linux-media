Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaEILzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 07:55:49 -0400
Date: Fri, 9 May 2014 14:55:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jingoo Han <jg1.han@samsung.com>, Jon Mason <jdmason@kudzu.us>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kristina =?utf-8?Q?Mart=C5=A1enko?=
	<kristina.martsenko@gmail.com>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] Staging: dt3155v4l: set error code on failure
Message-ID: <20140509115509.GA32027@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should be returning -ENOMEM here instead of success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index afbc2e5..178aa5b 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -907,8 +907,10 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!pd)
 		return -ENOMEM;
 	pd->vdev = video_device_alloc();
-	if (!pd->vdev)
+	if (!pd->vdev) {
+		err = -ENOMEM;
 		goto err_video_device_alloc;
+	}
 	*pd->vdev = dt3155_vdev;
 	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
 	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
