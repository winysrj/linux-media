Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71CEC10F00
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747982147C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Cx5OPdga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfBQCtC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45148 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfBQCtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:01 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B21D349;
        Sun, 17 Feb 2019 03:48:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371739;
        bh=DP6XNzroNh0zZw8oYwbqya//5pP2zRagF+wQ4+L+daQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Cx5OPdga4crRRrd0L3S15TpSo39GC29qmQTDvKDvHZ3i5Lc8q4gKlrAVrrLfLQfx8
         c3K4EtOiLAFbXOiabLqhhjrMj4fYhmyLRXVQWs3f6FdDPlksBMsLWVeDunEkgY+S1q
         9FgnbRiPf19O3hlhzg7Wac9oHCV/kxiQI1WVerSg=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 0/7] VSP1: Display writeback support
Date:   Sun, 17 Feb 2019 04:48:45 +0200
Message-Id: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This patch series implements display writeback support for the R-Car
Gen3 platforms in the VSP1 driver.

DRM/KMS provides a writeback API through a special type of writeback
connectors. This series takes a different approach by exposing writeback
as a V4L2 device. While there is nothing fundamentally wrong with
writeback connectors, display for R-Car Gen3 platforms relies on the
VSP1 driver behind the scene, which already implements V4L2 support.
Enabling writeback through V4L2 is thus significantly easier in this
case.

The writeback pixel format is restricted to RGB, due to the VSP1
outputting RGB to the display and lacking a separate colour space
conversion unit for writeback. The resolution can be freely picked by
will result in cropping or composing, not scaling.

Writeback requests are queued to the hardware on page flip (atomic
flush), and complete at the next vblank. This means that a queued
writeback buffer will not be processed until the next page flip, but
once it starts being written to by the VSP, it will complete at the next
vblank regardless of whether another page flip occurs at that time.

The code is based on a merge of the media master branch, the drm-next
branch and the R-Car DT next branch. For convenience patches can be
found at

	git://linuxtv.org/pinchartl/media.git v4l2/vsp1/writeback

Kieran Bingham (2):
  Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
  media: vsp1: Provide a writeback video device

Laurent Pinchart (5):
  media: vsp1: wpf: Fix partition configuration for display pipelines
  media: vsp1: Replace leftover occurrence of fragment with body
  media: vsp1: Fix addresses of display-related registers for VSP-DL
  media: vsp1: Refactor vsp1_video_complete_buffer() for later reuse
  media: vsp1: Replace the display list internal flag with a flags field

 drivers/media/platform/vsp1/vsp1_dl.c    | 118 ++++++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_drm.c   |  24 ++-
 drivers/media/platform/vsp1/vsp1_drv.c   |  17 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
 drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
 drivers/media/platform/vsp1/vsp1_regs.h  |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
 drivers/media/platform/vsp1/vsp1_video.c | 198 +++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_video.h |   6 +
 drivers/media/platform/vsp1/vsp1_wpf.c   |  65 ++++++--
 11 files changed, 378 insertions(+), 75 deletions(-)

-- 
Regards,

Laurent Pinchart

