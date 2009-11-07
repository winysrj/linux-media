Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42339 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZKGVtj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:49:39 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:49:41 +0000
Message-ID: <1257630581.15927.408.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 16/75] drx397xD: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move punctuation into definition of _FW_ENTRY so we can use either a
comma or semicolon.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/drx397xD.c    |    7 ++++---
 drivers/media/dvb/frontends/drx397xD_fw.h |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index 868b78b..4f4c403 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -39,7 +39,7 @@ static const char mod_name[] = "drx397xD";
 #define F_SET_0D4h	2
 
 enum fw_ix {
-#define _FW_ENTRY(a, b, c)	b
+#define _FW_ENTRY(a, b, c)	b,
 #include "drx397xD_fw.h"
 };
 
@@ -77,7 +77,7 @@ static struct {
 			.file	= NULL,					\
 			.lock	= __RW_LOCK_UNLOCKED(fw[c].lock),	\
 			.refcnt = 0,					\
-			.data	= { }		}
+			.data	= { }		},
 #include "drx397xD_fw.h"
 };
 
@@ -1507,4 +1507,5 @@ EXPORT_SYMBOL(drx397xD_attach);
 MODULE_DESCRIPTION("Micronas DRX397xD DVB-T Frontend");
 MODULE_AUTHOR("Henk Vergonet");
 MODULE_LICENSE("GPL");
-
+#define _FW_ENTRY(a, b, c) MODULE_FIRMWARE(a);
+#include "drx397xD_fw.h"
diff --git a/drivers/media/dvb/frontends/drx397xD_fw.h b/drivers/media/dvb/frontends/drx397xD_fw.h
index c8b44c1..f0260ad 100644
--- a/drivers/media/dvb/frontends/drx397xD_fw.h
+++ b/drivers/media/dvb/frontends/drx397xD_fw.h
@@ -18,8 +18,8 @@
  */
 
 #ifdef _FW_ENTRY
-	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0,	DRXD_FW_A2	),
-	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1,	DRXD_FW_B1	),
+	_FW_ENTRY("drx397xD.A2.fw",	DRXD_FW_A2 = 0,	DRXD_FW_A2	)
+	_FW_ENTRY("drx397xD.B1.fw",	DRXD_FW_B1,	DRXD_FW_B1	)
 #undef _FW_ENTRY
 #endif /* _FW_ENTRY */
 
-- 
1.6.5.2



