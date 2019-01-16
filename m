Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92DEC43612
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A05205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405096AbfAPQHZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:07:25 -0500
Received: from gofer.mess.org ([88.97.38.141]:34937 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbfAPQHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 11:07:25 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 62B3B603E3; Wed, 16 Jan 2019 16:07:24 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH 2/2] ir-ctl: imon protocol can be encoded too
Date:   Wed, 16 Jan 2019 16:07:24 +0000
Message-Id: <20190116160724.18403-2-sean@mess.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190116160724.18403-1-sean@mess.org>
References: <20190116160724.18403-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 10d4d594..226bf606 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -181,7 +181,7 @@ pulse and space file. The following protocols are supported:
 \fBrc5\fR, \fBrc5x_20\fR, \fBrc5_sz\fR, \fBjvc\fR, \fBsony12\fR,
 \fBsony\fB15\fR, \fBsony20\fR, \fBnec\fR, \fBnecx\fR, \fBnec32\fR,
 \fBsanyo\fR, \fBrc6_0\fR, \fBrc6_6a_20\fR, \fBrc6_6a_24\fR, \fBrc6_6a_32\fR,
-\fBrc6_mce\fR, \fBsharp\fR.
+\fBrc6_mce\fR, \fBsharp\fR, \fBimon\fR.
 If the scancode starts with 0x it will be interpreted as a
 hexadecimal number, and if it starts with 0 it will be interpreted as an
 octal number.
-- 
2.20.1

