Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B575C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF967218AC
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfCOQo7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:44:59 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48966 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbfCOQo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:44:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 85D952820A3
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 00/16] media: vimc: Add support for multiplanar formats
Date:   Fri, 15 Mar 2019 13:43:43 -0300
Message-Id: <20190315164359.626-1-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This series implements support for multiplane pixel formats at vimc.
A lot of changes were required since vimc support for singleplane
was "hardcoded". The code has been adapted in order to support both
formats. When was possible, the functions were written generically,
avoiding functions for just one type of pixel format (single/multi)
and favoring code reuse.

The debayer subdevice is the only one that currently doesn't supports
multiplanar formats. Documentation to each device will be made in a
future patch.

Thanks,
	André

André Almeida (16):
  media: Move sp2mp functions to v4l2-common
  media: vimc: Remove unnecessary stream check
  media: vimc: Check if the stream is on using ved.stream
  media: vimc: cap: Change vimc_cap_device.format type
  media: vimc: Create multiplanar parameter
  media: vimc: cap: Dynamically define stream pixelformat
  media: vimc: cap: Add handler for singleplanar fmt ioctls
  media: vimc: cap: Add handler for multiplanar fmt ioctls
  media: vimc: cap: Add multiplanar formats
  media: vimc: cap: Add multiplanar default format
  media: vimc: cap: Allocate and verify mplanar buffers
  media: vimc: Add and use new struct vimc_frame
  media: vimc: sen: Add support for multiplanar formats
  media: vimc: sca: Add support for multiplanar formats
  media: vimc: cap: Add support for multiplanar formats
  media: vimc: cap: Dynamically define device caps

 drivers/media/platform/vimc/vimc-capture.c    | 310 +++++++++++++++---
 drivers/media/platform/vimc/vimc-common.c     |  37 +++
 drivers/media/platform/vimc/vimc-common.h     |  50 ++-
 drivers/media/platform/vimc/vimc-core.c       |   8 +
 drivers/media/platform/vimc/vimc-debayer.c    |  38 +--
 drivers/media/platform/vimc/vimc-scaler.c     | 125 ++++---
 drivers/media/platform/vimc/vimc-sensor.c     |  62 ++--
 drivers/media/platform/vimc/vimc-streamer.c   |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  |   6 +-
 .../media/platform/vivid/vivid-vid-common.c   |  59 ----
 .../media/platform/vivid/vivid-vid-common.h   |   9 -
 drivers/media/platform/vivid/vivid-vid-out.c  |   6 +-
 drivers/media/v4l2-core/v4l2-common.c         |  62 ++++
 include/media/v4l2-common.h                   |  31 ++
 14 files changed, 580 insertions(+), 225 deletions(-)

-- 
2.21.0

