Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41401 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeAPVHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 16:07:07 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id DE771201F5
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 22:06:15 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] uvcvideo style cleanups
Date: Tue, 16 Jan 2018 23:07:03 +0200
Message-Id: <20180116210707.7727-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I was growing tired of explaining during review that, while the uvcvideo.h
header used the extern keyword in front of function declarations, the same
style mistake didn't have to be copied in all patches. I thus decided to write
patch 1/4, and while at it I fixed similar style issues in patch 2/4 to 4/4.

Apart from the kmalloc() to kmalloc_array() change, a byte-to-byte comparison
of the .text sections of the module shows no difference before and after this
series.

Laurent Pinchart (4):
  uvcvideo: Drop extern keyword in function declarations
  uvcvideo: Use kernel integer types
  uvcvideo: Use internal kernel integer types
  uvcvideo: Use parentheses around sizeof operand

 drivers/media/usb/uvc/uvc_ctrl.c   |  62 +++----
 drivers/media/usb/uvc/uvc_driver.c |  97 +++++------
 drivers/media/usb/uvc/uvc_isight.c |   6 +-
 drivers/media/usb/uvc/uvc_status.c |   4 +-
 drivers/media/usb/uvc/uvc_v4l2.c   |  76 ++++-----
 drivers/media/usb/uvc/uvc_video.c  |  42 ++---
 drivers/media/usb/uvc/uvcvideo.h   | 321 ++++++++++++++++++-------------------
 7 files changed, 303 insertions(+), 305 deletions(-)

-- 
Regards,

Laurent Pinchart
