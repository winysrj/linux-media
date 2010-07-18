Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:55398 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0GRETF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 00:19:05 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org
Subject: [RFC] [PATCH 0/6] Add camera support to the OMAP1 Amstrad Delta videophone
Date: Sun, 18 Jul 2010 06:18:06 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007180618.08266.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series consists of the following patches:

  1/6	SoC Camera: add driver for OMAP1 camera interface
  2/6	OMAP1: Add support for SoC camera interface
  3/6	SoC Camera: add driver for OV6650 sensor
  4/6	SoC Camera: add support for g_parm / s_parm operations
  5/6	OMAP1: Amstrad Delta: add support for on-board camera
  6/6	OMAP1: Amstrad Delta: add camera controlled LEDS trigger

 arch/arm/mach-omap1/board-ams-delta.c     |   69 +
 arch/arm/mach-omap1/devices.c             |   43
 arch/arm/mach-omap1/include/mach/camera.h |    8
 drivers/media/video/Kconfig               |   20
 drivers/media/video/Makefile              |    2
 drivers/media/video/omap1_camera.c        | 1656 ++++++++++++++++++++++++++++++
 drivers/media/video/ov6650.c              | 1336 ++++++++++++++++++++++++
 drivers/media/video/soc_camera.c          |   18
 include/media/omap1_camera.h              |   16
 include/media/v4l2-chip-ident.h           |    1
 10 files changed, 3169 insertions(+)

Thanks,
Janusz
