Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34592 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab2CTMAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 08:00:20 -0400
Received: by eaaq12 with SMTP id q12so2960227eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 05:00:18 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add uvc_driver.c to no_atomic_include backport patch
Date: Tue, 20 Mar 2012 13:00:10 +0100
Message-Id: <1332244810-14881-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request:

http://patchwork.linuxtv.org/patch/10122/

and in particular this patch:

Andrew Morton (1):
      uvcvideo: uvc_driver.c: use linux/atomic.h

includes the header file linux/atomic.h in file uvc_driver.c, breaking the
media_build tree compilation on all kernels up to 3.0.

To fix the problem, let's remove the included file adding a new chunk for
uvc_driver.c in the existing no_atomic_include.patch backport patch.

Tested with kernel 2.6.32.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/no_atomic_include.patch |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/backports/no_atomic_include.patch b/backports/no_atomic_include.patch
index c14c55d..d063734 100644
--- a/backports/no_atomic_include.patch
+++ b/backports/no_atomic_include.patch
@@ -16,6 +16,12 @@ index 10c2364..74587fa 100644
 +++ b/drivers/media/video/uvc/uvc_ctrl.c
 @@ -23 +22,0 @@
 -#include <linux/atomic.h>
+diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
+index c029535..d143339 100644
+--- a/drivers/media/video/uvc/uvc_driver.c
++++ b/drivers/media/video/uvc/uvc_driver.c
+@@ -26 +25,0 @@
+-#include <linux/atomic.h>
 diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
 index 677691c..a123a2f 100644
 --- a/drivers/media/video/uvc/uvc_queue.c
-- 
1.7.0.4

