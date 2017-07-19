Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33685 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753705AbdGSQ3k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 12:29:40 -0400
Message-ID: <1500481777.2364.69.camel@pengutronix.de>
Subject: Re: [PATCH] [media] imx: csi: enable double write reduction
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 19 Jul 2017 18:29:37 +0200
In-Reply-To: <12f124d8-fec2-8b90-5bd8-c688c649ad35@gmail.com>
References: <20170719122243.22911-1-p.zabel@pengutronix.de>
         <12f124d8-fec2-8b90-5bd8-c688c649ad35@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Wed, 2017-07-19 at 09:18 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 07/19/2017 05:22 AM, Philipp Zabel wrote:
> > For 4:2:0 subsampled YUV formats, avoid chroma overdraw by only writing
> > chroma for even lines. Reduces necessary write memory bandwidth by 25%.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >   drivers/staging/media/imx/imx-media-csi.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> > index a2d26693912ec..0fb70d5a9e7fe 100644
> > --- a/drivers/staging/media/imx/imx-media-csi.c
> > +++ b/drivers/staging/media/imx/imx-media-csi.c
> > @@ -388,6 +388,12 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
> >   			goto unsetup_vb2;
> >   	}
> >   
> > +	switch (image.pix.pixelformat) {
> > +	case V4L2_PIX_FMT_YUV420:
> > +	case V4L2_PIX_FMT_NV12:
> > +		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
> > +	}
> > +
> 
> Is there any reason why you can't place this call under the
> already existing case statement for YUV420 and NV12 at line
> 352?

Not really. I didn't touch that block of code because it only dealt with
the burst size and generic data / passthrough mode settings. I'll move
the odd row skipping flag up there. Thank you for the suggestion.

regards
Philipp
