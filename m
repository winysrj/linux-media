Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:27999 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751194AbcINEw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 00:52:58 -0400
Message-ID: <1473828757.25758.4.camel@mtksdaap41>
Subject: Re: [PATCH 0/4] Add V4L2_PIX_FMT_MT21C format for MT8173 codec
 driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Date: Wed, 14 Sep 2016 12:52:37 +0800
In-Reply-To: <64676168-8c5f-3720-820a-17e7bdbcc735@xs4all.nl>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
         <e4d91e67-0b36-3675-575a-c5f38a68dbdb@xs4all.nl>
         <1473325879.26612.2.camel@mtksdaap41>
         <64676168-8c5f-3720-820a-17e7bdbcc735@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 2016-09-08 at 11:27 +0200, Hans Verkuil wrote:
> On 09/08/16 11:11, Tiffany Lin wrote:
> > Hi Hans,
> >
> > On Thu, 2016-09-08 at 09:21 +0200, Hans Verkuil wrote:
> >> Hi Tiffany,
> >>
> >> On 09/07/2016 08:56 AM, Tiffany Lin wrote:
> >>> This patch series add Mediatek compressed block format V4L2_PIX_FMT_MT21C, the
> >>> decoder driver will decoded bitstream to V4L2_PIX_FMT_MT21C format.
> >>>
> >>> User space applications could use MT8173 MDP driver to convert V4L2_PIX_FMT_MT21C to
> >>> V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
> >>>
> >>> MDP driver[1] is stand alone driver.
> >>>
> >>> Usage:
> >>> MT21C -> MT8173 MDP -> NV12M/YUV420M/YVU420
> >>> NV12M/NV21M/YUV420M/YVU420M -> mt8173 Encoder -> H264/VP8
> >>> H264/VP8/VP9 -> mtk8173 Decoder -> MT21C
> >>>
> >>> When encode with MT21 source, the pipeline will be:
> >>> MT21C -> MDP driver-> NV12M/NV21M/YUV420M/YVU420M -> Encoder -> H264/VP8
> >>>
> >>> When playback, the pipeline will be:
> >>> H264/VP8/VP9 -> Decoder driver -> MT21C -> MDP Driver -> DRM
> >>>
> >>> [1]https://patchwork.kernel.org/patch/9305329/
> >>>
> >>> Tiffany Lin (4):
> >>>   v4l: add Mediatek compressed video block format
> >>>   docs-rst: Add compressed video formats used on MT8173 codec driver
> >>>   vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
> >>>   arm64: dts: mediatek: Add Video Decoder for MT8173
> >>>
> >>>  Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    6 +++
> >>>  arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   44 ++++++++++++++++++++
> >>>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    7 +++-
> >>>  drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
> >>>  include/uapi/linux/videodev2.h                     |    1 +
> >>>  5 files changed, 58 insertions(+), 1 deletion(-)
> >>>
> >>
> >> So basically the video decoder is useless without support for this format and
> >> without the MDP driver, right?
> >>
> > Yes. It also require new vpu firmware.
> > Andrew will help release new vpu firmware include encode/decode/mdp
> > capability.
> 
> OK, then I'll park this until:
> 
> - the MT21C patch series is OK
> - the MDP patch series is OK
> - the new firmware is released
> 

> For the record: the decoder patch series is OK as far as I am concerned.
> It's in my mtkdec branch.
> 

Appreciated for your help.
We had upstream new MT21C, MDP and new VPU firmware.

MT21C patch series: https://patchwork.kernel.org/patch/9323883/
MDP patch series: https://patchwork.kernel.org/patch/9321343/
VPU firmware: https://patchwork.linuxtv.org/patch/36968/


best regards,
Tiffany



> Regards,
> 
> 	Hans


