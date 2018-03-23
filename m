Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36473 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755656AbeCWKtW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 06:49:22 -0400
Date: Fri, 23 Mar 2018 10:49:20 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: keytable: add support for imon protocol
Message-ID: <20180323104919.gof5vqu7hu3refpi@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/common/ir-encode.c  | 1 +
 utils/keytable/keytable.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/utils/common/ir-encode.c b/utils/common/ir-encode.c
index e6b65b5b..c7e319eb 100644
--- a/utils/common/ir-encode.c
+++ b/utils/common/ir-encode.c
@@ -376,6 +376,7 @@ static const struct {
 	[RC_PROTO_MCIR2_MSE] = { "mcir2-mse" },
 	[RC_PROTO_XMP] = { "xmp" },
 	[RC_PROTO_CEC] = { "cec" },
+	[RC_PROTO_IMON] = { "imon", 0x7fffffff },
 };
 
 static bool str_like(const char *a, const char *b)
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 925eab00..482fcf86 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -116,6 +116,7 @@ enum sysfs_protocols {
 	SYSFS_SHARP		= (1 << 11),
 	SYSFS_XMP		= (1 << 12),
 	SYSFS_CEC		= (1 << 13),
+	SYSFS_IMON		= (1 << 14),
 	SYSFS_INVALID		= 0,
 };
 
@@ -149,6 +150,7 @@ const struct protocol_map_entry protocol_map[] = {
 	{ "sharp",	NULL,		SYSFS_SHARP	},
 	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
 	{ "cec",	NULL,		SYSFS_CEC	},
+	{ "imon",	NULL,		SYSFS_IMON	},
 	{ NULL,		NULL,		SYSFS_INVALID	},
 };
 
-- 
2.14.3
