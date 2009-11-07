Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42351 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbZKGVuL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:11 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:14 +0000
Message-ID: <1257630614.15927.413.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 20/75] sp8870: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/sp8870.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index b85eb60..51bee98 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -615,5 +615,6 @@ MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 MODULE_DESCRIPTION("Spase SP8870 DVB-T Demodulator driver");
 MODULE_AUTHOR("Juergen Peitz");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SP8870_DEFAULT_FIRMWARE);
 
 EXPORT_SYMBOL(sp8870_attach);
-- 
1.6.5.2



