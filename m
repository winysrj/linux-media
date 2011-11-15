Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35132 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab1KOPpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 10:45:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH v3 0/2] as3645a flash driver
Date: Tue, 15 Nov 2011 16:45:30 +0100
Message-Id: <1321371932-28399-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the as3645a flash controller driver.

Compared to v2, it addresses most of Sakari's comments. I've left an unneeded
default case in a switch statement to avoid gcc complaining about uninitialized
variables, and I haven't removed the control values cache from the as3645a
structure as this is still being discussed.

Laurent Pinchart (2):
  v4l: Add over-current and indicator flash fault bits
  as3645a: Add driver for LED flash controller

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                |  880 ++++++++++++++++++++++++++
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   83 +++
 6 files changed, 983 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart

