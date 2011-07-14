Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab1GNWEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:04:54 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EM4rZP019333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:04:54 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] redrat3: remove unused dev struct members
Date: Thu, 14 Jul 2011 18:04:49 -0400
Message-Id: <1310681089-3204-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/redrat3.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5fc2f05..ee1303c 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -195,11 +195,6 @@ struct redrat3_dev {
 	dma_addr_t dma_in;
 	dma_addr_t dma_out;
 
-	/* true if write urb is busy */
-	bool write_busy;
-	/* wait for the write to finish */
-	struct completion write_finished;
-
 	/* locks this structure */
 	struct mutex lock;
 
@@ -207,8 +202,6 @@ struct redrat3_dev {
 	struct timer_list rx_timeout;
 	u32 hw_timeout;
 
-	/* Is the device currently receiving? */
-	bool recv_in_progress;
 	/* is the detector enabled*/
 	bool det_enabled;
 	/* Is the device currently transmitting?*/
-- 
1.7.1

