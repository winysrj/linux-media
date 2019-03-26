Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F017C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 22:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D747120811
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 22:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbfCZWP0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 18:15:26 -0400
Received: from gofer.mess.org ([88.97.38.141]:36825 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfCZWPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 18:15:25 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id A5FD0617A9; Tue, 26 Mar 2019 22:15:24 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] keytable: no need to explain -s option separately
Date:   Tue, 26 Mar 2019 22:15:24 +0000
Message-Id: <20190326221524.20971-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/ir-keytable.1.in | 7 ++-----
 utils/keytable/keytable.c       | 6 ++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index a717b8da..f3a2b9c8 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -3,10 +3,7 @@
 ir\-keytable \- a swiss\-knife tool to handle Remote Controllers.
 .SH SYNOPSIS
 .B ir\-keytable
-[\fIOPTION\fR]... \fI\-\-sysdev\fR [\fIrc class (f. ex. rc0)\fR]
-.br
-.B ir\-keytable
-[\fIOPTION\fR]... [\fIfor using the rc0 sysdev\fR]
+[\fIOPTION\fR]...
 .SH DESCRIPTION
 ir\-keytable is a tool that lists the Remote Controller devices, allows one to
 get/set rc keycode/scancode tables, set protocol decoder, test events
@@ -43,7 +40,7 @@ Sets the period to repeat a keystroke.
 Read and show the current scancode to keycode mapping.
 .TP
 \fB\-s\fR, \fB\-\-sysdev\fR=\fISYSDEV\fR
-rc device to control
+rc device to control, defaults to \fIrc0\fR if not specified.
 .TP
 \fB\-t\fR, \fB\-\-test\fR
 test if the rc device is generating events
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index ec0e25fe..f753cb5f 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -246,7 +246,7 @@ static const char doc[] = N_(
 static const struct argp_option options[] = {
 	{"verbose",	'v',	0,		0,	N_("enables debug messages"), 0},
 	{"clear",	'c',	0,		0,	N_("clears the old table"), 0},
-	{"sysdev",	's',	N_("SYSDEV"),	0,	N_("rc class device to control"), 0},
+	{"sysdev",	's',	N_("SYSDEV"),	0,	N_("rc device to control, defaults to rc0 if not specified"), 0},
 	{"test",	't',	0,		0,	N_("test if IR is generating events"), 0},
 	{"read",	'r',	0,		0,	N_("reads the current scancode/keycode table"), 0},
 	{"write",	'w',	N_("KEYMAP"),	0,	N_("write (adds) the keymap from the specified file"), 0},
@@ -262,9 +262,7 @@ static const struct argp_option options[] = {
 	{ 0, 0, 0, 0, 0, 0 }
 };
 
-static const char args_doc[] = N_(
-	"--sysdev [rc class (f. ex. rc0)]\n"
-	"[for using the rc0 sysdev]");
+static const char args_doc[] = N_("");
 
 /* Static vars to store the parameters */
 static char *devclass = NULL;
-- 
2.20.1

