Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3D0C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB062146F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfBSJ6N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:58:13 -0500
Received: from gofer.mess.org ([88.97.38.141]:50257 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfBSJ6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 04:58:13 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 8822460366; Tue, 19 Feb 2019 09:58:11 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 1/2] ir-ctl/keytable: add see also to reference to man pages
Date:   Tue, 19 Feb 2019 09:58:10 +0000
Message-Id: <20190219095811.31946-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add hint to how you can start to figure out what protocol a remote
uses.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in        | 3 +++
 utils/keytable/ir-keytable.1.in | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 226bf606..f6192dab 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -233,3 +233,6 @@ License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
+.SH SEE ALSO
+To display decoded IR, or set IR decoding options, use
+ir\-keytable(1).
diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index c8ff722e..e7fd7760 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -118,6 +118,13 @@ To read the current keytable, on the second remote controller:
 To enable NEC protocol and load a BPF protocol, with a parameter for the BPF protocol:
 .br
 	\fBir\-keytable \-p nec,pulse_distance \-e pulse_header=9000
+.PP
+If you do not know what protocol a remote uses, it can be helpful to first
+try with all kernel decoders enabled. The decoded protocol and scancodes
+will be displayed in the output:
+.br
+	\fBir\-keytable \-c \-p all \-t\fR
+
 .SH BUGS
 Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
 .SH COPYRIGHT
@@ -127,3 +134,5 @@ License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
+.SH SEE ALSO
+To transmit IR or receive raw IR, use ir\-ctl(1).
-- 
2.20.1

