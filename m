Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35464 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1KHMGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:06:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Yann Sionneau <yann@minet.net>
Subject: [PATCH 0/4] uvcvideo: device timestamp support
Date: Tue,  8 Nov 2011 13:05:58 +0100
Message-Id: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I've finally got around to working on timestamping support for the uvcvideo
driver. After a couple of years of development, it was about time.

The following patch set is divided in two parts. The first 3 patches implement
debugfs support to export video stream statistics (thanks to Alexey Fisher for
providing the initial implementation). As I don't know whether the Windows UVC
driver makes use of device timestamps, I'm not sure how much the feature has
been tested in devices. Having a way to retrieve statistics is thus vital to
handle the stream of bug reports that might follow :-)

The last patch implements device timestamps support. In a nutshell, devices
report a timestamp based on their own clock. Converting from the device clock
to the host clock requires going through an intermediate USB clock, shared
between the device and the host. The code computes the linear relations from
the device clock to the USB clock and from the USB clock to the host clock,
and then converts the device timestamp to a host timestamp.

Standard deviation in timestamps has been reduced by a factor of 10 with these
patches. Precision could maybe be enhanced further by using the least min
squares method to compute the linear regression. If anyone feels playful,
please go ahead and submit an additional patch :-)

Alexey Fisher (2):
  uvcvideo: Add debugfs support
  uvcvideo: Extract video stream statistics

Laurent Pinchart (2):
  uvcvideo: Extract timestamp-related statistics
  uvcvideo: Add UVC timestamps support

 drivers/media/video/uvc/Makefile      |    2 +-
 drivers/media/video/uvc/uvc_debugfs.c |  136 ++++++++
 drivers/media/video/uvc/uvc_driver.c  |   21 +-
 drivers/media/video/uvc/uvc_queue.c   |   12 +
 drivers/media/video/uvc/uvc_video.c   |  557 ++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvcvideo.h    |   87 +++++
 6 files changed, 807 insertions(+), 8 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_debugfs.c

-- 
Regards,

Laurent Pinchart

