Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0BBUMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 15:12:09 -0500
Message-ID: <4B688711.2020907@infradead.org>
Date: Tue, 02 Feb 2010 18:12:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Douglas Landgraf <dougsland@gmail.com>
Subject: [PATCH] Updated procedures for patch submission
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updates the procedures to reflect the -git tree support on LinuxTV.

The previous version of the document were already a little outdated, since
it assumed that all patches were sent via -hg. So, email submission weren't
mentioned. Also it used to mix mercurial procedures with best practices.

With the usage of -git, the document needs to be reviewed, to incorporate
the new procedures.

Basically the changes on this document does:
- Add the git procedures submitted for RFC, and updated at LinuxTV wiki:
	http://linuxtv.org/wiki/index.php/Maintaining_Git_trees

- Move the procedures specific to -hg to a separate section;

- Add a general explanation about patch management;

- Add git specific procedures;

- Add mail submission procedures.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/README.patches b/README.patches
--- a/README.patches
+++ b/README.patches
@@ -1,5 +1,5 @@
 Mauro Carvalho Chehab <mchehab at infradead dot org>
-					Updated on 2009 February 9
+					Updated on 2010 January 30
 
 This file describes the general procedures used by the LinuxTV team (*)
 and by the v4l-dvb community.
@@ -13,58 +13,135 @@ TV and radio broadcast AM/FM.
    CONTENTS
    ========
 
-	1. A brief introduction about patch management
-	2. Git trees' relationships with v4l/dvb development
-	3. Mercurial trees used for v4l/dvb development
-	4. Community best practices
-	5. Knowing about newer patches committed at master hg repository
-	6. Patch handling for kernel submission
-	7. Patch submission from the community
-	8. Identifying regressions with Mercurial
-	9. Creating a newer driver
+     Part I - Patch management on LinuxTV
+        1. A brief introduction about patch management
+	2. Git and Mercurial trees hosted on LinuxTV site
+        3. Git and Mercurial trees' relationships with v4l/dvb development
+        4. Patch submission process overall
+        5. Other Git trees used for v4l/dvb development
+        6. Other Mercurial trees used for v4l/dvb development
+
+     Part II - Git trees
+        1. Kernel development procedures at the kernel upstream
+          1.1 Subsystem procedures for merging patches upstream
+          1.2 A practical example
+          1.3 Patches for stable
+        2. Kernel development procedures for V4L/DVB
+          2.1 Fixes and linux-next patches
+          2.2 How to solve those issues?
+        3. How to submit a -git pull request
+          3.1 Tags that a patch receive after its submission
+        4. Patches submitted via email
+          4.1 Example
+
+     Part III - Best Practices
+        1. Community best practices
+        2. Mercurial specific procedures
+        3. Knowing about newer patches committed at the development repositories
+        4. Patch submission from the community
+        5. Identifying regressions with Mercurial
+        6. Identifying regressions with Git
+        7. Creating a newer driver
+          7.1. Simple drivers
+          7.2. Bigger drivers
+
+===================================
+PART I. PATCH MANAGEMENT ON LINUXTV
+===================================
+
 
 1. A brief introduction about patch management
-   ==========================================
+   ===========================================
 
-Current V4L/DVB development is based on a modern SCM system that
-fits better into kernel development model, called Mercurial (aka hg).
+V4L/DVB development is based on modern SCM (Source Code Management) systems
+that fits better into kernel development model.
 
-Kernel development model is based on a similar SCM, called git. While
-very powerful for distributed development, git usage is not simple for
-final users. That's the reason why hg was selected for V4L/DVB
-development.
+At the beginning, the usage CVS for of a SCM (Source Code Management) were
+choosen on V4L/DVB. Both of the original V4L and DVB trees were developed with
+the help of cvs. On that time, upstream Linux kernel used to have another tree
+(BitKeeper).
 
-There are some tutorials, FAQs and other valuable information at
-http://selenic.com/mercurial/ about hg usage.
+In 2005, Upstream Kernel development model changed to use git (a SCM tool
+developed by Linus Torvalds, the inventor and main maintainer of the Linux
+Kernel).
 
-Mercurial is a distributed SCM, which means every developer gets his
-own full copy of the repository (including the complete revision
-history), and can work and commit locally without network connection.
-The resulting changesets can then be exchanged between repositories and
-finally merged into a common repository on linuxtv.org.
+Also in 2005, both V4L and DVB trees got merged into one cvs repository, and
+the community discussed about what would be the better SCM solution. It were
+mainly availed the usage of svn, hg and git. On that time, both hg and git were
+new technologies, based on the concept of a distributed SCM, where there's no
+need to go to the server every time a command is used at the SCM. This speeds
+up the development time, and allows descentralized development.
 
-A list of current available repositories is available at:
+Mercurial used to be stable and had more projects using, while git were giving
+its first steps, being used almost only by the Linux Kernel, and several distros
+didn't use to package it. Git objects were stored uncompressed, generating very
+large trees. Also, -git tools were complex to use, and some "porcelain" packages
+were needed, in order to be used by a normal user.
+
+So, the decision was made to use Mercurial. However, as time goes by, git got
+much more eyes than any other SCM, having all their weakness solved, and being
+developed really fast. Also, it got adopted by several other projects, due to
+its capability and its number of features.
+
+Technically speaking, -git is currently the most advanced distributed
+open-source SCM application available today.
+
+Yet, Mercurial has been doing a very good job maintaining the V4L/DVB trees,
+and, except for a few points, it does the job.
+
+However, the entire Linux Kernel development happens around -git. Even the ones
+that were adopting other tools (like -alsa, that used to have also Mercurial
+repositories) migrated to -git.
+
+Despite all technical advantages, the rationale for the migration to git is
+quite simple: converting patches between different repositories and SCM tools
+cause development and merge delays, may cause patch mangling and eats lot of
+the time for people that are part of the process.
+
+Also, every time a patch needs to touch on files outside the incomplete tree
+used at the subsystem, an workaround need to be done, in order to avoid troubles
+and to be able to send the patch upstream.
+
+So, it is simpler to just use -git.
+
+2. Git and Mercurial trees hosted on LinuxTV site
+   ==============================================
+
+A list of current available Git repositories used on LinuxTV is available at:
 	http://linuxtv.org/hg/
 
-2. Git and Mercurial trees' relationships with v4l/dvb development
+
+A list of current available Mercurial repositories used on LinuxTV is available
+at:
+	http://git.linuxtv.org
+
+3. Git and Mercurial trees' relationships with v4l/dvb development
    ===============================================================
 
-The main kernel trees are hosted at http://git.kernel.org. Each tree
-is owned by a maintainer.
+The main subsystem kernel trees are hosted at http://git.kernel.org. Each tree
+is owned by a maintainer. In the case of LinuxTV, the subsystem maintainer is
+Mauro Carvalho Chehab, who owns all sybsystem trees.
 
