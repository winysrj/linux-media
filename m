Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEE6C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D8D2070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfCDT0h (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:26:37 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50272 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDT0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 14:26:37 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id C923A276DFA
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 00/11] Add MPEG-2 decoding to Rockchip VPU
Date:   Mon,  4 Mar 2019 16:25:18 -0300
Message-Id: <20190304192529.14200-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series introduces the decoding infrastructure that will be
used to add support for other codecs such as VP8, VP9 and H.264.

As explained in the cover letter for the v1 patchset,
the driver is now exposing two video device nodes.
The VPU encoder is exposed on /dev/video0, and the VPU decoder
is exposed on /dev/video1. Both devices are tied to the same
memory-to-memory queue, and same media device /dev/media0.

Therefore there are two media graphs:

┌────────────────────────────────┐
│ rockchip,rk3399-vpu-enc-source │
│          /dev/video0           │
└────────────────────────────────┘
  ┃
  ┃
  ▼
┌────────────────────────────────┐
│  rockchip,rk3399-vpu-enc-proc  │
└────────────────────────────────┘
  ┃
  ┃
  ▼
┌────────────────────────────────┐
│  rockchip,rk3399-vpu-enc-sink  │
│          /dev/video0           │
└────────────────────────────────┘

┌────────────────────────────────┐
│ rockchip,rk3399-vpu-dec-source │
│          /dev/video1           │
└────────────────────────────────┘
  ┃
  ┃
  ▼
┌────────────────────────────────┐
│  rockchip,rk3399-vpu-dec-proc  │
└────────────────────────────────┘
  ┃
  ┃
  ▼
┌────────────────────────────────┐
│  rockchip,rk3399-vpu-dec-sink  │
│          /dev/video1           │
└────────────────────────────────┘

Of course, this work has been possible thanks to Jonas Karlman, who did the initial
MPEG-2 decoding work and also got mpv+ffmpeg working using the Request API.

This driver can be tested using mpv+ffmpeg for the video
decoding side, and the Panfrost mesa driver for rendering.

I should be posting instructions to set all of this up,
and also will be submitting the support for H264, VP8 and VP9,
hopefully very soon.

v2:
  * Fixed some minor issues brought up by v4l2-compliance.
  * Fixed bytesused wrongly assigned 0 on the MPEG-2 decoder.
  * Addressed comments from Hans and Tomasz on the pixel format
    helpers.

Ezequiel Garcia (10):
  rockchip/vpu: Rename pixel format helpers
  media: Introduce helpers to fill pixel format structs
  rockchip/vpu: Use pixel format helpers
  rockchip/vpu: Use v4l2_m2m_buf_copy_metadata
  rockchip/vpu: Cleanup macroblock alignment
  rockchip/vpu: Cleanup JPEG bounce buffer management
  rockchip/vpu: Open-code media controller register
  rockchip/vpu: Support the Request API
  rockchip/vpu: Add decoder boilerplate
  rockchip/vpu: Add support for non-standard controls

Jonas Karlman (1):
  rockchip/vpu: Add support for MPEG-2 decoding

 drivers/media/v4l2-core/v4l2-common.c         | 186 ++++++
 drivers/staging/media/rockchip/vpu/Makefile   |   5 +-
 .../media/rockchip/vpu/rk3288_vpu_hw.c        |   4 +-
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     |   4 +-
 .../media/rockchip/vpu/rk3399_vpu_hw.c        |  61 +-
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     |  10 +-
 .../rockchip/vpu/rk3399_vpu_hw_mpeg2_dec.c    | 263 +++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 115 +++-
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  10 +
 .../media/rockchip/vpu/rockchip_vpu_dec.c     | 558 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 440 ++++++++++++--
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 152 ++---
 .../media/rockchip/vpu/rockchip_vpu_hw.h      |  42 ++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.c    |  25 +
 .../media/rockchip/vpu/rockchip_vpu_mpeg2.c   |  61 ++
 include/media/v4l2-common.h                   |  32 +
 16 files changed, 1795 insertions(+), 173 deletions(-)
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_mpeg2_dec.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_mpeg2.c

-- 
2.20.1

