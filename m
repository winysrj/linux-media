Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55714 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbcGHTLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 15:11:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] drivers/media/platform/Kconfig: fix VIDEO_MEDIATEK_VCODEC dependency
Date: Fri,  8 Jul 2016 21:11:19 +0200
Message-Id: <1468005079-28636-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468005079-28636-1-git-send-email-hverkuil@xs4all.nl>
References: <1468005079-28636-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Allow VIDEO_MEDIATEK_VCODEC to build when COMPILE_TEST is set (even
without MTK_IOMMU).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3231b25..2c2670c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -168,7 +168,7 @@ config VIDEO_MEDIATEK_VPU
 
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
-	depends on MTK_IOMMU
+	depends on MTK_IOMMU || COMPILE_TEST
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.8.1

