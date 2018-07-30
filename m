Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41223 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbeG3LHi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 07:07:38 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: crope@iki.fi, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: usb: hackrf: Replace GFP_ATOMIC with GFP_KERNEL
Date: Mon, 30 Jul 2018 17:33:20 +0800
Message-Id: <20180730093320.8007-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hackrf_submit_urbs(), hackrf_alloc_stream_bufs() and hackrf_alloc_urbs() 
are never called in atomic context.
They call usb_submit_urb(), usb_alloc_coherent() and usb_alloc_urb() 
with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/usb/hackrf/hackrf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 7eb53517a82f..520a3c6dee43 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -597,7 +597,7 @@ static int hackrf_submit_urbs(struct hackrf_dev *dev)
 
 	for (i = 0; i < dev->urbs_initialized; i++) {
 		dev_dbg(dev->dev, "submit urb=%d\n", i);
-		ret = usb_submit_urb(dev->urb_list[i], GFP_ATOMIC);
+		ret = usb_submit_urb(dev->urb_list[i], GFP_KERNEL);
 		if (ret) {
 			dev_err(dev->dev, "Could not submit URB no. %d - get them all back\n",
 					i);
@@ -636,7 +636,7 @@ static int hackrf_alloc_stream_bufs(struct hackrf_dev *dev)
 
 	for (dev->buf_num = 0; dev->buf_num < MAX_BULK_BUFS; dev->buf_num++) {
 		dev->buf_list[dev->buf_num] = usb_alloc_coherent(dev->udev,
-				BULK_BUFFER_SIZE, GFP_ATOMIC,
+				BULK_BUFFER_SIZE, GFP_KERNEL,
 				&dev->dma_addr[dev->buf_num]);
 		if (!dev->buf_list[dev->buf_num]) {
 			dev_dbg(dev->dev, "alloc buf=%d failed\n",
@@ -689,7 +689,7 @@ static int hackrf_alloc_urbs(struct hackrf_dev *dev, bool rcv)
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
 		dev_dbg(dev->dev, "alloc urb=%d\n", i);
-		dev->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
+		dev->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!dev->urb_list[i]) {
 			for (j = 0; j < i; j++)
 				usb_free_urb(dev->urb_list[j]);
-- 
2.17.0
