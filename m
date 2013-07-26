Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37391 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3GZJcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:32:48 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so1810308pab.7
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:32:47 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 0/7] [media] vsp1: Add VIO6 support
Date: Fri, 26 Jul 2013 18:32:10 +0900
Message-Id: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Could you please consider the following patches to add VIO6 support
into your VSP1 driver implementation?
Any comments or ideas of better implementation are of course welcome.

The first two patches are fixes, not only for VIO6.
The next four patches are preparations of supporting multiple
versions of the H/W IP.
The final one is adding definitions of VIO6.

The code has been tested on an Armadillo800EVA board.

The series is based on the following patchset:
 [PATCH v3 0/5] Renesas VSP1 driver
 [PATCH v3 1/5] media: Add support for circular graph traversal
 [PATCH v3 2/5] v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
 [PATCH v3 3/5] v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
 [PATCH v3 4/5] v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
 [PATCH v3 5/5] v4l: Renesas R-Car VSP1 driver


Katsuya Matsubara (7):
  [media] vsp1: Fix lack of the sink entity setting for enabled links.
  [media] vsp1: Use the maximum number defined in platform data
  [media] vsp1: Rewrite the definition of registers' offset as enum and
    arrays
  [media] vsp1: Rewrite the value definitions for DPR routing as enum
    and arrays
  [media] vsp1: Introduce bit operations for the DPR route registers
  [media] vsp1: Move the DPR_WPF_FPORCH register settings into the
    device initialization
  [media] vsp1: Add VIO6 support

 drivers/media/platform/vsp1/vsp1.h        |   23 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |  492 ++++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_entity.c |   31 +-
 drivers/media/platform/vsp1/vsp1_entity.h |    3 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |    2 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  497 +++++++++++++++++------------
 drivers/media/platform/vsp1/vsp1_rpf.c    |   19 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   14 +-
 drivers/media/platform/vsp1/vsp1_video.c  |   27 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |   29 +-
 10 files changed, 849 insertions(+), 288 deletions(-)

-- 
Thanks,

Katsuya Matsubara / IGEL Co., Ltd.
matsu@igel.co.jp
