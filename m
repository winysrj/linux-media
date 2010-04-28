Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48088 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0D1Wwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 18:52:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: robert.lukassen@tomtom.com
Subject: [RFC 0/2] UVC gadget driver
Date: Thu, 29 Apr 2010 00:52:57 +0200
Message-Id: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's a new version of the UVC gadget driver I posted on the list some time
ago, rebased on 2.6.34-rc5.

The private events API has been replaced by the new V4L2 events API that will
be available in 2.6.34 (the code is already available in the v4l-dvb tree on
linuxtv.org, and should be pushed to
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git very
soon).

Further testing of the changes related to the events API is required (this is
planned for the next few days). As it seems to be the UVC gadget driver season
(Robert Lukassen posted his own implementation - having a different goal - two
days ago), I thought I'd post the patch as an RFC. I'd like the UVC function
driver to make it to 2.6.35, comments are more than welcome.

Laurent Pinchart (2):
  USB gadget: video class function driver
  USB gadget: Webcam device

 drivers/usb/gadget/Kconfig     |    9 +-
 drivers/usb/gadget/Makefile    |    2 +
 drivers/usb/gadget/f_uvc.c     |  661 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_uvc.h     |  376 +++++++++++++++++++++++
 drivers/usb/gadget/uvc.h       |  242 +++++++++++++++
 drivers/usb/gadget/uvc_queue.c |  583 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/uvc_queue.h |   89 ++++++
 drivers/usb/gadget/uvc_v4l2.c  |  374 +++++++++++++++++++++++
 drivers/usb/gadget/uvc_video.c |  386 +++++++++++++++++++++++
 drivers/usb/gadget/webcam.c    |  399 ++++++++++++++++++++++++
 10 files changed, 3120 insertions(+), 1 deletions(-)
 create mode 100644 drivers/usb/gadget/f_uvc.c
 create mode 100644 drivers/usb/gadget/f_uvc.h
 create mode 100644 drivers/usb/gadget/uvc.h
 create mode 100644 drivers/usb/gadget/uvc_queue.c
 create mode 100644 drivers/usb/gadget/uvc_queue.h
 create mode 100644 drivers/usb/gadget/uvc_v4l2.c
 create mode 100644 drivers/usb/gadget/uvc_video.c
 create mode 100644 drivers/usb/gadget/webcam.c

-- 
Regards,

Laurent Pinchart