-The main kernel trees is owned by Linus Torvalds, being located at:
+The main kernel tree is owned by Linus Torvalds, being located at:
 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
 
-The subsystem master tree is owned by the subsystem maintainer (Mauro
-Carvalho Chehab) being located at:
+The subsystem maintainer's master tree is located at:
 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git
 
-A tree with development patches that aren't ready yet for upstream is
-handled at:
-	http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git
+The subsystem maintainer's tree with development patches that aren't ready yet
+for upstream is handled at:
+	http://git.linuxtv.org/git/v4l-dvb.git
+
+The main function of this tree is to merge patches received via email and from
+other Git and Mercurial repositories and to test the entire subsystem with the
+finished patches.
+
+The subsystem maintainer's tree with development patches that will be sent soon
+to upstream is located at:
+	http://git.linuxtv.org/git/fixes.git
 
 There is also an experimental tree, that contains all experimental patches
-from subsystem trees, called linux-next. Its purpose is to check in
+from all subsystem trees, called linux-next. Its purpose is to check in
 advance if patches from different trees would conflict. The main tree for
 linux-next is owned by Stephen Rothwell and it is located at:
 	http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
@@ -73,41 +150,107 @@ Warning: linux-next is meant to be used 
 +++++++  patches on several subsystems, it may cause damage if used on
 	 production systems.
 
-The subsystem linux-next tree is also owned by Mauro Carvalho Chehab, and it is
-located at:
+The subsystem maintainer's linux-next tree is located at:
 	http://www.kernel.org/git/?p=linux/kernel/git/mchehab/linux-next.git
 
-Before committing into the master -git tree, the finished patches from
-each maintainers tree are added on a staging tree, owned by the
-subsystem maintainer, at:
-	http://linuxtv.org/hg/v4l-dvb/
+In general, it contains a replica of the contents of the development tree.
 
-The main function of this tree is to merge patches from other
-repositories and to test the entire subsystem with the finished patches.
-This is also the recommended tree for users interested on testing newer V4L/DVB
-patches and drivers.
+Michael Krufky maintains a backport tree, containing a subset of the
+patches from the subsystem tree that are meant to be sent to kernel
+-stable team, at:
+	http://git.kernel.org/http://git.kernel.org/?p=linux/kernel/git/mkrufky/
+v4l-dvb-2.6.x.y.git
+
+In order to allow testing the LinuxTV drivers with older kernels, a backport
+tree is maintained by Douglas Landgraf. The backport tree is at:
+        http://linuxtv.org/hg/v4l-dvb
+
+ Basically, all patches added at -git
+are manually imported on this tree, that also contains some logic to allow
+compilation of the core system since kernel 2.6.16. It should be noticed,
+however, that some drivers may require newer kernels in order to compile.
+
+Also, those backports are developped as best efforts, and are mainly against
+upstream stable kernels, so they may not compile with distro-patched kernels,
+nor they are meant to offer production level of support. So, if you need to
+run any prodution machine, you should really be using a Linux distribution
+that offers support for the drivers you need and has a Quality Assurance
+process when doing backports. You were warned.
 
 Users are welcome to use, test and report any issues via the mailing
 lists or via the Kernel Bug Tracker, available at:
 	http://bugzilla.kernel.org
 
-Michael Krufky maintains a backport tree, containing a subset of the
-patches from the subsystem tree that are meant to be sent to kernel
--stable team, at:
-	http://git.kernel.org/http://git.kernel.org/?p=linux/kernel/git/mkrufky/v4l-dvb-2.6.x.y.git
+4. Patch submission process overall
+   ================================
 
-3. Other Mercurial trees used for v4l/dvb development
+When a developer believes that there are done to be merged, he sends a request
+for the patches to get merged at the v4l-dvb.git tree, at the linux-media at
+vger.kernel.org (the main mailing list for LinuxTV).
+
+The patches are analyzed and, if they look ok, they got merged into v4l-dvb.git.
+
+Currently, there are thre ways to submit a patch:
+  as an email, with the subject [PATCH];
+  as a hg pull request, with the subject [PULL];
+  as a git pull request, with the subject [GIT FIXES ...] or [GIT UPDATES ...]
+
+If the patch is developed against the Mercurial repositories, it is converted
+to the format git expects and have any backport code removed.
+
+No matter how the patch is received, after being checked and accepted by the maintainer, the patch will receive the maintainer's Certificate of Origin (Signed-off-by, as explained later within this document), and will be added
+at:
+  http://git.linuxtv.org/git/v4l-dvb.git
+
+Later, it will be backported to the -hg tree.
+
+The community also reviews the patches and may send emails informing that the
+patch has problems or were tested/acked. When those reviews happen after the
+patch merge at the tree, the patch is modified before its upstream submission.
+
+Also, the maintainer may need to modify the patch at his trees, in order to
+fix conflicts that may happen with the patch.
+
+The subsystem maintainer, when preparing the kernel patches to be sent
+to mainstream, send the patches first to linux-next tree, and waits for some
+to receive contributions from other upstream developers. If, during that period,
+he notices a problem, he may correct the patch at his upstream submission tree.
+
+5. Other Git trees used for v4l/dvb development
+   ============================================
+
+V4L/DVB Git trees are hosted at
+  git://linuxtv.org.
+
+There are a number of trees there each owned by a developer of the LinuxTV team.
+
+The submission emails are generated via the usage of git request-pull, as
+described on part II.
+
+Git is a distributed SCM, which means every developer gets his
+own full copy of the repository (including the complete revision
+history), and can work and commit locally without network connection.
+The resulting changesets can then be exchanged between repositories and
+finally merged into a common repository on linuxtv.org.
+
+The Git trees used on LinuxTV have the entire Linux Kernel tree and history
+since kernel 2.6.12. So, it generally takes some time to update it at the
+first time.
+
+There are several good documents on how to use -git, including:
+  http://git.or.cz/
+  http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html
+  http://www.kernel.org/pub/software/scm/git/docs
+
+6. Other Mercurial trees used for v4l/dvb development
    ==================================================
 
-V4L/DVB driver development is hosted at http://linuxtv.org. There are a
-number of trees there each owned by a developer of the LinuxTV team.
+V4L/DVB Mercurial trees are hosted at
+  http://linuxtv.org/hg.
 
-When a developer believes that he has patches done to be merged, he
-sends a request the developers' mailing list and to the subsystem
-maintainer. The patches are analyzed and, if they look ok, merged into
-the master repository.
+There are a number of trees there each owned by a developer of the LinuxTV team.
 
