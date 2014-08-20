Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36197 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaHTNn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:56 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/3] LED / flash API integration - LED Flash Class
 drivers
Date: Wed, 20 Aug 2014 15:43:38 +0200
Message-id: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
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

Jacek Anaszewski (3):
  mfd: max77693: Fix register enum name
  leds: Add support for max77693 mfd flash cell
  leds: Add driver for AAT1290 current regulator

 drivers/leds/Kconfig                 |   15 +
 drivers/leds/Makefile                |    2 +
 drivers/leds/leds-aat1290.c          |  448 +++++++++++++++
 drivers/leds/leds-max77693.c         | 1048 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |    5 +-
 include/linux/mfd/max77693-private.h |   61 +-
 include/linux/mfd/max77693.h         |   40 ++
 7 files changed, 1617 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c

-- 
1.7.9.5

