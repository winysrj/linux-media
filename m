Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43037 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1EYIKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 04:10:21 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LLQ00GWCS0X77@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 09:10:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLQ008DLS0WI4@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 May 2011 09:10:08 +0100 (BST)
Date: Wed, 25 May 2011 10:10:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-csis: Add missing dependency on PLAT_S5P
In-reply-to: <1306306916.2390.6.camel@porites>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1306311005-14150-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1306306916.2390.6.camel@porites>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

s5p-csis is to be built only on S5P SoC platforms.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

Hi Nicolas,

On x86 mipi-csis build should be disabled. This patch should the issue.

Regards,
Sylwester Nawrocki
Samsung Poland R&D Center

---
 drivers/media/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index cf5a1f6..bd739a6 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -954,7 +954,7 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 
 config VIDEO_S5P_MIPI_CSIS
 	tristate "Samsung S5P and EXYNOS4 MIPI CSI receiver driver"
-	depends on VIDEO_V4L2 && PM_RUNTIME && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P && VIDEO_V4L2_SUBDEV_API && PLAT_S5P
 	---help---
 	  This is a v4l2 driver for Samsung S5P/EXYNOS4 MIPI-CSI receiver.
 
-- 
1.7.2.5

