Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35285 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcFVTW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 15:22:57 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RESEND PATCH v2 0/5] ir-rx51 driver fixes
Date: Wed, 22 Jun 2016 22:22:16 +0300
Message-Id: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir-rx51 is a driver for Nokia N900 IR transmitter. The current series
fixes the remaining problems in the driver:

 - replace GP timer 9 with PWM framework usage
 - replace pulse width timer dmtimer usage with hrtimer
 - add DT support to the driver
 - add driver to the board DTS

Patch 2 is needed so the driver to function correctly, without it PWM
refuses to set the needed carrier frequency.

Changes compared to v1:
 - removed [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime
   functions when not needed.
 - DT compatible string changed to "nokia,n900-ir"

Ivaylo Dimitrov (5):
  ir-rx51: Fix build after multiarch changes broke it
  pwm: omap-dmtimer: Allow for setting dmtimer clock source
  ir-rx51: use PWM framework instead of OMAP dmtimer
  ir-rx51: add DT support to driver
  ir-rx51: use hrtimer instead of dmtimer

 .../devicetree/bindings/media/nokia,n900-ir        |  20 ++
 .../devicetree/bindings/pwm/pwm-omap-dmtimer.txt   |   4 +
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   5 -
 arch/arm/mach-omap2/pdata-quirks.c                 |  10 +-
 drivers/media/rc/Kconfig                           |   2 +-
 drivers/media/rc/ir-rx51.c                         | 229 +++++++--------------
 drivers/pwm/pwm-omap-dmtimer.c                     |  12 +-
 include/linux/platform_data/media/ir-rx51.h        |   3 -
 8 files changed, 111 insertions(+), 174 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir

-- 
1.9.1

