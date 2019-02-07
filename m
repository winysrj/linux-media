Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936F1C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 07:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644A1218B0
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 07:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfBGHBg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:01:36 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51052 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfBGHBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 02:01:36 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rdghgrwUoNR5yrdgkgzXYN; Thu, 07 Feb 2019 08:01:34 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Rui Miguel Silva <rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] staging/imx7: add i.MX7 media driver
Message-ID: <5b867d6c-99cb-d8ee-24f9-8b56dcb707cb@xs4all.nl>
Date:   Thu, 7 Feb 2019 08:01:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIj2zP/BmsWlWs+wY8tJ9ATUFjaCSFtueP5bkp+Wa7ehPVUXhAE9dcCIn0JtuPVYPZ7S0ZABQPEJbIlFI+eDbB/b58bdelixt5YvDxWzDjFTiKMrJcQK
 HCrvXN4h1fqkHuSKqPJRs0zlecCuBRN1tgWnVgPgBQRq1M3rddteIgugavSJLeajuTD7Pt2YVCPZlHWVBben41d82QHtRmEGivjvveAwsE1sKgaRiqSCTHAn
 it1rooSzjJvpcORSTH5ApQqKC62Rm2udKnyH86JOID6NxDBUc92KBx4l7/d8eJTE4lj36foeO7beGzjR5gMwWw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This pull request supersedes https://patchwork.linuxtv.org/patch/54350/ after the
kbuild test robot found a small issue that is now fixed in this PR.

Regards,

	Hans

The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-imx7b

for you to fetch changes up to 7fc5e80b3c476674bc8cebd4d012e63d8ff6f5fa:

  media: MAINTAINERS: add entry for Freescale i.MX7 media driver (2019-02-07 07:57:55 +0100)

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
