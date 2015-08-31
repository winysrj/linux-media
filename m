Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35223 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbHaL5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:57:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NTY00FKH3VW9860@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Aug 2015 12:57:32 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, b.zolnierkie@samsung.com,
	m.szyprowski@samsung.com, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] v4l2-compat-ioctl32: fix alignment for ARM64
Date: Mon, 31 Aug 2015 13:56:15 +0200
Message-id: <1441022175-19725-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alignment/padding rules on AMD64 and ARM64 differs. To allow properly match
compatible ioctls on ARM64 kernels without breaking AMD64 some fields
should be aligned using compat_s64 type and in one case struct should be
unpacked.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Hans,

I have tested following structures:
struct v4l2_format32
struct v4l2_buffer32
struct v4l2_framebuffer32
struct v4l2_standard32
struct v4l2_input32
struct v4l2_edid32
struct v4l2_ext_controls32
struct v4l2_ext_control32
struct v4l2_event32
struct v4l2_create_buffers32

Following structures should be fixed:
v4l2_standard32 - .id alignment
v4l2_input32 - whole struct padding
v4l2_event32 - .data alignment

I hope this patch does it correctly.

Regards
Andrzej
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af63543..d309d270 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -266,7 +266,7 @@ static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_
 
 struct v4l2_standard32 {
 	__u32		     index;
-	__u32		     id[2]; /* __u64 would get the alignment wrong */
+	compat_u64	     id;
 	__u8		     name[24];
 	struct v4l2_fract    frameperiod; /* Frames, not fields */
 	__u32		     framelines;
@@ -286,7 +286,7 @@ static int put_v4l2_standard32(struct v4l2_standard *kp, struct v4l2_standard32
 {
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_standard32)) ||
 		put_user(kp->index, &up->index) ||
-		copy_to_user(up->id, &kp->id, sizeof(__u64)) ||
+		put_user(kp->id, &up->id) ||
 		copy_to_user(up->name, kp->name, 24) ||
 		copy_to_user(&up->frameperiod, &kp->frameperiod, sizeof(kp->frameperiod)) ||
 		put_user(kp->framelines, &up->framelines) ||
@@ -587,10 +587,10 @@ struct v4l2_input32 {
 	__u32	     type;		/*  Type of input */
 	__u32	     audioset;		/*  Associated audios (bitfield) */
 	__u32        tuner;             /*  Associated tuner */
-	v4l2_std_id  std;
+	compat_s64   std;
 	__u32	     status;
 	__u32	     reserved[4];
-} __attribute__ ((packed));
+};
 
 /* The 64-bit v4l2_input struct has extra padding at the end of the struct.
    Otherwise it is identical to the 32-bit version. */
@@ -738,6 +738,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 struct v4l2_event32 {
 	__u32				type;
 	union {
+		compat_s64		value64;
 		__u8			data[64];
 	} u;
 	__u32				pending;
-- 
1.9.1

