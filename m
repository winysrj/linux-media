Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:40933 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZBQSBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 13:01:11 -0500
Received: from ozzy.localnet (dhpc-2-02.sissa.it [147.122.2.182])
	by smtp.sissa.it (Postfix) with ESMTP id CCF9E1B4804B
	for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 19:01:08 +0100 (CET)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: [PATCH] Trivial fixes for README.patches
Date: Tue, 17 Feb 2009 19:01:11 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171901.11613.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Uniform capitals, add trailing slash to some URLs and other typo corrections.

Priority: low

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
---
diff -r b7d4dc653623 -r 7e62edc7fd3e README.patches
--- a/README.patches	Thu Feb 12 08:17:46 2009 -0200
+++ b/README.patches	Thu Feb 12 15:08:02 2009 +0100
@@ -7,13 +7,13 @@
 (*) This is just an aka for the main developers involved in V4L/DVB
 drivers. They are a volunteer and unremunerated group of people that
 have the common interest of providing a good support on Linux for
-receiving and capturing video streams from Web cams, Analog TV, Digital
+receiving and capturing video streams from webcams, analog TV, digital
 TV and radio broadcast AM/FM.
 
    CONTENTS
    ========
 
-	1. A Brief introduction about patch management
+	1. A brief introduction about patch management
 	2. Git trees' relationships with v4l/dvb development
 	3. Mercurial trees used for v4l/dvb development
 	4. Community best practices
@@ -23,7 +23,7 @@
 	8. Identifying regressions with Mercurial
 	9. Creating a newer driver
 
-1. A Brief introduction about patch management
+1. A brief introduction about patch management
    ==========================================
 
 Current V4L/DVB development is based on a modern SCM system that
@@ -35,7 +35,7 @@
 development.
 
 There are some tutorials, FAQs and other valuable information at
-http://selenic.com/mercurial about hg usage.
+http://selenic.com/mercurial/ about hg usage.
 
 Mercurial is a distributed SCM, which means every developer gets his
 own full copy of the repository (including the complete revision
@@ -44,7 +44,7 @@
 finally merged into a common repository on linuxtv.org.
 
 A list of current available repositories is available at:
-	http://linuxtv.org/hg
+	http://linuxtv.org/hg/
 
 2. Git and Mercurial trees' relationships with v4l/dvb development
    ===============================================================
@@ -58,12 +58,13 @@
 The subsystem master tree is owned by the subsystem maintainer (Mauro
 Carvalho Chehab) being located at:
 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git
+
 A tree with development patches that aren't ready yet for upstream is
 handled at:
 	http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git
 
-There's also an experimental tree, that contains all experimental patches
-from subsystem trees. It is called linux-next. Its purpose is to check in
+There is also an experimental tree, that contains all experimental patches
+from subsystem trees, called linux-next. Its purpose is to check in
 advance if patches from different trees would conflict. The main tree for
 linux-next is owned by Stephen Rothwell and it is located at:
 	http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
@@ -79,7 +80,7 @@
 Before committing into the master -git tree, the finished patches from
 each maintainers tree are added on a staging tree, owned by the
 subsystem maintainer, at:
-	http://linuxtv.org/hg/v4l-dvb
+	http://linuxtv.org/hg/v4l-dvb/
 
 The main function of this tree is to merge patches from other
 repositories and to test the entire subsystem with the finished patches.
@@ -87,7 +88,7 @@
 patches and drivers.
 
 Users are welcome to use, test and report any issues via the mailing
-lists or via the Kernel's bugzilla, available at:
+lists or via the kernel's bugzilla, available at:
 	http://bugzilla.kernel.org
 
 Michael Krufky maintains a backport tree, containing a subset of the
@@ -95,7 +96,7 @@
 -stable team, at:
 	http://git.kernel.org/http://git.kernel.org/?p=linux/kernel/git/mkrufky/v4l-dvb-2.6.x.y.git
 
-3. Other mercurial trees used for v4l/dvb development
+3. Other Mercurial trees used for v4l/dvb development
    ==================================================
 
 V4L/DVB driver development is hosted at http://linuxtv.org. There are a
@@ -132,7 +133,7 @@
 	Documentation/SubmitChecklist
 	Documentation/CodingStyle
 
-b) All commits at mercurial trees should have a consistent message,
+b) All commits at Mercurial trees should have a consistent message,
    describing the patch. This is done by using:
 
 	make commit
@@ -157,7 +158,7 @@
 	   Signed-off-by: nowhere <nowhere@noplace.org>
 
    All lines starting with # and all lines starting with HG: will be
