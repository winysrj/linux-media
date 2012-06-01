Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:45558 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759300Ab2FAJiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 05:38:08 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-media@vger.kernel.org>,
	<gregkh@linuxfoundation.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 0/5] UVC webcam gadget related changes
Date: Fri, 1 Jun 2012 15:07:42 +0530
Message-ID: <cover.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset tries to take the UVC webcam gadget one step
closer to being used with a real V4L2 video capture device (via
a user-space application which is responsible for ensuring correct sequence of
operations being performed on both UVC gadget and V4L2 capture device
end).

A major change introduced by this patchset is to port UVC webcam gadget
to use videobuf2 framework for videobuffer managment and exposes
USER_PTR IO method at the UVC gadget side to ensure "zero-copy" of
video data as it passes from V4L2 capture driver domain to UVC gadget domain.
(Thanks to Laurent Pinchart for suggesting this design change).

I have tested this patchset on a super-speed compliant USB device
controller, with the VIVI capture device acting as a dummy source
of video data and I have modified the 'uvc-gadget' application written
by Laurent (original application available
here: http://git.ideasonboard.org/uvc-gadget.git) for testing the
complete flow from V4L2 to UVC domain and vice versa.

Bhupesh Sharma (5):
  usb: gadget/uvc: Fix string descriptor STALL issue when multiple uvc
    functions are added to a configuration
  usb: gadget/uvc: Use macro for interrupt endpoint status size instead
    of using a MAGIC number
  usb: gadget/uvc: Add super-speed support to UVC webcam gadget
  usb: gadget/uvc: Port UVC webcam gadget to use videobuf2 framework
  usb: gadget/uvc: Add support for 'USB_GADGET_DELAYED_STATUS' response
    for a set_intf(alt-set 1) command

 drivers/usb/gadget/Kconfig     |    1 +
 drivers/usb/gadget/f_uvc.c     |  304 +++++++++++++++++++----
 drivers/usb/gadget/f_uvc.h     |    8 +-
 drivers/usb/gadget/uvc.h       |    7 +-
 drivers/usb/gadget/uvc_queue.c |  524 +++++++++++-----------------------------
 drivers/usb/gadget/uvc_queue.h |   25 +--
 drivers/usb/gadget/uvc_v4l2.c  |   73 ++++--
 drivers/usb/gadget/uvc_video.c |   17 +-
 drivers/usb/gadget/webcam.c    |   29 ++-
 9 files changed, 509 insertions(+), 479 deletions(-)

-- 
1.7.2.2

