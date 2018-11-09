Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38840 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbeKJCrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:06 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v6 00/10] Asynchronous UVC
Date: Fri,  9 Nov 2018 17:05:23 +0000
Message-Id: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linux UVC driver has long provided adequate performance capabilities for
web-cams and low data rate video devices in Linux while resolutions were low.

Modern USB cameras are now capable of high data rates thanks to USB3 with
1080p, and even 4k capture resolutions supported.

Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
(isochronous transfers) can generate more data than an embedded ARM core is
able to process on a single core, resulting in frame loss.

A large part of this performance impact is from the requirement to
‘memcpy’ frames out from URB packets to destination frames. This unfortunate
requirement is due to the UVC protocol allowing a variable length header, and
thus it is not possible to provide the target frame buffers directly.

Extra throughput is possible by moving the actual memcpy actions to a work
queue, and moving the memcpy out of interrupt context thus allowing work tasks
to be scheduled across multiple cores.

This series has been tested on both the ZED and BRIO cameras on arm64
platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a Sonix USB2
Camera, and a built in Toshiba Laptop camera, and with thanks to Philipp Zabel
for testing on a Lite-On internal Laptop Webcam, Logitech C910 (USB2 isoc),
Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).

As far as I am aware iSight devices, and devices which use UVC to encode data
(output device) have not yet been tested - but should find no ill effect (at
least not until they are tested of course :D )

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>

This series is based upon Laurent Pinchart's uvc/next available at:
  git://linuxtv.org/pinchartl/media.git uvc/next

and the series itself is available at my kernel.org repo:
  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/linux.git uvc/async

v2:
 - Fix race reported by Guennadi

v3:
 - Fix similar race reported by Laurent
 - Only queue work if required (encode/isight do not queue work)
 - Refactor/Rename variables for clarity

v4:
 - (Yet another) Rework of the uninitialise path.
   This time to hopefully clean up the shutdown races for good.
   use usb_poison_urb() to halt all URBs, then flush the work queue
   before freeing.
 - Rebase to latest linux-media/master

v5:
 - Provide lockdep validation
 - rename uvc_queue_requeue -> uvc_queue_buffer_requeue()
 - Fix comments and periods throughout
 - Rebase to media/v4.20-2
 - Use GFP_KERNEL allocation in uvc_video_copy_data_work()
 - Fix function documentation for uvc_video_copy_data_work()
 - Add periods to the end of sentences
 - Rename 'decode' variable to 'op' in uvc_video_decode_data()
 - Move uvc_urb->async_operations initialisation to before use
 - Move async workqueue to match uvc_streaming lifetime instead of
   streamon/streamoff
 - bracket the for_each_uvc_urb() macro

 - New patches added to series:
    media: uvcvideo: Split uvc_video_enable into two
    media: uvcvideo: Rename uvc_{un,}init_video()
    media: uvcvideo: Utilise for_each_uvc_urb iterator

v6:
 - New patch added to series
    media: uvcvideo: Abstract streaming object lifetime

 - Utilise the new streaming object lifetime functions to perform
   allocation and destruction of the async workqueue.
 - Append _transfer to {_stop,_start} in uvc_video_{stop,start}_transfer
 - rename lone 'j' iterator to 'i'
 - Remove conversion which doesn't make sense due to needing the
   iterator value.

Kieran Bingham (10):
  media: uvcvideo: Refactor URB descriptors
  media: uvcvideo: Convert decode functions to use new context structure
  media: uvcvideo: Protect queue internals with helper
  media: uvcvideo: queue: Simplify spin-lock usage
  media: uvcvideo: queue: Support asynchronous buffer handling
  media: uvcvideo: Abstract streaming object lifetime
  media: uvcvideo: Move decode processing to process context
  media: uvcvideo: Split uvc_video_enable into two
  media: uvcvideo: Rename uvc_{un,}init_video()
  media: uvcvideo: Utilise for_each_uvc_urb iterator

 drivers/media/usb/uvc/uvc_driver.c |  65 +++++--
 drivers/media/usb/uvc/uvc_isight.c |   6 +-
 drivers/media/usb/uvc/uvc_queue.c  | 110 +++++++++---
 drivers/media/usb/uvc/uvc_video.c  | 275 ++++++++++++++++++------------
 drivers/media/usb/uvc/uvcvideo.h   |  65 ++++++-
 5 files changed, 370 insertions(+), 151 deletions(-)

base-commit: b82b45e8c9d5d015c6887216868e3335897662d3
-- 
git-series 0.9.1