-   removed from the mercurial commit log.
+   removed from the Mercurial commit log.
 
    *WARNING* Be careful not to leave the first line blank, otherwise hg
    will leave subject blank.
@@ -212,9 +213,9 @@
 
    It is strongly recommended to have those lines in .bashrc or .profile.
 
-e) All patches shall have a Developers Certificate of Origin
+e) All patches shall have a Developer's Certificate of Origin
    version 1.1 in the commit log or the email description, signed by the
-   patch authors, as postulated in the Linux Kernel source at:
+   patch authors, as postulated in the Linux kernel source at:
 
 	Documentation/SubmittingPatches
 
@@ -253,21 +254,21 @@
    After reviewing a patchset, please send an e-mail indicating that, if
    possible, with some additional data about the testing, with the tag:
 	Reviewed-by: My Name <myemail@mysite.com>
-   This is particularly important for Kernel to userspace ABI changes.
+   This is particularly important for kernel to userspace ABI changes.
 
 h) If the patch also affects other parts of kernel (like Alsa
    or i2c), it is required that, when submitting upstream, the patch
    also goes to the maintainers of that subsystem. To do this, the
    developer shall copy the interested parties.
 
-   At mercurial tree, this can be handled automatically by the LinuxTV
+   At Mercurial tree, this can be handled automatically by the LinuxTV
    scripts, by using the cc: meta tag, together with the Signed-off-by
    lines. Something like:
 
 	CC: someotherkerneldeveloper@someplace
 	Signed-off-by: nowhere <nowhere@noplace.org>
 
-   This way, when a patch arrives mercurial hg tree, a mailbomb script
+   This way, when a patch arrives Mercurial hg tree, a mailbomb script
    will copy the proper interested parties.
 
    When submitting a patch via e-mail, it is better to copy all interested
@@ -283,8 +284,8 @@
    document still builds. Of course, any changes you make to the public
    V4L2 API must be documented anyway.
 
-j) Sometimes, mainstream changes affect the v4l-dvb tree, and mast be
-   backported to the v4l-dvb tree. This kind of commit to the mercurial
+j) Sometimes, mainstream changes affect the v4l-dvb tree, and must be
+   backported to the v4l-dvb tree. This kind of commit to the Mercurial
    tree should follow the rules above and should also have the line:
 
 	kernel-sync:
@@ -352,7 +353,7 @@
     machine, since git has a gitimport script that is used by mailimport.
 
     There's also a helper script to make easier to retrieve patches from
-    other mercurial repositories. The syntax is:
+    other Mercurial repositories. The syntax is:
 	./hgimport <URL>
 
     Also, hg has a feature, called mqueue, that allows having several patches
@@ -361,14 +362,14 @@
 
 m) By submitting a patch to the subsystem maintainer, either via email
    or via pull request, the patch author(s) are agreeing that the
-   submitted code will be added on Kernel, and that the submitted code
+   submitted code will be added on kernel, and that the submitted code
    are being released as GPLv2. The author may grant additional licenses
    to the submitted code (for example, using dual GPL/BSD) or GPLv2 or
    later. If no specific clause are added, the added code will be
    assumed as GPLv2 only.
 
 n) "Commit earlier and commit often". This is a common used rule at
-   Kernel. This means that a sooner submission of a patch will mean that
+   kernel. This means that a sooner submission of a patch will mean that
    a review can happen sooner, and help the develop to address the
    comments. This helps to reduce the life-cycle for having a changeset
    committed at kernel at the proper time. It also means that the one
@@ -437,7 +438,7 @@
 better to avoid those circumstances.
 
 During the procedure of generating kernel patches, the maintainer uses
-to do a diff between the kernel tree and v4l-dvb mercurial tree
+to do a diff between the kernel tree and v4l-dvb Mercurial tree
 (without any backport code there). If there are discrepancies, a
 backport patch from mainstream to v4l-dvb is generally applied by the
 maintainer.
@@ -498,9 +499,9 @@
 	   This is just a sample commit comment, just for reference purposes.
 	   This does nothing.
 
-	   Signed-off-by nowhere <nowere@noplace.org>
+	   Signed-off-by: nowhere <nowere@noplace.org>
 
-d. Every patch shall have a Developers Certificate of Origin and should
+d. Every patch shall have a Developer's Certificate of Origin and should
    be submitted by one of its authors. All the patch authors should sign
    it.
 
@@ -522,7 +523,7 @@
 
    The better way for you to identify regressions with Mercurial is to
    use hg bisect. This is an extension provided with the current
-   mercurial versions. For it to work, you need to have the proper setup
+   Mercurial versions. For it to work, you need to have the proper setup
    at an hgrc file. To test if bisect is working, you can do:
 	hg bisect help
 
