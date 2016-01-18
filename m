Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50805 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbcARQKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:10:39 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O15017JCOXPOM20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:10:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 0/3] Exynos4-is fixes for libv4l exynos4 camera plugin
Date: Mon, 18 Jan 2016 17:10:24 +0100
Message-id: <1453133427-20793-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set applies some fixes to the Exynos4412-trats2 platform
camera infrastructure. The modifications address issues detected
while testing libv4l plugin for Exynos4 camera with GStreamer.

Jacek Anaszewski (3):
  s5k6a3: Fix VIDIOC_SUBDEV_G_FMT ioctl for TRY format
  exynos4-is: Open shouldn't fail when sensor entity is not linked
  exynos4-is: Wait for 100us before opening sensor

 drivers/media/i2c/s5k6a3.c                    |    3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |    6 ++
 drivers/media/platform/exynos4-is/media-dev.c |   95 ++++++++++++++++++++-----
 3 files changed, 83 insertions(+), 21 deletions(-)

-- 
1.7.9.5

