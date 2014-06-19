Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54638 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894AbaFSRX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 13:23:27 -0400
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 5E3BB21410
	for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 13:23:26 -0400 (EDT)
From: Ramakrishnan Muthukrishnan <ram@fastmail.in>
To: linux-media@vger.kernel.org
Cc: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [REVIEW PATCH 4/4] media: Documentation: remove V4L2_FL_USE_FH_PRIO flag.
Date: Thu, 19 Jun 2014 22:53:00 +0530
Message-Id: <1403198580-3126-5-git-send-email-ram@fastmail.in>
In-Reply-To: <1403198580-3126-1-git-send-email-ram@fastmail.in>
References: <1403198580-3126-1-git-send-email-ram@fastmail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>

Signed-off-by: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt       | 8 +-------
 Documentation/video4linux/v4l2-pci-skeleton.c      | 5 -----
 Documentation/zh_CN/video4linux/v4l2-framework.txt | 7 +------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 667a433..a11dff0 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -675,11 +675,6 @@ You should also set these fields:
   video_device is initialized you *do* know which parent PCI device to use and
   so you set dev_device to the correct PCI device.
 
-- flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the framework
-  handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you use struct
-  v4l2_fh. Eventually this flag will disappear once all drivers use the core
-  priority handling. But for now it has to be set explicitly.
-
 If you use v4l2_ioctl_ops, then you should set .unlocked_ioctl to video_ioctl2
 in your v4l2_file_operations struct.
 
@@ -909,8 +904,7 @@ struct v4l2_fh
 
 struct v4l2_fh provides a way to easily keep file handle specific data
 that is used by the V4L2 framework. New drivers must use struct v4l2_fh
-since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY)
-if the video_device flag V4L2_FL_USE_FH_PRIO is also set.
+since it is also used to implement priority handling (VIDIOC_G/S_PRIORITY).
 
 The users of v4l2_fh (in the V4L2 framework, not the driver) know
 whether a driver uses v4l2_fh as its file->private_data pointer by
diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 46904fe..006721e 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -883,11 +883,6 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	vdev->v4l2_dev = &skel->v4l2_dev;
 	/* Supported SDTV standards, if any */
 	vdev->tvnorms = SKEL_TVNORMS;
-	/* If this bit is set, then the v4l2 core will provide the support
-	 * for the VIDIOC_G/S_PRIORITY ioctls. This flag will eventually
-	 * go away once all drivers have been converted to use struct v4l2_fh.
-	 */
-	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
 	video_set_drvdata(vdev, skel);
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
diff --git a/Documentation/zh_CN/video4linux/v4l2-framework.txt b/Documentation/zh_CN/video4linux/v4l2-framework.txt
index 0da95db..2b828e6 100644
--- a/Documentation/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/zh_CN/video4linux/v4l2-framework.txt
@@ -580,11 +580,6 @@ release()回调必须被设置，且在最后一个 video_device 用户退出之
   v4l2_device 无法与特定的 PCI 设备关联，所有没有设置父设备。但当
   video_device 配置后，就知道使用哪个父 PCI 设备了。
 
-- flags：可选。如果你要让框架处理设置 VIDIOC_G/S_PRIORITY ioctls，
-  请设置 V4L2_FL_USE_FH_PRIO。这要求你使用 v4l2_fh 结构体。
-  一旦所有驱动使用了核心的优先级处理，最终这个标志将消失。但现在它
-  必须被显式设置。
-
 如果你使用 v4l2_ioctl_ops，则应该在 v4l2_file_operations 结构体中
 设置 .unlocked_ioctl 指向 video_ioctl2。
 
@@ -789,7 +784,7 @@ v4l2_fh 结构体
 -------------
 
 v4l2_fh 结构体提供一个保存用于 V4L2 框架的文件句柄特定数据的简单方法。
-如果 video_device 的 flag 设置了 V4L2_FL_USE_FH_PRIO 标志，新驱动
+如果 video_device 标志，新驱动
 必须使用 v4l2_fh 结构体，因为它也用于实现优先级处理（VIDIOC_G/S_PRIORITY）。
 
 v4l2_fh 的用户（位于 V4l2 框架中，并非驱动）可通过测试
-- 
2.0.0

