Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36610 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967664AbaLLN2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] cx231xx: remove btcx_riscmem reference
Date: Fri, 12 Dec 2014 14:27:55 +0100
Message-Id: <1418390880-39009-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
References: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove this comment block, it's unused. This removes the btcx_riscmem
reference as well, since that will no longer be available to other
drivers except bttv.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index f9e262eb..6d6f3ee 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -532,15 +532,7 @@ struct cx231xx_video_mode {
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
 	u16 end_point_addr;
 };
-/*
-struct cx23885_dmaqueue {
-	struct list_head       active;
-	struct list_head       queued;
-	struct timer_list      timeout;
-	struct btcx_riscmem    stopper;
-	u32                    count;
-};
-*/
+
 struct cx231xx_tsport {
 	struct cx231xx *dev;
 
-- 
2.1.3

