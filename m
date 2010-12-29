Return-path: <mchehab@gaivota>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3728 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0L2Vnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 16:43:31 -0500
Received: from localhost (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTLhTVR048375
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 22:43:29 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <7bc271da1df7c09f57e30c5aad00e24d3e2245bc.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
References: <cover.1293657717.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 22:43:28 +0100
Subject: [PATCH 10/10] [RFC] v4l2-framework.txt: document new v4l2_device release() callback
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/v4l2-framework.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 7739705..86ccdfa 100644
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
1.6.4.2

