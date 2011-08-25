Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3455 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1HYOIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/12] drxd_hard: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:34 +0200
Message-Id: <d120f6eafa4207ce12540d3daf630bd7817e7b62.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/dvb/frontends/drxd_hard.c: In function 'DownloadMicrocode':
v4l-dvb-git/drivers/media/dvb/frontends/drxd_hard.c:933:6: warning: variable 'BlockCRC' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/dvb/frontends/drxd_hard.c:929:6: warning: variable 'Flags' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/frontends/drxd_hard.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 2238bf0..5490b48 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -926,16 +926,15 @@ static int DownloadMicrocode(struct drxd_state *state,
 			     const u8 *pMCImage, u32 Length)
 {
 	u8 *pSrc;
-	u16 Flags;
 	u32 Address;
 	u16 nBlocks;
 	u16 BlockSize;
-	u16 BlockCRC;
 	u32 offset = 0;
 	int i, status = 0;
 
 	pSrc = (u8 *) pMCImage;
-	Flags = (pSrc[0] << 8) | pSrc[1];
+	/* We're not using Flags */
+	/* Flags = (pSrc[0] << 8) | pSrc[1]; */
 	pSrc += sizeof(u16);
 	offset += sizeof(u16);
 	nBlocks = (pSrc[0] << 8) | pSrc[1];
@@ -952,11 +951,13 @@ static int DownloadMicrocode(struct drxd_state *state,
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
-		Flags = (pSrc[0] << 8) | pSrc[1];
+		/* We're not using Flags */
+		/* u16 Flags = (pSrc[0] << 8) | pSrc[1]; */
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
-		BlockCRC = (pSrc[0] << 8) | pSrc[1];
+		/* We're not using BlockCRC */
+		/* u16 BlockCRC = (pSrc[0] << 8) | pSrc[1]; */
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
 
-- 
1.7.5.4

