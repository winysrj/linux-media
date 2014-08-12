Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/10] [media] as102: better name the unknown frontend
Date: Tue, 12 Aug 2014 18:50:18 -0300
Message-Id: <1407880224-374-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the frontend .name more coherent with DVB namespace.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_fe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 9596756b3869..041bb80aa4ba 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -245,7 +245,7 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 static struct dvb_frontend_ops as102_fe_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
-		.name			= "Unknown AS102 device",
+		.name			= "Abilis AS102 DVB-T",
 		.frequency_min		= 174000000,
 		.frequency_max		= 862000000,
 		.frequency_stepsize	= 166667,
-- 
1.9.3

