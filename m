Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:63906 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbcDYNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 09:19:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.com>
Cc: Nicolas Pitre <nico@linaro.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH 3/3] samples: v4l: from Documentation to samples directory
Date: Mon, 25 Apr 2016 15:17:21 +0200
Message-Id: <1461590265-1397577-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1461590265-1397577-1-git-send-email-arnd@arndb.de>
References: <1461590265-1397577-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new autoksyms support, we can run into a situation where
the v4l pci skeleton module is the only one using some exported
symbols that get dropped because they are never referenced by
the kernel otherwise, causing a build problem:

ERROR: "vb2_dma_contig_memops" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_dma_contig_init_ctx_attrs" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_match_dv_timings" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_find_dv_timings_cap" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_valid_dv_timings" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "v4l2_enum_dv_timings_cap" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!
ERROR: "vb2_dma_contig_cleanup_ctx" [Documentation/video4linux/v4l2-pci-skeleton.ko] undefined!

Specifically, we do look in the samples directory for users of
symbols, but not the Documentation directory.

This solves the build problem by moving the connector sample into
the same directory as the other samples.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 23121ca2b56b ("kbuild: create/adjust generated/autoksyms.h")
---
 Documentation/Makefile                                         | 3 +--
 Documentation/video4linux/v4l2-framework.txt                   | 2 +-
 samples/Makefile                                               | 2 +-
 {Documentation/video4linux => samples/v4l}/Makefile            | 0
 {Documentation/video4linux => samples/v4l}/v4l2-pci-skeleton.c | 0
 5 files changed, 3 insertions(+), 4 deletions(-)
 rename {Documentation/video4linux => samples/v4l}/Makefile (100%)
 rename {Documentation/video4linux => samples/v4l}/v4l2-pci-skeleton.c (100%)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 13b5ae1b87aa..de955e151af8 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,4 +1,3 @@
 subdir-y := accounting auxdisplay blackfin \
 	filesystems filesystems ia64 laptops mic misc-devices \
-	networking pcmcia prctl ptp timers vDSO video4linux \
-	watchdog
+	networking pcmcia prctl ptp timers vDSO watchdog
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index fa41608ab2b4..cbefc7902f5f 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -35,7 +35,7 @@ need and this same framework should make it much easier to refactor
 common code into utility functions shared by all drivers.
 
 A good example to look at as a reference is the v4l2-pci-skeleton.c
-source that is available in this directory. It is a skeleton driver for
+source that is available in samples/v4l/. It is a skeleton driver for
 a PCI capture card, and demonstrates how to use the V4L2 driver
 framework. It can be used as a template for real PCI video capture driver.
 
diff --git a/samples/Makefile b/samples/Makefile
index 594ef7d9fa2a..2e3b523d7097 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -2,4 +2,4 @@
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
-			   configfs/ connector/
+			   configfs/ connector/ v4l/
diff --git a/Documentation/video4linux/Makefile b/samples/v4l/Makefile
similarity index 100%
rename from Documentation/video4linux/Makefile
rename to samples/v4l/Makefile
diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
similarity index 100%
rename from Documentation/video4linux/v4l2-pci-skeleton.c
rename to samples/v4l/v4l2-pci-skeleton.c
-- 
2.7.0

