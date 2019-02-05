Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD05C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8AC820818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfBEUYn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:24:43 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41726 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfBEUYn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:24:43 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 6AA6B28020E
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v1 00/10] Add MPEG-2 decoding to Rockchip VPU
Date:   Tue,  5 Feb 2019 17:24:07 -0300
Message-Id: <20190205202417.16555-1-ezequiel@collabora.com>
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

There are a number of v4l2-compliance issues, which I
will be addressing shortly. For those wanting to take
a peep, I've pasted the v4l2-compliance issues here: http://ix.io/1AfJ.

Minor issues aside, "release early" they say, so here it is!

About the JPEG bounce buffer, we can probably get rid of it,
but for now, it's fine to keep it as it won't affect video decoding.

About the media controller topology change, which is no doubt
the nastiest change in this series, it's important to mention
that we need multiple video interface nodes: one video node
for encoding, and one video node for decoding.

Since the VPU is a single engine, it needs a single mem2mem device
to serialize the codec jobs thru it, taking advantage of the
whole mem2mem infrastructure.

This works perfectly well, but requires a somewhat involved topology.
For the encoder the graph goes like this:

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

For the decoder the graph goes like this:

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

Both are tied to the same media device,
i.e. /dev/media0. Does this comply with the media
controller specification?

The pixel format helpers deserve a discussion of its own.
Note that these helpers will be useful for probably
most V4L drivers. See for instance, this recent bug
caused by bad math in vivid's sizeimage calculations:

https://patchwork.kernel.org/patch/10796201/

Finally, I have to thank Jonas Karlman, who did the initial
MPEG-2 decoding work and also for getting mpv+ffmpeg to
work using the Request API.

This driver can be tested using mpv+ffmpeg for the video
decoding side, and the Panfrost mesa driver for rendering.

I should be posting instructions to set all of this up,
and also will be submitting the support for H264, VP8 and VP9,
hopefully very soon.

Ezequiel Garcia (9):
  media: Introduce helpers to fill pixel format structs
  rockchip/vpu: Use pixel format helpers
  rockchip/vpu: Use v4l2_m2m_buf_copy_data
  rockchip/vpu: Cleanup macroblock alignment
  rockchip/vpu: Cleanup JPEG bounce buffer management
  rockchip/vpu: Open-code media controller register
  rockchip/vpu: Support the Request API
  rockchip/vpu: Add decoder boilerplate
  rockchip/vpu: Add support for non-standard controls

Jonas Karlman (1):
  rockchip/vpu: Add support for MPEG-2 decoding

 drivers/media/v4l2-core/Makefile              |   2 +-
 drivers/media/v4l2-core/v4l2-common.c         |  71 +++
 drivers/media/v4l2-core/v4l2-fourcc.c         | 109 ++++
 drivers/staging/media/rockchip/vpu/Makefile   |   5 +-
 .../media/rockchip/vpu/rk3288_vpu_hw.c        |   4 +-
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     |   4 +-
 .../media/rockchip/vpu/rk3399_vpu_hw.c        |  61 +-
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     |  10 +-
 .../rockchip/vpu/rk3399_vpu_hw_mpeg2_dec.c    | 263 +++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 115 +++-
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  10 +
 .../media/rockchip/vpu/rockchip_vpu_dec.c     | 557 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 426 ++++++++++++--
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 152 ++---
 .../media/rockchip/vpu/rockchip_vpu_hw.h      |  42 ++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.c    |  25 +
 .../media/rockchip/vpu/rockchip_vpu_mpeg2.c   |  61 ++
 include/media/v4l2-common.h                   |   5 +
 include/media/v4l2-fourcc.h                   |  53 ++
 19 files changed, 1803 insertions(+), 172 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-fourcc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_mpeg2_dec.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_dec.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_mpeg2.c
 create mode 100644 include/media/v4l2-fourcc.h

-- 
2.20.1

