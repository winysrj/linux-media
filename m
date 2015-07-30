Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36438 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbbG3RJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:09:32 -0400
Received: by wicgb10 with SMTP id gb10so577743wic.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 10:09:31 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	m.krufky@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, joe@perches.com
Subject: [PATCH v2 11/11] MAINTAINERS: Add c8sectpfe driver directory to STi section
Date: Thu, 30 Jul 2015 18:09:01 +0100
Message-Id: <1438276141-16902-12-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
References: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the new c8sectpfe demux driver to the STi section of the
MAINTAINERS file.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a226416..a9f2f37 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1506,6 +1506,7 @@ F:	arch/arm/boot/dts/sti*
 F:	drivers/clocksource/arm_global_timer.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/media/rc/st_rc.c
+F:	drivers/media/platform/sti/c8sectpfe/
 F:	drivers/mmc/host/sdhci-st.c
 F:	drivers/phy/phy-miphy28lp.c
 F:	drivers/phy/phy-miphy365x.c
-- 
1.9.1

