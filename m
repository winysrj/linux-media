Return-path: <linux-media-owner@vger.kernel.org>
Received: from r0.smtpout1.paris1.alwaysdata.com ([188.72.70.1]:49973 "EHLO
        r0.smtpout1.paris1.alwaysdata.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751383AbdLABiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 20:38:10 -0500
From: Alexandre Macabies <web+oss@zopieux.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/1] Add quirk to support light switch on some cameras
Date: Fri,  1 Dec 2017 02:21:24 +0100
Message-Id: <20171201012125.8941-1-web+oss@zopieux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Dino-Lite cameras are equipped with LED lights that can be switched
on and off by setting a proprietary control. For this control, the
camera reports a length of 1 byte, but actually the value set by the
original Windows driver is 3 byte long. This makes it impossible to
toggle the camera lights from uvcvideo, as the length from GET_LEN is
trusted as being the right one.
    
This patch makes GET_LEN indicate a length of 3 instead of 1 for this
specific device and control cs/unit.

This patch is a follow-up of a previous patch [1] sent in June, that
went unnoticed but addresses the same issue. It uses a table of local
fixups instead of a module quirk. If you prefer this approach, please
tell me, so I can rework it a bit and submit it in place of this one.

[1] https://patchwork.kernel.org/patch/9764937/

Alexandre Macabies (1):
  media: uvcvideo: Add quirk to support light switch on Dino-Lite
    cameras

 drivers/media/usb/uvc/uvc_driver.c |  9 +++++++++
 drivers/media/usb/uvc/uvc_video.c  | 10 ++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 20 insertions(+)

-- 
2.15.1
