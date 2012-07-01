Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:59128 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab2GAOYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 10:24:37 -0400
Message-ID: <4FF05D10.1060906@freenet.de>
Date: Sun, 01 Jul 2012 16:22:08 +0200
From: Thomas Betker <thomas.betker@freenet.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] bttv-cards.c: Allow radio for CHP05x/CHP06x.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ".has_radio = 1" for BTTV_BOARD_MAGICTVIEW061 because there are
some CHP05x/CHP06x boards with a radio tuner.

I still have an analog Askey Magic TView card (CHP051, PCI 144f:3002)
which I use for radio only. This worked fine with kernel 2.6.37
(openSUSE 11.4), but no longer works with kernel 3.1.10 (openSUSE 12.1).

The reason apparently is that ".has_radio = 1" is missing in
bttv-cards.c for BTTV_BOARD_MAGICTVIEW061; when I add this line and
recompile the kernel, radio is working again. The line is still missing
in the latest git tree, for which I have generated the attached patch.

I can't test what will happen for CHP05x/CHP06x devices without radio;
however, it seems that other cards also have the problem that there are
some boards with radio and some without, so I hope that this can be
sorted out.

Signed-off-by: Thomas Betker <thomas.betker@freenet.de>

diff -Naur linux-HEAD-6887a41-orig/drivers/media/video/bt8xx/bttv-cards.c linux-HEAD-6887a41/drivers/media/video/bt8xx/bttv-cards.c
--- linux-HEAD-6887a41-orig/drivers/media/video/bt8xx/bttv-cards.c	2012-06-30 23:08:57.000000000 +0000
+++ linux-HEAD-6887a41/drivers/media/video/bt8xx/bttv-cards.c	2012-07-01 10:09:28.672559366 +0000
@@ -676,6 +676,7 @@
  		.tuner_type	= UNSET,
  		.tuner_addr	= ADDR_UNSET,
  		.has_remote     = 1,
+		.has_radio	= 1,  /* not every card has radio */
  	},
  	[BTTV_BOARD_VOBIS_BOOSTAR] = {
  		.name           = "Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar",
