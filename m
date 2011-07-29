Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 29/59] ARM: PXA: use gpio_set_value_cansleep() on pcm990
Date: Fri, 29 Jul 2011 12:56:29 +0200
Message-Id: <1311937019-29914-30-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera-switching GPIOs are provided by a i2c GPIO extender, switching
them can send the caller to sleep. Use the GPIO API *_cansleep methods
explicitly to avoid runtime warnings.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>
---
 arch/arm/mach-pxa/pcm990-baseboard.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 6d5b7e0..8ad2597 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -395,9 +395,9 @@ static int pcm990_camera_set_bus_param(struct soc_camera_link *link,
 	}
 
 	if (flags & SOCAM_DATAWIDTH_8)
-		gpio_set_value(gpio_bus_switch, 1);
+		gpio_set_value_cansleep(gpio_bus_switch, 1);
 	else
-		gpio_set_value(gpio_bus_switch, 0);
+		gpio_set_value_cansleep(gpio_bus_switch, 0);
 
 	return 0;
 }
-- 
1.7.2.5