-A script called hg-pull-req.pl is included that will generate this
+A script called v4l/scripts/hg-pull-req.pl is included that will generate this
 request, providing a list of patches that will be pulled, links to each
 patch, and a diffstat of the all patches.  It will work best if Hg has
 been configured with the correct username (also used by the commit
@@ -118,7 +261,446 @@ It is good practice that each developer 
 called 'v4l-dvb', which keeps their patches, and periodically update
 this tree with the master tree's patches.
 
-4. Community best practices
+Mercurial is a distributed SCM, which means every developer gets his
+own full copy of the repository (including the complete revision
+history), and can work and commit locally without network connection.
+The resulting changesets can then be exchanged between repositories and
+finally merged into a common repository on linuxtv.org.
+
+There are some tutorials, FAQs and other valuable information at
+  http://selenic.com/mercurial/
+
+
+==================
+PART II. GIT TREES
+==================
+
+
+1. Kernel development procedures at the kernel upstream
+   ====================================================
+
+It is important that people understand how upstream development works.
+
+Kernel development has 2 phases:
+
+a) a merge window typically with 2 weeks (although Linus is gave some
+  indications that he may reduce it on 2.6.34), starting with the release of
+  a new kernel version;
+
+b) the -rc period, where the Kernel is tested and receive fixes.
+
+The length of the -rc period depends on the number and relevance of the fixes.
+Considering the recent history, it ranges from -rc6 to -rc8, where each -rc
+takes one week.
+
+Those are the latest -rc kernels since 2.6.12:
+  kernel 	latest -rc version
+  2.6.12 	rc6
+  2.6.13 	rc7
+  2.6.14 	rc5
+  2.6.15 	rc7
+  2.6.16 	rc6
+  2.6.17 	rc6
+  2.6.18 	rc7
+  2.6.19 	rc6
+  2.6.20 	rc7
+  2.6.21 	rc7
+  2.6.22 	rc7
+  2.6.23 	rc9
+  2.6.24 	rc8
+  2.6.25 	rc9
+  2.6.26 	rc9
+  2.6.27 	rc9
+  2.6.28 	rc9
+  2.6.29 	rc8
+  2.6.30 	rc8
+  2.6.31 	rc9
+  2.6.32 	rc8
+
+In general, the announcement of a new -rc kernel gives some hints when that
+-rc kernel may be the last one.
+
+1.1. Subsystem procedures for merging patches upstream
+     =================================================
+
+The required procedure on subsystem trees is that:
+
+a) During -rc period (e.g. latest main kernel available is 2.6.x, the latest
+  -rc kernel is 2.6.[x+1]-rc<y>):
+
+    * fix patches for the -rc kernel (2.6.[x+1]) should be sent upstream,
+      being a good idea to send them for some time at linux-next tree, allowing
+      other people to test it, and check for potential conflicts with the other
+      arch's;
+    * patches for 2.6.[x+2] should be sent to linux-next.
+
+b) the release of 2.6.[x+1] kernel:
+
+    * closes the -rc period and starts the merge window.
+
+c) During the merge window:
+
+    * the patch that were added on linux-next during the -rc period for
+      2.6.[x+2] should be sent upstream;
+    * new non-fix patches should be hold until the next -rc period starts, so,
+      they'll be added on 2.6.[x+3];
+    * fix patches for 2.6.[x+2] should go to linux-next, wait for a few days
+      and then send upstream.
+
+d) the release of 2.6.[x+2]-rc1 kernel:
+
+    * the merge window has closed. No new features are allowed.
+    * the patches with new features that arrived during the merge window
+      will be moved to linux-next
+
+1.2. A practical example
+     ===================
+
+Considering that, at the time this document were written, the last main release
+is 2.6.32, and the latest -rc release is 2.6.33-rc5, this means that:
+
+    * Stable patches, after adding upstream, are being received for 2.6.32
+      kernel series;
+    * Bug fixes are being received for kernel 2.6.33;
+    * New feature patches are being received for kernel 2.6.34.
+
+After the release of kernel 2.6.33, starts the period for receiving patches
+for 2.6.35.
+
+In other words, the features being developed are always meant to be included on
+the next 2 kernels.
+
+In the specific case of new drivers that don't touch on existing features, it
+could be possible to send it during the -rc period, but it is safer to assume
+that those drivers should follow the above procedure, as a later submission may
+be nacked.
+
+1.3. Patches for stable
+   ====================
+
+Sometimes, a fix patch corrects a problem that happens also on stable kernels
+(e. g. on kernel 2.6.x or even 2.6.y, where y < x). In this case, the patch
+should be sent to stable@kernel.org, in order to be added on stable kernels.
+
+In the case of git-submitted patches with fixes, that also need to be send to
+stable, all the developer needs to do is to add, a the patch description:
+
+ CC: stable.kernel.org
+
+At the moment the patch reaches upstream, a copy of the patch will be
+automatically be sent to the stable maintainer and will be considered for
+inclusion on the next stable kernel (2.6.x.y).
+
+2. Kernel development procedures for V4L/DVB
+   =========================================
+
+The upsteam procedures should be followed by every kernel subsystem. The
+subsystems have their own specific procedures detailing how the development
+patches are handled before arriving upstream. In the case of v4l/dvb, those
+are the used procedures.
+
+2.1. Fixes and linux-next patches
+     ============================
+
+One of the big problems of our model used in the past by the subsystem, based on
+one Mercurial tree, is that there were just one tree/branch for everything. This
+makes hard to send some fix patches for 2.6.[x+1], as they may have conflicts
+with the patches for 2.6.[x+2]. So, when the conflict is simple to solve, the
+patch is sent as fixes. Otherwise, the patch generally needed to hold to the
+next cycle. The fix patches used to get a special tag, added by the developer
+("Priority: high", in the body of the description), to give a hint to the
+subsystem maintainer that the patch should be sent upstream.
+
+Unfortunately, sometimes people mark the driver with the wrong tag. For example,
+a patch got merged on Jan, 22 2010 that marked with "high". However, that patch
+didn't apply at the fixes tree, because it fix a regression introduced by a
+driver that weren't merged upstream yet.
+
+2.2. How to solve those issues?
+     ==========================
+
+Well, basically, the subsystem should work with more than one tree (or branch),
+on upstream submission:
+
+    * a tree(branch) with the fix patches;
+    * a tree(branch) with the new feature patches.
+
+So, the subsystem uses two development -git trees:
+
+    * http://linuxtv.org/git//v4l-dvb.git - for patches that will be sent to the
+      [x+2] kernel (and merged at upstream linux-next tree)
+
+    * http://linuxtv.org/git//fixes.git - for bug patches that will be sent to
+      the [x+1] kernel (also, patches that need to go to both [x+1] and [x])
+
+While the patches via -hg, due to the merge conflicts its mentioned, the better
+is that, even those developers that prefer to develop patches use the old way,
+to send the fix patches via -git. This way, if is there a conflict, he is the
+one that can better solve it. Also, it avoids the risk of a patch being wrongly
+tagged.
+
+Also, after having a patch added on one of the above trees, it can't simply
+remove it, as others will be cloning that tree. So, the only option would be to
+send a revert patch, causing the patch history to be dirty and could be
+resulting on some troubles when submitting upstream. I've seen some nacks on
+receiving patches upstream from dirty git trees. So, we should really avoid
+this.
+
+3. how to submit a -git pull request
+   =================================
+
+As the same git tree may have more than one branch, and we'll have 2 -git trees
+for upstream, it is required that people specify what should be done. The
+internal maintainer's workflow is based on different mail queues for each type
+of requesting received.
+
+There are some scripts to automate the process, so it is important that everyone
+that sends -git pull do it at the same way.
+
+So, a pull request to be send with the following email tags:
+
+ From: <your real email>
+ Subject: [GIT FIXES FOR 2.6.33] Fixes for driver cx88
+ To: linux-media@vger.kernel.org
+
+ From: <your real email>
+ Subject: [GIT PATCHES FOR 2.6.34] Updates for the driver saa7134
+ To: linux-media@vger.kernel.org
+
+The from line may later be used by the git mailbomb script to send you a copy
+when the patch were committed, so it should be your real email.
+
+The indication between [] on the subject will be handled by the mailer scripts
+to put the request at the right queue. So, if tagged wrong, it may not be
+committed.
+
+Don't send a copy of the pull to the maintainer addresses. The pull will be
+filtering based on the subject and on the mailing list. If you send a c/c to the
+maintainer, it will be simply discarded.
+
+NEVER send a copy of any pull request to a subscribers-only mailing list.
+Everyone is free to answer to the email, reviewing your patches. Don't penalty
+people that wants to contribute with you with SPAM bouncing emails, produced by
+subscribers only lists.
+
+When a patch touches on other subsystem codes, please copy the other subsystem
+maintainers. This is important for patches that touches on arch files, and also
+for -alsa non-trivial patches.
+
+The email should be generated with the usage of git request-pull:
+
+      git request-pull $ORIGIN $URL
+
+where $ORIGIN is the commit hash of the tree before your patches, and $URL is
+the URL for your repository.
+
+For example, for the patches merged directly from -hg at the -git trees on Jan,
+22 2010, the above commands produced:
+
+ The following changes since commit 2f52713ab3cb9af2eb0f9354dba1421d1497f3e7:
+   Abylay Ospan (1):
+         V4L/DVB: 22-kHz set_tone fix for NetUP Dual DVB-S2-CI card. 22kHz logic controlled by demod
+
+ are available in the git repository at:
+
+   git://linuxtv.org/v4l-dvb.git master
+
+ Andy Walls (4):
+       V4L/DVB: cx25840, v4l2-subdev, ivtv, pvrusb2: Fix ivtv/cx25840 tinny audio
+       V4L/DVB: ivtv: Adjust msleep() delays used to prevent tinny audio and PCI bus hang
+       V4L/DVB: cx18-alsa: Initial non-working cx18-alsa files
+       V4L/DVB: cx18-alsa: Add non-working cx18-alsa-pcm.[ch] files to avoid data loss
+
+ Devin Heitmueller (20):
+       V4L/DVB: xc3028: fix regression in firmware loading time
+       V4L/DVB: cx18: rename cx18-alsa.c
+       V4L/DVB: cx18: make it so cx18-alsa-main.c compiles
+       V4L/DVB: cx18: export a couple of symbols so they can be shared with cx18-alsa
+       V4L/DVB: cx18: overhaul ALSA PCM device handling so it works
+       V4L/DVB: cx18: add cx18-alsa module to Makefile
+       V4L/DVB: cx18: export more symbols required by cx18-alsa
+       V4L/DVB: cx18-alsa: remove unneeded debug line
+       V4L/DVB: cx18: rework cx18-alsa module loading to support automatic loading
+       V4L/DVB: cx18: cleanup cx18-alsa debug logging
+       V4L/DVB: cx18-alsa: name alsa device after the actual card
+       V4L/DVB: cx18-alsa: remove a couple of warnings
+       V4L/DVB: cx18-alsa: fix memory leak in error condition
+       V4L/DVB: cx18-alsa: fix codingstyle issue
+       V4L/DVB: cx18-alsa: codingstyle fixes
+       V4L/DVB: cx18: codingstyle fixes
+       V4L/DVB: cx18-alsa: codingstyle cleanup
+       V4L/DVB: cx18-alsa: codingstyle cleanup
+       V4L/DVB: cx18: address possible passing of NULL to snd_card_free
+       V4L/DVB: cx18-alsa: Fix the rates definition and move some buffer freeing code.
+
+ Ian Armstrong (1):
+       V4L/DVB: ivtv: Fix race condition for queued udma transfers
+
+ Igor M. Liplianin (4):
+       V4L/DVB: Add Support for DVBWorld DVB-S2 PCI 2004D card
+       V4L/DVB: dm1105: connect splitted else-if statements
+       V4L/DVB: dm1105: use dm1105_dev & dev instead of dm1105dvb
+       V4L/DVB: dm1105: use macro for read/write registers
+
+ JD Louw (1):
+       V4L/DVB: Compro S350 GPIO change
+
+  drivers/media/common/tuners/tuner-xc2028.c  |   11 +-
+  drivers/media/dvb/dm1105/Kconfig            |    1 +
+  drivers/media/dvb/dm1105/dm1105.c           |  501 ++++++++++++++-------------
+  drivers/media/video/cx18/Kconfig            |   11 +
+  drivers/media/video/cx18/Makefile           |    2 +
+  drivers/media/video/cx18/cx18-alsa-main.c   |  293 ++++++++++++++++
+  drivers/media/video/cx18/cx18-alsa-mixer.c  |  191 ++++++++++
+  drivers/media/video/cx18/cx18-alsa-mixer.h  |   23 ++
+  drivers/media/video/cx18/cx18-alsa-pcm.c    |  353 +++++++++++++++++++
+  drivers/media/video/cx18/cx18-alsa-pcm.h    |   27 ++
+  drivers/media/video/cx18/cx18-alsa.h        |   59 ++++
+  drivers/media/video/cx18/cx18-driver.c      |   40 ++-
+  drivers/media/video/cx18/cx18-driver.h      |   10 +
+  drivers/media/video/cx18/cx18-fileops.c     |    6 +-
+  drivers/media/video/cx18/cx18-fileops.h     |    3 +
+  drivers/media/video/cx18/cx18-mailbox.c     |   46 +++-
+  drivers/media/video/cx18/cx18-streams.c     |    2 +
+  drivers/media/video/cx25840/cx25840-core.c  |   48 ++-
+  drivers/media/video/ivtv/ivtv-irq.c         |    5 +-
+  drivers/media/video/ivtv/ivtv-streams.c     |    6 +-
+  drivers/media/video/ivtv/ivtv-udma.c        |    1 +
+  drivers/media/video/pvrusb2/pvrusb2-hdw.c   |    1 +
+  drivers/media/video/saa7134/saa7134-cards.c |    4 +-
+  include/media/v4l2-subdev.h                 |    1 +
+  24 files changed, 1380 insertions(+), 265 deletions(-)
+  create mode 100644 drivers/media/video/cx18/cx18-alsa-main.c
+  create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.c
+  create mode 100644 drivers/media/video/cx18/cx18-alsa-mixer.h
+  create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.c
+  create mode 100644 drivers/media/video/cx18/cx18-alsa-pcm.h
+  create mode 100644 drivers/media/video/cx18/cx18-alsa.h
+
+This helps to identify what's expected to be found at the -git tree and to
+double check if the merge happened fine.
+
+3.1. Tags that a patch receive after its submission
+     ==============================================
+
+This is probably the most complex issue to solve.
+
+Signed-off-by/Acked-by/Tested-by/Nacked-by tags may be received after a patch or
+a -git submission. This can happen even while the patch is being tested at
+linux-next, from people reporting problems on the existing patches, or reporting
+that a patch worked fine.
+
+Also, the driver maintainer and the subsystem maintainer that is committing
+those patches should sign each one, to indicate that he reviewed and has
+accepted the patch.
+
+Currently, if a new tag is added to a committed patch, its hash will change.
+There were some discussions at Linux Kernel Mailing List about allowing adding
+new tags on -git without changing the hash, but I think this weren't implemented
+(yet?).
+
+The same problem occurs with -hg, but, as -hg doesn't support multiple branches
+(well, it has a "branch" command, but the concept of branch there is different),
+it was opted that the -hg trees won't have all the needed SOBs. Instead, those
+would be added only at the submission tree.
+
+With -git, a better procedure can be used:
+
+The developer may have two separate branches on his tree. For example, let's
+assume that the developer has the following branches on his tree:
+
+    * media-master (associated with "linuxtv" remote)
+    * fixes
+    * devel
+
+His development happens on devel branch. When the patches are ready to
+submission will be copied into a new for_submission branch: git branch
+for_submission devel
+
+And a pull request from the branch "for_submission" will be sent.
+
+Eventually, he'll write new patches on his devel branch.
+
+After merged, the developer updates the linuxtv remote and drops the
+for_submission branch. This way, "media-master" will contain his patches that
+got a new hash, due to the maintainer's SOB. However, he has some new patches on
+his devel, that applies over the old hashes.
+
+Fortunately, git has a special command to automatically remove the old objects:
+git rebase.
+
+All the developer needs to do is to run the commands bellow:
+  git remote update 		# to update his remotes, including "linuxtv"
+  git checkout devel		# move to devel branch
+  git pull . media-master 	# to make a recursive merge from v4l/dvb upstream
+  git rebase media-master 	# to remove the legacy hashes
+
+After this, his development branch will contain only upstream patches + the new
+ones he added after sending the patches for upstream submission.
+
+4. Patches submitted via email
+   ===========================
+
+All valid patches submitted via email to linux-media at vger.kernel.org are
+automatically stored at http://patchwork.kernel.org/project/linux-media/list. A
+patch, to be valid, should be in diff unified format. If you're using a -git
+tree, the simplest way to generate unified diff patches is to run:
+
+ git diff
+
+If you're writing several patches, the better is to create a tag or a branch for
+the changes you're working. After that, you can use
+
+  git format-patch <origin_branch>
+
+to create the patches for email submission.
+
+4.1. Example
+     =======
+
+Suppose that the -git tree were created with:
+
+ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
+ cd v4l-dvb
+ git remote add linuxtv git://linuxtv.org/v4l-dvb.git
+ git remote update
+ git checkout -b media-master linuxtv/master
+
+
+Before start working, you need to create your work branch:
+
+ git branch work media-master
+
+And move the working copy to the "work" branch:
+
+ git checkout work
+
+Some changes were done at the driver and saved by commit:
+
+ git commit -as
+
+When the patches are ready for submission via email, all that is needed is to
+run:
+
+ git format-patch work
+
+The command will create a series of emails bodies, one file per email.
+
+Just send the email with the patch inlined for it to ge caught by patchwork.
+
+  BE CAREFUL: several emailers including Thunderdird breaks long lines, causing
+  patch corruption.
+  In the specific case of Thunderbird, an extension is needed to send the
+  patches, called Asalted Patches:
+	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
+
+
+=========================
+Part III - BEST PRACTICES
+=========================
+
+
+1. Community best practices
    ========================
 
 From accumulated experience, there are some basic rules that should
