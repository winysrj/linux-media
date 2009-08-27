Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35249 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZH0U6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 16:58:10 -0400
Received: by ewy2 with SMTP id 2so1600816ewy.17
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2009 13:58:11 -0700 (PDT)
From: Eugene Yudin <eugene.yudin@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix working LifeView FlyVideo 3000 Card
Date: Fri, 28 Aug 2009 01:12:53 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908280112.53765.Eugene.Yudin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this bug for this card and clones:
> Hi, for a couple of days now, my lifeview PCI hybrid card that worked 
flawlessly for the last 2 years doesn't work. The problem is with the driver 
from what I understand from the logs.
> 
> Today 23/8/2009 I tried the drivers within vanilla kernel 2.6.30.5 (i386 and 
amd64) and then separately latest mercurial snapshot. I always use latest 
mercurial snapshot updating every time a new kernel is released.
> This card works within Windows XP. I also switched the PCI slot but that 
didn't help.

Now all is working great.
Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>
Best Regards, Eugene.

diff -uprN a/linux/drivers/media/video/saa7134/saa7134-cards.c 
b/linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-27 
20:27:10.000000000 +0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-28 
01:05:14.530155113 +0400
@@ -103,6 +103,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
