Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbeACUdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 15:33:07 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com
Subject: [RFC/RFT PATCH 0/6] Asynchronous UVC
Date: Wed,  3 Jan 2018 20:32:50 +0000
Message-Id: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The Linux UVC driver has long provided adequate performance capabilities for
web-cams and low data rate video devices in Linux while resolutions were low.

Modern USB cameras are now capable of high data rates thanks to USB3 with
1080p, and even 4k capture resolutions supported.

Cameras such as the Stereolabs ZED or the Logitech Brio can generate more data
than an embedded ARM core is able to process on a single core, resulting in
frame loss.

A large part of this performance impact is from the requirement to
‘memcpy’ frames out from URB packets to destination frames. This unfortunate
requirement is due to the UVC protocol allowing a variable length header, and
thus it is not possible to provide the target frame buffers directly.

Extra throughput is possible by moving the actual memcpy actions to a work
queue, and moving the memcpy out of interrupt context and allowing work tasks
to be scheduled across multiple cores.

This series has been tested on both the ZED and Brio cameras on arm64
platforms, however due to the intrinsic changes in the driver I would like to
see it tested with other devices and other platforms, so I'd appreciate if
anyone can test this on a range of USB cameras.

Kieran Bingham (6):
  uvcvideo: Refactor URB descriptors
  uvcvideo: Convert decode functions to use new context structure
  uvcvideo: Protect queue internals with helper
  uvcvideo: queue: Simplify spin-lock usage
  uvcvideo: queue: Support asynchronous buffer handling
  uvcvideo: Move decode processing to process context

 drivers/media/usb/uvc/uvc_isight.c |   4 +-
 drivers/media/usb/uvc/uvc_queue.c  | 115 ++++++++++++++----
 drivers/media/usb/uvc/uvc_video.c  | 191 ++++++++++++++++++++++--------
 drivers/media/usb/uvc/uvcvideo.h   |  56 +++++++--
 4 files changed, 289 insertions(+), 77 deletions(-)

base-commit: 6f0e5fd39143a59c22d60e7befc4f33f22aeed2f
-- 
git-series 0.9.1
