Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA11AC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B76E2214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfCLJUU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:20:20 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44036 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbfCLJUU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 05:20:20 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3da2hZDgy4HFn3da6hIjKh; Tue, 12 Mar 2019 10:20:18 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.2] Various fixes/enhancements part 3
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Helen Koike <helen.koike@collabora.com>
Message-ID: <bdd59c37-a1c9-48f7-db80-ad9b93d677f9@xs4all.nl>
Date:   Tue, 12 Mar 2019 10:20:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKEF5zMQsuj6UWqqeY4uz/tRo9aQf/lgcSEp1auNTZH/6EbrVzmE4I2j8hdETZGtPC4czNV4tKm+fRz5A/MBj2oIfrxKcDvWRiI3Jfx1vQlrBpB7oeL1
 UXWrml8mSv+8b0I5f+naNuDAqKzLOCZpf6dTmAnRjS7jeaPuctzWbegDBc4WU30iMCC5RnSMP6+LVBXL0SR72rSpXkLheN6arJtgiZNqYdUq4xBPnePuEhLh
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Helen,

I dropped patches 4 and 8 from your series. I've asked Ezequiel to make changes to
the format info helper patch and patch 4 depends on that, and patch 8 because it
introduces a bug. I've merged the other 6 patches of your series.

Regards,

	Hans

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.2c2

for you to fetch changes up to 28dd544f3ef69076ba1a2843204be0b440ffaf80:

  media: wl128x: Fix an error code in fm_download_firmware() (2019-03-12 10:18:03 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Arnd Bergmann (2):
      media: i2c: adv748x: select V4L2_FWNODE
      media: staging: davinci_vpfe: disallow building with COMPILE_TEST

Dan Carpenter (1):
      media: wl128x: Fix an error code in fm_download_firmware()

Hans Petter Selasky (1):
      strscpy() returns a negative value on failure unlike strlcpy().

Helen Fornazier (6):
      media: vimc: deb: fix default sink bayer format
      media: vimc: stream: fix thread state before sleep
      media: vimc: cap: fix step width/height in enum framesize
      media: vimc: stream: cleanup frame field from struct vimc_stream
      media: vimc: stream: add docs to struct vimc_stream
      media: vimc: stream: init/terminate the first entity

Mao Wenan (1):
      staging: davinci: drop pointless static qualifier in vpfe_resizer_init()

Souptick Joarder (1):
      media: videobuf2: Return error after allocation failure

Steve Longerbeam (1):
      media: imx: vdic: Fix wrong CSI group ID

YueHaibing (1):
      media: rockchip-vpu: Remove duplicated include from rockchip_vpu_drv.c

claudiojpaz (1):
      staging: media: zoran: Fixes a checkpatch.pl error in videocodec.c

 drivers/media/common/videobuf2/videobuf2-vmalloc.c    | 10 +++++-----
 drivers/media/i2c/Kconfig                             |  1 +
 drivers/media/platform/vimc/vimc-capture.c            |  4 ++--
 drivers/media/platform/vimc/vimc-debayer.c            |  2 +-
 drivers/media/platform/vimc/vimc-streamer.c           | 38 +++++++++++++++++++++-----------------
 drivers/media/platform/vimc/vimc-streamer.h           | 16 +++++++++++++++-
 drivers/media/radio/wl128x/fmdrv_common.c             |  5 +++--
 drivers/media/v4l2-core/v4l2-ioctl.c                  |  2 +-
 drivers/staging/media/davinci_vpfe/Kconfig            |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c    |  2 +-
 drivers/staging/media/imx/imx-media-vdic.c            |  2 +-
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c |  1 -
 drivers/staging/media/zoran/videocodec.c              |  2 +-
 13 files changed, 53 insertions(+), 34 deletions(-)
