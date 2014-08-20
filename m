Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:60618 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaHTNmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:15 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/4] LED / flash API integration - LED Flash Class
Date: Wed, 20 Aug 2014 15:41:54 +0200
Message-id: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is the follow-up of the LED / flash API integration
series [1]. For clarity reasons the patchset has been split into
five subsets:

- LED Flash Class
- Flash Manager
- V4L2 Flash
- LED Flash Class drivers
- Documentation

The series is based on linux-next-20140820.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (4):
  leds: Improve and export led_update_brightness
  leds: implement sysfs interface locking mechanism
  leds: add API for setting torch brightness
  leds: Add LED Flash Class wrapper to LED subsystem

 drivers/leds/Kconfig            |   11 +
 drivers/leds/Makefile           |    1 +
 drivers/leds/led-class-flash.c  |  645 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c        |   40 ++-
 drivers/leds/led-core.c         |   48 +++
 drivers/leds/led-triggers.c     |   20 +-
 include/linux/led-class-flash.h |  273 +++++++++++++++++
 include/linux/leds.h            |   66 ++++
 8 files changed, 1091 insertions(+), 13 deletions(-)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

-- 
1.7.9.5

