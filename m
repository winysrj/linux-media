Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF2FC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27DE21019
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfAHPpD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:45:03 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44668 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728075AbfAHPpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 10:45:02 -0500
Received: from [IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231] ([IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231])
        by smtp-cloud9.xs4all.net with ESMTPA
        id gtYmgGaO2MWvEgtYqgOvKJ; Tue, 08 Jan 2019 16:45:00 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <42137155-e76e-8818-3ac3-3d15eec682f8@xs4all.nl>
Date:   Tue, 8 Jan 2019 16:44:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfIk4J1rDAmWEAVPzjDPAme0unYBDCs4v3qYcZ6aiMpvsgThRSW0o6NkWf21B1/s1rdlnqiDRgY5S/9wZI5DSEe3aUEc6+nTeB+SEooyeML/MF0K5sREd
 YN0v++tU2rsBcbkK0JuC2xTsiA76FYa50hXI7MDV3yw9BNX3MRyoZt8qHri2XpFo7JV81IdmKm7d1ywVxAS2nuYlkS/8hOtd7ruqOIJCM+gSTe2Bot+0OR1p
 SwUX3Rt8K/f+m9Be6i7l6N+/rip8J2snQavjKgYQ1tmQpgTzGzuBoPDancaIVCUe
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1b2

for you to fetch changes up to aaa099e5efb834c55a8ddbeb7d9596208e4433c2:

  rcar-vin: remove unneeded locking in async callbacks (2019-01-08 16:41:51 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Aditya Pakki (2):
      media: gspca: Check the return value of write_bridge for timeout
      media: gspca: mt9m111: Check write_bridge for timeout

Akinobu Mita (1):
      media: staging: bcm2835-camera: use V4L2_FRACT_COMPARE

Alexey Khoroshilov (2):
      media: tw9910: fix failure handling in tw9910_power_on()
      media: tw9910: add helper function for setting gpiod value

Andrzej Pietrasiewicz (2):
      media: Change Andrzej Pietrasiewicz's e-mail address
      MAINTAINERS: Change s5p-jpeg maintainer information.

Dafna Hirschfeld (1):
      media: vicodec: bugfix - replace '=' with '|='

Hans Verkuil (1):
      v4l2-ctrls.c/uvc: zero v4l2_event

Jacopo Mondi (1):
      media: rcar-csi2: Fix PHTW table values for E3/V3M

Kangjie Lu (2):
      usb: gspca: add a missed return-value check for do_command
      usb: gspca: add a missed check for goto_low_power

Kieran Bingham (1):
      media: vsp1: Fix trivial documentation

Niklas Söderlund (1):
      rcar-vin: remove unneeded locking in async callbacks

Ondrej Jirman (1):
      media: sunxi: cedrus: Fix missing error message context

Pawe? Chmiel (1):
      media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration

 MAINTAINERS                                                   |  3 ++-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c             |  2 +-
 drivers/media/i2c/tw9910.c                                    | 27 +++++++++++----------
 drivers/media/platform/rcar-vin/rcar-core.c                   | 14 -----------
 drivers/media/platform/rcar-vin/rcar-csi2.c                   | 62 +++++++++++++++++++++++------------------------
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   | 23 ++++++++++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.h                   |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c                 |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h                 |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h                   |  2 +-
 drivers/media/platform/vicodec/codec-fwht.c                   |  8 +++---
 drivers/media/platform/vsp1/vsp1_video.c                      |  2 +-
 drivers/media/usb/gspca/cpia1.c                               | 14 ++++++++---
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c                 |  8 +++---
 drivers/media/usb/gspca/m5602/m5602_po1030.c                  |  8 ++++--
 drivers/media/usb/uvc/uvc_ctrl.c                              |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                          |  2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c                | 28 ++++++++++-----------
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |  8 ++----
 include/media/videobuf2-dma-sg.h                              |  2 +-
 20 files changed, 111 insertions(+), 110 deletions(-)
