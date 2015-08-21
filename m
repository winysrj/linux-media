Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62496 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbHUJue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:50:34 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NTF00JEYFC79H90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Aug 2015 10:50:32 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: [RFC PATCH] v4l2-compat-ioctl32: fix struct v4l2_event32 alignment
Date: Fri, 21 Aug 2015 11:50:09 +0200
Message-id: <1440150609-23312-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Union v4l2_event::u is aligned to 8 bytes on arm32. On arm64 v4l2_event32::u
is aligned to 4 bytes. As a result structures v4l2_event and v4l2_event32 have
different sizes and VIDOC_DQEVENT ioctl does not work from arm32 apps running
on arm64 kernel. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Hans,

It seems there is problem with VIDIOC_DQEVENT called from arm32 apps on arm64
kernel. After tracking down the issue it seems v4l2_event32 on arm64 have
different field alignment/size than v4l2_event on arm32. The patch fixes it.
But i guess it can break ABI on other architectures. Simple tests shows:

i386:
sizeof(struct v4l2_event)=0x78
offsetof(struct v4l2_event::u)=0x4

amd64:
sizeof(struct v4l2_event)=0x88
offsetof(struct v4l2_event::u)=0x8

arm:
sizeof(struct v4l2_event)=0x80
offsetof(struct v4l2_event::u)=0x8

arm64:
sizeof(struct v4l2_event)=0x88
offsetof(struct v4l2_event::u)=0x8

Any advices how to fix it in arch compatible way?

Regards
Andrzej
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af63543..a4a1856 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -739,7 +739,7 @@ struct v4l2_event32 {
 	__u32				type;
 	union {
 		__u8			data[64];
-	} u;
+	} u __attribute__((aligned(8)));
 	__u32				pending;
 	__u32				sequence;
 	struct compat_timespec		timestamp;
-- 
1.9.1

