Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbZKGVud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:33 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:35 +0000
Message-ID: <1257630635.15927.416.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 23/75] tda1004x: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/tda1004x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index f2a8abe..0561aa1 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -1375,6 +1375,8 @@ MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 MODULE_DESCRIPTION("Philips TDA10045H & TDA10046H DVB-T Demodulator");
 MODULE_AUTHOR("Andrew de Quincey & Robert Schlabbach");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(TDA10045_DEFAULT_FIRMWARE);
+MODULE_FIRMWARE(TDA10046_DEFAULT_FIRMWARE);
 
 EXPORT_SYMBOL(tda10045_attach);
 EXPORT_SYMBOL(tda10046_attach);
-- 
1.6.5.2



