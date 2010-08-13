Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:37892 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761668Ab0HMOwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 10:52:10 -0400
Message-ID: <4C655A01.7010807@matrix-vision.de>
Date: Fri, 13 Aug 2010 16:43:13 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: laurent.pinchart@ideasonboard.com,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
CC: linux-media@vger.kernel.org
Subject: Must omap34xxcam be a module?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent & Sakari,

Regarding the omap3camera/devel branch:

In v4l2-common.c:v4l2_i2c_new_subdev_board(), request_module() is called to ensure that the sensor driver is already registered before registering the sensor device.  When I compile-in both my sensor driver and omap34xxcam with the kernel, this call to request_module() fails, and indeed omap34xxcam is initialized before my sensor driver, causing the omap34xxcam device registration to fail. When I leave omap34xxcam compiled-in and try to just let it load the sensor module when needed on bootup, request_module() fails.  I haven't managed to track down why that is.  When I compile both omap34xxcam and my sensor driver as modules, and load them after boot-up, registration succeeds.

Is it neccessary for omap34xxcam and its subdevices to be modules?  How are you guys building these?

Full disclosure: my sensor is actually an SPI device, but the v4l2_spi_new_subdev() function I'm actually using seems to be _very_ analogous to its I2C counterpart, so I'm assuming SPI is not responsible.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Hans-Joachim Reich
