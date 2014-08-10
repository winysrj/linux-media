Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaHJArl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 08/18] [media] au0828: properly handle stream on/off state
Date: Sat,  9 Aug 2014 21:47:14 -0300
Message-Id: <1407631644-11990-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The STREAM_ON state is used by s_format callback,
but the driver never sets it.

Fix it. This will also be needed in order to handle
suspend/resume ops.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 98f7ea1d6d63..36ff3b496f87 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -159,6 +159,7 @@ static void au0828_irq_callback(struct urb *urb)
 		au0828_isocdbg("urb resubmit failed (error=%i)\n",
 			       urb->status);
 	}
+	dev->stream_state = STREAM_ON;
 }
 
 /*
@@ -198,6 +199,8 @@ static void au0828_uninit_isoc(struct au0828_dev *dev)
 	dev->isoc_ctl.urb = NULL;
 	dev->isoc_ctl.transfer_buffer = NULL;
 	dev->isoc_ctl.num_bufs = 0;
+
+	dev->stream_state = STREAM_OFF;
 }
 
 /*
-- 
1.9.3

