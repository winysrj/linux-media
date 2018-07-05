Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49181 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752458AbeGEJCo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 05:02:44 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] MAINTAINERS: Add entry for STM32 DCMI media driver
Date: Thu, 5 Jul 2018 11:01:42 +0200
Message-ID: <1530781302-6675-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry to make myself a maintainer of STM32 DCMI media driver.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 07d1576..1032c05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8955,6 +8955,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/dvb-frontends/stv6111*
 
+MEDIA DRIVERS FOR STM32 - DCMI
+M:	Hugues Fruchet <hugues.fruchet@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
+F:	drivers/media/platform/stm32/stm32-dcmi.c
+
 MEDIA DRIVERS FOR NVIDIA TEGRA - VDE
 M:	Dmitry Osipenko <digetx@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
1.9.1
