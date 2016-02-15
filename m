Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36355 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbcBOKNc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 05:13:32 -0500
Subject: Re: [PATCH v4 2/8] [media] VPU: mediatek: support Mediatek VPU
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C1A4C6.7040601@xs4all.nl>
Date: Mon, 15 Feb 2016 11:13:26 +0100
MIME-Version: 1.0
In-Reply-To: <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2016 12:34 PM, Tiffany Lin wrote:
> The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
> It is able to handle video decoding/encoding of in a range of formats.
> The driver provides with VPU firmware download, memory management and
> the communication interface between CPU and VPU.
> For VPU initialization, it will create virtual memory for CPU access and
> IOMMU address for vcodec hw device access. When a decode/encode instance
> opens a device node, vpu driver will download vpu firmware to the device.
> A decode/encode instant will decode/encode a frame using VPU
> interface to interrupt vpu to handle decoding/encoding jobs.
> 
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/Kconfig           |    9 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/mtk-vpu/Makefile  |    1 +
>  drivers/media/platform/mtk-vpu/mtk_vpu.c |  994 ++++++++++++++++++++++++++++++
>  drivers/media/platform/mtk-vpu/mtk_vpu.h |  167 +++++
>  5 files changed, 1173 insertions(+)
>  create mode 100644 drivers/media/platform/mtk-vpu/Makefile
>  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
>  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index ccbc974..ba812d6 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -148,6 +148,15 @@ config VIDEO_CODA
>  	   Coda is a range of video codec IPs that supports
>  	   H.264, MPEG-4, and other video formats.
>  
> +config VIDEO_MEDIATEK_VPU
> +	tristate "Mediatek Video Processor Unit"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MEDIATEK
> +	---help---
> +	    This driver provides downloading VPU firmware and
> +	    communicating with VPU. This driver for hw video
> +	    codec embedded in new Mediatek's SOCs. It is able
> +	    to handle video decoding/encoding in a range of formats.

Can you be more specific in this text and mention for which Mediatek SoCs
this driver is for? Just like you did in the commit log.

Also add something like this:

          To compile this driver as a module, choose M here: the module
          will be called mtk-vpu.

I always find it useful if the Kconfig text mentions the module name.

Regards,

	Hans

> +
>  config VIDEO_MEM2MEM_DEINTERLACE
>  	tristate "Deinterlace support"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE

