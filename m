Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3KEPLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 10:11:50 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 25/29] [media] af9015: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:38 -0200
Message-Id: <1383645702-30636-26-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/af9015.c:433:1: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]

In this specific case, it is a gcc bug, as the size is a const, but
it is easy to just change it from const to a #define, getting rid of
the gcc warning.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index d556042cf312..da47d2392f2a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -397,12 +397,13 @@ error:
 	return ret;
 }
 
+#define AF9015_EEPROM_SIZE 256
+
 /* hash (and dump) eeprom */
 static int af9015_eeprom_hash(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
 	int ret, i;
-	static const unsigned int AF9015_EEPROM_SIZE = 256;
 	u8 buf[AF9015_EEPROM_SIZE];
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, NULL};
 
-- 
1.8.3.1

