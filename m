Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3KAWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:41:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/11] iguanair: shut up a gcc warning on avr32 arch
Date: Fri,  1 Nov 2013 17:39:25 -0200
Message-Id: <1383334770-27130-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
References: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

