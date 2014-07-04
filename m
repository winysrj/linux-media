Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaGDS0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 14:26:53 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 04/14] dib8000: Fix: add missing 4K mode
Date: Fri,  4 Jul 2014 14:15:30 -0300
Message-Id: <1404494140-17777-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without that, tuning may fail on 4K modes, as the transmission
parameter cache will be initialized with a wrong value.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 7751a35a008c..975cbddd71dd 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3433,6 +3433,9 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 	case 1:
 		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_2K;
 		break;
+	case 2:
+		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_4K;
+		break;
 	case 3:
 	default:
 		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
-- 
1.9.3

