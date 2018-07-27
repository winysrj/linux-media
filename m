Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33594 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbeG0NNS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 09:13:18 -0400
Received: by mail-lf1-f68.google.com with SMTP id u14-v6so3342740lfu.0
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 04:51:42 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 27 Jul 2018 13:51:40 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: update stream start for V3M
Message-ID: <20180727115140.GC14328@bigcity.dyn.berto.se>
References: <20180726223657.26340-1-niklas.soderlund+renesas@ragnatech.se>
 <2085902.EcbZgA7qhr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2085902.EcbZgA7qhr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-07-27 12:25:13 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 27 July 2018 01:36:57 EEST Niklas Söderlund wrote:
> > Latest errata document updates the start procedure for V3M. This change
> > in addition to adhering to the datasheet update fixes capture on early
> > revisions of V3M.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> > ---
> > 
> > Hi Hans, Mauro and Sakari
> > 
> > I know this is late for v4.19 but if possible can it be considered? It
> > fixes a real issue on R-Car V3M boards. I'm sorry for the late
> > submission, the errata document accesses unfortunate did not align with
> > the release schedule.
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> > daef72d410a3425d..dc5ae8025832ab6e 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -339,6 +339,7 @@ enum rcar_csi2_pads {
> > 
> >  struct rcar_csi2_info {
> >  	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
> > +	int (*confirm_start)(struct rcar_csi2 *priv);
> >  	const struct rcsi2_mbps_reg *hsfreqrange;
> >  	unsigned int csi0clkfreqrange;
> >  	bool clear_ulps;
> > @@ -545,6 +546,13 @@ static int rcsi2_start(struct rcar_csi2 *priv)
> >  	if (ret)
> >  		return ret;
> > 
> > +	/* Confirm start */
> > +	if (priv->info->confirm_start) {
> > +		ret = priv->info->confirm_start(priv);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> 
> While PHTW has to be written in the "Confirmation of PHY start" sequence, the 
> operation doesn't seem to be related to confirmation of PHY start, it instead 
> looks like a shuffle of the configuration sequence. I would thus not name the 
> operation .confirm_start() as that's not what it does.

I think the hook name being .confirm_start() is good as it is where in 
stream start procedure it is called. What the operation do in the V3M 
case is for me hidden as the datasheet only lists register writes and 
instructs you to check what I believe is the result of each "operation".

For all I know it might be a configuration sequence or a method to 
confirm that the stream is started. Do you have anymore insight to what 
it does? All I know is prior to datasheet v1.0 it was not documented for 
V3M and streaming worked fine without it, and still do.

> 
> >  	/* Clear Ultra Low Power interrupt. */
> >  	if (priv->info->clear_ulps)
> >  		rcsi2_write(priv, INTSTATE_REG,
> > @@ -880,6 +888,11 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2
> > *priv, unsigned int mbps) }
> > 
> >  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int
> > mbps)
> > +{
> > +	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> > +}
> > +
> > +static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
> >  {
> >  	static const struct phtw_value step1[] = {
> >  		{ .data = 0xed, .code = 0x34 },
> > @@ -890,12 +903,6 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2
> > *priv, unsigned int mbps) { /* sentinel */ },
> >  	};
> > 
> > -	int ret;
> > -
> > -	ret = rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> > -	if (ret)
> > -		return ret;
> > -
> 
> There's something I don't get here. According to the errata, it's the step1 
> array write sequence that need to be moved from "Start of PHY" to 
> "Confirmation of PHY start". This patch moves the PHTW frequency configuration 
> instead.

Is this not what this patch do? I agree the diff is hard to read. The 
result however is more clear.

    static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
    {
	    return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
    }

    static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
    {
	    static const struct phtw_value step1[] = {
		    { .data = 0xed, .code = 0x34 },
		    { .data = 0xed, .code = 0x44 },
		    { .data = 0xed, .code = 0x54 },
		    { .data = 0xed, .code = 0x84 },
		    { .data = 0xed, .code = 0x94 },
		    { /* sentinel */ },
	    };

	    return rcsi2_phtw_write_array(priv, step1);
    }

    ...

    static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
	    .init_phtw = rcsi2_init_phtw_v3m_e3,
	    .confirm_start = rcsi2_confirm_start_v3m_e3,
    };

> 
> >  	return rcsi2_phtw_write_array(priv, step1);
> >  }
> > 
> > @@ -949,6 +956,7 @@ static const struct rcar_csi2_info
> > rcar_csi2_info_r8a77965 = {
> > 
> >  static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
> >  	.init_phtw = rcsi2_init_phtw_v3m_e3,
> > +	.confirm_start = rcsi2_confirm_start_v3m_e3,
> >  };
> > 
> >  static const struct of_device_id rcar_csi2_of_table[] = {
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Regards,
Niklas Söderlund
