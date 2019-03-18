Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B590AC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 20:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8488620872
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 20:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfCRUz6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 16:55:58 -0400
Received: from gofer.mess.org ([88.97.38.141]:54745 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfCRUz6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 16:55:58 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id BF6C66043E; Mon, 18 Mar 2019 20:55:56 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] keytable: minor rewording from TABLE to KEYMAP
Date:   Mon, 18 Mar 2019 20:55:56 +0000
Message-Id: <20190318205556.21120-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/ir-keytable.1.in | 15 +++++++++------
 utils/keytable/keytable.c       |  6 +++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index c0844945..9a354be4 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -57,8 +57,8 @@ test if the rc device is generating events
 \fB\-v\fR, \fB\-\-verbose\fR
 Enables debug messages.
 .TP
-\fB\-w\fR, \fB\-\-write\fR=\fITABLE\fR
-Reads the protocols and scancode to keycode mapping from the \fITABLE\fR file,
+\fB\-w\fR, \fB\-\-write\fR=\fIKEYMAP\fR
+Reads the protocols and scancode to keycode mapping from the \fIKEYMAP\fR file,
 and enables those on the rc device.
 .TP
 \fB\-?\fR, \fB\-\-help\fR
@@ -77,8 +77,9 @@ for any corresponding short options. Options can be combined together.
 the /dev/input/event* device to control
 .IP \fISYSDEV\fR
 the rc class as found at /sys/class/rc
-.IP \fITABLE\fR
-a toml file with a list of protocols and scancode to keycode mappings.
+.IP \fIKEYMAP\fR
+a toml keymap file with a list of protocols and scancodes to keycode mappings.
+The format is described in rc_keymap(5).
 .IP \fISCANKEY\fR
 a set of scancode1=keycode1,scancode2=keycode2.. value pairs
 .IP \fIPROTOCOL\fR
@@ -112,7 +113,8 @@ To append more codes to the existing table:
 .br
 	\fBir\-keytable \-w /etc/rc_keymaps/nec_terratec_cinergy_xs.toml\fR
 .PP
-To read the current keytable, on the second remote controller:
+To read the current scancode to keycode mapping on the second remote controller:
+.br
 	\fBir\-keytable \-s rc1 \-r\fR
 .PP
 To enable NEC protocol and load a BPF protocol, with a parameter for the BPF protocol:
@@ -135,5 +137,6 @@ License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
 .SH SEE ALSO
-rc_keymap(5).
+The keymap format is described in rc_keymap(5).
+
 To transmit IR or receive raw IR, see ir\-ctl(1).
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 5be2274a..b27ceb98 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -232,10 +232,10 @@ static const char doc[] = N_(
 	"\nOn the options below, the arguments are:\n"
 	"  DEV       - the /dev/input/event* device to control\n"
 	"  SYSDEV    - the ir class as found at /sys/class/rc\n"
-	"  TABLE     - a file with a set of scancode=keycode value pairs\n"
+	"  KEYMAP    - a keymap file with protocols and scancode to keycode mappings\n"
 	"  SCANKEY   - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
 	"  PROTOCOL  - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
-	"              sharp, mce_kbd, xmp, imon, rc_mm, other, all) to be enabled,\n"
+	"              sharp, mce_kbd, xmp, imon, rc-mm, other, all) to be enabled,\n"
 	"              or a bpf protocol name or file\n"
 	"  DELAY     - Delay before repeating a keystroke\n"
 	"  PERIOD    - Period to repeat a keystroke\n"
@@ -251,7 +251,7 @@ static const struct argp_option options[] = {
 	{"test",	't',	0,		0,	N_("test if IR is generating events"), 0},
 	{"device",	'd',	N_("DEV"),	0,	N_("ir device to control"), 0},
 	{"read",	'r',	0,		0,	N_("reads the current scancode/keycode table"), 0},
-	{"write",	'w',	N_("TABLE"),	0,	N_("write (adds) the scancodes to the device scancode/keycode table from an specified file"), 0},
+	{"write",	'w',	N_("KEYMAP"),	0,	N_("write (adds) the keymap from the specified file"), 0},
 	{"set-key",	'k',	N_("SCANKEY"),	0,	N_("Change scan/key pairs"), 0},
 	{"protocol",	'p',	N_("PROTOCOL"),	0,	N_("Protocol to enable (the other ones will be disabled). To enable more than one, use the option more than one time"), 0},
 	{"parameter",	'e',	N_("PARAMETER"), 0,	N_("Set a parameter for the protocol decoder")},
-- 
2.20.1

