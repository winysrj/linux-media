Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50285 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaHUCF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 22:05:27 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAM00G2RWH17M90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Aug 2014 11:05:25 +0900 (KST)
From: Changbing Xiong <cb.xiong@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, crope@iki.fi
Subject: [PATCH 2/3] media: correct return value in dvb_demux_poll
Date: Thu, 21 Aug 2014 10:05:07 +0800
Message-id: <1408586707-2137-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Data type of return value is unsigned int, but in function of dvb_demux_poll,
when the pointer of dmxdevfilter equals NULL, it will return -EINVAL, which
is invalid.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/dvb-core/dmxdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/media/dvb-core/dmxdev.c

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
old mode 100644
new mode 100755
index c0363f1..7a5c070
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1088,7 +1088,7 @@ static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
 	unsigned int mask = 0;

 	if (!dmxdevfilter)
-		return -EINVAL;
+		return POLLERR;

 	poll_wait(file, &dmxdevfilter->buffer.queue, wait);

--
1.7.9.5

