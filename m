Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0DFSSO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:14 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIEvd022073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:14 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/26] V4L/DVB: saa7134: Add support for both positive and
 negative edge IRQ
Message-ID: <20100406151801.642ec970@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code that enables IRQ for the Remote Controller on saa7134 is a little
messy: it is outside saa7134-input, it checks if RC is GPIO based, and
it mixes both serial raw decode with parallel reads from a hardware-based
IR decoder.

Also, currently, it doesn't allow to trigger both transition edges at GPIO16
and GPIO18 lines. A rework on the code is needed to provide a better way
to specify what saa7134-input needs, maybe even moving part of the code from
saa7134-core and saa7134-cards into saa7134-input.

Yet, as a large rework is happening at RC core, it is better to wait until
the core changes stablize, in order to rework saa7134 RC internals.While
this don't happen, let's just change the logic a little bit to allow
enabling IRQ to be generated on both edge transitions, in order to better
support pulse/space raw decoders.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 0612fff..90f2318 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -701,10 +701,12 @@ static int saa7134_hw_enable2(struct saa7134_dev *dev)
 	if (dev->has_remote == SAA7134_REMOTE_GPIO && dev->remote) {
 		if (dev->remote->mask_keydown & 0x10000)
 			irq2_mask |= SAA7134_IRQ2_INTE_GPIO16_N;
-		else if (dev->remote->mask_keydown & 0x40000)
-			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_P;
-		else if (dev->remote->mask_keyup & 0x40000)
-			irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_N;
+		else {		/* Allow enabling both IRQ edge triggers */
+			if (dev->remote->mask_keydown & 0x40000)
+				irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_P;
+			if (dev->remote->mask_keyup & 0x40000)
+				irq2_mask |= SAA7134_IRQ2_INTE_GPIO18_N;
+		}
 	}
 
 	if (dev->has_remote == SAA7134_REMOTE_I2C) {
-- 
1.6.6.1


