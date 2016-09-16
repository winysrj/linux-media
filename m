Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:38520 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752032AbcIPIvI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 04:51:08 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id B593B18021F
        for <linux-media@vger.kernel.org>; Fri, 16 Sep 2016 10:51:02 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] rcar-vin fixes and removal of old soc-camera
 driver
Message-ID: <85828084-172d-9790-ddf7-0d49611bf0df@xs4all.nl>
Date: Fri, 16 Sep 2016 10:51:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series has various fixes/enhancements for the rcar-vin driver.

It also removes the old soc-camera rcar-vin driver.

After this patch series there are only two soc-camera drivers left:

atmel-isi and sh-mobile-ceu-camera.

I hope I can get my atmel-isi replacement driver merged for 4.10 and then soc-camera
as a framework can be removed (i.e. it will become part of sh-mobile-ceu-camera and
not usable by other drivers anymore).

Regards,

	Hans

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcar

for you to fetch changes up to 97468229c18da701d3bdd964a9c0a07ac61424e1:

  media: rcar-vin: use sink pad index for DV timings (2016-09-16 10:38:10 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      soc-camera/rcar-vin: remove obsolete driver

Niklas Söderlund (8):
      adv7180: rcar-vin: change mbus format to UYVY
      media: adv7180: fill in mbus format in set_fmt
      media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
      media: rcar-vin: allow field to be changed
      media: rcar-vin: fix bug in scaling
      media: rcar-vin: fix height for TOP and BOTTOM fields
      media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
      MAINTAINERS: Add entry for the Renesas VIN driver

Ulrich Hecht (2):
      rcar-vin: implement EDID control ioctls
      media: rcar-vin: use sink pad index for DV timings

 MAINTAINERS                                  |    9 +
 drivers/media/i2c/adv7180.c                  |   10 +-
 drivers/media/platform/rcar-vin/rcar-core.c  |    4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c   |   39 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c  |  206 +++++---
 drivers/media/platform/rcar-vin/rcar-vin.h   |    2 +
 drivers/media/platform/soc_camera/Kconfig    |   10 -
 drivers/media/platform/soc_camera/Makefile   |    1 -
 drivers/media/platform/soc_camera/rcar_vin.c | 1968 ----------------------------------------------------------------------------
 9 files changed, 192 insertions(+), 2057 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
