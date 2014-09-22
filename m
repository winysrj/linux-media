Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55975 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaIVPV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:21:59 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v6 0/2] LED / flash API integration - V4L2 Flash
Date: Mon, 22 Sep 2014 17:21:47 +0200
Message-id: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
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
  media: Add registration helpers for V4L2 flash
  exynos4-is: Add support for v4l2-flash subdevs

 drivers/media/platform/exynos4-is/media-dev.c |   36 +-
 drivers/media/platform/exynos4-is/media-dev.h |   13 +-
 drivers/media/v4l2-core/Kconfig               |   11 +
 drivers/media/v4l2-core/Makefile              |    2 +
 drivers/media/v4l2-core/v4l2-flash.c          |  502 +++++++++++++++++++++++++
 include/media/v4l2-flash.h                    |  135 +++++++
 6 files changed, 696 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

