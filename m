Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34935 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2EHInA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 04:43:00 -0400
Received: by wgbds11 with SMTP id ds11so347239wgb.1
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 01:42:59 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix backport patches removing et61x251 hunks
Date: Tue,  8 May 2012 10:42:49 +0200
Message-Id: <1336466569-32529-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The old et61x251 driver has been removed:

http://git.linuxtv.org/media_tree.git/commit/04ef052419ac61f28c6b7eafbe5d8e82c02bbee2

so let's delete the related hunks from the media_build backport patches.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/api_version.patch |    6 ------
 backports/pr_fmt.patch      |   24 ------------------------
 2 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/backports/api_version.patch b/backports/api_version.patch
index 147221c..9bd9348 100644
--- a/backports/api_version.patch
+++ b/backports/api_version.patch
@@ -1,9 +1,3 @@
-diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
---- a/drivers/media/video/et61x251/et61x251_core.c
-+++ b/drivers/media/video/et61x251/et61x251_core.c
-@@ -1582,1 +1582,1 @@ et61x251_vidioc_querycap(struct et61x251
--		.version = LINUX_VERSION_CODE,
-+		.version = V4L2_VERSION,
 diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
 --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
 +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
diff --git a/backports/pr_fmt.patch b/backports/pr_fmt.patch
index e6db18e..5561d6f 100644
--- a/backports/pr_fmt.patch
+++ b/backports/pr_fmt.patch
@@ -322,30 +322,6 @@ index ffd8bc7..c38d97d 100644
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
  
  #include "cx25821-video.h"
-diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
-index 5539f09..8cdf5b6 100644
---- a/drivers/media/video/et61x251/et61x251_core.c
-+++ b/drivers/media/video/et61x251/et61x251_core.c
-@@ -18,6 +18,7 @@
-  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
-  ***************************************************************************/
- 
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
- 
- #include <linux/version.h>
-diff --git a/drivers/media/video/et61x251/et61x251_tas5130d1b.c b/drivers/media/video/et61x251/et61x251_tas5130d1b.c
-index ced2e16..3977c93 100644
---- a/drivers/media/video/et61x251/et61x251_tas5130d1b.c
-+++ b/drivers/media/video/et61x251/et61x251_tas5130d1b.c
-@@ -19,6 +19,7 @@
-  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.               *
-  ***************************************************************************/
- 
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
- 
- #include "et61x251_sensor.h"
 diff --git a/drivers/media/video/gspca/benq.c b/drivers/media/video/gspca/benq.c
 index 9769f17..e9b1052 100644
 --- a/drivers/media/video/gspca/benq.c
-- 
1.7.0.4

