Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59949 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752576AbcLBRUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 5/6] ir-keytable: "-p all" or "-p mce-kdb" does not work
Date: Fri,  2 Dec 2016 17:20:20 +0000
Message-Id: <1480699221-9267-5-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When writing to the sysfs protocols file, use the underscore variant.
The kernel does not accept "mce-kdb" and it never did.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 202610a..a6ecc9e 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -131,8 +131,8 @@ const struct protocol_map_entry protocol_map[] = {
 	{ "sony20",	NULL,		SYSFS_INVALID	},
 	{ "nec",	"/nec_decoder",	SYSFS_NEC	},
 	{ "sanyo",	NULL,		SYSFS_SANYO	},
-	{ "mce-kbd",	NULL,		SYSFS_MCE_KBD	},
 	{ "mce_kbd",	NULL,		SYSFS_MCE_KBD	},
+	{ "mce-kbd",	NULL,		SYSFS_MCE_KBD	},
 	{ "rc-6",	"/rc6_decoder",	SYSFS_RC6	},
 	{ "rc6",	NULL,		SYSFS_RC6	},
 	{ "rc-6-0",	NULL,		SYSFS_INVALID	},
-- 
2.9.3

