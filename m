Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47424 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752521AbdLHR50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 12:57:26 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Fixed include compiler-gcc.h directly error
Date: Fri,  8 Dec 2017 18:57:19 +0100
Message-Id: <1512755839-6716-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The type definitions have been splitting from compiler.h into
compiler_types.h. This requires to check for the new and the old
include guard in compiler-gcc.h.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt          |  3 +++
 backports/v4.14_compiler_h.patch | 11 +++++++++++
 2 files changed, 14 insertions(+)
 create mode 100644 backports/v4.14_compiler_h.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 618c4e8..78dfb9c 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -26,6 +26,9 @@ add pr_fmt.patch
 add debug.patch
 add drx39xxj.patch
 
+[4.14.255]
+add v4.14_compiler_h.patch
+
 [4.12.255]
 add v4.12_revert_solo6x10_copykerneluser.patch
 
diff --git a/backports/v4.14_compiler_h.patch b/backports/v4.14_compiler_h.patch
new file mode 100644
index 0000000..3faa85f
--- /dev/null
+++ b/backports/v4.14_compiler_h.patch
@@ -0,0 +1,11 @@
+diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
+index 2272ded..744334e 100644
+--- a/include/linux/compiler-gcc.h
++++ b/include/linux/compiler-gcc.h
+@@ -1,5 +1,5 @@
+ /* SPDX-License-Identifier: GPL-2.0 */
+-#ifndef __LINUX_COMPILER_TYPES_H
++#if (!defined(__LINUX_COMPILER_TYPES_H) && !defined (__LINUX_COMPILER_H))
+ #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+ #endif
+ 
-- 
2.7.4
