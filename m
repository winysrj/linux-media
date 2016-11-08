Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:63066 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752158AbcKHCXM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 21:23:12 -0500
Message-ID: <1478571782.28520.19.camel@mtksdaap41>
Subject: Re: [PATCH v4 1/3] dt-bindings: mediatek: Add a binding for
 Mediatek JPEG Decoder
From: Rick Chang <rick.chang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Date: Tue, 8 Nov 2016 10:23:02 +0800
In-Reply-To: <134eb37e-b33e-3ce9-f413-70f57a5d622b@gmail.com>
References: <1478501839-2775-1-git-send-email-rick.chang@mediatek.com>
         <1478501839-2775-2-git-send-email-rick.chang@mediatek.com>
         <134eb37e-b33e-3ce9-f413-70f57a5d622b@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Matthias,

Thank you for your review.I will include your advice in patch v5.

On Mon, 2016-11-07 at 18:00 +0100, Matthias Brugger wrote:
> 
> On 07/11/16 07:57, Rick Chang wrote:
> > Add a DT binding documentation for Mediatek JPEG Decoder of
> > MT2701 SoC.
> >
> > Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  .../bindings/media/mediatek-jpeg-codec.txt         | 35 ++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> > new file mode 100644
> > index 0000000..c7dbcc2
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
> > @@ -0,0 +1,35 @@
> > +* Mediatek JPEG Decoder
> > +
> > +Mediatek JPEG Decoder is the JPEG decode hardware present in Mediatek SoCs
> > +
> > +Required properties:
> > +- compatible : "mediatek,jpgdec"
> 
> Is this block in all arm SoCs from Mediatek?

JPEG Decoder hardware is in most of Mediatek SoCs, but I can't guarantee
that each of them has identical IP.

> If not, then I would prefer to use "mediatek,mtXXXX-jpgdec"
> where XXXX stands for the oldest model which has this block.
> 
> In parallel to that the dts should have this compatible plus the one for 
> mt2701, for example:
> compatible = "mediatek,mt2701-uart", "mediatek,mt6577-uart"

The oldest model that I can make sure this patch series work on is
mt8173.I will add it to the compatible string.

> Thanks,
> Matthias


