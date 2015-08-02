Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:53236 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751967AbbHBUko (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2015 16:40:44 -0400
Message-ID: <1438548040.30149.1.camel@perches.com>
Subject: MAINTAINERS/s5p: Kamil Debski no longer with Samsung?
From: Joe Perches <joe@perches.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-media <linux-media@vger.kernel.org>,
	lm-sensors <lm-sensors@lm-sensors.org>
Date: Sun, 02 Aug 2015 13:40:40 -0700
In-Reply-To: <20150802203128.1B6952691B2@smtprelay05.hostedemail.com>
References: <20150802203128.1B6952691B2@smtprelay05.hostedemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2015-08-02 at 20:31 +0000, Mail Delivery System wrote:
> <k.debski@samsung.com>: host mailin.samsung.com[203.254.224.12] 
> said: 550 5.1.1
>     Recipient address rejected: User unknown (in reply to RCPT TO 
> command)

His email address bounces.

Should MAINTAINERS be updated?

---
 MAINTAINERS | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 826affa..b5197c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1442,7 +1442,6 @@ F:        arch/arm/mach-s5pv210/
 
 ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
 M:     Kyungmin Park <kyungmin.park@samsung.com>
-M:     Kamil Debski <k.debski@samsung.com>
 L:     linux-arm-kernel@lists.infradead.org
 L:     linux-media@vger.kernel.org
 S:     Maintained
@@ -1450,7 +1449,6 @@ F:        drivers/media/platform/s5p-g2d/
 
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:     Kyungmin Park <kyungmin.park@samsung.com>
-M:     Kamil Debski <k.debski@samsung.com>
 M:     Jeongtae Park <jtp.park@samsung.com>
 L:     linux-arm-kernel@lists.infradead.org
 L:     linux-media@vger.kernel.org
@@ -8248,9 +8246,8 @@ S:        Maintained
 F:     drivers/media/usb/pwc/*
 
 PWM FAN DRIVER
-M:     Kamil Debski <k.debski@samsung.com>
 L:     lm-sensors@lm-sensors.org
-S:     Supported
+S:     Orphan
 F:     Documentation/devicetree/bindings/hwmon/pwm-fan.txt
 F:     Documentation/hwmon/pwm-fan
 F:     drivers/hwmon/pwm-fan.c
@@ -8906,9 +8903,8 @@ T:        https://github.com/lmajewski/linux-samsung-thermal.git
 F:     drivers/thermal/samsung/
 
 SAMSUNG USB2 PHY DRIVER
-M:     Kamil Debski <k.debski@samsung.com>
 L:     linux-kernel@vger.kernel.org
-S:     Supported
+S:     Orphan
 F:     Documentation/devicetree/bindings/phy/samsung-phy.txt
 F:     Documentation/phy/samsung-usb2.txt
 F:     drivers/phy/phy-exynos4210-usb2.c
