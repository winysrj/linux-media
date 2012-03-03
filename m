Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2CCP17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:27:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 00/10] MT9M032 sensor driver
Date: Sat,  3 Mar 2012 16:28:05 +0100
Message-Id: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the Aptina MT9M032 sensor driver, originally
written by Martin Hostettler.

Compared to the second version, I've optimized the PLL code to get rid of the
inner loop. The limits are now declared as static const in the mt9m032 driver.

Laurent Pinchart (9):
  mt9m032: Reorder code into section and whitespace cleanups
  mt9m032: Make get/set format/crop operations consistent across
    drivers
  mt9m032: Use module_i2c_driver() macro
  mt9m032: Enclose to_dev() macro argument in brackets
  mt9m032: Pass an i2c_client pointer to the register read/write
    functions
  mt9m032: Put HFLIP and VFLIP controls in a cluster
  mt9m032: Remove unneeded register read
  v4l: Aptina-style sensor PLL support
  mt9m032: Use generic PLL setup code

Martin Hostettler (1):
  v4l: Add driver for Micron MT9M032 camera sensor

 drivers/media/video/Kconfig      |   11 +
 drivers/media/video/Makefile     |    5 +
 drivers/media/video/aptina-pll.c |  175 ++++++++
 drivers/media/video/aptina-pll.h |   55 +++
 drivers/media/video/mt9m032.c    |  828 ++++++++++++++++++++++++++++++++++++++
 include/media/mt9m032.h          |   36 ++
 6 files changed, 1110 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