@@ -133,8 +715,144 @@ a) Every developer should follow the "ru
 	Documentation/SubmitChecklist
 	Documentation/CodingStyle
 
-b) All commits at Mercurial trees should have a consistent message,
-   describing the patch. This is done by using:
+b) All commits at the trees should have a consistent message, describing the
+   patch.
+
+   When a patch is generated against the git tree, the better is to commit it
+   with:
+        git commit -as
+
+  This will automatically add all existing patches that got modified and add
+  your Certificate of Origin (Signed-off-by).
+
+  It will open an editor for you to provide a description of the patch.
+  The first line is a short summary describing why the patch is needed, and
+  the following lines describe what and how the patch does that.
+
+  If you've added new files, don't forget to add them before the commit, with:
+        git add <the name of each file you've created>
+
+  Before committing a patch, you need to check it with checkpatch.pl tool. This
+  is done by running:
+        git diff | ./script/checkpatch.pl -
+
+c) All patches are requested to have their coding style validated by using
+   ./script/checkpatch.pl.
+
+   On Git, the script checks not only the patch against coding style, but
+   also checks for the usage of functions that are marked to be removed
+   from the kernel ABI.
+
+d) All patches shall have a Developer's Certificate of Origin
+   version 1.1 in the commit log or the email description, signed by the
+   patch authors, as postulated in the Linux kernel source at:
+
+	Documentation/SubmittingPatches
+
+   This is done by adding Signed-off-by: fields to the commit message.
+
+   It is not acceptable to use fake signatures, e.g.:
+
+	Signed-off-by: Fake me <me@snakeoilcompany.com>
+
+   The email must be a valid one.
+   The author that is submitting the email should be at the button of
+   the author's signed-off-by (SOB) block. Other SOBs or Acked-by: will be
+   added at the bottom, marking that somebody else reviewed the patch.
+
+   Each person who is in the kernel patch submission chain (driver author
+   and/or driver maintainer, subsystem/core maintainers, etc) will
+   review each patch. If they agree, the patch will be added to their
+   trees and signed. Otherwise, they may comment on the patch, asking
+   for some review.
+
+e) Although not documented at kernel's Documentation/, a common kernel
+   practice is to use Acked-by: and Tested-by: tags.
+
+   An Acked-by: tag usually means that the acked person didn't write the
+   patch, nor is in the chain responsible for sending the patch to
+   kernel, but reviewed the patch and agreed that it was good.
+
+  A Tested-by: tag is a stronger variation of Acked-by. It means that the
+  person not only reviewed the patch, but also successfully tested it.
+
+   The better is that the patch author submitting his patches via git or hg
+   to add any acked-by/tested-by tags he received. When a patch is sent via
+   email, Patchwork tool will automatically include any such tags it receives
+   in reply together with the patch.
+
+   It is also common to receive acks after having a patch inserted at the
+   maintainer's trees. In this case, the ack will be added only at -git tree
+   used to send patches upstream.
+
+f) Another kernel's practice that is agreed to be good is that a
+   patchset should be reviewed/tested by other developers. So, a new
+   tag should be used by testers/reviewers. So, reviewers are welcome.
+   After reviewing a patchset, please send an e-mail indicating that, if
+   possible, with some additional data about the testing, with the tag:
+	Reviewed-by: My Name <myemail@mysite.com>
+   This is particularly important for Kernel to userspace ABI changes.
+
+g) If the patch also affects other parts of kernel (like ALSA
+   or i2c), it is required that, when submitting upstream, the patch
+   also goes to the maintainers of that subsystem. To do this, the
+   developer shall copy the interested parties.
+
+   When submitting a patch via e-mail, it is better to copy all interested
+   parties directly, by adding them as cc's to the email itself.
+
+   Please note that those changes generally require ack from the
+   other subsystem maintainers. So, the best practice is to first ask
+   for their acks, then commit to the development tree or send the
+   patch via email with their Acked-by: already included.
+
+   NOTE: at Mercurial tree, it used to be possible to use the cc: meta tag to
+   warn other users/mailing lists about a patch submission. However, this only
+   works when a patch is merged at the backport tree. So, it's usage is
+   considered obsolete nowadays.
+
+h) If the patch modifies the V4L or DVB API's (for example, modifying
+   include/linux/videodev2.h) file, then it must verify be verified that the
+   V4L2 specification document still builds. Of course, any changes you make
+   to the public V4L2 API must be documented anyway.
+
+   Currently, this can be done only with the Mercurial trees, by running:
+        make spec
+
+   Patches are welcome to migrate this functionality to upstream kernel DocBook
+   makefile rules.
+
+i) By submitting a patch to the subsystem maintainer, either via email
+   or via pull request, the patch author(s) are agreeing that the
+   submitted code will be added on Kernel, and that the submitted code
+   are being released as GPLv2. The author may grant additional licenses
+   to the submitted code (for example, using dual GPL/BSD) or GPLv2 or
+   later. If no specific clause are added, the added code will be
+   assumed as GPLv2 only.
+
+j) "Commit earlier and commit often". This is a common used rule at
+   Kernel. This means that a sooner submission of a patch will mean that
+   a review can happen sooner, and help the develop to address the
+   comments. This helps to reduce the life-cycle for having a changeset
+   committed at kernel at the proper time. It also means that the one
+   changeset should ideally address just one issue. So, mixing different
+   things at the same patch should be avoided.
+
+k) Sometimes, the maintainer may need to slightly modify patches you receive
+   in order to merge them, because the code is not exactly the same in your
+   tree and the submitters'. In order to save time, it may do the changes and
+   add a line before his SOB, as stated on Documentation/SubmittingPatches,
+   describing what he did to merge it. Something like:
+
+	Signed-off-by: Random J Developer <random@developer.example.org>
+	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
+	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
+
+2. Mercurial specific procedures
+   =============================
+
+a) With the -hg trees, some scripts are used to generate the patch. This is
+      done by running:
 
 	make commit
 
