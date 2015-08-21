Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36315 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbbHUNTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 09:19:38 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 03/10] media/v4l2-compat-ioctl32: Simple stylechecks
Date: Fri, 21 Aug 2015 15:19:22 +0200
Message-Id: <1440163169-18047-4-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The next patches on the serie need this modifications to pass clean
checkpath.pl.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af635430524e..5416806609a8 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -609,11 +609,11 @@ static inline int put_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __
 }
 
 struct v4l2_ext_controls32 {
-       __u32 ctrl_class;
-       __u32 count;
-       __u32 error_idx;
-       __u32 reserved[2];
-       compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
+	__u32 ctrl_class;
+	__u32 count;
+	__u32 error_idx;
+	__u32 reserved[2];
+	compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
 };
 
 struct v4l2_ext_control32 {
@@ -655,7 +655,8 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 		get_user(kp->ctrl_class, &up->ctrl_class) ||
 		get_user(kp->count, &up->count) ||
 		get_user(kp->error_idx, &up->error_idx) ||
-		copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+		copy_from_user(kp->reserved, up->reserved,
+			       sizeof(kp->reserved)))
 			return -EFAULT;
 	n = kp->count;
 	if (n == 0) {
-- 
2.5.0

