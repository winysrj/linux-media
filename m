Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34726 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932359AbcKGRAf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:00:35 -0500
Subject: Re: [PATCH v4 1/3] dt-bindings: mediatek: Add a binding for Mediatek
 JPEG Decoder
To: Rick Chang <rick.chang@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478501839-2775-1-git-send-email-rick.chang@mediatek.com>
 <1478501839-2775-2-git-send-email-rick.chang@mediatek.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <134eb37e-b33e-3ce9-f413-70f57a5d622b@gmail.com>
Date: Mon, 7 Nov 2016 18:00:31 +0100
MIME-Version: 1.0
In-Reply-To: <1478501839-2775-2-git-send-email-rick.chang@mediatek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/11/16 07:57, Rick Chang wrote:
> Add a DT binding documentation for Mediatek JPEG Decoder of
> MT2701 SoC.
>
> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  .../bindings/media/mediatek-jpeg-codec.txt         | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
>
> diff --git a/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> new file mode 100644
> index 0000000..c7dbcc2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> @@ -0,0 +1,35 @@
> +* Mediatek JPEG Decoder
> +
> +Mediatek JPEG Decoder is the JPEG decode hardware present in Mediatek SoCs
> +
> +Required properties:
> +- compatible : "mediatek,jpgdec"

Is this block in all arm SoCs from Mediatek?
If not, then I would prefer to use "mediatek,mtXXXX-jpgdec"
where XXXX stands for the oldest model which has this block.

In parallel to that the dts should have this compatible plus the one for 
mt2701, for example:
compatible = "mediatek,mt2701-uart", "mediatek,mt6577-uart"

Thanks,
Matthias
