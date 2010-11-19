Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33758 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab0KSXoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:44 -0500
Subject: [PATCH 10/10] rc-core: fix some leftovers from the renaming patches
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:27 +0100
Message-ID: <20101119234327.3511.79604.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fix some minor comments etc which are leftover from the old naming scheme.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-raw.c       |    2 +-
 drivers/media/rc/rc-core-priv.h |    6 +++---
 drivers/media/rc/rc-main.c      |    2 +-
 include/media/rc-core.h         |   12 ++++++------
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 165412f..185badd 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -1,4 +1,4 @@
-/* ir-raw-event.c - handle IR Pulse/Space event
+/* ir-raw.c - handle IR pulse/space events
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 48065b7..873b387 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -13,8 +13,8 @@
  *  GNU General Public License for more details.
  */
 
-#ifndef _IR_RAW_EVENT
-#define _IR_RAW_EVENT
+#ifndef _RC_CORE_PRIV
+#define _RC_CORE_PRIV
 
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -190,4 +190,4 @@ void ir_raw_init(void);
 #endif
 
 
-#endif /* _IR_RAW_EVENT */
+#endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 0b0524c..6bdd0d3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,4 +1,4 @@
-/* rc-core.c - handle IR scancode->keycode tables
+/* rc-main.c - Remote Controller core module
  *
  * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
  *
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index affb93f..a23c1fc 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -206,12 +206,12 @@ static inline u32 ir_extract_bits(u32 data, u32 mask)
 	u32 vbit = 1, value = 0;
 
 	do {
-	    if (mask & 1) {
-		if (data & 1)
-			value |= vbit;
-		vbit <<= 1;
-	    }
-	    data >>= 1;
+		if (mask & 1) {
+			if (data & 1)
+				value |= vbit;
+			vbit <<= 1;
+		}
+		data >>= 1;
 	} while (mask >>= 1);
 
 	return value;

