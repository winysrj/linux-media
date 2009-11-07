Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbZKGVuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:25 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:28 +0000
Message-ID: <1257630628.15927.415.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 22/75] tda10048: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/tda10048.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 4e2a7c8..175e90e 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -1170,3 +1170,4 @@ MODULE_PARM_DESC(debug, "Enable verbose debug messages");
 MODULE_DESCRIPTION("NXP TDA10048HN DVB-T Demodulator driver");
 MODULE_AUTHOR("Steven Toth");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(TDA10048_DEFAULT_FIRMWARE);
-- 
1.6.5.2



