Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33775 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbbFOLeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/14] sh-veu: don't use COLORSPACE_JPEG.
Date: Mon, 15 Jun 2015 13:33:29 +0200
Message-Id: <1434368021-7467-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

COLORSPACE_JPEG should only be used for JPEGs. Use SMPTE170M instead,
which is how YCbCr images are usually encoded.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_veu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 77a74d3..f5e3eb3a 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -211,7 +211,7 @@ static enum v4l2_colorspace sh_veu_4cc2cspace(u32 fourcc)
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV24:
-		return V4L2_COLORSPACE_JPEG;
+		return V4L2_COLORSPACE_SMPTE170M;
 	case V4L2_PIX_FMT_RGB332:
 	case V4L2_PIX_FMT_RGB444:
 	case V4L2_PIX_FMT_RGB565:
-- 
2.1.4

