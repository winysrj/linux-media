Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4694 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1HYOIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/12] vpx3220, bt819: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:35 +0200
Message-Id: <cf274b4c8195cb8e087b534e980a8be7a8b99d3b.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/video/vpx3220.c: In function 'vpx3220_status':
v4l-dvb-git/drivers/media/video/vpx3220.c:299:6: warning: variable 'res' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/video/bt819.c: In function 'bt819_status':
v4l-dvb-git/drivers/media/video/bt819.c:219:6: warning: variable 'res' set but not used [-Wunused-but-set-variable]

Same status/res mixup.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/bt819.c   |    2 +-
 drivers/media/video/vpx3220.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index f872044..859eabf 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -229,7 +229,7 @@ static int bt819_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pstd)
 	if (pstd)
 		*pstd = std;
 	if (pstatus)
-		*pstatus = status;
+		*pstatus = res;
 
 	v4l2_dbg(1, debug, sd, "get status %x\n", status);
 	return 0;
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index ca372eb..e5cad6f 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -331,7 +331,7 @@ static int vpx3220_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pst
 	if (pstd)
 		*pstd = std;
 	if (pstatus)
-		*pstatus = status;
+		*pstatus = res;
 	return 0;
 }
 
-- 
1.7.5.4

