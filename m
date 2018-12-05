Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5750DC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25CDF2084C
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25CDF2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbeLEQ3p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:29:45 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38393 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727195AbeLEQ3p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 11:29:45 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id Ua3OgR6XcO44XUa3SgQgIu; Wed, 05 Dec 2018 17:29:42 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Rockchip VPU JPEG encoder driver
Message-ID: <c7c87316-983a-6918-592c-337a1dc6a739@xs4all.nl>
Date:   Wed, 5 Dec 2018 17:29:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFJ1Urvf5DEHDzyJL707vvP2oPugLkRAviKXUX3kgLUnBr9ffx1lO5XO0SANs0ngfGHx1+CtRcZ8at+O2OjV2b6ZGw3nE2UK56HQQXDEbE0ntf481Hdp
 XhgPVGcYD1aK8B2EA2xPGdvoCXQrxp/a/QzZMKJ7nUpmMzvVETR3+nMAjVT5wjAD0RDd+NKfeam0etTBcVpIpny3FagCjHipM4c=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Note regarding the first 'Revert' patch: that is this patch:

https://patchwork.linuxtv.org/patch/52869/

It is currently pending for 4.20 as a fix, but since it is not merged upstream
yet, our master branch still has those old bindings.

I decided to first apply the Revert patch, then add the new patch on top.

Regards,

	Hans

The following changes since commit da2c94c8f9739e4099ea3cfefc208fc721b22a9c:

  media: v4l2: async: remove locking when initializing async notifier (2018-12-05 06:51:28 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-rkjpeg2

for you to fetch changes up to 7f608cfd52c08e7d84bd38438e330c26263eddcb:

  media: add Rockchip VPU JPEG encoder driver (2018-12-05 17:18:46 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (3):
      Revert "media: dt-bindings: Document the Rockchip VPU bindings"
      media: dt-bindings: Document the Rockchip VPU bindings
      media: add Rockchip VPU JPEG encoder driver

 MAINTAINERS                                                 |   7 +
 drivers/staging/media/Kconfig                               |   2 +
 drivers/staging/media/Makefile                              |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig                  |  13 +
 drivers/staging/media/rockchip/vpu/Makefile                 |  10 +
 drivers/staging/media/rockchip/vpu/TODO                     |  13 +
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c          | 118 +++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c | 130 ++++++++
 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h        | 442 ++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c          | 118 +++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c | 164 ++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h        | 600 +++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu.h           | 232 ++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h    |  29 ++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c       | 537 +++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c       | 676 ++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h        |  58 ++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c      | 290 +++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h      |  14 +
 19 files changed, 3454 insertions(+)
 create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
 create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
 create mode 100644 drivers/staging/media/rockchip/vpu/TODO
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
