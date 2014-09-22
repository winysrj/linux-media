Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:16300 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVPWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:22:49 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v6 0/2] LED / flash API integration - LED Flash Class
 drivers
Date: Mon, 22 Sep 2014 17:22:18 +0200
Message-id: <1411399340-16458-1-git-send-email-j.anaszewski@samsung.com>
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

Jacek Anaszewski (2):
  leds: Add support for max77693 mfd flash cell
  leds: Add driver for AAT1290 current regulator

 drivers/leds/Kconfig         |   15 +
 drivers/leds/Makefile        |    2 +
 drivers/leds/leds-aat1290.c  |  460 ++++++++++++++++++
 drivers/leds/leds-max77693.c | 1083 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1560 insertions(+)
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c

-- 
1.7.9.5

