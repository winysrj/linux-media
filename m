Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60335 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3GQKJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 06:09:00 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so1747025pbb.28
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 03:09:00 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	pawel.moll@arm.com, t.katayama@jp.fujitsu.com,
	vikas.sajjan@linaro.org, linaro-kernel@lists.linaro.org,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH 0/2][RFC] CDFv2 for VExpress HDLCD DVI output support
Date: Wed, 17 Jul 2013 18:08:55 +0800
Message-Id: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This series patches extend Pawel's patches to 
Versatile Express HDLCD DVI output support.
Before apply this patches, please apply Pawel's patches first.
This series patches implements base on Linaro release 13.06 branch "ll_20130621.0".

here is Pawel's patches
[1] http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html

Show Liu (2):
  Fixed for compatible with kernel 3.10.0-rc6
  CDFv2 for VExpress HDLCD DVI output support

 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |    6 +-
 drivers/video/Kconfig                      |    2 +
 drivers/video/arm-hdlcd.c                  |  116 +++++++++++++++++++++++++---
 drivers/video/fbmon.c                      |   12 ++-
 drivers/video/vexpress-dvimode.c           |   11 +++
 drivers/video/vexpress-muxfpga.c           |    8 +-
 include/linux/arm-hdlcd.h                  |    6 ++
 7 files changed, 142 insertions(+), 19 deletions(-)

-- 
1.7.9.5

