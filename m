Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1267DC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0C172073F
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfBGPbr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:31:47 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53217 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfBGPbr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 10:31:47 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rleRgyt9uNR5yrleTg2jNT; Thu, 07 Feb 2019 16:31:45 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <4c004997-3a85-7b78-4bcc-8b6d00a0a9c4@xs4all.nl>
Date:   Thu, 7 Feb 2019 16:31:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKOt2r8ys8Vtd/pi5ui0v6DdKPdUgXWzCBV64m/eJ2k1oirZpPOtab4vUSAYMxxNDcKHnQepnKMPcaiDoAyg13BC3aqgR/gEoOD73r1x/Ukt3aZR/vRV
 d0pTnegaDBvlFYel9wn+n4Q5KvRpIJ4kCAXvbNBQkqpX1f7iQ819X4ITcvTDEoCXUXCki7uokdjTx6/uVfb5Q286rTdfzK7O8iM+QFtYGdC8OU69izK4VMYs
 /gVAmzNdnGofkK1jFgDVkFPuCH/qWO7lenytRsquhADzPq9QuaL5/c5BQpA1Fyr88NltbpAkoIFQlhaY3f2SvQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1m

for you to fetch changes up to 2ce52e1ff1fad37fe7179306b8e4efd82ea98630:

  vimc: fill in bus_info in media_device_info (2019-02-07 16:19:54 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (2):
      media: vb2: Fix buf_out_validate documentation
      media: v4l2-mem2mem: Rename v4l2_m2m_buf_copy_data to v4l2_m2m_buf_copy_metadata

Hans Verkuil (4):
      hdpvr: fix smatch warning
      vim2m: fix smatch warning
      pxa_camera: fix smatch warning
      vimc: fill in bus_info in media_device_info

Steve Longerbeam (1):
      media: imx: Validate frame intervals before setting

 drivers/media/platform/pxa_camera.c             |  8 +++++---
 drivers/media/platform/vicodec/vicodec-core.c   |  4 ++--
 drivers/media/platform/vim2m.c                  |  4 ++--
 drivers/media/platform/vimc/vimc-capture.c      |  4 +---
 drivers/media/platform/vimc/vimc-core.c         |  2 ++
 drivers/media/usb/hdpvr/hdpvr-i2c.c             | 14 +++++++-------
 drivers/media/v4l2-core/v4l2-mem2mem.c          |  8 ++++----
 drivers/staging/media/imx/imx-ic-prp.c          |  9 +++++++--
 drivers/staging/media/imx/imx-ic-prpencvf.c     |  9 +++++++--
 drivers/staging/media/imx/imx-media-csi.c       |  5 ++++-
 drivers/staging/media/imx/imx-media-vdic.c      |  5 ++++-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c |  2 +-
 include/media/v4l2-mem2mem.h                    | 14 +++++++-------
 include/media/videobuf2-core.h                  |  3 ++-
 14 files changed, 55 insertions(+), 36 deletions(-)
