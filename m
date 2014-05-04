Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:63351 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaEDCJt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:49 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 4/6] [dvb-apps] dvb-apps: pass LDFLAGS to alevt and lib binaries
Date: Sun,  4 May 2014 02:51:19 +0100
Message-Id: <1399168281-20626-5-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on patch by Tobias Grimm in Debian's dvb-apps 1.1.1+rev1500-1
package.

Description: Use LDFLAGS passed in from dpkg-buildflags
 The alevt and lib binaries are not linked with the hardening options
 provided by dpkg-buildflags because LDFLAGS isn't used there.
 This patch simple adds the LDFLAGS to the Makefiles.
Author: Tobias Grimm <etobi@debian.org>
Date: Thu, 19 Sep 2013 23:04:58 +0200

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 Make.rules          | 4 ++--
 util/alevt/Makefile | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Make.rules b/Make.rules
index 3410d7b..0726060 100644
--- a/Make.rules
+++ b/Make.rules
@@ -46,7 +46,7 @@ ifeq ($(V),1)
 %: %.c
 	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD $(LDFLAGS) -o $@ $< $(filter-out %.h %.c,$^) $(LOADLIBES) $(LDLIBS)
 %.so:
-	$(CC) -shared -o $@ $^
+	$(CC) -shared $(LDFLAGS) -o $@ $^
 %.a:
 	$(AR) rcs $@ $^
 clean::
@@ -76,7 +76,7 @@ else
 	@$(CC) $(CPPFLAGS) $(CFLAGS) -MMD $(LDFLAGS) -o $@ $< $(filter-out %.h %.c,$^) $(LOADLIBES) $(LDLIBS)
 %.so:
 	@echo CC $@
-	@$(CC) -shared -o $@ $^
+	@$(CC) -shared $(LDFLAGS) -o $@ $^
 %.a:
 	@echo AR $@
 	@$(AR) rcs $@ $^
diff --git a/util/alevt/Makefile b/util/alevt/Makefile
index 2f7c8da..ac1996f 100644
--- a/util/alevt/Makefile
+++ b/util/alevt/Makefile
@@ -25,13 +25,13 @@ endif
 all: alevt alevt-date alevt-cap alevt.1 alevt-date.1 alevt-cap.1
 
 alevt: $(OBJS)
-	$(CC) $(OPT) $(OBJS) -o alevt -L$(PREFIX)/lib -L$(PREFIX)/lib64 -lX11 $(EXPLIBS)
+	$(CC) $(OPT) $(OBJS) $(LDFLAGS) -o alevt -L$(PREFIX)/lib -L$(PREFIX)/lib64 -lX11 $(EXPLIBS)
 
 alevt-date: $(TOBJS)
-	$(CC) $(OPT) $(TOBJS) -o alevt-date $(ZVBILIB)
+	$(CC) $(OPT) $(TOBJS) $(LDFLAGS) -o alevt-date $(ZVBILIB)
 
 alevt-cap: $(COBJS)
-	$(CC) $(OPT) $(COBJS) -o alevt-cap $(EXPLIBS)
+	$(CC) $(OPT) $(COBJS) $(LDFLAGS) -o alevt-cap $(EXPLIBS)
 
 font.o: font1.xbm font2.xbm font3.xbm font4.xbm
 fontsize.h: font1.xbm font2.xbm font3.xbm font4.xbm
-- 
1.9.2

