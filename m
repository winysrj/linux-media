Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3869 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1ACNyu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 08:54:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [RFC PATCH 2/4] v4l2-framework.txt: document new v4l2_device release() callback
Date: Mon,  3 Jan 2011 14:54:30 +0100
Message-Id: <4e8311a75e739d7f757985a1099eb5510c5c57ef.1294062751.git.hverkuil@xs4all.nl>
In-Reply-To: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
References: <1294062872-8312-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
References: <adec9ffda2cd47023cde5d0beda01fc84bd867f6.1294062751.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-framework.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f22f35c..a6003d7 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -167,6 +167,21 @@ static int __devinit drv_probe(struct pci_dev *pdev,
 	state->instance = atomic_inc_return(&drv_instance) - 1;
 }
 
+If you have multiple device nodes then it can be difficult to know when it is
+safe to unregister v4l2_device. For this purpose v4l2_device has refcounting
+support. The refcount is increased whenever video_register_device is called and
+it is decreased whenever that device node is released. When the refcount reaches
+zero, then the v4l2_device release() callback is called. You can do your final
+cleanup there.
+
+If other device nodes (e.g. ALSA) are created, then you can increase and
+decrease the refcount manually as well by calling:
+
+void v4l2_device_get(struct v4l2_device *v4l2_dev);
+
+or:
+
+int v4l2_device_put(struct v4l2_device *v4l2_dev);
 
 struct v4l2_subdev
 ------------------
-- 
1.7.0.4

