Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38819 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1KNATD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 19:19:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH v2 0/2] as3645a flash driver
Date: Mon, 14 Nov 2011 01:19:08 +0100
Message-Id: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the as3645a flash controller driver.

Compared to v1, this version addresses Hans' comments, and removes the
overheat protection code.

The overheat protection implementation was specific to Nokia's use cases, and
thus not ready for mainline. A more generic overheat protection implementation
(possibly as a library usable by several flash controllers) can be integrated
later.

Laurent Pinchart (2):
  v4l: Add over-current and indicator flash fault bits
  as3645a: Add driver for LED flash controller

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                |  951 ++++++++++++++++++++++++++
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   69 ++
 6 files changed, 1040 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart

