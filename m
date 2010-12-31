Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62090 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0LaFcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 00:32:06 -0500
Message-ID: <4d1d6ad3.857a0e0a.45e5.ffffd919@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Tue, 17 Aug 2010 13:10:07 +0300
Subject: [PATCH 07/18] cx23885: implement num_fds_portb, num_fds_portc parameters for cx23885_board structure.
To: <mchehab@infradead.org>, linux-media@vger.kernel.org,
	<linux-kernel@vger.kernel.org>, <aospan@netup.ru>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is needed for multifrontend support.
NetUP Dual DVB-T/C CI RF card has frontends connected to port B & C
Each frontend has two switchable cores - DVB-T & DVB-C

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-cards.c |    2 ++
 drivers/media/video/cx23885/cx23885-core.c  |    4 ++++
 drivers/media/video/cx23885/cx23885.h       |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 7de6379..461413a 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -344,6 +344,8 @@ struct cx23885_board cx23885_boards[] = {
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
+		.num_fds_portb	= 2,
+		.num_fds_portc	= 2,
 		.tuner_type	= TUNER_XC5000,
 		.tuner_addr	= 0x64,
 		.input          = { {
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index a5998dd..307eaf4 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1011,6 +1011,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portb)
+			dev->ts1.num_frontends = cx23885_boards[dev->board].num_fds_portb;
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
 			       __func__);
@@ -1025,6 +1027,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	}
 
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
+		if (cx23885_boards[dev->board].num_fds_portc)
+			dev->ts2.num_frontends = cx23885_boards[dev->board].num_fds_portc;
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
 			printk(KERN_ERR
 				"%s() Failed to register dvb on VID_C\n",
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index d43f80b..e678667 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -205,6 +205,7 @@ typedef enum {
 struct cx23885_board {
 	char                    *name;
 	port_t			porta, portb, portc;
+	int		num_fds_portb, num_fds_portc;
 	unsigned int		tuner_type;
 	unsigned int		radio_type;
 	unsigned char		tuner_addr;
-- 
1.7.1

