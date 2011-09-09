Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45782 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1IIPwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 11:52:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 0/2] as3645a flash driver
Date: Fri,  9 Sep 2011 17:52:47 +0200
Message-Id: <1315583569-22727-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's a driver for the as3645a flash controller.

The first patch adds two new flash faults bits to the V4L2 API, and the second
patch adds the driver itself.

Laurent Pinchart (2):
  v4l: Add over-current and indicator flash fault bits
  as3645a: Add driver for LED flash controller

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                | 1425 ++++++++++++++++++++++++++
 include/linux/as3645a.h                      |   36 +
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   69 ++
 7 files changed, 1550 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/linux/as3645a.h
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart

