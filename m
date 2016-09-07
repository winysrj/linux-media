Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:15280 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753455AbcIGGE3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:04:29 -0400
Message-ID: <1473228263.15879.0.camel@mtksdaap41>
Subject: Re: [PATCH] vcodec: mediatek: add Maintainers entry for Mediatek
 MT8173 vcodec drivers
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        "Andrew-CT Chen" <andrew-ct.chen@mediatek.com>
Date: Wed, 7 Sep 2016 14:04:23 +0800
In-Reply-To: <1473143730-22156-1-git-send-email-tiffany.lin@mediatek.com>
References: <1473143730-22156-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2016-09-06 at 14:35 +0800, Tiffany Lin wrote:
> Add Tiffany Lin and Andrew-CT Chen as maintainers for
> Mediatek MT8173 vcodec drivers
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> ---
>  MAINTAINERS |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0a16a82..ed830c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7590,6 +7590,15 @@ F:	include/uapi/linux/meye.h
>  F:	include/uapi/linux/ivtv*
>  F:	include/uapi/linux/uvcvideo.h
>  
> +MT8173 MEDIA DRIVER

We might upstream mediate driver for other SoC based on this driver.
I think we can just write "MEDIATEK MEDIA DRIVER" here.

Joe.C


> +M:	Tiffany Lin <tiffany.lin@mediatek.com>
> +M:	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> +S:	Supported
> +F:	drivers/media/platform/mtk-vcodec/
> +F:	drivers/media/platform/mtk-vpu/
> +F:	Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> +F:	Documentation/devicetree/bindings/media/mediatek-vpu.txt
> +
>  MEDIATEK ETHERNET DRIVER
>  M:	Felix Fietkau <nbd@openwrt.org>
>  M:	John Crispin <blogic@openwrt.org>


