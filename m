Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26463 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaKLQJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Nov 2014 11:09:51 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v7 0/3] LED / flash API integration - LED Flash Class
Date: Wed, 12 Nov 2014 17:09:14 +0100
Message-id: <1415808557-29557-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is the follow-up of the LED / flash API integration
series [1].

========================
Changes since version 6:
========================

- removed addition of public LED subsystem API for setting
  torch brightness in favour of internal API for
  synchronous and asynchronous led brightness level setting
- fixed possible race condition upon creating LED Flash class
  related sysfs attributes

========================
Changes since version 5:
========================

- removed flash manager framework - its implementation needs
  further thorough discussion.
- removed external strobe facilities from the LED Flash Class
  and provided external_strobe_set op in v4l2-flash. LED subsystem
  should be strobe provider agnostic.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914


Jacek Anaszewski (3):
  leds: Add support for setting brightness in a synchronous way
  leds: Add LED Flash Class wrapper to LED subsystem
  Documentation: leds: Add description of LED Flash Class extension

 Documentation/leds/leds-class-flash.txt   |   39 +++
 drivers/leds/Kconfig                      |   11 +
 drivers/leds/Makefile                     |    1 +
 drivers/leds/led-class-flash.c            |  511 +++++++++++++++++++++++++++++
 drivers/leds/led-class.c                  |   14 +-
 drivers/leds/led-core.c                   |   19 +-
 drivers/leds/leds.h                       |   20 +-
 drivers/leds/trigger/ledtrig-backlight.c  |    8 +-
 drivers/leds/trigger/ledtrig-default-on.c |    2 +-
 drivers/leds/trigger/ledtrig-gpio.c       |    6 +-
 drivers/leds/trigger/ledtrig-heartbeat.c  |    2 +-
 drivers/leds/trigger/ledtrig-oneshot.c    |    4 +-
 drivers/leds/trigger/ledtrig-transient.c  |   10 +-
 include/linux/led-class-flash.h           |  229 +++++++++++++
 include/linux/leds.h                      |   11 +
 15 files changed, 861 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/leds/leds-class-flash.txt
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

-- 
1.7.9.5

