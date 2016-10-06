Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:54307 "EHLO
        resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936217AbcJFX6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 19:58:06 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: corbet@lwn.net, broonie@kernel.org, tglx@linutronix.de,
        mmarek@suse.com, mchehab@kernel.org, davem@davemloft.net,
        ecree@solarflare.com, arnd@arndb.de, j.anaszewski@samsung.com,
        akpm@linux-foundation.org, keescook@chromium.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, dan.j.williams@intel.com,
        aryabinin@virtuozzo.com, tj@kernel.org, jpoimboe@redhat.com,
        nikolay@cumulusnetworks.com, dvyukov@google.com, olof@lixom.net,
        nab@linux-iscsi.org, rostedt@goodmis.org, hans.verkuil@cisco.com,
        valentinrothberg@gmail.com, paul.gortmaker@windriver.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] Doc: update 00-INDEX files to reflect the runnable code move
Date: Thu,  6 Oct 2016 17:48:52 -0600
Message-Id: <1f6bf489083cdf1173ab165efa921878f6038d8e.1475792539.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1475792538.git.shuahkh@osg.samsung.com>
References: <cover.1475792538.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1475792538.git.shuahkh@osg.samsung.com>
References: <cover.1475792538.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update 00-INDEX files with the current file list to reflect the runnable
code move.

Acked-by: Michal Marek <mmarek@suse.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 Documentation/00-INDEX             | 3 ++-
 Documentation/arm/00-INDEX         | 2 --
 Documentation/filesystems/00-INDEX | 2 --
 Documentation/networking/00-INDEX  | 2 --
 Documentation/spi/00-INDEX         | 2 --
 Documentation/timers/00-INDEX      | 4 ----
 6 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index cb9a6c6..3acc4f1 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -46,7 +46,8 @@ IRQ.txt
 Intel-IOMMU.txt
 	- basic info on the Intel IOMMU virtualization support.
 Makefile
-	- some files in Documentation dir are actually sample code to build
+	- This file does nothing. Removing it breaks make htmldocs and
+	  make distclean.
 ManagementStyle
 	- how to (attempt to) manage kernel hackers.
 RCU/
diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index dea011c..b6e69fd 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -8,8 +8,6 @@ Interrupts
 	- ARM Interrupt subsystem documentation
 IXP4xx
 	- Intel IXP4xx Network processor.
-Makefile
-	- Build sourcefiles as part of the Documentation-build for arm
 Netwinder
 	- Netwinder specific documentation
 Porting
diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 9922939..f66e748 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -2,8 +2,6 @@
 	- this file (info on some of the filesystems supported by linux).
 Locking
 	- info on locking rules as they pertain to Linux VFS.
-Makefile
-	- Makefile for building the filsystems-part of DocBook.
 9p.txt
 	- 9p (v9fs) is an implementation of the Plan 9 remote fs protocol.
 adfs.txt
diff --git a/Documentation/networking/00-INDEX b/Documentation/networking/00-INDEX
index 415154a..98f3d4b 100644
--- a/Documentation/networking/00-INDEX
+++ b/Documentation/networking/00-INDEX
@@ -10,8 +10,6 @@ LICENSE.qlge
 	- GPLv2 for QLogic Linux qlge NIC Driver
 LICENSE.qlcnic
 	- GPLv2 for QLogic Linux qlcnic NIC Driver
-Makefile
-	- Makefile for docsrc.
 PLIP.txt
 	- PLIP: The Parallel Line Internet Protocol device driver
 README.ipw2100
diff --git a/Documentation/spi/00-INDEX b/Documentation/spi/00-INDEX
index 4644bf0..8e4bb17 100644
--- a/Documentation/spi/00-INDEX
+++ b/Documentation/spi/00-INDEX
@@ -1,7 +1,5 @@
 00-INDEX
 	- this file.
-Makefile
-	- Makefile for the example sourcefiles.
 butterfly
 	- AVR Butterfly SPI driver overview and pin configuration.
 ep93xx_spi
diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
index ee212a2..3be05fe 100644
--- a/Documentation/timers/00-INDEX
+++ b/Documentation/timers/00-INDEX
@@ -4,12 +4,8 @@ highres.txt
 	- High resolution timers and dynamic ticks design notes
 hpet.txt
 	- High Precision Event Timer Driver for Linux
-hpet_example.c
-	- sample hpet timer test program
 hrtimers.txt
 	- subsystem for high-resolution kernel timers
-Makefile
-	- Build and link hpet_example
 NO_HZ.txt
 	- Summary of the different methods for the scheduler clock-interrupts management.
 timekeeping.txt
-- 
2.7.4

