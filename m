Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13370 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0LVNk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 08:40:58 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDU00CMG0O2I250@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU000920O20G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Date: Wed, 22 Dec 2010 14:40:36 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 06/13] v4l: v4l2-ioctl: Fix conversion between multiplane and
 singleplane buffers
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293025239-9977-7-git-send-email-m.szyprowski@samsung.com>
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Fix copying unions and preserve pointer to the plane array
in buf_sp_to_mp() and buf_mp_to_sp().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index fee8b94..60793d6 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -762,16 +762,20 @@ static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
 static int buf_sp_to_mp(const struct v4l2_buffer *b_sp,
 			struct v4l2_buffer *b_mp)
 {
+	struct v4l2_plane *planes;
 	int ret;
 
+	planes = b_mp->m.planes;
 	memcpy(b_mp, b_sp, sizeof *b_mp);
+	b_mp->m.planes = planes;
+
 	ret = type_sp_to_mp(b_sp->type, &b_mp->type);
 	if (ret)
 		return ret;
 	b_mp->m.planes[0].length = b_sp->length;
 	b_mp->m.planes[0].bytesused = b_mp->bytesused;
 	b_mp->length = 1;
-	memcpy(&b_mp->m.planes[0].m, &b_sp->m, sizeof(struct v4l2_plane));
+	memcpy(&b_mp->m.planes[0].m, &b_sp->m, sizeof(b_mp->m.planes[0].m));
 
 	return 0;
 }
@@ -785,9 +789,10 @@ static int buf_mp_to_sp(const struct v4l2_buffer *b_mp,
 	ret = type_mp_to_sp(b_mp->type, &b_sp->type);
 	if (ret)
 		return ret;
+
 	b_sp->length = b_mp->m.planes[0].length;
 	b_sp->bytesused = b_mp->m.planes[0].bytesused;
-	memcpy(&b_sp->m, &b_mp->m.planes[0].m, sizeof(struct v4l2_plane));
+	memcpy(&b_sp->m, &b_mp->m.planes[0].m, sizeof(b_sp->m));
 
 	return 0;
 }
-- 
1.7.1.569.g6f426

