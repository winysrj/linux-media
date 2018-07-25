Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53195 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbeGYO43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:56:29 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: mchehab@kernel.org, sakari.ailus@iki.fi,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [v2 0/2] media: i2c: mt9v111 sensor driver
Date: Wed, 25 Jul 2018 15:44:29 +0200
Message-Id: <1532526271-19639-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this is a sensor level driver for Aptina MT9V111.

Compared to v1 the biggest difference is that now auto-exposure and
auto-white-balancing are exposed through the v4l2-ctrl framework, and can be
activated/deactivated by the user.

For this reason, while auto-exposure algorithm still controls the frame rate in
low light conditions, the driver now enables it by default and let the user
disable it to more precisely control the framerate.

(Most of the) comments from Sakari and Kieran have been addressed, see changelog
for a more precise list.

Tested VGA, QVGA QQVGA resolutions at 5, 10, 15 and 30 frame per second.

v4l2-compliance fails on some tests, and I've not been able to identify what's
wrong with the driver. Copy of the failures reported here below:

fail: v4l2-test-subdevs.cpp(69): doioctl(node, VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL, &fie) != EINVAL
fail: v4l2-test-subdevs.cpp(180): ret && ret != ENOTTY
fail: v4l2-test-subdevs.cpp(248): ret && ret != ENOTTY
test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL

I've found no mention of ENOTTY to be reported by enum_frame_interval in the
documentation, but apparently v4l2-compliance checks for that.

v1: https://lkml.org/lkml/2018/6/11/467

Thanks
   j

v1 -> v2:
- Addressed syntax mistakes pointed out by Kieran
- Drop spinlock around address space change
- Extend mutex to cover frame rate and format get/set operations
- Add controls for auto-exposure and auto-white-balancing
- Move MAINTAINERS modifications to bindings patch
- Fix resolution in bindings document
- Drop dependency on OF
- Drop subdev 'open' function in favour of pad operation init_cfg and use a
  default configuration to initialize the sensor
- Turn off power if sensor identification fails

Jacopo Mondi (2):
  dt-bindings: media: i2c: Document MT9V111 bindings
  media: i2c: Add driver for Aptina MT9V111

 .../bindings/media/i2c/aptina,mt9v111.txt          |   46 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/mt9v111.c                        | 1299 ++++++++++++++++++++
 5 files changed, 1365 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
 create mode 100644 drivers/media/i2c/mt9v111.c

--
2.7.4
