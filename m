Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53890 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbeGZOLM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 10:11:12 -0400
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D50A21817
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 14:54:26 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.19] uvcvideo changes
Date: Thu, 26 Jul 2018 15:55:04 +0300
Message-ID: <1936008.o9qq4RlplV@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7ba2eb72f843fb79de1857a39f9a7e8006f8133b:

  media: dib0700: add code comment (2018-07-25 14:55:59 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 3c3ffa7cbccc4dbb689adaf87e5186e2a71ea0fa:

  uvcvideo: Send a control event when a Control Change interrupt arrives 
(2018-07-26 15:54:22 +0300)

----------------------------------------------------------------
Guennadi Liakhovetski (3):
      uvcvideo: Remove a redundant check
      uvcvideo: Handle control pipe protocol STALLs
      uvcvideo: Send a control event when a Control Change interrupt arrives

Kieran Bingham (1):
      uvcvideo: Fix minor spelling

Laurent Pinchart (1):
      uvcvideo: Add KSMedia 8-bit IR format support

Nicolas Dufresne (1):
      uvcvideo: Also validate buffers in BULK mode

 drivers/media/usb/uvc/uvc_ctrl.c   | 215 +++++++++++++++++++++++++++---------
 drivers/media/usb/uvc/uvc_driver.c |   5 ++
 drivers/media/usb/uvc/uvc_status.c | 121 ++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
 drivers/media/usb/uvc/uvc_video.c  |  62 ++++++++++---
 drivers/media/usb/uvc/uvcvideo.h   |  18 +++-
 include/uapi/linux/uvcvideo.h      |   2 +
 7 files changed, 346 insertions(+), 81 deletions(-)

-- 
Regards,

Laurent Pinchart
