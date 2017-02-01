Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49635 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751353AbdBAQDt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 11:03:49 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v6 03/10] ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
Date: Wed, 1 Feb 2017 17:03:24 +0100
Message-ID: <1485965011-17388-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables support of STMicroelectronics STiH4xx SoC series
DELTA multi-format video decoder V4L2 driver.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index b01a438..5dff8fe 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -569,6 +569,7 @@ CONFIG_VIDEO_SAMSUNG_S5P_MFC=m
 CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC=m
 CONFIG_VIDEO_STI_BDISP=m
 CONFIG_VIDEO_STI_HVA=m
+CONFIG_VIDEO_STI_DELTA=m
 CONFIG_VIDEO_RENESAS_JPU=m
 CONFIG_VIDEO_RENESAS_VSP1=m
 CONFIG_V4L_TEST_DRIVERS=y
-- 
1.9.1

