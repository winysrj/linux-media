Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42869 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751979AbcIHHVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 03:21:48 -0400
Subject: Re: [PATCH 0/4] Add V4L2_PIX_FMT_MT21C format for MT8173 codec driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e4d91e67-0b36-3675-575a-c5f38a68dbdb@xs4all.nl>
Date: Thu, 8 Sep 2016 09:21:42 +0200
MIME-Version: 1.0
In-Reply-To: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

On 09/07/2016 08:56 AM, Tiffany Lin wrote:
> This patch series add Mediatek compressed block format V4L2_PIX_FMT_MT21C, the
> decoder driver will decoded bitstream to V4L2_PIX_FMT_MT21C format.
> 
> User space applications could use MT8173 MDP driver to convert V4L2_PIX_FMT_MT21C to
> V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
> 
> MDP driver[1] is stand alone driver.
> 
> Usage:
> MT21C -> MT8173 MDP -> NV12M/YUV420M/YVU420
> NV12M/NV21M/YUV420M/YVU420M -> mt8173 Encoder -> H264/VP8
> H264/VP8/VP9 -> mtk8173 Decoder -> MT21C
> 
> When encode with MT21 source, the pipeline will be:
> MT21C -> MDP driver-> NV12M/NV21M/YUV420M/YVU420M -> Encoder -> H264/VP8
> 
> When playback, the pipeline will be:
> H264/VP8/VP9 -> Decoder driver -> MT21C -> MDP Driver -> DRM
> 
> [1]https://patchwork.kernel.org/patch/9305329/
> 
> Tiffany Lin (4):
>   v4l: add Mediatek compressed video block format
>   docs-rst: Add compressed video formats used on MT8173 codec driver
>   vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
>   arm64: dts: mediatek: Add Video Decoder for MT8173
> 
>  Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    6 +++
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   44 ++++++++++++++++++++
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    7 +++-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
>  include/uapi/linux/videodev2.h                     |    1 +
>  5 files changed, 58 insertions(+), 1 deletion(-)
> 

So basically the video decoder is useless without support for this format and
without the MDP driver, right?

I'm wondering if I should hold off on merging the decoder driver until these two
are in. What is the timeline for v6 of the MDP driver?

If a v6 is posted early next week, then I have time to review and (assuming it is
OK) I can make a pull request for both this driver and the MDP driver.

If it takes longer, then there is a good chance that it will slip to 4.10. I will
have very little time in the period September 20 - October 14.

Regards,

	Hans
