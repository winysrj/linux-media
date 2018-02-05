Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:42198 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbeBEBZW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 20:25:22 -0500
From: Ulf Magnusson <ulfalizer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, tfiga@chromium.org,
        paul.burton@mips.com, m.szyprowski@samsung.com,
        egtvedt@samfundet.no, linus.walleij@linaro.org,
        vgupta@synopsys.com, mgorman@techsingularity.net, hch@lst.de,
        mina86@mina86.com, robh@kernel.org, sboyd@codeaurora.org,
        paulus@ozlabs.org, will.deacon@arm.com, tony@atomide.com,
        npiggin@gmail.com, yamada.masahiro@socionext.com,
        Ulf Magnusson <ulfalizer@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 17/20] media: sec: Remove PLAT_S5P dependency
Date: Mon,  5 Feb 2018 02:21:29 +0100
Message-Id: <20180205012146.23981-18-ulfalizer@gmail.com>
In-Reply-To: <20180205012146.23981-1-ulfalizer@gmail.com>
References: <20180205012146.23981-1-ulfalizer@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PLAT_S5P symbol was removed in commit d78c16ccde96 ("ARM: SAMSUNG:
Remove remaining legacy code").

Remove the PLAT_S5P dependency from VIDEO_SAMSUNG_S5P_CEC.

Discovered with the
https://github.com/ulfalizer/Kconfiglib/blob/master/examples/list_undefined.py
script.

Signed-off-by: Ulf Magnusson <ulfalizer@gmail.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 614fbef08ddc..8b4cd02e2938 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -582,7 +582,7 @@ config CEC_GPIO
 
 config VIDEO_SAMSUNG_S5P_CEC
        tristate "Samsung S5P CEC driver"
-       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+       depends on ARCH_EXYNOS || COMPILE_TEST
        select CEC_CORE
        select CEC_NOTIFIER
        ---help---
-- 
2.14.1
