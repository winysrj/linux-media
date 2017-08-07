Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:48690 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751364AbdHGMwD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 08:52:03 -0400
To: Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] keytable.c: add support for the CEC protocol
Message-ID: <991a08f5-40e1-e364-1400-91236c6fbeb0@xs4all.nl>
Date: Mon, 7 Aug 2017 14:52:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC protocol wasn't known, so 'Supported protocols:' would just say
'other' instead of 'cec'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 634f4561..55abfc19 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -106,6 +106,7 @@ enum sysfs_protocols {
 	SYSFS_RC6		= (1 << 10),
 	SYSFS_SHARP		= (1 << 11),
 	SYSFS_XMP		= (1 << 12),
+	SYSFS_CEC		= (1 << 13),
 	SYSFS_INVALID		= 0,
 };

@@ -138,6 +139,7 @@ const struct protocol_map_entry protocol_map[] = {
 	{ "rc-6-mce",	NULL,		SYSFS_INVALID	},
 	{ "sharp",	NULL,		SYSFS_SHARP	},
 	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
+	{ "cec",	NULL,		SYSFS_CEC	},
 	{ NULL,		NULL,		SYSFS_INVALID	},
 };
