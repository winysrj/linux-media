Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:57840 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753051AbdLMOV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:21:56 -0500
Date: Wed, 13 Dec 2017 16:21:52 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] media: dt-bindings: coda: Add compatible for CodaHx4
 on i.MX51
Message-ID: <20171213142152.7vcludcs7ohjeaqb@sapphire.tkos.co.il>
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213140918.22500-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Dec 13, 2017 at 03:09:17PM +0100, Philipp Zabel wrote:
> Add a compatible for the CodaHx4 VPU used on i.MX51.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/media/coda.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
> index 2865d04e40305..660f5ecf2a23b 100644
> --- a/Documentation/devicetree/bindings/media/coda.txt
> +++ b/Documentation/devicetree/bindings/media/coda.txt
> @@ -7,6 +7,7 @@ called VPU (Video Processing Unit).
>  Required properties:
>  - compatible : should be "fsl,<chip>-src" for i.MX SoCs:
>    (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
> +  (a) "fsl,imx51-vpu" for CodaHx4 present in i.MX51

Renumbering the strings might be useful.

>    (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
>    (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
>  - reg: should be register base and length as documented in the

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
