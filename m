Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40334 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1KOQU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 11:20:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH v4 0/2] as3645a flash driver
Date: Tue, 15 Nov 2011 17:21:03 +0100
Message-Id: <1321374065-20063-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

v3 was missing a small bug fix (setting ctrl->cur.val to 0 before adding bits
in the fault control read code). v4 fixes that (and also includes a cosmetic
fix).

Laurent Pinchart (2):
  v4l: Add over-current and indicator flash fault bits
  as3645a: Add driver for LED flash controller

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                |  881 ++++++++++++++++++++++++++
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   83 +++
 6 files changed, 984 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart

