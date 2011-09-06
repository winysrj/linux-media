Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1IFPaP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 11:30:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 05/10] Ignore auto-generated files
Date: Tue,  6 Sep 2011 12:29:51 -0300
Message-Id: <1315322996-10576-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315322996-10576-4-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
 <1315322996-10576-2-git-send-email-mchehab@redhat.com>
 <1315322996-10576-3-git-send-email-mchehab@redhat.com>
 <1315322996-10576-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 .gitignore      |   17 +++++++++++++++++
 docs/.gitignore |    3 +++
 intl/.gitignore |    2 ++
 m4/.gitignore   |    8 ++++++++
 po/.gitignore   |    7 +++++++
 src/.gitignore  |    9 +++++++++
 6 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 docs/.gitignore
 create mode 100644 intl/.gitignore
 create mode 100644 m4/.gitignore
 create mode 100644 po/.gitignore
 create mode 100644 src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..9bbc8df
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,17 @@
+autom4te.cache/
+Makefile
+Makefile.in
+aclocal.m4
+config.guess
+config.h
+config.h.in
+config.log
+config.status
+config.sub
+configure
+install-sh
+libtool
+ltmain.sh
+missing
+stamp-h1
+depcomp
diff --git a/docs/.gitignore b/docs/.gitignore
new file mode 100644
index 0000000..22a4e72
--- /dev/null
+++ b/docs/.gitignore
@@ -0,0 +1,3 @@
+Makefile
+Makefile.in
+
diff --git a/intl/.gitignore b/intl/.gitignore
new file mode 100644
index 0000000..5c1aa8c
--- /dev/null
+++ b/intl/.gitignore
@@ -0,0 +1,2 @@
+plural.c
+
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..19aca97
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,8 @@
+Makefile
+Makefile.in
+libtool.m4
+ltoptions.m4
+ltsugar.m4
+ltversion.m4
+lt~obsolete.m4
+
diff --git a/po/.gitignore b/po/.gitignore
new file mode 100644
index 0000000..d2fdb57
--- /dev/null
+++ b/po/.gitignore
@@ -0,0 +1,7 @@
+*.gmo
+Makefile
+Makefile.in
+POTFILES
+remove-potcdate.sed
+stamp-po
+
diff --git a/src/.gitignore b/src/.gitignore
new file mode 100644
index 0000000..3a6766d
--- /dev/null
+++ b/src/.gitignore
@@ -0,0 +1,9 @@
+*.o
+.deps/
+Makefile
+Makefile.in
+tvtime
+tvtime-command
+tvtime-configure
+tvtime-scanner
+
-- 
1.7.6.1

