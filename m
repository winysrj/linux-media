Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:48305 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753263AbcIIPsR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 11:48:17 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v2 0/4] Add V4L2_PIX_FMT_MT21C format for MT8173 codec driver 
Date: Fri, 9 Sep 2016 23:48:03 +0800
Message-ID: <1473436087-21943-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add Mediatek compressed block format V4L2_PIX_FMT_MT21C,
the decoder driver will decoded bitstream to V4L2_PIX_FMT_MT21C format.

User space applications could use MT8173 MDP driver to convert V4L2_PIX_FMT_MT21C
to V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
MDP driver[1] is stand alone driver.

Usage:
MT21C -> MT8173 MDP -> NV12M/YUV420M/YVU420 NV12M/NV21M/YUV420M/YVU420M -> mt8173 Encoder -> H264/VP8
H264/VP8/VP9 -> mtk8173 Decoder -> MT21C

When encode with MT21 source, the pipeline will be:
MT21C -> MDP driver-> NV12M/NV21M/YUV420M/YVU420M -> Encoder -> H264/VP8

When playback, the pipeline will be:
H264/VP8/VP9 -> Decoder driver -> MT21C -> MDP Driver -> DRM

[1]https://patchwork.kernel.org/patch/9305329/

---
v2: add more information for MT21C in docs-rst
---


Tiffany Lin (4):
  v4l: add Mediatek compressed video block format
  docs-rst: Add compressed video formats used on MT8173 codec driver
  vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
  arm64: dts: mediatek: Add Video Decoder for MT8173

 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |   10 +++++
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   44 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    7 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
 include/uapi/linux/videodev2.h                     |    1 +
 5 files changed, 62 insertions(+), 1 deletion(-)

-- 
1.7.9.5