@@ -166,28 +884,15 @@ b) All commits at Mercurial trees should
    From: line shouldn't be omitted, since it will be used for the
    patch author when converting to -git.
 
-   Priority: meta-tag will be used as a hint to the subsystem maintainer, to help him to
-   identify if the patch is an improvement or board addition ("normal"), that will follow
-   the normal lifecycle of a patch (e.g. will be sent upstream on the next merge tree), if
-   the patch is a bug fix tree for a while without merging upstream ("low").
-
+   Priority: meta-tag will be used as a hint to the subsystem maintainer, to
+   help him to identify if the patch is an improvement or board addition
+   ("normal"), that will follow the normal lifecycle of a patch (e.g. will be
+   sent upstream on the next merge tree), if the patch is a bug fix tree for a
+   while without merging upstream ("low").
    Valid values for "Priority:" are "low", "normal" and "high".
 
-c) All patches are requested to have their coding style validated by using
-   script/checkpatch.pl. This check runs automatically by using "make commit". By default,
-   it will try to use the newest version of the script, between the kernel one and a copy
-   at v4l-dvb development tree.
-
-   It is always a good idea to use in-kernel version, since additional tests
-   are performed (like checking for the usage of deprecated API's that are
-   about to be removed).
-
-   It is possible to override the in-kernel checkpatch.pl location, by using
-   the CHECKPATCH shell environment var to something like:
-	CHECKPATCH="/usr/src/linux/scripts/checkpatch.pl"
-
-d) For "make commit" to work properly, the HGUSER shell environment var
-   should be defined (replacing the names at the left):
+b)For "make commit" to work properly, the HGUSER shell environment var should
+  be defined (replacing the names at the right):
 
 	HGUSER="My Name <myemail@mysite.com>"
 
