Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2804 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3EZNdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:33:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=2024/24=5D=20v4l2-framework=3A=20replace=20g=5Fchip=5Fident=20by=20g=5Fstd=20in=20the=20examples=2E?=
Date: Sun, 26 May 2013 15:27:19 +0200
Message-Id: <1369574839-6687-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The framework documentation used the g_chip_ident op as an example. This
op has been removed, so replace its use in the examples by the g_std op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt       |   13 ++++++-------
 Documentation/zh_CN/video4linux/v4l2-framework.txt |   13 ++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index a300b28..24353ec 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -246,7 +246,6 @@ may be NULL if the subdev driver does not support anything from that category.
 It looks like this:
 
 struct v4l2_subdev_core_ops {
-	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	...
@@ -346,24 +345,24 @@ Afterwards the subdev module can be unloaded and sd->dev == NULL.
 
 You can call an ops function either directly:
 
-	err = sd->ops->core->g_chip_ident(sd, &chip);
+	err = sd->ops->core->g_std(sd, &norm);
 
 but it is better and easier to use this macro:
 
-	err = v4l2_subdev_call(sd, core, g_chip_ident, &chip);
+	err = v4l2_subdev_call(sd, core, g_std, &norm);
 
 The macro will to the right NULL pointer checks and returns -ENODEV if subdev
-is NULL, -ENOIOCTLCMD if either subdev->core or subdev->core->g_chip_ident is
-NULL, or the actual result of the subdev->ops->core->g_chip_ident ops.
+is NULL, -ENOIOCTLCMD if either subdev->core or subdev->core->g_std is
+NULL, or the actual result of the subdev->ops->core->g_std ops.
 
 It is also possible to call all or a subset of the sub-devices:
 
-	v4l2_device_call_all(v4l2_dev, 0, core, g_chip_ident, &chip);
+	v4l2_device_call_all(v4l2_dev, 0, core, g_std, &norm);
 
 Any subdev that does not support this ops is skipped and error results are
 ignored. If you want to check for errors use this:
 
-	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_chip_ident, &chip);
+	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_std, &norm);
 
 Any error except -ENOIOCTLCMD will exit the loop with that error. If no
 errors (except -ENOIOCTLCMD) occurred, then 0 is returned.
diff --git a/Documentation/zh_CN/video4linux/v4l2-framework.txt b/Documentation/zh_CN/video4linux/v4l2-framework.txt
index 44c1d93..0da95db 100644
--- a/Documentation/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/zh_CN/video4linux/v4l2-framework.txt
@@ -247,7 +247,6 @@ i2c_client 结构体，i2c_set_clientdata() 函数可用于保存一个 v4l2_sub
 这些结构体定义如下：
 
 struct v4l2_subdev_core_ops {
-	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	...
@@ -337,24 +336,24 @@ subdev->dev 域就指向了 v4l2_device。
 
 注册之设备后，可通过以下方式直接调用其操作函数：
 
-	err = sd->ops->core->g_chip_ident(sd, &chip);
+	err = sd->ops->core->g_std(sd, &norm);
 
 但使用如下宏会比较容易且合适：
 
-	err = v4l2_subdev_call(sd, core, g_chip_ident, &chip);
+	err = v4l2_subdev_call(sd, core, g_std, &norm);
 
 这个宏将会做 NULL 指针检查，如果 subdev 为 NULL，则返回-ENODEV；如果
-subdev->core 或 subdev->core->g_chip_ident 为 NULL，则返回 -ENOIOCTLCMD；
-否则将返回 subdev->ops->core->g_chip_ident ops 调用的实际结果。
+subdev->core 或 subdev->core->g_std 为 NULL，则返回 -ENOIOCTLCMD；
+否则将返回 subdev->ops->core->g_std ops 调用的实际结果。
 
 有时也可能同时调用所有或一系列子设备的某个操作函数：
 
-	v4l2_device_call_all(v4l2_dev, 0, core, g_chip_ident, &chip);
+	v4l2_device_call_all(v4l2_dev, 0, core, g_std, &norm);
 
 任何不支持此操作的子设备都会被跳过，并忽略错误返回值。但如果你需要
 检查出错码，则可使用如下函数：
 
-	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_chip_ident, &chip);
+	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_std, &norm);
 
 除 -ENOIOCTLCMD 外的任何错误都会跳出循环并返回错误值。如果（除 -ENOIOCTLCMD
 外）没有错误发生，则返回 0。
-- 
1.7.10.4

