Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:2783 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932855AbcIGG44 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:56:56 -0400
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
Subject: [PATCH 0/4] Add V4L2_PIX_FMT_MT21C format for MT8173 codec driver
Date: Wed, 7 Sep 2016 14:56:39 +0800
Message-ID: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add Mediatek compressed block format V4L2_PIX_FMT_MT21C, the
decoder driver will decoded bitstream to V4L2_PIX_FMT_MT21C format.

User space applications could use MT8173 MDP driver to convert V4L2_PIX_FMT_MT21C to
V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.

MDP driver[1] is stand alone driver.

Usage:
MT21C -> MT8173 MDP -> NV12M/YUV420M/YVU420
NV12M/NV21M/YUV420M/YVU420M -> mt8173 Encoder -> H264/VP8
H264/VP8/VP9 -> mtk8173 Decoder -> MT21C

When encode with MT21 source, the pipeline will be:
MT21C -> MDP driver-> NV12M/NV21M/YUV420M/YVU420M -> Encoder -> H264/VP8

When playback, the pipeline will be:
H264/VP8/VP9 -> Decoder driver -> MT21C -> MDP Driver -> DRM

[1]https://patchwork.kernel.org/patch/9305329/

Tiffany Lin (4):
  v4l: add Mediatek compressed video block format
  docs-rst: Add compressed video formats used on MT8173 codec driver
  vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
  arm64: dts: mediatek: Add Video Decoder for MT8173

 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    6 +++
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   44 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    7 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
 include/uapi/linux/videodev2.h                     |    1 +
 5 files changed, 58 insertions(+), 1 deletion(-)

-- 
1.7.9.5

