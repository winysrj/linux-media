Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA47C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D1D2086C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfBHKVj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:21:39 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44383 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbfBHKVj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 05:21:39 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s3HsgzNO3BDyIs3HtgLyLZ; Fri, 08 Feb 2019 11:21:37 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes, mostly adv748x
Message-ID: <8c1e21f4-566d-4c69-a985-983fb25d8c76@xs4all.nl>
Date:   Fri, 8 Feb 2019 11:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCvRie5BxYs1hxXOC1IJvve+1WszcZAh8t2D2qWAgECfn+eznYFDOGfwbX9VdTtVXK4sh/9ii5ZAy47bitHa1qMF+DLl6CrypTi26TxwpLBrrtS9MJVR
 EkYvowx22HNfbGdcjDls4RghCN06t2YcdP5AuToYj8JRAjb9lzPrtvZZJ5XpH9q/HS6gepWaie1df7dI+pdVpzDmj8RbLIvt9nZEHJPzOO06CaRC5o+Im8lQ
 uaZrGzxIuMNo59Bk1lK9Vq+Q6TJM/u2BeXsd1yZRxf9/9joEpXj5Zl2x8SzJEb6WrWAQxQyJQZNFtnj0H0u5rQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1n

for you to fetch changes up to 72a98aaee48bd2980d1d18f212972201ed036fb0:

  media: i2c: adv748x: Remove PAGE_WAIT (2019-02-08 11:19:26 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (2):
      vimc: add USERPTR support
      v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable

Jacopo Mondi (6):
      media: adv748x: Add is_txb()
      media: adv748x: Rename reset procedures
      media: adv748x: csi2: Link AFE with TXA and TXB
      media: adv748x: Store the source subdevice in TX
      media: adv748x: Store the TX sink in HDMI/AFE
      media: adv748x: Implement TX link_setup callback

Kieran Bingham (2):
      media: i2c: adv748x: Convert SW reset routine to function
      media: i2c: adv748x: Remove PAGE_WAIT

Lucas A. M. Magalhães (1):
      media: vimc: Remove unused but set variables

Steve Longerbeam (1):
      media: imx: Set capture compose rectangle in capture_device_set_format

 drivers/media/i2c/adv748x/adv748x-afe.c       |   2 +-
 drivers/media/i2c/adv748x/adv748x-core.c      | 125 ++++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/i2c/adv748x/adv748x-csi2.c      |  64 +++++++++++++++++++-----------
 drivers/media/i2c/adv748x/adv748x-hdmi.c      |   2 +-
 drivers/media/i2c/adv748x/adv748x.h           |  27 ++++++++++++-
 drivers/media/platform/vimc/vimc-capture.c    |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c     |   7 ----
 drivers/staging/media/imx/imx-ic-prpencvf.c   |   5 ++-
 drivers/staging/media/imx/imx-media-capture.c |  24 +++++------
 drivers/staging/media/imx/imx-media-csi.c     |   5 ++-
 drivers/staging/media/imx/imx-media-utils.c   |  20 +++++++---
 drivers/staging/media/imx/imx-media.h         |   6 ++-
 include/media/v4l2-subdev.h                   |   7 ++--
 13 files changed, 198 insertions(+), 98 deletions(-)
