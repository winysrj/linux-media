Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95BBC10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93BFF2146F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBSJ6N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:58:13 -0500
Received: from gofer.mess.org ([88.97.38.141]:58401 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfBSJ6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 04:58:13 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id BF6F260370; Tue, 19 Feb 2019 09:58:11 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 2/2] rc-mm protocol support
Date:   Tue, 19 Feb 2019 09:58:11 +0000
Message-Id: <20190219095811.31946-2-sean@mess.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190219095811.31946-1-sean@mess.org>
References: <20190219095811.31946-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/common/ir-encode.c  | 3 +++
 utils/keytable/keytable.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/utils/common/ir-encode.c b/utils/common/ir-encode.c
index ccc75032..4bd1b694 100644
--- a/utils/common/ir-encode.c
+++ b/utils/common/ir-encode.c
@@ -372,6 +372,9 @@ static const struct {
 	[RC_PROTO_XMP] = { "xmp" },
 	[RC_PROTO_CEC] = { "cec" },
 	[RC_PROTO_IMON] = { "imon", 0x7fffffff },
+	[RC_PROTO_RCMM12] = { "rc-mm-12", 0x0fff },
+	[RC_PROTO_RCMM24] = { "rc-mm-24", 0xffffff },
+	[RC_PROTO_RCMM32] = { "rc-mm-32", 0xffffffff },
 };
 
 static bool str_like(const char *a, const char *b)
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 0aceb015..0726e5fd 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -127,6 +127,7 @@ enum sysfs_protocols {
 	SYSFS_XMP		= (1 << 12),
 	SYSFS_CEC		= (1 << 13),
 	SYSFS_IMON		= (1 << 14),
+	SYSFS_RCMM		= (1 << 15),
 	SYSFS_INVALID		= 0,
 };
 
@@ -161,6 +162,7 @@ const struct protocol_map_entry protocol_map[] = {
 	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
 	{ "cec",	NULL,		SYSFS_CEC	},
 	{ "imon",	NULL,		SYSFS_IMON	},
+	{ "rc-mm",	NULL,		SYSFS_RCMM	},
 	{ NULL,		NULL,		SYSFS_INVALID	},
 };
 
-- 
2.20.1

