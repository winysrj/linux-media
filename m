Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:17918 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbeEQObF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 10:31:05 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/2] v4l: Add support for STD ioctls on subdev nodes
Date: Thu, 17 May 2018 16:30:14 +0200
Message-Id: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

This series enables the video standards to be controlled directly on the 
subdev device node. This is needed as there is no way to control the 
standard of a subdevice if it's part of a media controller centric setup 
as oppose to a video centric one.

I have tested this on Renesas Gen3 Salvator-XS M3-N using the AFE
subdevice from the adv748x driver together with the R-Car VIN and CSI-2
pipeline. And verified ENUMSTD still works for video device centric 
devices on Renesas Gen2 Koelsch board.

I wrote a prototype patch for v4l2-ctl which adds four new options
(--get-subdev-standard, --get-subdev-standard, --set-subdev-standard and
--get-subdev-detected-standard) to ease testing which I plan to submit
after some cleanup if this patch receives positive feedback.

If you or anyone else is interested in testing this patch the v4l2-utils
prototype patches are available at

git://git.ragnatech.se/v4l-utils#subdev-std

* Changes since v1
- Add VIDIOC_SUBDEV_ENUMSTD.

Niklas Söderlund (2):
  v4l2-ioctl: create helper to fill in v4l2_standard for ENUMSTD
  v4l: Add support for STD ioctls on subdev nodes

 .../media/uapi/v4l/vidioc-enumstd.rst         | 11 ++--
 Documentation/media/uapi/v4l/vidioc-g-std.rst | 14 ++--
 .../media/uapi/v4l/vidioc-querystd.rst        | 11 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c          | 66 +++++++++++--------
 drivers/media/v4l2-core/v4l2-subdev.c         | 22 +++++++
 include/media/v4l2-ioctl.h                    | 11 ++++
 include/uapi/linux/v4l2-subdev.h              |  4 ++
 7 files changed, 98 insertions(+), 41 deletions(-)

-- 
2.17.0
