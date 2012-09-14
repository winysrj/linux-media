Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52458 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2INK60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:26 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqC2013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:58:00 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 31/31] Add vfl_dir field documentation.
Date: Fri, 14 Sep 2012 12:57:46 +0200
Message-Id: <77a2489dac81a471ef53aeffa172b11f676ae3c7.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 89318be..20f1c05 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -583,11 +583,18 @@ You should also set these fields:
 
 - name: set to something descriptive and unique.
 
+- vfl_dir: set to VFL_DIR_TX for output devices and VFL_DIR_M2M for mem2mem
+  (codec) devices.
+
 - fops: set to the v4l2_file_operations struct.
 
 - ioctl_ops: if you use the v4l2_ioctl_ops to simplify ioctl maintenance
   (highly recommended to use this and it might become compulsory in the
-  future!), then set this to your v4l2_ioctl_ops struct.
+  future!), then set this to your v4l2_ioctl_ops struct. The vfl_type and
+  vfl_dir fields are used to disable ops that do not match the type/dir
+  combination. E.g. VBI ops are disabled for non-VBI nodes, and output ops
+  are disabled for a capture device. This makes it possible to provide
+  just one v4l2_ioctl_ops struct for both vbi and video nodes.
 
 - lock: leave to NULL if you want to do all the locking in the driver.
   Otherwise you give it a pointer to a struct mutex_lock and before the
-- 
1.7.10.4

