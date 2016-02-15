Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:1303 "EHLO
	mailgw02.hq.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbcBOL1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 06:27:42 -0500
Message-ID: <1455535656.27088.6.camel@mtksdaap41>
Subject: Re: [PATCH v4 2/8] [media] VPU: mediatek: support Mediatek VPU
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Date: Mon, 15 Feb 2016 19:27:36 +0800
In-Reply-To: <56C1A4C6.7040601@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <56C1A4C6.7040601@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-02-15 at 11:13 +0100, Hans Verkuil wrote:
> On 02/04/2016 12:34 PM, Tiffany Lin wrote:
> > The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
> > It is able to handle video decoding/encoding of in a range of formats.
> > The driver provides with VPU firmware download, memory management and
> > the communication interface between CPU and VPU.
> > For VPU initialization, it will create virtual memory for CPU access and
> > IOMMU address for vcodec hw device access. When a decode/encode instance
> > opens a device node, vpu driver will download vpu firmware to the device.
> > A decode/encode instant will decode/encode a frame using VPU
> > interface to interrupt vpu to handle decoding/encoding jobs.
> > 
> > Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  drivers/media/platform/Kconfig           |    9 +
> >  drivers/media/platform/Makefile          |    2 +
> >  drivers/media/platform/mtk-vpu/Makefile  |    1 +
> >  drivers/media/platform/mtk-vpu/mtk_vpu.c |  994 ++++++++++++++++++++++++++++++
> >  drivers/media/platform/mtk-vpu/mtk_vpu.h |  167 +++++
> >  5 files changed, 1173 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-vpu/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index ccbc974..ba812d6 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -148,6 +148,15 @@ config VIDEO_CODA
> >  	   Coda is a range of video codec IPs that supports
> >  	   H.264, MPEG-4, and other video formats.
> >  
> > +config VIDEO_MEDIATEK_VPU
> > +	tristate "Mediatek Video Processor Unit"
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MEDIATEK
> > +	---help---
> > +	    This driver provides downloading VPU firmware and
> > +	    communicating with VPU. This driver for hw video
> > +	    codec embedded in new Mediatek's SOCs. It is able
> > +	    to handle video decoding/encoding in a range of formats.
> 
> Can you be more specific in this text and mention for which Mediatek SoCs
> this driver is for? Just like you did in the commit log.
> 
Got it. We will add more specific description in Kconfig in next
version.

> Also add something like this:
> 
>           To compile this driver as a module, choose M here: the module
>           will be called mtk-vpu.
> 
> I always find it useful if the Kconfig text mentions the module name.
> 
Got it. We will fix this. Thanks for sharing experience.


best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> > +
> >  config VIDEO_MEM2MEM_DEINTERLACE
> >  	tristate "Deinterlace support"
> >  	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
> 


