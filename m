Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab1IFPaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 10/10] tvtime: Bump to version 1.0.3
Date: Tue,  6 Sep 2011 12:29:56 -0300
Message-Id: <1315322996-10576-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-9-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
 <1315322996-10576-4-git-send-email-mchehab@redhat.com>
 <1315322996-10576-5-git-send-email-mchehab@redhat.com>
 <1315322996-10576-6-git-send-email-mchehab@redhat.com>
 <1315322996-10576-7-git-send-email-mchehab@redhat.com>
 <1315322996-10576-8-git-send-email-mchehab@redhat.com>
 <1315322996-10576-9-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Need to update its version, in order to allow distros to use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 ChangeLog    |    7 +++++++
 NEWS         |   10 +++++-----
 configure.ac |    4 ++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/ChangeLog b/ChangeLog
index 147b822..c613bde 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -1,3 +1,10 @@
+1.0.3 - Tue Sep 6 14:53:23 CEST 2011
+  * djh: Conversion to Mercurial, compilation fixes, patch backports
+	 from other places, more generic VBI handling, Alsa streaming
+	 support, get rid of V4L1.
+  * mchehab/hdegoede: Improved alsa audio streaming code.
+  * mchehab: Backport the remaining patches found on Fedora.
+
 1.0.2 - Wed Nov  9 21:46:28 EST 2005
   * vektor: Add a proper TVTIME_NOOP command so that you can remove
       keybindings.  Thanks to Andrew Dalton for the fix.
diff --git a/NEWS b/NEWS
index 7fe5522..0279b1d 100644
--- a/NEWS
+++ b/NEWS
@@ -1,8 +1,8 @@
-
-For news and updates on tvtime, please visit our website at:
-
-  http://tvtime.net/
-
+News for 1.0.3
+  * V4L1 removal
+  * Alsa streaming support
+  * Compilation fixes, patch backports from other places
+  * More generic VBI handling
 
 News for 1.0.2
 
diff --git a/configure.ac b/configure.ac
index f102b5b..37c2871 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,8 +1,8 @@
 # Process this file with autoconf to produce a configure script.
 AC_PREREQ(2.52)
-AC_INIT(tvtime, 1.0.2, http://tvtime.net/)
+AC_INIT(tvtime, 1.0.3, http://linuxtv.org/)
 AC_CONFIG_SRCDIR([src/tvtime.c])
-AM_INIT_AUTOMAKE(tvtime,1.0.2)
+AM_INIT_AUTOMAKE(tvtime,1.0.3)
 AM_CONFIG_HEADER(config.h)
 AM_MAINTAINER_MODE
 AC_CANONICAL_HOST
-- 
1.7.6.1

