Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42154 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaIVPVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:21:17 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v6 0/3] LED / flash API integration - LED Flash Class
Date: Mon, 22 Sep 2014 17:21:03 +0200
Message-id: <1411399266-16375-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is the follow-up of the LED / flash API integration
series [1]. For clarity reasons the patchset has been split into
four subsets:

- LED Flash Class
- V4L2 Flash
- LED Flash Class drivers
- Documentation

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
  leds: implement sysfs interface locking mechanism
  leds: add API for setting torch brightness
  leds: Add LED Flash Class wrapper to LED subsystem

 drivers/leds/Kconfig            |   11 +
 drivers/leds/Makefile           |    1 +
 drivers/leds/led-class-flash.c  |  557 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c        |   30 ++-
 drivers/leds/led-core.c         |   32 +++
 drivers/leds/led-triggers.c     |   16 +-
 include/linux/led-class-flash.h |  238 +++++++++++++++++
 include/linux/leds.h            |   56 ++++
 8 files changed, 934 insertions(+), 7 deletions(-)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

-- 
1.7.9.5

