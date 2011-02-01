Return-path: <mchehab@pedra>
Received: from eta-ori.net ([46.4.55.213]:59868 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab1BAGLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 01:11:42 -0500
Received: from [10.0.0.158] (p5B06FF0E.dip.t-dialin.net [91.6.255.14])
	by orion.eta-ori.net (Postfix) with ESMTPSA id 45DABB29A
	for <linux-media@vger.kernel.org>; Tue,  1 Feb 2011 07:02:49 +0100 (CET)
Message-ID: <4D47A209.4060805@impulze.org>
Date: Tue, 01 Feb 2011 07:02:49 +0100
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] prevent building/installation of various utilities
Content-Type: multipart/mixed;
 boundary="------------050805010804090901030105"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------050805010804090901030105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Heya, I wanted to provide a patch to have the ability to _not_ build
and install various tools even if the requirements are met.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22

--------------050805010804090901030105
Content-Type: text/plain;
 name="0001-make-compilation-installation-of-some-utils-configur.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-make-compilation-installation-of-some-utils-configur.pa";
 filename*1="tch"

>From 9e0771185011dedd3969dd084f0e2b9a2b23da27 Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Tue, 1 Feb 2011 05:38:55 +0100
Subject: [PATCH] make compilation/installation of some utils configurable

---
 utils/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/utils/Makefile b/utils/Makefile
index bcce0fe..25ff7c3 100644
--- a/utils/Makefile
+++ b/utils/Makefile
@@ -5,11 +5,14 @@ all install:
 		$(MAKE) -C $$i $@ || exit 1; \
 	done
 
+ifneq ($(USE_SYSFS_PATH),no)
 	# Test if libsysfs is installed
 	@-if [ -f /usr/include/sysfs/libsysfs.h ]; then \
 		$(MAKE) -C v4l2-sysfs-path $@; \
 	fi
+endif
 
+ifneq ($(USE_QV4L2),no)
 	# Test whether qmake is installed, and whether it is for qt4.
 	@if which qmake-qt4 >/dev/null 2>&1; then \
 		QMAKE=qmake-qt4; \
@@ -24,6 +27,7 @@ all install:
 			$(MAKE) -C qv4l2 -f Makefile.install $@; \
 		fi \
 	fi
+endif
 
 sync-with-kernel:
 	$(MAKE) -C keytable $@
-- 
1.7.3.5


--------------050805010804090901030105--
