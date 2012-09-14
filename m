Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.fr.smartjog.net ([95.81.144.3]:47994 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2INJ1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:27:41 -0400
From: =?UTF-8?q?R=C3=A9mi=20Cardona?= <remi.cardona@smartjog.com>
To: linux-media@vger.kernel.org
Cc: liplianin@me.by
Subject: [PATCH 1/6] [media] ds3000: Declare MODULE_FIRMWARE usage
Date: Fri, 14 Sep 2012 11:27:21 +0200
Message-Id: <1347614846-19046-2-git-send-email-remi.cardona@smartjog.com>
In-Reply-To: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
References: <1347614846-19046-1-git-send-email-remi.cardona@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rémi Cardona <remi.cardona@smartjog.com>
---
 drivers/media/dvb/frontends/ds3000.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 4c8ac26..46874c7 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1310,3 +1310,4 @@ MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
 			"DS3000/TS2020 hardware");
 MODULE_AUTHOR("Konstantin Dimitrov");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(DS3000_DEFAULT_FIRMWARE);
-- 
1.7.10.4

