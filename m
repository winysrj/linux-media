Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13370 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0LVNkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 08:40:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDU00CMG0O2I250@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU0008U0O10G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Date: Wed, 22 Dec 2010 14:40:34 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 04/13] v4l: fix copy sizes in compat32 for ext controls
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293025239-9977-5-git-send-email-m.szyprowski@samsung.com>
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index dd585f1..7b5c645 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -813,12 +813,13 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_READ, ucontrols, n * sizeof(struct v4l2_ext_control)))
+	if (!access_ok(VERIFY_READ, ucontrols,
+			n * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
 	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
 	kp->controls = kcontrols;
 	while (--n >= 0) {
-		if (copy_in_user(kcontrols, ucontrols, sizeof(*kcontrols)))
+		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
 			return -EFAULT;
 		if (ctrl_is_pointer(kcontrols->id)) {
 			void __user *s;
@@ -854,7 +855,8 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	if (get_user(p, &up->controls))
 		return -EFAULT;
 	ucontrols = compat_ptr(p);
-	if (!access_ok(VERIFY_WRITE, ucontrols, n * sizeof(struct v4l2_ext_control)))
+	if (!access_ok(VERIFY_WRITE, ucontrols,
+			n * sizeof(struct v4l2_ext_control32)))
 		return -EFAULT;
 
 	while (--n >= 0) {
-- 
1.7.1.569.g6f426

