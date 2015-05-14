Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25652 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbbENIjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 04:39:46 -0400
Date: Thu, 14 May 2015 11:39:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] rtl2832_sdr: cleanup some set_bit() calls
Message-ID: <20150514083917.GE1665@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55536721.6070302@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code works fine but static checkers complain.  The test_bit()
function takes the bit number and not a mask.  Then the other issue is
that we were using USB_STATE_URB_BUF which is BIT(0) instead of URB_BUF.
Also we were open coding that instead of using the test/clear/set_bit()
functions.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 3ff8806..6362c6c 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -108,8 +108,8 @@ struct rtl2832_sdr_frame_buf {
 };
 
 struct rtl2832_sdr_dev {
-#define POWER_ON           (1 << 1)
-#define URB_BUF            (1 << 2)
+#define POWER_ON           0  /* BIT(0) */
+#define URB_BUF            1  /* BIT(1) */
 	unsigned long flags;
 
 	struct platform_device *pdev;
@@ -351,7 +351,7 @@ static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
 	struct platform_device *pdev = dev->pdev;
 
-	if (dev->flags & USB_STATE_URB_BUF) {
+	if (test_bit(URB_BUF, &dev->flags)) {
 		while (dev->buf_num) {
 			dev->buf_num--;
 			dev_dbg(&pdev->dev, "free buf=%d\n", dev->buf_num);
@@ -360,7 +360,7 @@ static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 					  dev->dma_addr[dev->buf_num]);
 		}
 	}
-	dev->flags &= ~USB_STATE_URB_BUF;
+	clear_bit(URB_BUF, &dev->flags);
 
 	return 0;
 }
@@ -389,7 +389,7 @@ static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 		dev_dbg(&pdev->dev, "alloc buf=%d %p (dma %llu)\n",
 			dev->buf_num, dev->buf_list[dev->buf_num],
 			(long long)dev->dma_addr[dev->buf_num]);
-		dev->flags |= USB_STATE_URB_BUF;
+		set_bit(URB_BUF, &dev->flags);
 	}
 
 	return 0;
