Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbbFXPLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:52 -0400
Received: by wicgi11 with SMTP id gi11so49609590wic.0
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:51 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 12/12] MAINTAINERS: Add c8sectpfe driver directory to STi section
Date: Wed, 24 Jun 2015 16:11:10 +0100
Message-Id: <1435158670-7195-13-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the new c8sectpfe demux driver to the STi section of the
MAINTAINERS file.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d8afd29..49c8963 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1481,6 +1481,7 @@ F:	arch/arm/boot/dts/sti*
 F:	drivers/clocksource/arm_global_timer.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/media/rc/st_rc.c
+F:	drivers/media/tsin/c8sectpfe/
 F:	drivers/mmc/host/sdhci-st.c
 F:	drivers/phy/phy-miphy28lp.c
 F:	drivers/phy/phy-miphy365x.c
-- 
1.9.1

