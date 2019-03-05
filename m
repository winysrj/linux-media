Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4E1C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22BD206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 10:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfCEKoK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:44:10 -0500
Received: from gofer.mess.org ([88.97.38.141]:33533 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfCEKoJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 05:44:09 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id EE05E601DC; Tue,  5 Mar 2019 10:44:07 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] ir-ctl: various typos
Date:   Tue,  5 Mar 2019 10:44:07 +0000
Message-Id: <20190305104407.1836-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in  | 4 ++--
 utils/ir-ctl/ir-ctl.c     | 2 +-
 utils/keytable/keytable.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index c3ab118f..03fcf438 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -30,7 +30,7 @@ lirc device to control, /dev/lirc0 by default
 \fB\-f\fR, \fB\-\-features\fR
 List the features of the lirc device.
 .TP
-\fB\-r\fR, \fB\-\-receive\fR=[\fIFILE\fR]
+\fB\-r\fR, \fB\-\-receive\fR[=\fIFILE\fR]
 Receive IR and print to standard output if no file is specified, else
 save to the filename.
 .TP
@@ -166,7 +166,7 @@ carrier. The above can be written as:
 	scancode rc5:0x1e01
 .PP
 If multiple scancodes are specified in a file, a gap is inserted between
-scancodes if there is no space between then (see \fB\-\-gap\fR). One file
+scancodes if there is no space between them (see \fB\-\-gap\fR). One file
 can only have one carrier frequency, so this might cause problems
 if different protocols are specified in one file if they use different
 carrier frequencies.
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index f8f4e0aa..ad830612 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -133,7 +133,7 @@ static const char doc[] = N_(
 	"\nReceive IR, send IR and list features of lirc device\n"
 	"You will need permission on /dev/lirc for the program to work\n"
 	"\nOn the options below, the arguments are:\n"
-	"  DEV	    - the /dev/lirc* device to use\n"
+	"  DEV      - the /dev/lirc* device to use\n"
 	"  FILE     - a text file containing pulses and spaces\n"
 	"  CARRIER  - the carrier frequency to use for sending\n"
 	"  DUTY     - the duty cycle to use for sending\n"
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 0726e5fd..5be2274a 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -235,7 +235,7 @@ static const char doc[] = N_(
 	"  TABLE     - a file with a set of scancode=keycode value pairs\n"
 	"  SCANKEY   - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
 	"  PROTOCOL  - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
-	"              sharp, mce_kbd, xmp, imon, other, all) to be enabled,\n"
+	"              sharp, mce_kbd, xmp, imon, rc_mm, other, all) to be enabled,\n"
 	"              or a bpf protocol name or file\n"
 	"  DELAY     - Delay before repeating a keystroke\n"
 	"  PERIOD    - Period to repeat a keystroke\n"
-- 
2.20.1