@@ -213,78 +918,25 @@ d) For "make commit" to work properly, t
 
    It is strongly recommended to have those lines in .bashrc or .profile.
 
-e) All patches shall have a Developer's Certificate of Origin
-   version 1.1 in the commit log or the email description, signed by the
-   patch authors, as postulated in the Linux kernel source at:
+b) the CodingStyle compliance check on Mercurial trees are done when
+   "make check" is called. This happens also when "make commit" is done.
 
-	Documentation/SubmittingPatches
+   There's a copy of the kernel tool at the mercurial repository. However,
+   this copy may be outdated. So, by default, it will try to use the newest
+   version of the script, between the one found at the kernel tree and
+   its own copy.
 
-   This is done by adding Signed-off-by: fields to the commit message.
+   It is always a good idea to use in-kernel version, since additional tests
+   are performed when called from the kernel tree. Yet, those tests are
+   dependent of the kernel version, so, the results of checkpatch may not
+   reflect the latest rules/deprecated functions, if you're not using -git.
 
-   It is not acceptable to use fake signatures, e.g.:
+   It is possible to override the in-kernel checkpatch.pl location, by using
+   the CHECKPATCH shell environment var to something like:
+	CHECKPATCH="/usr/src/linux/scripts/checkpatch.pl"
 
-	Signed-off-by: Fake me <me@snakeoilcompany.com>
 
