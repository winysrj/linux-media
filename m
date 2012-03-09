Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39923 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab2CIPBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 10:01:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.ifi,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH v4 0/5] MT9M032 and MT9P031 sensor patches
Date: Fri,  9 Mar 2012 16:01:20 +0100
Message-Id: <1331305285-10781-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the fourth version of the MT9M032 and MT9P031 sensor patches for v3.4.

Compared to v3, only patch 5/5 has been changed. I've added locking to the
driver, removed the memset to 0 for the reserved fields in the frame interval
set handler, fixed a typo in a kernel log message and moved the driver to the
right location in Kconfig and Makefile.

Danny Kukawka (1):
  mt9p031: Remove duplicate media/v4l2-subdev.h include

Laurent Pinchart (3):
  mt9p031: Remove unused xskip and yskip fields in struct mt9p031
  v4l: Aptina-style sensor PLL support
  mt9p031: Use generic PLL setup code

Martin Hostettler (1):
  v4l: Add driver for Micron MT9M032 camera sensor

 drivers/media/video/Kconfig      |   12 +
 drivers/media/video/Makefile     |    5 +
 drivers/media/video/aptina-pll.c |  174 ++++++++
 drivers/media/video/aptina-pll.h |   56 +++
 drivers/media/video/mt9m032.c    |  862 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/mt9p031.c    |   67 ++--
 include/media/mt9m032.h          |   36 ++
 7 files changed, 1172 insertions(+), 40 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

