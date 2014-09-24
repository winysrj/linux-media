Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18017 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIXKhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 06:37:08 -0400
Date: Wed, 24 Sep 2014 13:36:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] hackrf: harmless off by one in debug code
Message-ID: <20140924103639.GB15107@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My static checker complains that "i" could be one element beyond the end
of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 328b5ba..fd1fa41 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -932,7 +932,7 @@ static int hackrf_set_bandwidth(struct hackrf_dev *dev)
 	dev->bandwidth->val = bandwidth;
 	dev->bandwidth->cur.val = bandwidth;
 
-	dev_dbg(dev->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
+	dev_dbg(dev->dev, "bandwidth selected=%d\n", bandwidth);
 
 	u16tmp = 0;
 	u16tmp |= ((bandwidth >> 0) & 0xff) << 0;
