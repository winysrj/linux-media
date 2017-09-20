Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:51771 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdITRDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:03:05 -0400
Subject: [PATCH 5/5] [media] s2255drv: Delete an unnecessary return statement
 in five functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Message-ID: <9c75bbfd-ee58-3f97-4fa7-47aa306d1396@users.sourceforge.net>
Date: Wed, 20 Sep 2017 19:02:53 +0200
MIME-Version: 1.0
In-Reply-To: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 17:50:36 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement in the affected functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/s2255/s2255drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 5a5d5ae833ff..2f0e0fafc4e2 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -471,6 +471,5 @@ static void planar422p_to_yuv_packed(const unsigned char *in,
 		out[i + 3] = (fmt == V4L2_PIX_FMT_YUYV) ? *pCb++ : *pY++;
 	}
-	return;
 }
 
 static void s2255_reset_dsppower(struct s2255_dev *dev)
@@ -482,5 +481,4 @@ static void s2255_reset_dsppower(struct s2255_dev *dev)
 	s2255_vendor_req(dev, 0x10, 0x0000, 0x0000, NULL, 0, 1);
-	return;
 }
 
 /* kickstarts the firmware loading. from probe
@@ -1586,6 +1584,5 @@ static void s2255_video_device_release(struct video_device *vdev)
 	if (atomic_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
-	return;
 }
 
 static const struct video_device template = {
@@ -1890,5 +1887,4 @@ static void s2255_read_video_callback(struct s2255_dev *dev,
 	dprintk(dev, 50, "callback read video done\n");
-	return;
 }
 
 static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
@@ -2205,5 +2201,4 @@ static void s2255_stop_readpipe(struct s2255_dev *dev)
 	dprintk(dev, 4, "%s", __func__);
-	return;
 }
 
 static void s2255_fwload_start(struct s2255_dev *dev, int reset)
-- 
2.14.1
