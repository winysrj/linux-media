Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58431 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2BZD13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 00/11] MT9M032 sensor driver
Date: Sun, 26 Feb 2012 04:27:26 +0100
Message-Id: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's a new driver for the Aptina MT9M032 sensor, written by Martin
Hostettler. I've reviewed the original version posted on the list a couple of
weeks ago, and agreed with Martin that I would write the cleanup patches I
deemed necessary and/or useful and post the result. Here it is.

The first patch is Martin's original driver untouched for ease of review. I
can squash some of the other patches onto it if needed after review is
complete.

Patch 10/11 adds a generic PLL setup code for several Aptina sensors. I will
post a patch for the MT9P031 sensor driver to use that code separately from
this set.

I would like to push the patches in time for v3.4. Martin, could you please
review the set and test it with your hardware if possible ?

Laurent Pinchart (10):
  mt9m032: Reorder code into section and whitespace cleanups
  mt9m032: Make get/set format/crop operations consistent across
    drivers
  mt9m032: Use module_i2c_driver() macro
  mt9m032: Enclose to_dev() macro argument in brackets
  mt9m032: Pass an i2c_client pointer to the register read/write
    functions
  mt9m032: Put HFLIP and VFLIP controls in a cluster
  mt9m032: Compute PLL parameters at runtime
  mt9m032: Remove unneeded register read
  v4l: Aptina-style sensor PLL support
  mt9m032: Use generic PLL setup code

Martin Hostettler (1):
  v4l: Add driver for Micron MT9M032 camera sensor

 drivers/media/video/Kconfig      |   11 +
 drivers/media/video/Makefile     |    5 +
 drivers/media/video/aptina-pll.c |  120 ++++++
 drivers/media/video/aptina-pll.h |   55 +++
 drivers/media/video/mt9m032.c    |  820 ++++++++++++++++++++++++++++++++++++++
 include/media/mt9m032.h          |   36 ++
 6 files changed, 1047 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

