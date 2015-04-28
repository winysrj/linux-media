Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965942AbbD1PoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:01 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/14] wl128x: fix int type for streg_cbdata
Date: Tue, 28 Apr 2015 12:43:52 -0300
Message-Id: <297efe76b68adffbbb4309cf335dcaa1522c8395.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The streg_cbdata can have a negative error value. So, it should be
an integer, and not u8, as reported by smatch:
	drivers/media/radio/wl128x/fmdrv_common.c:1517 fmc_prepare() warn: assigning (-115) to unsigned variable 'fmdev->streg_cbdata'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index a587c9bac930..dd203de5de95 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -210,7 +210,7 @@ struct fmdev {
 	spinlock_t resp_skb_lock; /* To protect access to received SKB */
 
 	long flag;		/*  FM driver state machine info */
-	u8 streg_cbdata; /* status of ST registration */
+	int streg_cbdata; /* status of ST registration */
 
 	struct sk_buff_head rx_q;	/* RX queue */
 	struct tasklet_struct rx_task;	/* RX Tasklet */
-- 
2.1.0