-   The email must be a valid one.
-   The author that is submitting the email should be at the button of
-   the author's signed-off-by (SOB) block. Other SOBs or Acked-by: will be
-   added at the bottom, marking that somebody else reviewed the patch.
-
-   Each person who is in the kernel patch submission chain (driver author
-   and/or driver maintainer, subsystem/core maintainers, etc) will
-   review each patch. If they agree, the patch will be added to their
-   trees and signed. Otherwise, they may comment on the patch, asking
-   for some review.
-
-f) Although not documented at kernel's Documentation/, a common kernel
-   practice is to use Acked-by: tag.
-
-   An Acked-by: tag usually means that the acked person didn't write the
-   patch, nor is in the chain responsible for sending the patch to
-   kernel, but tested or reviewed the patch and agreed that it was good.
-
-   A patch acked-by can be added at hg trees, if received by each tree
-   maintainer. It is also common to receive acks after having a patch
-   inserted at master repository. In this case, the ack will be added
-   only at -git tree.
-
-g) Another kernel's practice that is agreed to be good is that a
-   patchset should be reviewed/tested by other developers. So, a new
-   tag should be used by testers/reviewers. So, reviewers are welcome.
-   After reviewing a patchset, please send an e-mail indicating that, if
-   possible, with some additional data about the testing, with the tag:
-	Reviewed-by: My Name <myemail@mysite.com>
-   This is particularly important for Kernel to userspace ABI changes.
-
-h) If the patch also affects other parts of kernel (like ALSA
-   or i2c), it is required that, when submitting upstream, the patch
-   also goes to the maintainers of that subsystem. To do this, the
-   developer shall copy the interested parties.
-
-   At Mercurial tree, this can be handled automatically by the LinuxTV
-   scripts, by using the cc: meta tag, together with the Signed-off-by
-   lines. Something like:
-
-	CC: someotherkerneldeveloper@someplace
-	Signed-off-by: nowhere <nowhere@noplace.org>
-
-   This way, when a patch arrives Mercurial hg tree, a mailbomb script
-   will copy the proper interested parties.
-
-   When submitting a patch via e-mail, it is better to copy all interested
-   parties directly, by adding them as cc's to the email itself.
-
-   Please note that those changes generally require ack from the
-   other subsystem maintainers. So, the best practice is to first ask
-   for their acks, then commit to the development tree or send the
-   patch via email with their Acked-by: already included.
-
-i) If the patch modifies the include/linux/videodev2.h file, then you
-   must also run 'make spec' to verify that the V4L2 specification
-   document still builds. Of course, any changes you make to the public
-   V4L2 API must be documented anyway.
-
-j) Sometimes, mainstream changes affect the v4l-dvb tree, and must be
+c) Sometimes, mainstream changes affect the v4l-dvb tree, and must be
    backported to the v4l-dvb tree. This kind of commit to the Mercurial
    tree should follow the rules above and should also have the line:
 
@@ -292,7 +944,7 @@ j) Sometimes, mainstream changes affect 
 
    Patches with this line will not be submitted upstream.
 
-k) Sometimes it is necessary to introduce some testing code inside a
+d) Sometimes it is necessary to introduce some testing code inside a
    module or remove parts that are not yet finished. Also, compatibility
    tests may be required to provide backporting.
 
@@ -343,7 +995,7 @@ k) Sometimes it is necessary to introduc
    See the file v4l/scripts/gentree.pl for a more complete description
    of what kind of code will be kept and what kind will be removed.
 
-l) To import contributed stuff to a developer's, a script is provided.
+e) To import contributed stuff to a developer's, a script is provided.
    This allows an easy import of mbox-based patch emails.
    This is done with (called from the root tree directory):
 
@@ -360,46 +1012,20 @@ l) To import contributed stuff to a deve
     that can be applied/unapplied for testing. mailimport trusts on it to work,
     so, this extension should be enabled for mailimport script to work.
 
-m) By submitting a patch to the subsystem maintainer, either via email
-   or via pull request, the patch author(s) are agreeing that the
-   submitted code will be added on Kernel, and that the submitted code
-   are being released as GPLv2. The author may grant additional licenses
-   to the submitted code (for example, using dual GPL/BSD) or GPLv2 or
-   later. If no specific clause are added, the added code will be
-   assumed as GPLv2 only.
+3. Knowing about newer patches committed at the development repositories
+   =====================================================================
 
-n) "Commit earlier and commit often". This is a common used rule at
-   Kernel. This means that a sooner submission of a patch will mean that
-   a review can happen sooner, and help the develop to address the
-   comments. This helps to reduce the life-cycle for having a changeset
-   committed at kernel at the proper time. It also means that the one
-   changeset should ideally address just one issue. So, mixing different
-   things at the same patch should be avoided.
+There are patchbomb scripts at linuxtv.org that will send one copy of
+each patch applied patch to v4l-dvb.git and v4l-dvb trees to announce
+when a patch is received. This announcement goes to the linuxtv-commits mailing list, hosted on linuxtv.org.
 
-o) Sometimes, the maintainer may need to slightly modify patches you receive
-   in order to merge them, because the code is not exactly the same in your
-   tree and the submitters'. In order to save time, it may do the changes and
-   add a line before his SOB, as stated on Documentation/SubmittingPatches,
-   describing what he did to merge it. Something like:
+The Mercurial script also currently sends a copy of the patch to:
 
-	Signed-off-by: Random J Developer <random@developer.example.org>
-	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
-	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
+1) The patch author (as stated on the From: field in the patch comments);
 
-5. Knowing about newer patches committed at master hg repository
-   =============================================================
+2) The patch committer (the "user" at hg metadata);
 
-There's a patchbomb script at linuxtv.org that will send one copy of
-each patch applied to -hg tree to:
-
-1) The subscribers of the linuxtv-commits mailing list, hosted on
-   linuxtv.org;
-
-2) The patch author (as stated on the From: field in the patch comments);
-
-3) The patch committer (the "user" at hg metadata);
-
-4) All people with Signed-off-by:, Acked-by:, or CC: metadata clause
+3) All people with Signed-off-by:, Acked-by:, or CC: metadata clause
    in the patch's comment.
 
 If, for some reason, there's no "From:" metatag (or it is on the first
@@ -407,83 +1033,19 @@ line, instead of the second one), someti
 filling patch authorship wrongly. So people should take care to properly
 commit patches with "From:".
 
-6. Patch handling for kernel submission
-   ====================================
+It is recommended that the developers who submit a pull request via Mercurial
+to not touch on the submission tree, until he receives the notification email,
+since, even after being merged at -git, the backport maintainer will need to
+merge it.
 
