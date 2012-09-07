Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3129 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2IGN3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 28/28] Add vfl_dir field documentation.
Date: Fri,  7 Sep 2012 15:29:28 +0200
Message-Id: <73a5869ff6f5b11437f0938458e99e0532e70757.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

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

