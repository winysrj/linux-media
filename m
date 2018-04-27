Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:58138 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757142AbeD0Lla (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 07:41:30 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 0/2] Add new grayscale formats
Date: Fri, 27 Apr 2018 14:40:37 +0300
Message-Id: <1524829239-4664-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following two patches add one new media bus code and one new pixel format.
Both are for 10bit grayscale data. They will be used by the future version of
the QComm CAMSS driver when receiving the frame data from the OV7251 grayscale
camera sensor.

Todor Tomov (2):
  media: v4l: Add new 2X8 10-bit grayscale media bus code
  media: v4l: Add new 10-bit packed grayscale format

 Documentation/media/uapi/v4l/pixfmt-y10p.rst    | 31 +++++++++++
 Documentation/media/uapi/v4l/subdev-formats.rst | 72 +++++++++++++++++++++++++
 Documentation/media/uapi/v4l/yuv-formats.rst    |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
 include/uapi/linux/media-bus-format.h           |  3 +-
 include/uapi/linux/videodev2.h                  |  1 +
 6 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst

-- 
2.7.4
