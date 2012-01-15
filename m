Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45278 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2AOL0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 06:26:51 -0500
Date: Sun, 15 Jan 2012 14:25:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tony Jago <tony@hammertelecom.com.au>,
	Steven Toth <stoth@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] saa7164: remove duplicate initialization
Message-ID: <20120115112557.GA20463@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These were initialized twice by mistake.  They were defined the same way
both times so this doesn't change how the code works.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/saa7164/saa7164-cards.c b/drivers/media/video/saa7164/saa7164-cards.c
index 971591d..5b72da5 100644
--- a/drivers/media/video/saa7164/saa7164-cards.c
+++ b/drivers/media/video/saa7164/saa7164-cards.c
@@ -269,8 +269,6 @@ struct saa7164_board saa7164_boards[] = {
 		.portb		= SAA7164_MPEG_DVB,
 		.portc		= SAA7164_MPEG_ENCODER,
 		.portd		= SAA7164_MPEG_ENCODER,
-		.portc		= SAA7164_MPEG_ENCODER,
-		.portd		= SAA7164_MPEG_ENCODER,
 		.porte		= SAA7164_MPEG_VBI,
 		.portf		= SAA7164_MPEG_VBI,
 		.chiprev	= SAA7164_CHIP_REV3,
@@ -333,8 +331,6 @@ struct saa7164_board saa7164_boards[] = {
 		.portd		= SAA7164_MPEG_ENCODER,
 		.porte		= SAA7164_MPEG_VBI,
 		.portf		= SAA7164_MPEG_VBI,
-		.porte		= SAA7164_MPEG_VBI,
-		.portf		= SAA7164_MPEG_VBI,
 		.chiprev	= SAA7164_CHIP_REV3,
 		.unit		= {{
 			.id		= 0x28,
