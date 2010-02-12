Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0BLGvs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 01:51:48 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1C6plW5018089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 01:51:47 -0500
Received: from [10.11.9.28] (vpn-9-28.rdu.redhat.com [10.11.9.28])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1C6piLL013388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 01:51:46 -0500
Message-ID: <4B74FA7F.5080507@redhat.com>
Date: Fri, 12 Feb 2010 04:51:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] tm6000: only register after initialized
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Udev calls an utility when it senses a v4l device. So, register needs
to be delayed, otherwise it may cause block conditions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/staging/tm6000/tm6000-cards.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index ff04bba..8297801 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -453,11 +453,6 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	if (rc<0)
 		goto err;
 
-	/* register and initialize V4L2 */
-	rc=tm6000_v4l2_register(dev);
-	if (rc<0)
-		goto err;
-
 	/* Default values for STD and resolutions */
 	dev->width = 720;
 	dev->height = 480;
@@ -480,12 +475,18 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"tvaudio", "tvaudio", I2C_ADDR_TDA9874, NULL);
 
+	/* register and initialize V4L2 */
+	rc=tm6000_v4l2_register(dev);
+	if (rc<0)
+		goto err;
+
 	if(dev->caps.has_dvb) {
 		dev->dvb = kzalloc(sizeof(*(dev->dvb)), GFP_KERNEL);
 		if(!dev->dvb) {
 			rc = -ENOMEM;
 			goto err2;
 		}
+
 #ifdef CONFIG_VIDEO_TM6000_DVB
 		rc = tm6000_dvb_register(dev);
 		if(rc < 0) {
-- 
1.6.6.1

