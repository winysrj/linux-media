Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51940 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753263AbdHXOQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 10:16:10 -0400
Date: Thu, 24 Aug 2017 17:16:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: jacek.anaszewski@gmail.com, rmfrfs@gmail.com
Subject: [GIT PULL for 4.14] LED flash class improvements, AS3645A flash
 support
Message-ID: <20170824141606.a352kf2jrvnktybp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset includes the AS3645A LED driver as well as contents of the
previous pull request here of which the driver depends on:

<URL:https://patchwork.linuxtv.org/patch/43363/>

I've agreed with Jacek that the AS3645A patches in the pull request go
through the media tree. The same applies to the greybus light patch from
Rui.

Please pull.


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git as3645a-leds

for you to fetch changes up to 281410d1c163b7eaaa0128338e8717b401797555:

  arm: dts: omap3: N9/N950: Add AS3645A camera flash (2017-08-23 11:02:52 +0300)

----------------------------------------------------------------
Rui Miguel Silva (1):
      staging: greybus: light: fix memory leak in v4l2 register

Sakari Ailus (5):
      v4l2-flash-led-class: Create separate sub-devices for indicators
      v4l2-flash-led-class: Document v4l2_flash_init() references
      dt: bindings: Document DT bindings for Analog devices as3645a
      leds: as3645a: Add LED flash class driver
      arm: dts: omap3: N9/N950: Add AS3645A camera flash

 .../devicetree/bindings/leds/ams,as3645a.txt       |  71 ++
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-aat1290.c                        |   4 +-
 drivers/leds/leds-as3645a.c                        | 763 +++++++++++++++++++++
 drivers/leds/leds-max77693.c                       |   4 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     | 113 +--
 drivers/staging/greybus/light.c                    |  42 +-
 include/media/v4l2-flash-led-class.h               |  46 +-
 11 files changed, 990 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
