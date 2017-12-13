Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40185 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753146AbdLMOwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:52:18 -0500
Message-ID: <1513176735.9445.1.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: dt-bindings: coda: Add compatible for
 CodaHx4 on i.MX51
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 13 Dec 2017 15:52:15 +0100
In-Reply-To: <20171213142152.7vcludcs7ohjeaqb@sapphire.tkos.co.il>
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
         <20171213142152.7vcludcs7ohjeaqb@sapphire.tkos.co.il>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

On Wed, 2017-12-13 at 16:21 +0200, Baruch Siach wrote:
> Hi Philipp,
> 
> On Wed, Dec 13, 2017 at 03:09:17PM +0100, Philipp Zabel wrote:
> > Add a compatible for the CodaHx4 VPU used on i.MX51.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/devicetree/bindings/media/coda.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
> > index 2865d04e40305..660f5ecf2a23b 100644
> > --- a/Documentation/devicetree/bindings/media/coda.txt
> > +++ b/Documentation/devicetree/bindings/media/coda.txt
> > @@ -7,6 +7,7 @@ called VPU (Video Processing Unit).
> >  Required properties:
> >  - compatible : should be "fsl,<chip>-src" for i.MX SoCs:
> >    (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
> > +  (a) "fsl,imx51-vpu" for CodaHx4 present in i.MX51
> 
> Renumbering the strings might be useful.

yes, thank you. I should probably add the generic "cnm,coda<variant>"
compatibles as well. I'll send a fixed version.

regards
Philipp
