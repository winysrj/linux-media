Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 06/29] iguanair: shut up a gcc warning on avr32 arch
Date: Sat,  2 Nov 2013 11:31:14 -0200
Message-Id: <1383399097-11615-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	drivers/media/rc/iguanair.c: In function 'iguanair_set_tx_carrier':
	drivers/media/rc/iguanair.c:304: warning: 'sevens' may be used uninitialized in this function

This is clearly a gcc bug, but it doesn't hurt to add a default line
at the switch to shut it up.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/iguanair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 19632b1c2190..67e5667db2eb 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -320,6 +320,7 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 			sevens = 2;
 			break;
 		case 3:
+		default:
 			sevens = 1;
 			break;
 		}
-- 
1.8.3.1

