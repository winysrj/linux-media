Return-path: <mchehab@pedra>
Received: from connie.slackware.com ([64.57.102.36]:37093 "EHLO
	connie.slackware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1ECEiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 00:38:19 -0400
From: Robby Workman <rworkman@slackware.com>
Message-Id: <201105030438.p434c7jn026979@connie.slackware.com>
Date: Mon, 02 May 2011 21:38:07 -0700
To: linux-media@vger.kernel.org
Cc: <volkerdi@slackware.com>, Volkerding@connie.slackware.com,
	Patrick@connie.slackware.com, <hdegoede@redhat.com>,
	Goede@connie.slackware.com, De@connie.slackware.com,
	Hans@connie.slackware.com, <obi@linuxtv.org>,
	Oberritter@connie.slackware.com, Andreas@connie.slackware.com,
	<mchehab@redhat.com>, Chehab@connie.slackware.com,
	Carvalho@connie.slackware.com, Mauro@connie.slackware.com
Subject: [PATCH 2/2] Allow override of manpage installation directory
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From dc79c6a5e20d8e3ceaa3763e68761556de8e16a7 Mon Sep 17 00:00:00 2001
From: Robby Workman <rworkman@slackware.com>
Date: Tue, 12 Apr 2011 09:26:57 -0500
Subject: [PATCH 2/2] Allow override of manpage installation directory

This creates MANDIR in Make.rules and keeps the preexisting
default of $(PREFIX)/share/man, but allows packagers to easily
override via e.g. "make MANDIR=/usr/man"
---
 Make.rules              |    1 +
 utils/keytable/Makefile |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Make.rules b/Make.rules
index 0bb2eb8..875828a 100644
--- a/Make.rules
+++ b/Make.rules
@@ -11,6 +11,7 @@ PREFIX = /usr/local
 LIBDIR = $(PREFIX)/lib
 # subdir below LIBDIR in which to install the libv4lx libc wrappers
 LIBSUBDIR = libv4l
+MANDIR = $(PREFIX)/share/man
 
 # These ones should not be overriden from the cmdline
 
diff --git a/utils/keytable/Makefile b/utils/keytable/Makefile
index 29a6ac4..e093280 100644
--- a/utils/keytable/Makefile
+++ b/utils/keytable/Makefile
@@ -39,7 +39,7 @@ install: $(TARGETS)
 	install -m 644 -p rc_keymaps/* $(DESTDIR)/etc/rc_keymaps
 	install -m 755 -d $(DESTDIR)/lib/udev/rules.d
 	install -m 644 -p 70-infrared.rules $(DESTDIR)/lib/udev/rules.d
-	install -m 755 -d $(DESTDIR)$(PREFIX)/share/man/man1
-	install -m 644 -p ir-keytable.1 $(DESTDIR)$(PREFIX)/share/man/man1
+	install -m 755 -d $(DESTDIR)$(MANDIR)/man1
+	install -m 644 -p ir-keytable.1 $(DESTDIR)$(MANDIR)/man1
 
 include ../../Make.rules
-- 
1.7.4.4

