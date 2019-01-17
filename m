Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35BAC43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EABC20652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfAQP3m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:29:42 -0500
Received: from gofer.mess.org ([88.97.38.141]:60319 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfAQP3m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 10:29:42 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id ED84C601DF; Thu, 17 Jan 2019 15:29:39 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     Patrick Lerda <patrick9876@free.fr>, linux-media@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>
Subject: [PATCH 1/2] selftests: Use lirc.h from kernel tree, not from system
Date:   Thu, 17 Jan 2019 15:29:38 +0000
Message-Id: <dad2fab452d98aaadea210807f9e0545a7814b32.1547738495.git.sean@mess.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1547738495.git.sean@mess.org>
References: <cover.1547738495.git.sean@mess.org>
In-Reply-To: <cover.1547738495.git.sean@mess.org>
References: <cover.1547738495.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When the system lirc.h is older than v4.16, you will get errors like:

ir_loopback.c:32:16: error: field ‘proto’ has incomplete type
  enum rc_proto proto;

Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
---
 tools/testing/selftests/ir/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/ir/Makefile b/tools/testing/selftests/ir/Makefile
index f4ba8eb84b95..ad06489c22a5 100644
--- a/tools/testing/selftests/ir/Makefile
+++ b/tools/testing/selftests/ir/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_PROGS := ir_loopback.sh
 TEST_GEN_PROGS_EXTENDED := ir_loopback
+APIDIR := ../../../include/uapi
+CFLAGS += -Wall -O2 -I$(APIDIR)
 
 include ../lib.mk
-- 
2.20.1

