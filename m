Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC7BC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 14:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 690732175B
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 14:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfCSOwu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:52:50 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37448 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCSOwu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 10:52:50 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id BCAAC2808D0;
        Tue, 19 Mar 2019 14:52:48 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [RFC PATCH 0/3] media: v4l2: Add extended fmt and buffer ioctls
Date:   Tue, 19 Mar 2019 15:52:40 +0100
Message-Id: <20190319145243.25047-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This RFC follows the discussion started by Hans [1] a few months back.
It does not try to address all the problem reported in this thread but
instead focuses on the FMT and BUF(S) ioctls.

Note that my primary goal is to unify handling for multiplanar and
singleplanar formats and extend things to support the "single dmabuf
storing all pixel planes" issue.

This is just preliminary work, and nothing has been tested yet (still
patching the VB2/VIVID code to test everything), but it should give
a good idea of what the new APIs could look like. I hope to get
feedback early on so I can adjust the structs/hooks before going into
heavy refactoring of the VB2 core (and drivers depending on the VB2
helpers).

One last thing, I'm new to the media/v4l2 subsystem, so I likely got a
few things wrong.

Regards,

Boris

[1]https://www.mail-archive.com/linux-media@vger.kernel.org/msg135729.html

Boris Brezillon (2):
  media: v4l2: Get rid of ->vidioc_enum_fmt_vid_{cap,out}_mplane
  media: v4l2: Extend pixel formats to unify single/multi-planar
    handling (and more)

Hans Verkuil (1):
  media: v4l2: Add extended buffer operations

 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |   2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |   4 +-
 .../media/platform/exynos4-is/fimc-capture.c  |   2 +-
 .../platform/exynos4-is/fimc-isp-video.c      |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |   2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c  |   4 +-
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   |   4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  |   4 +-
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      |   4 +-
 .../platform/mtk-vcodec/mtk_vcodec_enc.c      |   4 +-
 .../media/platform/qcom/camss/camss-video.c   |   2 +-
 drivers/media/platform/qcom/venus/vdec.c      |   4 +-
 drivers/media/platform/qcom/venus/venc.c      |   4 +-
 drivers/media/platform/rcar_fdp1.c            |   4 +-
 drivers/media/platform/rcar_jpu.c             |   4 +-
 drivers/media/platform/renesas-ceu.c          |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   4 +-
 drivers/media/platform/ti-vpe/vpe.c           |   4 +-
 drivers/media/platform/vicodec/vicodec-core.c |   2 -
 drivers/media/platform/vivid/vivid-core.c     |   6 +-
 .../media/platform/vivid/vivid-vid-common.c   |  20 -
 .../media/platform/vivid/vivid-vid-common.h   |   2 -
 drivers/media/v4l2-core/v4l2-common.c         | 281 ++++++
 drivers/media/v4l2-core/v4l2-dev.c            |  32 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          | 831 +++++++++++++++---
 drivers/staging/media/ipu3/ipu3-v4l2.c        |   4 +-
 .../media/rockchip/vpu/rockchip_vpu_enc.c     |   4 +-
 include/media/v4l2-common.h                   |  12 +
 include/media/v4l2-ioctl.h                    |  65 +-
 include/uapi/linux/videodev2.h                | 207 +++++
 31 files changed, 1332 insertions(+), 198 deletions(-)

-- 
2.20.1

