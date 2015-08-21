Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10878 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbHUMEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 08:04:05 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NTF00784LIQSR10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Aug 2015 13:04:02 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] v4l2-compat-ioctl32: fix struct v4l2_event32 alignment
Date: Fri, 21 Aug 2015 14:03:50 +0200
Message-id: <1440158630-29620-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <55D70787.2080508@xs4all.nl>
References: <55D70787.2080508@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Union v4l2_event::u is aligned to 8 bytes on arm32. On arm64 v4l2_event32::u
is aligned to 4 bytes. As a result structures v4l2_event and v4l2_event32 have
different sizes and VIDOC_DQEVENT ioctl does not work from arm32 apps running
on arm64 kernel. The patch fixes it. Using compat_s64 allows to retain 4 bytes
alignment on x86 architecture.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Hans,

Tested successfully on arm32 app / arm64 kernel.
Thanks for help.

Regards
Andrzej
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index af63543..52afffe 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
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

