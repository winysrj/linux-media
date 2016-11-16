Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49757 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbcKPQnT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Max Kellermann <max@duempel.org>, Sean Young <sean@mess.org>,
        Ole Ernst <olebowle@gmx.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH 34/35] [media] rc-main: use pr_foo() macros
Date: Wed, 16 Nov 2016 14:43:06 -0200
Message-Id: <20a57c3c0e1d3884e9c725faee427ca2a251bea9.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of calling printk() directly, use pr_foo() macro.

That should make the rc_core messages be formatted with the
right prefix.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/rc-main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 5087e76dfb03..adb10fac63e4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -12,6 +12,8 @@
  *  GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <media/rc-core.h>
 #include <linux/atomic.h>
 #include <linux/spinlock.h>
@@ -66,7 +68,7 @@ struct rc_map *rc_map_get(const char *name)
 	if (!map) {
 		int rc = request_module("%s", name);
 		if (rc < 0) {
-			printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
+			pr_err("Couldn't load IR keymap %s\n", name);
 			return NULL;
 		}
 		msleep(20);	/* Give some time for IR to register */
@@ -75,7 +77,7 @@ struct rc_map *rc_map_get(const char *name)
 	}
 #endif
 	if (!map) {
-		printk(KERN_ERR "IR keymap %s not found\n", name);
+		pr_err("IR keymap %s not found\n", name);
 		return NULL;
 	}
 
@@ -1620,7 +1622,7 @@ static int __init rc_core_init(void)
 {
 	int rc = class_register(&rc_class);
 	if (rc) {
-		printk(KERN_ERR "rc_core: unable to register rc class\n");
+		pr_err("rc_core: unable to register rc class\n");
 		return rc;
 	}
 
-- 
2.7.4


