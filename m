Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbeK3NWh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 08:22:37 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 026C6553
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 03:14:57 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.21] uvcvideo updates
Date: Fri, 30 Nov 2018 04:15:27 +0200
Message-ID: <2415293.1zdhjpb6o1@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 
-0500)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to dd3bd1ac29aa9a0f83a55f100e69091c0567a27c:

  media: uvcvideo: Refactor teardown of uvc on USB disconnect (2018-11-30 
04:12:08 +0200)

----------------------------------------------------------------
Daniel Axtens (1):
      media: uvcvideo: Refactor teardown of uvc on USB disconnect

Sergey Dorodnicov (2):
      media: v4l: Add 4bpp packed depth confidence format CNF4
      media: uvcvideo: Add support for the CNF4 format

 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 31 +++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c             | 18 ++++++++++++++----
 drivers/media/usb/uvc/uvc_status.c             | 12 ++++++++----
 drivers/media/usb/uvc/uvcvideo.h               |  4 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 7 files changed, 60 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst

-- 
Regards,

Laurent Pinchart
