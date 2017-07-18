Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751436AbdGRSlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 14:41:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/2] Create sub-device per LED
Date: Tue, 18 Jul 2017 21:41:05 +0300
Message-Id: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

The original design decision in the V4L2 flash API allows controlling a two
LEDs (an indicator and a flash) through a single sub-device. This covered
virtually all flash driver chips back then but this no longer holds as
there are many LED driver chips with multiple flash LED outputs. This
necessitates creating as many sub-devices as there are flash LEDs.

Additionally the flash LEDs can be associated to different sensors. This is
not unconceivable although not very probable.

This patchset splits the indicator and flash LEDs exposed by the V4L2 flash
class framework into multiple sub-devices. This way the driver creates the
sub-devices individually for each LED which will also facilitate fwnode
matching (e.g. will you refer to LED or a LED driver chip with a phandle?).

I'll post that set soonish.

These go on top of the other flash patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.14-2>

Sakari Ailus (2):
  staging: greybus: light: Don't leak memory for no gain
  v4l2-flash-led-class: Create separate sub-devices for indicators

 drivers/leds/leds-aat1290.c                    |   4 +-
 drivers/leds/leds-max77693.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 112 +++++++++++++++----------
 drivers/staging/greybus/light.c                |  33 +++++---
 include/media/v4l2-flash-led-class.h           |  41 ++++++---
 5 files changed, 119 insertions(+), 75 deletions(-)

-- 
2.11.0
