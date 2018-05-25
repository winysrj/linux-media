Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f52.google.com ([209.85.160.52]:41409 "EHLO
        mail-pl0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030721AbeEYXxp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:53:45 -0400
Received: by mail-pl0-f52.google.com with SMTP id az12-v6so3974270plb.8
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:53:45 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 0/6] imx-media: Fixes for bt.656 interlaced capture
Date: Fri, 25 May 2018 16:53:30 -0700
Message-Id: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A set of patches that fixes some bugs with capturing from a bt.656
interlaced source, and incompatibilites between IDMAC interlace
interweaving and 4:2:0 data write reduction.

Steve Longerbeam (6):
  media: imx-csi: Fix interlaced bt.656
  gpu: ipu-csi: Check for field type alternate
  media: videodev2.h: Add macro V4L2_FIELD_IS_SEQUENTIAL
  media: imx-csi: Enable interlaced scan for field type alternate
  media: imx-csi: Allow skipping odd chroma rows for YVU420
  media: staging/imx: interweave and odd-chroma-row skip are
    incompatible

 drivers/gpu/ipu-v3/ipu-csi.c                |  3 ++-
 drivers/staging/media/imx/imx-ic-prpencvf.c | 18 ++++++++++++-----
 drivers/staging/media/imx/imx-media-csi.c   | 31 ++++++++++++++---------------
 include/uapi/linux/videodev2.h              |  4 ++++
 4 files changed, 34 insertions(+), 22 deletions(-)

-- 
2.7.4
