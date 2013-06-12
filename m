Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4684 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3FLPCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 12/12] v4l2-framework: update documentation
Date: Wed, 12 Jun 2013 17:01:02 +0200
Message-Id: <1371049262-5799-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

'parent' was renamed to 'dev_parent'. Clarify how/when this should be used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 24353ec..3944d5c 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -574,9 +574,13 @@ of the video device exits.
 The default video_device_release() callback just calls kfree to free the
 allocated memory.
 
+There is also a video_device_release_empty() function that does nothing
+(is empty) and can be used if the struct is embedded and there is nothing
+to do when it is released.
+
 You should also set these fields:
 
-- v4l2_dev: set to the v4l2_device parent device.
+- v4l2_dev: must be set to the v4l2_device parent device.
 
 - name: set to something descriptive and unique.
 
@@ -613,15 +617,16 @@ You should also set these fields:
   If you want to have a separate priority state per (group of) device node(s),
   then you can point it to your own struct v4l2_prio_state.
 
-- parent: you only set this if v4l2_device was registered with NULL as
+- dev_parent: you only set this if v4l2_device was registered with NULL as
   the parent device struct. This only happens in cases where one hardware
   device has multiple PCI devices that all share the same v4l2_device core.
 
   The cx88 driver is an example of this: one core v4l2_device struct, but
-  it is used by both an raw video PCI device (cx8800) and a MPEG PCI device
-  (cx8802). Since the v4l2_device cannot be associated with a particular
-  PCI device it is setup without a parent device. But when the struct
-  video_device is setup you do know which parent PCI device to use.
+  it is used by both a raw video PCI device (cx8800) and a MPEG PCI device
+  (cx8802). Since the v4l2_device cannot be associated with a two PCI devices
+  at the same time it is setup without a parent device. But when the struct
+  video_device is initialized you *do* know which parent PCI device to use and
+  so you set dev_device to the correct PCI device.
 
 - flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the framework
   handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you use struct
-- 
1.7.10.4

