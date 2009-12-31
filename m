Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:60478 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZLaLTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 06:19:05 -0500
Message-ID: <4B3C88A4.6070808@freemail.hu>
Date: Thu, 31 Dec 2009 12:19:00 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] move autoconf.h for 2.6.33
References: <200912291959.nBTJxkB3066435@smtp-vbr9.xs4all.nl> <4B3A72E1.9010107@freemail.hu> <4B3A86ED.1090303@redhat.com> <4B3A8E10.9000609@freemail.hu>
In-Reply-To: <4B3A8E10.9000609@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The linux/autoconf.h was moved to generated/autoconf.h as of 2.6.33.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 62ee2b0f6556 v4l/scripts/make_config_compat.pl
--- a/v4l/scripts/make_config_compat.pl	Wed Dec 30 18:19:11 2009 +0100
+++ b/v4l/scripts/make_config_compat.pl	Thu Dec 31 11:37:34 2009 +0100
@@ -383,9 +383,19 @@
 # Do the basic rules
 open IN, "<$infile" or die "File not found: $infile";

-$out.= "#ifndef __CONFIG_COMPAT_H__\n";
-$out.= "#define __CONFIG_COMPAT_H__\n\n";
-$out.= "#include <linux/autoconf.h>\n\n";
+$out .= <<'EOD'
+#ifndef __CONFIG_COMPAT_H__
+#define __CONFIG_COMPAT_H__
+
+#include <linux/version.h>
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+#include <linux/autoconf.h>
+#else
+#include <generated/autoconf.h>
+#endif
+
+EOD
+;

 # mmdebug.h includes autoconf.h. So if this header exists,
 # then include it before our config is set.

