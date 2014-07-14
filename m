Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58057 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbaGNRJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/18] si2157: advertise Si2158 A20 firmware
Date: Mon, 14 Jul 2014 20:08:57 +0300
Message-Id: <1405357739-3570-16-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver uses that firmware. Add it module firmware list.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index b656f9b..3fa1f26 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -360,3 +360,4 @@ module_i2c_driver(si2157_driver);
 MODULE_DESCRIPTION("Silicon Labs Si2157/Si2158 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
-- 
1.9.3

