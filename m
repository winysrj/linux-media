Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbZKGVuS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:18 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:20 +0000
Message-ID: <1257630620.15927.414.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 21/75] sp887x: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/sp887x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 4a7c3d8..298e2a5 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -613,5 +613,6 @@ MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
 MODULE_DESCRIPTION("Spase sp887x DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SP887X_DEFAULT_FIRMWARE);
 
 EXPORT_SYMBOL(sp887x_attach);
-- 
1.6.5.2



