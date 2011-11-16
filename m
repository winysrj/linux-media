Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49193 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab1KPOKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 09:10:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH v5 0/2] as3645a flash driver
Date: Wed, 16 Nov 2011 15:10:55 +0100
Message-Id: <1321452657-24424-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the 5th (and hopefully final) version of the as3645a flash driver.
Compared to v4, it incorporates Andy's patches, adds support for the
V4L2_CID_FLASH_STROBE_STATUS control and removes the minimum limits from
platform data.

Laurent Pinchart (2):
  v4l: Add over-current and indicator flash fault bits
  as3645a: Add driver for LED flash controller

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                |  892 ++++++++++++++++++++++++++
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   71 ++
 6 files changed, 983 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart

