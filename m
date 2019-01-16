Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B06C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E6C1205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfAPQHZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:07:25 -0500
Received: from gofer.mess.org ([88.97.38.141]:59565 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbfAPQHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 11:07:25 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 32E8060392; Wed, 16 Jan 2019 16:07:24 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH 1/2] ir-ctl: Rename no-wideband to narrowband
Date:   Wed, 16 Jan 2019 16:07:23 +0000
Message-Id: <20190116160724.18403-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in | 2 +-
 utils/ir-ctl/ir-ctl.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 2a148c70..10d4d594 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -54,7 +54,7 @@ Use the wideband receiver if available on the hardware. This is also
 known as learning mode. The measurements should be more precise and any
 carrier frequency should be accepted.
 .TP
-\fB\-n\fR, \fB\-\-no-wideband\fR
+\fB\-n\fR, \fB\-\-narrowband\fR
 Switches back to the normal, narrowband receiver if the wideband receiver
 was enabled.
 .TP
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index ddd93068..dcc9439c 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -109,7 +109,7 @@ static const struct argp_option options[] = {
 		{ .doc = N_("Receiving options:") },
 	{ "one-shot",	'1',	0,		0,	N_("end receiving after first message") },
 	{ "wideband",	'w',	0,		0,	N_("use wideband receiver aka learning mode") },
-	{ "no-wideband",'n',	0,		0,	N_("use normal narrowband receiver, disable learning mode") },
+	{ "narrowband",'n',	0,		0,	N_("use narrowband receiver, disable learning mode") },
 	{ "carrier-range", 'R', N_("RANGE"),	0,	N_("set receiver carrier range") },
 	{ "measure-carrier", 'm', 0,		0,	N_("report carrier frequency") },
 	{ "no-measure-carrier", 'M', 0,		0,	N_("disable reporting carrier frequency") },
-- 
2.20.1

