Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50607 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeKIXL0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 18:11:26 -0500
Message-ID: <1541770245.4112.41.camel@pengutronix.de>
Subject: Re: [PATCH 3/3] media: imx: lift CSI width alignment restriction
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Fri, 09 Nov 2018 14:30:45 +0100
In-Reply-To: <28564f76-1f87-d17e-88c8-b80a343bb649@gmail.com>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
         <20181105152055.31254-3-p.zabel@pengutronix.de>
         <28564f76-1f87-d17e-88c8-b80a343bb649@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-11-08 at 21:46 -0800, Steve Longerbeam wrote:
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index c4523afe7b48..d39682192a67 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -41,7 +41,7 @@
> >   #define MIN_H       144
> >   #define MAX_W      4096
> >   #define MAX_H      4096
> > -#define W_ALIGN    4 /* multiple of 16 pixels */
> > +#define W_ALIGN    1 /* multiple of 2 pixels */
> 
> This works for the IDMAC output pad because the channel's cpmem width 
> and stride can be rounded up, but width align at the CSI sink still 
> needs to be 8 pixels when directed to the IC via the CSI_SRC_PAD_DIRECT 
> pad, in order to support the 8x8 block rotator in the IC PRP, and 
> there's no way AFAIK to do the same trick of rounding up width andq 
> stride for non-IDMAC direct paths through the IPU.

Can't we just disallow rotation on prp subdevs if sink format is not
aligned to 2^3? Another possibility would be to align sink pad format
width to 2^3 only if the PAD_DIRECT link is enabled.

> Also, the imx-ic-prpencvf.c W_ALIGN_SRC can be relaxed to 2 pixels as
> well.

True, added for v2.

regards
Philipp
