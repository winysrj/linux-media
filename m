Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:35560 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbeJIEZ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 00:25:56 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] MAINTAINERS: add entry for TI DS90Ux9xx FPD-Link III drivers
Date: Tue,  9 Oct 2018 00:12:05 +0300
Message-Id: <20181008211205.2900-8-vz@mleia.com>
In-Reply-To: <20181008211205.2900-1-vz@mleia.com>
References: <20181008211205.2900-1-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Record TI DS90Ux9xx series of serializer and deserializer ICs
and IC subcontrollers as maintained.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29c08106bd22..3952035b6b71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14762,6 +14762,16 @@ S:	Maintained
 F:	drivers/media/platform/davinci/
 F:	include/media/davinci/
 
+TI DS90UX9XX FPD-LINK III SERDES DRIVERS
+M:	Vladimir Zapolskiy <vz@mleia.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/mfd/ds90ux9xx-core.c
+F:	drivers/mfd/ds90ux9xx-i2c-bridge.c
+F:	drivers/pinctrl/pinctrl-ds90ux9xx.c
+F:	include/linux/mfd/ds90ux9xx.h
+N:	ds90u[bhx]9*
+
 TI ETHERNET SWITCH DRIVER (CPSW)
 R:	Grygorii Strashko <grygorii.strashko@ti.com>
 L:	linux-omap@vger.kernel.org
-- 
2.17.1
