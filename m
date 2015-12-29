Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:33210 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbbL2Sut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 13:50:49 -0500
From: Insu Yun <wuninsu@gmail.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, scott.jiang.linux@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] cx231xx: correctly handling failed allocation
Date: Tue, 29 Dec 2015 13:53:35 -0500
Message-Id: <1451415215-8854-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since kmalloc can be failed in memory pressure, 
if not properly handled, NULL dereference can be happend

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 47a98a2..9725e4f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1382,6 +1382,8 @@ static int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 	buffer_size = urb->actual_length;
 
 	buffer = kmalloc(buffer_size, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
 
 	memcpy(buffer, dma_q->ps_head, 3);
 	memcpy(buffer+3, p_buffer, buffer_size-3);
-- 
1.9.1

