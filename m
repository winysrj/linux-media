Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D616CC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73D182084D
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=horus.com header.i=@horus.com header.b="t0RJ4mUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfBGJjD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:39:03 -0500
Received: from mail.horus.com ([78.46.148.228]:45605 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfBGJjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:39:02 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2019 04:39:02 EST
Received: from [192.168.1.20] (62-47-205-74.adsl.highway.telekom.at [62.47.205.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "E-Mail Matthias Reichl", Issuer "HiassofT CA 2014" (verified OK))
        by mail.horus.com (Postfix) with ESMTPSA id CA66A6413A;
        Thu,  7 Feb 2019 10:29:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=horus.com;
        s=20180324; t=1549531754;
        bh=emQVyc1tzMFc3pXNJMloIuiPTJJfmTBoREa6GdnrVsU=;
        h=From:To:Cc:Subject:Date:From;
        b=t0RJ4mUOP6aS+cYVJ+jWIciZznYx0rH5q2YMAKULOgd67HthLff/QhVIRcyWI4CVy
         UcHfakBYX/Rny8sna0hNZVfeaVqEZCN8KGr4N6E+OyoRUqR+WFtNKrobYPojF84nF5
         XhAlhOFtdKEefSGvQYUgz72FuHpkpMkU3bUW3pDM=
Received: by camel2.lan (Postfix, from userid 1000)
        id 28CD91C72A2; Thu,  7 Feb 2019 10:29:13 +0100 (CET)
From:   Matthias Reichl <hias@horus.com>
To:     Sean Young <sean@mess.org>
Cc:     linux-media@vger.kernel.org
Subject: [PATCH] media: rc: ir-rc6-decoder: enable toggle bit for Zotac remotes
Date:   Thu,  7 Feb 2019 10:29:12 +0100
Message-Id: <20190207092912.5444-1-hias@horus.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Zotac RC2604323/01G and RC2604329/02BG remotes use the 32-bit
rc6 protocol and toggle bit 15 (0x8000) on repeated button presses,
like MCE remotes.

Add the customer code 0x80340000 to the 32-bit rc6 toggle
handling code to get proper scancodes and toggle reports.

Signed-off-by: Matthias Reichl <hias@horus.com>
---
LibreELEC bug report and more info are here:
https://forum.libreelec.tv/thread/14388-ir-remote-malfunction-after-upgrade-to-le-9-0/

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index d96aed1343e4..5cc302fa4daa 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -40,6 +40,7 @@
 #define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
 #define RC6_6A_LCC_MASK		0xffff0000 /* RC6-6A-32 long customer code mask */
 #define RC6_6A_MCE_CC		0x800f0000 /* MCE customer code */
+#define RC6_6A_ZOTAC_CC		0x80340000 /* Zotac customer code */
 #define RC6_6A_KATHREIN_CC	0x80460000 /* Kathrein RCU-676 customer code */
 #ifndef CHAR_BIT
 #define CHAR_BIT 8	/* Normally in <limits.h> */
@@ -246,6 +247,7 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 				switch (scancode & RC6_6A_LCC_MASK) {
 				case RC6_6A_MCE_CC:
 				case RC6_6A_KATHREIN_CC:
+				case RC6_6A_ZOTAC_CC:
 					protocol = RC_PROTO_RC6_MCE;
 					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
 					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
-- 
2.20.1

