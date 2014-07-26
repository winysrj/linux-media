Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaGZO7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:17 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	James Harper <james.harper@ejbdigital.com.au>
Subject: [PATCH 3/4] [media] cx23885-dvb: remove previously overriden value
Date: Sat, 26 Jul 2014 11:59:07 -0300
Message-Id: <1406386748-8874-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
References: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx23885/cx23885-dvb.c:768:2: warning: initialized field overwritten [-Woverride-init]
  .freq_offset_khz_vhf = 550,
  ^
drivers/media/pci/cx23885/cx23885-dvb.c:768:2: warning: (near initialization for 'dib7070p_dib0070_config.freq_offset_khz_vhf') [-Woverride-init]

Cc: James Harper <james.harper@ejbdigital.com.au>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 9135260f3457..6968706b83b8 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -764,7 +764,6 @@ static struct dib0070_config dib7070p_dib0070_config = {
 	.reset = dib7070_tuner_reset,
 	.sleep = dib7070_tuner_sleep,
 	.clock_khz = 12000,
-	.freq_offset_khz_vhf = 950,
 	.freq_offset_khz_vhf = 550,
 	/* .flip_chip = 1, */
 };
-- 
1.9.3

