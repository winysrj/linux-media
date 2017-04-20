Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:13969 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971015AbdDTQIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 12:08:21 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v4 8/8] ARM: configs: stm32: DCMI + OV2640 camera support
Date: Thu, 20 Apr 2017 18:07:25 +0200
Message-ID: <1492704445-22186-9-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
References: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable DCMI camera interface and OV2640 camera sensor drivers.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/configs/stm32_defconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/configs/stm32_defconfig b/arch/arm/configs/stm32_defconfig
index 84adc88..3f2e4ce 100644
--- a/arch/arm/configs/stm32_defconfig
+++ b/arch/arm/configs/stm32_defconfig
@@ -53,6 +53,13 @@ CONFIG_GPIO_STMPE=y
 CONFIG_MFD_STMPE=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 # CONFIG_USB_SUPPORT is not set
+CONFIG_VIDEO_V4L2=y
+CONFIG_MEDIA_SUBDRV_AUTOSELECT=n
+CONFIG_V4L_PLATFORM_DRIVERS=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_VIDEO_STM32_DCMI=y
+CONFIG_VIDEO_OV2640=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
-- 
1.9.1
