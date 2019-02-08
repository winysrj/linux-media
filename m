Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63292C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEC920844
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfBHQSF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:18:05 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55388 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfBHQSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:18:05 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id B7D2027F68B
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 00/10] Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:38 -0300
Message-Id: <20190208161748.5862-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As the subject says, we want to fix the return type
of these mem2mem buffer helpers. They are currently returning
a void pointer, which prevents type checking.

The patchset turned out to be much bigger than I was expecting,
so it's splitted in per-driver patches.

It'd be awesome if driver maintainers can take review
the changes.

Thanks!

Ezequiel Garcia (10):
  mtk-jpeg: Correct return type for mem2mem buffer helpers
  mtk-mdp: Correct return type for mem2mem buffer helpers
  mtk-vcodec: Correct return type for mem2mem buffer helpers
  mx2_emmaprp: Correct return type for mem2mem buffer helpers
  rockchip/rga: Correct return type for mem2mem buffer helpers
  s5p-g2d: Correct return type for mem2mem buffer helpers
  s5p-jpeg: Correct return type for mem2mem buffer helpers
  sh_veu: Correct return type for mem2mem buffer helpers
  rockchip/vpu: Correct return type for mem2mem buffer helpers
  media: v4l2-mem2mem: Correct return type for mem2mem buffer helpers

 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   | 40 +++++------
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 20 ++----
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      | 62 +++++++---------
 .../platform/mtk-vcodec/mtk_vcodec_enc.c      | 72 ++++++++-----------
 drivers/media/platform/mx2_emmaprp.c          |  6 +-
 drivers/media/platform/rockchip/rga/rga.c     |  6 +-
 drivers/media/platform/s5p-g2d/g2d.c          |  6 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c   | 38 +++++-----
 drivers/media/platform/sh_veu.c               |  4 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  6 +-
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     |  6 +-
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     |  6 +-
 include/media/v4l2-mem2mem.h                  | 18 ++---
 13 files changed, 129 insertions(+), 161 deletions(-)

-- 
2.20.1

