Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72937C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB6A20823
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 16:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbfBFQ4V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:56:21 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46102 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbfBFQ4V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 11:56:21 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rQUkgBwVcRO5ZrQUlgpNdb; Wed, 06 Feb 2019 17:56:19 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Rui Miguel Silva <rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [GIT PULL FOR v5.1] staging/imx7: add i.MX7 media driver
Message-ID: <3f7aab13-fa42-e40c-78c3-a0727c38a543@xs4all.nl>
Date:   Wed, 6 Feb 2019 17:56:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfC4EBIGam0RXam8Q3IUhbW+lEVof34/ZEu6DW0EL+4ouHfmiBzMk70gDIVhrDBCurrXUHGOFzMeHbJZjG4J9DIM9BHHg1bFCAXEeWJ81hl9XDSdWB9o7
 eg89TjCM9HbZ2CxcgyIMsAj0ioWsFJ1/cSg2+d0q00riUakMz0WcloGDBoOTVFxrAnfHr9TYdmE/kntFH25MOKJPU/TVu4Yplc5Qoy9jLRYopxv0WO4xOJtF
 zvSpXaowz2Vk3/O9ZtawUBx5jtmDMUcL5lXBGbPzhXU/li/6N/p4Zjekqw9Txm05VMdR1YH3gJfAIXAwBSKQcg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-imx7

for you to fetch changes up to a95edaa9069c275170a9ecf5aedc68be974678a2:

  media: MAINTAINERS: add entry for Freescale i.MX7 media driver (2019-02-06 17:15:59 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Rui Miguel Silva (9):
      media: staging/imx: refactor imx media device probe
      media: staging/imx: rearrange group id to take in account IPU
      media: dt-bindings: add bindings for i.MX7 media driver
      media: staging/imx7: add imx7 CSI subdev driver
      media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
      media: imx7.rst: add documentation for i.MX7 media driver
      media: staging/imx: add i.MX7 entries to TODO file
      media: video-mux: add bayer formats
      media: MAINTAINERS: add entry for Freescale i.MX7 media driver

 Documentation/devicetree/bindings/media/imx7-csi.txt       |   45 ++
 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt |   90 +++
 Documentation/media/v4l-drivers/imx7.rst                   |  159 ++++++
 Documentation/media/v4l-drivers/index.rst                  |    1 +
 MAINTAINERS                                                |   11 +
 drivers/media/platform/video-mux.c                         |   20 +
 drivers/staging/media/imx/Kconfig                          |    9 +-
 drivers/staging/media/imx/Makefile                         |    4 +
 drivers/staging/media/imx/TODO                             |    9 +
 drivers/staging/media/imx/imx-ic-common.c                  |    6 +-
 drivers/staging/media/imx/imx-ic-prp.c                     |   16 +-
 drivers/staging/media/imx/imx-media-csi.c                  |    6 +-
 drivers/staging/media/imx/imx-media-dev-common.c           |   90 +++
 drivers/staging/media/imx/imx-media-dev.c                  |  108 +---
 drivers/staging/media/imx/imx-media-internal-sd.c          |   20 +-
 drivers/staging/media/imx/imx-media-of.c                   |    6 +-
 drivers/staging/media/imx/imx-media-utils.c                |   12 +-
 drivers/staging/media/imx/imx-media.h                      |   37 +-
 drivers/staging/media/imx/imx7-media-csi.c                 | 1367 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/imx/imx7-mipi-csis.c                 | 1187 ++++++++++++++++++++++++++++++++++++++
 20 files changed, 3082 insertions(+), 121 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
 create mode 100644 Documentation/media/v4l-drivers/imx7.rst
 create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
 create mode 100644 drivers/staging/media/imx/imx7-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c
