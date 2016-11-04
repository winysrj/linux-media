Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59735 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbcKDP4k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 11:56:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rick Chang <rick.chang@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
Date: Fri, 04 Nov 2016 17:56:29 +0200
Message-ID: <1792025.53iDXU6qZ9@avalon>
In-Reply-To: <1478235060.23008.35.camel@mtksdaap41>
References: <1477898217-19250-1-git-send-email-rick.chang@mediatek.com> <1838616.gXE7Zi2nyC@avalon> <1478235060.23008.35.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rick,

On Friday 04 Nov 2016 12:51:00 Rick Chang wrote:
> On Thu, 2016-11-03 at 20:34 +0200, Laurent Pinchart wrote:
> > On Thursday 03 Nov 2016 20:33:12 Laurent Pinchart wrote:
> >> On Monday 31 Oct 2016 15:16:55 Rick Chang wrote:
> >>> Add a DT binding documentation for Mediatek JPEG Decoder of
> >>> MT2701 SoC.
> >>> 
> >>> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> >>> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> >>> ---
> >>> 
> >>>  .../bindings/media/mediatek-jpeg-codec.txt         | 35 ++++++++++++++
> >>>  1 file changed, 35 insertions(+)
> >>>  create mode 100644
> >>> Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> >>> 
> >>> diff --git
> >>> a/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> >>> b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt new
> >>> file mode 100644
> >>> index 0000000..514e656
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> >>> @@ -0,0 +1,35 @@
> >>> +* Mediatek JPEG Codec
> >> 
> >> Is it a codec or a decoder only ?
> >> 
> >>> +Mediatek JPEG Codec device driver is a v4l2 driver which can decode
> >>> +JPEG-encoded video frames.
> >> 
> >> DT bindings should not reference drivers, they are OS-agnostic.
> >> 
> >>> +Required properties:
> >>> +  - compatible : "mediatek,mt2701-jpgdec"
> > 
> > Is the JPEG decoder found in MT2701 only, or in other Mediatek SoCs as
> > well ?
>
> Yes, the JPEG decoder is found in other Mediatek SoCs. However, the JPEG
> decoder HW in different SoCs have different register base, interrupt,
> power-domain and iommu setting.

That's fine, and that's exactly what the device tree is used for. When an 
identical IP core is integrated differently in different SoCs, the driver 
retrieves the resources (base address, clocks, IOMMU, interrupt, power domain 
and more) from the device tree without any need for SoC-specific code.

> This patch series is only applicable in MT2701.

That was precisely my question, apart from integration properties, is there 
anything specific to the MT2701 in patches 1/3 and 2/3 ?

-- 
Regards,

Laurent Pinchart
