Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36005 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753085AbcKIQNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 11:13:38 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 3/3] ir-keytable: make it possible to select the rc5 streamzap variant
Date: Wed,  9 Nov 2016 16:13:33 +0000
Message-Id: <1478708015-1164-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was not possible to select the rc-5-sz protocol.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 3922ad2..202610a 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -123,6 +123,7 @@ const struct protocol_map_entry protocol_map[] = {
 	{ "rc5",	NULL,		SYSFS_RC5	},
 	{ "rc-5x",	NULL,		SYSFS_INVALID	},
 	{ "rc5x",	NULL,		SYSFS_INVALID	},
+	{ "rc-5-sz",	NULL,		SYSFS_RC5_SZ	},
 	{ "jvc",	"/jvc_decoder",	SYSFS_JVC	},
 	{ "sony",	"/sony_decoder",SYSFS_SONY	},
 	{ "sony12",	NULL,		SYSFS_INVALID	},
-- 
2.7.4

