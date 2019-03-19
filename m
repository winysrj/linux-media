Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58477C10F03
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 10:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32DB62133D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 10:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfCSKMT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:12:19 -0400
Received: from gofer.mess.org ([88.97.38.141]:41349 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfCSKMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 06:12:19 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 0C12C61138; Tue, 19 Mar 2019 10:12:17 +0000 (GMT)
Date:   Tue, 19 Mar 2019 10:12:17 +0000
From:   Sean Young <sean@mess.org>
To:     Adam Di Carlo <a.p.dicarlo@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: ir-keytable known bug -- fails to work when device specified
Message-ID: <20190319101217.6uictrbyhyednzxj@gofer.mess.org>
References: <8736njzpep.fsf@gw.coo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736njzpep.fsf@gw.coo>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 18, 2019 at 08:19:42PM -0400, Adam Di Carlo wrote:
> 
> There seems to be known issue with ir-keytable such that while
> 
>   ./ir-keytable -p rc5
> 
> works, this one won't:
> 
>   ./ir-keytable -d /dev/input/event24 -p rc5
> 
> Reading the source, it looks like the internal 'rc_dev' struct is really
> only filled out (get_attribs()) in the case where the device isn't
> passed in.
> 
> 
> Rather than document all this, isn't better to clean it up in the
> source?  I can probably come up with a patch for this issue in fairly
> short order, if that's welcome.

You're right, this is broken. For this to work it would have to get all
the details for the all the rc devices and find the one that has an
input device with that name.

That command line above implies that the protocol is a property of the
input device which it is not. Actually I think the whole -d option is
misleading and not really useful. I think the right solution is to just
remove it completely.


Sean


From 57fde44ec8723e6c15143f72055bd586628c3d8b Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 19 Mar 2019 10:09:55 +0000
Subject: [PATCH] keytable: remove misleading --device argument

Running 'ir-keytable --device /dev/input/event24 -p rc5' does not work
since ir-keytable cannot find an rc device via the input device name.

Simply remove this options from ir-keytable since it is not useful and
is only misleading.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/ir-keytable.1.in |  8 ------
 utils/keytable/keytable.c       | 45 ++++++++++-----------------------
 2 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/utils/keytable/ir-keytable.1.in b/utils/keytable/ir-keytable.1.in
index 9a354be4..a717b8da 100644
--- a/utils/keytable/ir-keytable.1.in
+++ b/utils/keytable/ir-keytable.1.in
@@ -3,9 +3,6 @@
 ir\-keytable \- a swiss\-knife tool to handle Remote Controllers.
 .SH SYNOPSIS
 .B ir\-keytable
-[\fIOPTION\fR]... \fI\-\-device\fR [\fI/dev/input/event* device\fR]
-.br
-.B ir\-keytable
 [\fIOPTION\fR]... \fI\-\-sysdev\fR [\fIrc class (f. ex. rc0)\fR]
 .br
 .B ir\-keytable
@@ -26,9 +23,6 @@ Auto\-load a table, based on a configuration file. Only works with
 \fB\-c\fR, \fB\-\-clear\fR
 Clears the scancode to keycode mappings.
 .TP
-\fB\-d\fR, \fB\-\-device\fR=\fIDEV\fR
-Use specified input device.
-.TP
 \fB\-D\fR, \fB\-\-delay\fR=\fIDELAY\fR
 Sets the delay before repeating a keystroke.
 .TP
@@ -73,8 +67,6 @@ print the v4l2\-utils version
 Mandatory or optional arguments to long options are also mandatory or optional
 for any corresponding short options. Options can be combined together.
 .SS The options arguments are:
-.IP \fIDEV\fR
-the /dev/input/event* device to control
 .IP \fISYSDEV\fR
 the rc class as found at /sys/class/rc
 .IP \fIKEYMAP\fR
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index b27ceb98..ec0b17a3 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -249,7 +249,6 @@ static const struct argp_option options[] = {
 	{"clear",	'c',	0,		0,	N_("clears the old table"), 0},
 	{"sysdev",	's',	N_("SYSDEV"),	0,	N_("ir class device to control"), 0},
 	{"test",	't',	0,		0,	N_("test if IR is generating events"), 0},
-	{"device",	'd',	N_("DEV"),	0,	N_("ir device to control"), 0},
 	{"read",	'r',	0,		0,	N_("reads the current scancode/keycode table"), 0},
 	{"write",	'w',	N_("KEYMAP"),	0,	N_("write (adds) the keymap from the specified file"), 0},
 	{"set-key",	'k',	N_("SCANKEY"),	0,	N_("Change scan/key pairs"), 0},
@@ -265,8 +264,7 @@ static const struct argp_option options[] = {
 };
 
 static const char args_doc[] = N_(
-	"--device [/dev/input/event* device]\n"
-	"--sysdev [ir class (f. ex. rc0)]\n"
+	"--sysdev [rc class (f. ex. rc0)]\n"
 	"[for using the rc0 sysdev]");
 
 /* Static vars to store the parameters */
@@ -732,9 +730,6 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		if (!p || *p || period < 0)
 			argp_error(state, _("Invalid period: %s"), arg);
 		break;
-	case 'd':
-		devicename = arg;
-		break;
 	case 's':
 		devclass = arg;
 		break;
@@ -2099,17 +2094,6 @@ int main(int argc, char *argv[])
 
 	/* Just list all devices */
 	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && delay < 0 && period < 0 && !bpf_protocol) {
-		if (devicename) {
-			fd = open(devicename, O_RDONLY);
-			if (fd < 0) {
-				perror(_("Can't open device"));
-				return -1;
-			}
-			device_name(fd, "");
-			device_info(fd, "");
-			close(fd);
-			return 0;
-		}
 		if (show_sysfs_attribs(&rc_dev, devclass))
 			return -1;
 
@@ -2119,25 +2103,24 @@ int main(int argc, char *argv[])
 	if (!devclass)
 		devclass = "rc0";
 
-	if (cfg.next && (clear || keytable || ch_proto || devicename)) {
+	if (cfg.next && (clear || keytable || ch_proto)) {
 		fprintf (stderr, _("Auto-mode can be used only with --read, --verbose and --sysdev options\n"));
 		return -1;
 	}
-	if (!devicename) {
-		names = find_device(devclass);
-		if (!names)
-			return -1;
-		rc_dev.sysfs_name = names->name;
-		if (get_attribs(&rc_dev, names->name)) {
-			free_names(names);
-			return -1;
-		}
-		names->name = NULL;
-		free_names(names);
 
-		devicename = rc_dev.input_name;
-		dev_from_class++;
+	names = find_device(devclass);
+	if (!names)
+		return -1;
+	rc_dev.sysfs_name = names->name;
+	if (get_attribs(&rc_dev, names->name)) {
+		free_names(names);
+		return -1;
 	}
+	names->name = NULL;
+	free_names(names);
+
+	devicename = rc_dev.input_name;
+	dev_from_class++;
 
 	if (cfg.next) {
 		struct cfgfile *cur;
-- 
2.20.1

