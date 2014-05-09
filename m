Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55954 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIM1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:27:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] UVC gadget driver fixes
Date: Fri, 09 May 2014 14:27:34 +0200
Message-ID: <42415415.jy6YRrDCiC@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

Could you please pull the following three patches for v3.16 ? They've been 
reviewed on the linux-media and linux-usb mailing list.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-gadget

for you to fetch changes up to 7b1e2101bd9286fd9b8e1b37292da32f02080a4f:

  usb: gadget: uvc: Set the vb2 queue timestamp flags (2014-05-09 14:24:30 
+0200)

----------------------------------------------------------------
Laurent Pinchart (3):
      usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
      usb: gadget: uvc: Set the V4L2 buffer field to V4L2_FIELD_NONE
      usb: gadget: uvc: Set the vb2 queue timestamp flags

 drivers/usb/gadget/uvc_queue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

