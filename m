Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60248 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752243AbdHJPtu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 11:49:50 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
Subject: [PATCH v3 0/3] Create sub-device per LED                                  
Date: Thu, 10 Aug 2017 18:49:44 +0300
Message-Id: <20170810154947.2283-1-sakari.ailus@linux.intel.com>
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

	Note that this set depends on patch 85f7ff9702bc ("media:
	v4l2-flash: Use led_classdev instead of led_classdev_flash for
	indicator") in mediatree master.

since v2:

- Add Hans's acks and Rui's reviewed-by.

- Use IS_ERR() instead of IS_ERR_OR_NULL() to check v4l2_flash_init()
  success --- it never returns NULL.

since v1:

- Drop patch "staging: greybus: light: Don't leak memory for no gain" in
  favour of Rui's "staging: greybus: light: fix memory leak in v4l2
  register".

- Rebase "staging: greybus: light: fix memory leak in v4l2 register" on
  "media: v4l2-flash: Use led_classdev instead of led_classdev_flash for
  indicator" already in mediatree.

- Add "v4l2-flash-led-class: Document v4l2_flash_init() references" to the
  set.

Rui Miguel Silva (1):
  staging: greybus: light: fix memory leak in v4l2 register

Sakari Ailus (2):
  v4l2-flash-led-class: Create separate sub-devices for indicators
  v4l2-flash-led-class: Document v4l2_flash_init() references

 drivers/leds/leds-aat1290.c                    |   4 +-
 drivers/leds/leds-max77693.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 113 +++++++++++++++----------
 drivers/staging/greybus/light.c                |  42 ++++-----
 include/media/v4l2-flash-led-class.h           |  47 +++++++---
 5 files changed, 127 insertions(+), 83 deletions(-)

-- 
2.11.0
