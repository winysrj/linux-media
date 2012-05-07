Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604Ab2EGTUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 03/23] v4l2-framework.txt: add paragraph on driver locking and the control framework.
Date: Mon,  7 May 2012 21:01:14 +0200
Message-Id: <1336417294-4566-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/video4linux/v4l2-framework.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index c2e6591..33ac07a 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -661,6 +661,14 @@ wait_prepare and wait_finish.
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

