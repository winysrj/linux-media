Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53972 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755557AbeBOTqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 14:46:20 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id B4CF0200BF
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 20:44:45 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] uvcvideo changes
Date: Thu, 15 Feb 2018 21:46:54 +0200
Message-ID: <5514459.NidxLMrFhA@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 
-0500)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to df0d402a05dfe57cc6069d189ae9844f5bb4e852:

  uvcvideo: Fixed ktime_t to ns conversion (2018-02-15 10:16:34 +0200)

----------------------------------------------------------------
Edgar Thier (1):
      uvcvideo: Apply flags from device to actual properties

Jasmin Jessich (1):
      uvcvideo: Fixed ktime_t to ns conversion

Laurent Pinchart (4):
      uvcvideo: Drop extern keyword in function declarations
      uvcvideo: Use kernel integer types
      uvcvideo: Use internal kernel integer types
      uvcvideo: Use parentheses around sizeof operand

Philipp Zabel (1):
      uvcvideo: Support multiple frame descriptors with the same dimensions

 drivers/media/usb/uvc/uvc_ctrl.c   | 114 +++++++++-------
 drivers/media/usb/uvc/uvc_driver.c |  97 +++++++-------
 drivers/media/usb/uvc/uvc_isight.c |   6 +-
 drivers/media/usb/uvc/uvc_status.c |   4 +-
 drivers/media/usb/uvc/uvc_v4l2.c   | 139 +++++++++++++-------
 drivers/media/usb/uvc/uvc_video.c  |  47 +++----
 drivers/media/usb/uvc/uvcvideo.h   | 320 +++++++++++++++++-----------------
 7 files changed, 395 insertions(+), 332 deletions(-)

-- 
Regards,

Laurent Pinchart
