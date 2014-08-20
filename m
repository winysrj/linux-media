Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40175 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaHTNmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:54 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/2] LED / flash API integration - Flash Manager
Date: Wed, 20 Aug 2014 15:42:41 +0200
Message-id: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
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

Jacek Anaszewski (2):
  of: add of_node_ncmp wrapper
  leds: Add Flash Manager functionality

 arch/sparc/include/asm/prom.h        |    1 +
 drivers/leds/Kconfig                 |   11 +
 drivers/leds/Makefile                |    4 +
 drivers/leds/led-class-flash.c       |   19 ++
 drivers/leds/led-flash-gpio-mux.c    |  102 ++++++
 drivers/leds/led-flash-manager.c     |  590 ++++++++++++++++++++++++++++++++++
 drivers/leds/of_led_flash_manager.c  |  155 +++++++++
 include/linux/led-flash-gpio-mux.h   |   68 ++++
 include/linux/led-flash-manager.h    |  146 +++++++++
 include/linux/leds.h                 |    1 +
 include/linux/of.h                   |    1 +
 include/linux/of_led_flash_manager.h |   80 +++++
 12 files changed, 1178 insertions(+)
 create mode 100644 drivers/leds/led-flash-gpio-mux.c
 create mode 100644 drivers/leds/led-flash-manager.c
 create mode 100644 drivers/leds/of_led_flash_manager.c
 create mode 100644 include/linux/led-flash-gpio-mux.h
 create mode 100644 include/linux/led-flash-manager.h
 create mode 100644 include/linux/of_led_flash_manager.h

-- 
1.7.9.5