-The subsystem maintainer, when preparing the kernel patches to be sent
-to mainstream (or to -mm series), uses some scripts and a manual
-procedure, based on a quilt-like procedure, where a patch series file is
-generated, and patches can be handled one by one. This means that -git
-patches can be properly fixed, when required, if not already sent to
-mainstream, to fulfill the best practices and resolve conflicts with
-other patches directly merged in mainstream.
-
-There's a delay between updating a patch at master and sending it to
-mainstream. During this period, it is possible to review a patch. The
-common situations are:
-
-1) If a patch at master tree receives a late Acked-by: or a
-Reviewed-by:, this can be added at -git tree;
-
-2) If somebody fully nacks a patch applied at -hg, A reverse patch
-can be applied at -hg, and the original patch can be removed -git;
-
-3) If somebody partially nacks a patch or sends a reviewing patch,
-the -git patch may be a result of the merger of the two patches.
-
-By merging both patches at -git will allow avoiding storing unnecessary
-patch history details at -git and at Mainstream.
-
-Those changes will require some manual sync between -git and -hg, it is
-better to avoid those circumstances.
-
-During the procedure of generating kernel patches, the maintainer uses
-to do a diff between the kernel tree and v4l-dvb Mercurial tree
-(without any backport code there). If there are discrepancies, a
-backport patch from mainstream to v4l-dvb is generally applied by the
-maintainer.
-
-8. Commit windows
-   ==============
-
-Kernel development occurs on some cycles, according with the following
-picture:
-
-------------   2 week    ------------     ---------------     ---------
-| 2.6.(x-1) | ---------> | 2.6.x-rc1 | .. | 2.6.x-rc[n] | --> | 2.6.x |
-------------             ------------     ---------------     ---------
-	      Submission
-		Window
-
-Once a kernel release is done (for example, 2.6.(x-1) version), a
-submission window for the newer features and board additions to the next
-kernel release should start. This means that the subsystem maintainer
-will use this window to submit the work that were done during 2.6.(x-2)
-time.
-
-For this to happen, patches for 2.6.x should be already at the subsystem
-maintainers -hg tree before the release of 2.6.(x-1), to allow proper
-testing.
-
-After the submission window, only patches with bug fixes should be sent
-to mainstream. This means that the subsystem maintainer will separate
-those patches from the submitted ones for kernel submission during -rc
-cycle. Generally, the stabilization process (rc kernels) takes from 5
-to 7 weeks.
-
-To make life easier for the subsystem maintainer, please add:
-[FIX] at the subject of the submitted emails or at the commit first
-lines.
-
-7. Patch submission from the community
+4. Patch submission from the community
    ===================================
 
 Patch submission is open to all the Free Software community. The general
 procedure to have a patch accepted in the v4l/dvb subsystem and in the
 kernel is the following:
 
-a. Post your patches to the corresponding mailing list for review and
-   test by other people, at:
+a. Post your patches to the mailing list for review and test by other people:
 	linux-media@vger.kernel.org
 
 	This mailing list doesn't require subscription, although
@@ -518,7 +1080,10 @@ g. If it is a newer driver (not yet in o
    please send the patch to the subsystem maintainer, C/C the proper
    mailing lists.
 
-8. Identifying regressions with Mercurial
+h. Prefer to submit your patches against git, especially if it contains fixes
+   that needs to go upstream.
+
+5. Identifying regressions with Mercurial
    ======================================
 
    The better way for you to identify regressions with Mercurial is to
@@ -586,7 +1151,22 @@ 8. Identifying regressions with Mercuria
       you are, you can do something like:
 	hg log -r `hg id|cut -d' ' -f 1`
 
-9. Creating a newer driver
+6. Identifying regressions with Git
+   ================================
+
+  A similar bisect procedure to identify broken patches exist on git, and it
+  is used not only by LinuxTV. So, it is very important that any applied
+  patch at the kernel don't break compilation, to avoid affecting the bisect
+  procedures.
+
+  There are several good texts explaining how to use bisect with git. Some
+  recommended procedures can be seen at:
+
+  http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#using-bisect
+  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
+
+
+7. Creating a newer driver
    =======================
 
    This quick HOWTO explains how to create a new driver using v4l-dvb
@@ -609,18 +1189,21 @@ 9. Creating a newer driver
 	    |   `-- dvb		<== DVB userspace API files
 	    `-- media		<== V4L internal API files
 
-   9.1 - simple drivers
-   ====================
+   When using Mercurial trees, an additional /linux prefix should be added
+   on all patches
+
+7.1. Simple drivers
+     ==============
 
    For very simple drivers that have only one .c and one .h file, the
    recommended way is not to create a newer directory, but keep the
    driver into an existing one.
 
    Assuming that the will be V4L+DVB, the better place for it to be is under
-   /linux/drivers/media/video. Assuming also that the newer driver
+   /drivers/media/video. Assuming also that the newer driver
    will be called as "newdevice", you need to do:
 
-   a) add at /linux/drivers/media/video/Kconfig something like:
+   a) add at /drivers/media/video/Kconfig something like:
 
 config VIDEO_NEWDEVICE
 	tristate "newdevice driver"
@@ -631,13 +1214,13 @@ config VIDEO_NEWDEVICE
 
 	  Say Y if you own such a device and want to use it.
 
-   b) add at /linux/drivers/media/video/Makefile something like:
+   b) add at /drivers/media/video/Makefile something like:
 
 obj-$(CONFIG_VIDEO_NEWDEVICE) += newdevice.o
 EXTRA_CFLAGS = -Idrivers/media/video
 
-   9.2 - bigger drivers
-   ====================
+7.2. Bigger drivers
+     ==============
 
    In this case, a driver will be splitted into several different source
    codes. Ideally, a source file should have up to 1000 source code
@@ -647,8 +1230,8 @@ EXTRA_CFLAGS = -Idrivers/media/video
    is called "newdevice", all that is needed to add the newer driver is:
 
    a) create a newer dir with your driver, for example:
-	/linux/drivers/media/video/newdevice
-   b) create /linux/drivers/media/video/newdevice/Kconfig with something
+	/drivers/media/video/newdevice
+   b) create /drivers/media/video/newdevice/Kconfig with something
       like:
 
 config VIDEO_NEWDEVICE
@@ -660,23 +1243,27 @@ config VIDEO_NEWDEVICE
 
 	  Say Y if you own such a device and want to use it.
 
-   c) create /linux/drivers/media/video/newdevice/Makefile with
+   c) create /drivers/media/video/newdevice/Makefile with
       something like:
 
 obj-$(CONFIG_VIDEO_NEWDEVICE) += newdevice.o
 EXTRA_CFLAGS = -Idrivers/media/video
 
-   d) Add your driver directory at /linux/drivers/media/Makefile:
+   d) Add your driver directory at /drivers/media/Makefile:
 
 obj-$(CONFIG_VIDEO_NEWDEVICE) += newdevice/
 
-   e) Add your driver directory at /linux/drivers/media/Kconfig:
+   e) Add your driver directory at /drivers/media/Kconfig:
 
 source "drivers/media/video/newdevice/Kconfig"
 
    After that, you will be able to use v4l-dvb Makefile to compile your
-   driver.  With:
+   driver.
 
-	make help
+   In order to test if your patch is properly compiling, you'll need to
+   enable its compilation by using make menuconfig/make qconfig/make xconfig.
+   After that, you can test if your patch compiles well with:
 
-   you'll see some useful syntax that may help your development.
+      make drivers/media        (on git)
+  or
+      make                      (on hg)


-- 

Cheers,
Mauro
