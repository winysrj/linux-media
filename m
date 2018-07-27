Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35232 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbeG0EMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:12:36 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: crope@iki.fi, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: dvb-frontends: rtl2832_sdr: Replace GFP_ATOMIC with GFP_KERNEL
Date: Fri, 27 Jul 2018 10:52:49 +0800
Message-Id: <20180727025249.2249-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rtl2832_sdr_submit_urbs(), rtl2832_sdr_alloc_stream_bufs(), and 
rtl2832_sdr_alloc_urbs() are never called in atomic context.
They call usb_submit_urb(), usb_alloc_coherent() and usb_alloc_urb() 
with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index c6e78d870ccd..d448d9d4879c 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -301,7 +301,7 @@ static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_dev *dev)
 
 	for (i = 0; i < dev->urbs_initialized; i++) {
 		dev_dbg(&pdev->dev, "submit urb=%d\n", i);
-		ret = usb_submit_urb(dev->urb_list[i], GFP_ATOMIC);
+		ret = usb_submit_urb(dev->urb_list[i], GFP_KERNEL);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"Could not submit urb no. %d - get them all back\n",
@@ -345,7 +345,7 @@ static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 
 	for (dev->buf_num = 0; dev->buf_num < MAX_BULK_BUFS; dev->buf_num++) {
 		dev->buf_list[dev->buf_num] = usb_alloc_coherent(dev->udev,
-				BULK_BUFFER_SIZE, GFP_ATOMIC,
+				BULK_BUFFER_SIZE, GFP_KERNEL,
 				&dev->dma_addr[dev->buf_num]);
 		if (!dev->buf_list[dev->buf_num]) {
 			dev_dbg(&pdev->dev, "alloc buf=%d failed\n",
@@ -390,7 +390,7 @@ static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_dev *dev)
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
 		dev_dbg(&pdev->dev, "alloc urb=%d\n", i);
-		dev->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
+		dev->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!dev->urb_list[i]) {
 			for (j = 0; j < i; j++)
 				usb_free_urb(dev->urb_list[j]);
-- 
2.17.0
