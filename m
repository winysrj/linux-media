Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46833 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2CBKnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 05:43:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 00/10] MT9M032 sensor driver
Date: Fri,  2 Mar 2012 11:43:57 +0100
Message-Id: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the Aptina MT9M032 sensor driver, originally
written by Martin Hostettler.

Compared to the first version, I've squashed two patches together that were
not supposed to be split in the first place and fixed a couple of 80-columns
checkpatch warnings.

The first patch is still Martin's original driver untouched for ease of
review. I can squash some of the other patches onto it if needed after review
is complete.

Patch 09/10 adds a generic PLL setup code for several Aptina sensors. I will
post a patch for the MT9P031 sensor driver to use that code separately from
this set.

I would still like to push the patches in time for v3.4. Martin, could you
please review the set ? Guennadi, to you have any MT9M032 hardware you can use
to test the driver ?


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
 drivers/media/video/aptina-pll.c |  120 ++++++
 drivers/media/video/aptina-pll.h |   55 +++
 drivers/media/video/mt9m032.c    |  827 ++++++++++++++++++++++++++++++++++++++
 include/media/mt9m032.h          |   36 ++
 6 files changed, 1054 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

