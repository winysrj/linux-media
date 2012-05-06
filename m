Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4087 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2EFM2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/17] v4l2-framework.txt: add paragraph on driver locking and the control framework.
Date: Sun,  6 May 2012 14:28:16 +0200
Message-Id: <9b573dacb94a613c3ab807e8f483c527a75af601.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 4a313d8..2d7dd86 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -658,6 +658,14 @@ wait_prepare and wait_finish.
 The implementation of a hotplug disconnect should also take the lock before
 calling v4l2_device_disconnect.
 
+Note that if you do your own locking and want to use the control framework,
+then you have to implement the control callbacks yourself so you can take
+your own lock before calling into the control framework. Otherwise your lock
+won't be held when the v4l2_ctrl_ops are called. You can't take your lock
+there because a driver can also call e.g. v4l2_ctrl_s_ctrl with your lock
+already held, which in turn will call the s_ctrl op, which will attempt to
+take your lock again: deadlock!
+
 video_device registration
 -------------------------
 
-- 
1.7.10

