Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:57687 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750749AbcKXCxx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 21:53:53 -0500
Message-ID: <1479956028.8964.33.camel@mtksdaap41>
Subject: Re: [PATCH v7 4/4] vcodec: mediatek: Add Maintainers entry for
 Mediatek JPEG driver
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        "Minghsiu Tsai" <minghsiu.tsai@mediatek.com>
Date: Thu, 24 Nov 2016 10:53:48 +0800
In-Reply-To: <1479786377-11567-5-git-send-email-rick.chang@mediatek.com>
References: <1479786377-11567-1-git-send-email-rick.chang@mediatek.com>
         <1479786377-11567-5-git-send-email-rick.chang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Is it possible to update this patch? or I should create another new one.

I may need to update it.

Sorry for the inconvenience.

On Tue, 2016-11-22 at 11:46 +0800, Rick Chang wrote:
> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93e9f42..a9e7ee0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7818,6 +7818,13 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/ethernet/mediatek/
>  
> +MEDIATEK JPEG DRIVER
> +M:	Rick Chang <rick.chang@mediatek.com>
> +M:	Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> +S:	Supported
> +F:	drivers/media/platform/mtk-jpeg/
> +F:	Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
> +
>  MEDIATEK MEDIA DRIVER
>  M:	Tiffany Lin <tiffany.lin@mediatek.com>
>  M:	Andrew-CT Chen <andrew-ct.chen@mediatek.com>


