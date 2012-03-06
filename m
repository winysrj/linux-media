Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52544 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2CFQcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 11:32:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 0/5] MT9M032 and MT9P031 sensor patches
Date: Tue,  6 Mar 2012 17:32:34 +0100
Message-Id: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've missed a 64-bit division issue in v2. Here's a v3 that fixes that. Sorry
for the noise.

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
 drivers/media/video/mt9m032.c    |  825 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/mt9p031.c    |   67 ++--
 include/media/mt9m032.h          |   36 ++
 7 files changed, 1135 insertions(+), 40 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h
 create mode 100644 drivers/media/video/mt9m032.c
 create mode 100644 include/media/mt9m032.h

-- 
Regards,

Laurent Pinchart

