Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47615 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbZKGVtc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:49:32 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:49:35 +0000
Message-ID: <1257630575.15927.407.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 15/75] cx24416: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/cx24116.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index 2410d8b..f3eef67 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1506,4 +1506,4 @@ static struct dvb_frontend_ops cx24116_ops = {
 MODULE_DESCRIPTION("DVB Frontend module for Conexant cx24116/cx24118 hardware");
 MODULE_AUTHOR("Steven Toth");
 MODULE_LICENSE("GPL");
-
+MODULE_FIRMWARE(CX24116_DEFAULT_FIRMWARE);
-- 
1.6.5.2



