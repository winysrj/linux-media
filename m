Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B98C10F00
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1522082F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfCRIam (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 04:30:42 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:58763 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfCRIam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 04:30:42 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id DB608240008;
        Mon, 18 Mar 2019 08:30:35 +0000 (UTC)
Date:   Mon, 18 Mar 2019 09:31:13 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, dave.stevenson@raspberrypi.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
Message-ID: <20190318083113.evrnuibomrsumne3@uno.localdomain>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org>
 <20190316175121.wdek74c7tfpmrhde@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y6ktu4jmqe3pswip"
Content-Disposition: inline
In-Reply-To: <20190316175121.wdek74c7tfpmrhde@kekkonen.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--y6ktu4jmqe3pswip
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
+Maxime because of it's D-PHY work in the phy framework.

On Sat, Mar 16, 2019 at 07:51:21PM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Sat, Mar 16, 2019 at 04:47:57PM +0100, Jacopo Mondi wrote:
> > Add PHY-specific parameters to MIPI CSI-2 frame descriptor.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
> >  1 file changed, 36 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 6311f670de3c..eca9633c83bf 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -317,11 +317,33 @@ struct v4l2_subdev_audio_ops {
> >  	int (*s_stream)(struct v4l2_subdev *sd, int enable);
> >  };
> >
> > +#define V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES	4
> > +
> > +/**
> > + * struct v4l2_mbus_frame_desc_entry_csi2_dphy - MIPI D-PHY bus configuration
> > + *
> > + * @clock_lane:		physical lane index of the clock lane
> > + * @data_lanes:		an array of physical data lane indexes
> > + * @num_data_lanes:	number of data lanes
> > + */
> > +struct v4l2_mbus_frame_desc_entry_csi2_dphy {
> > +	u8 clock_lane;
> > +	u8 data_lanes[V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES];
> > +	u8 num_data_lanes;
>
> Do you need more than the number of the data lanes? I'd expect few devices
> to be able to do more than that. The PHY type comes already from the
> firmware but I guess it's good to do the separation here as well.

Indeed lane reordering at run time seems like a quite unusual
operation. I would say I could drop that, but then, a structure and a
new field in v4l2_mbus_frame_desc for just an u8, isn't it an
overkill (unless we know it could be expanded, with say, D-PHY timings
as in Maxime's D-PHY phy support implementation. Again, not sure they
should be run-time negotiated, but...)

>
> Could you use V4L2_FWNODE_CSI2_MAX_DATA_LANES? Or we could rename it. But I
> think it'd be good to stick to a single definition.
>

I initially moved and renamed that define, then went back and added a
new one as I was not sure where to put this new global and D-PHY
specific define. I'll look into unifying them.

Thanks
  j


> > +};
> > +
> > +/**
> > + * struct v4l2_mbus_frame_desc_entry_csi2_cphy - MIPI C-PHY bus configuration
> > + */
> > +struct v4l2_mbus_frame_desc_entry_csi2_cphy {
> > +	/* TODO */
> > +};
> > +
> >  /**
> >   * struct v4l2_mbus_frame_desc_entry_csi2
> >   *
> > - * @channel: CSI-2 virtual channel
> > - * @data_type: CSI-2 data type ID
> > + * @channel:	CSI-2 virtual channel
> > + * @data_type:	CSI-2 data type ID
> >   */
> >  struct v4l2_mbus_frame_desc_entry_csi2 {
> >  	u8 channel;
> > @@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
> >  	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
> >  	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
> >  	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> > -	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> > +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
> > +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
> >  };
> >
> >  /**
> >   * struct v4l2_mbus_frame_desc - media bus data frame description
> > - * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
> > - * @entry: frame descriptors array
> > - * @num_entries: number of entries in @entry array
> > + * @type:		type of the bus (enum v4l2_mbus_frame_desc_type)
> > + * @entry:		frame descriptors array
> > + * @phy:		PHY specific parameters
> > + * @phy.dphy:		MIPI D-PHY specific bus configurations
> > + * @phy.cphy:		MIPI C-PHY specific bus configurations
> > + * @num_entries:	number of entries in @entry array
> >   */
> >  struct v4l2_mbus_frame_desc {
> >  	enum v4l2_mbus_frame_desc_type type;
> >  	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
> > +	union {
> > +		struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
> > +		struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
> > +	} phy;
> >  	unsigned short num_entries;
> >  };
> >
>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--y6ktu4jmqe3pswip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyPV1EACgkQcjQGjxah
VjxkUxAAkdhZTDN90GEkYfaiIIhthYaaz3Hd2ByI51aTqbNR4wq/6+WeqqmCUVJP
wSB4cD3NQp6ZfJLbw97+XZ1oIZj7n4IRNDD050a3z4MFmVkJiz7dJ/yetBZhaqvA
eutDDqk+OM6GJc0d2IUTOuiX69JSA9ToUXJrcMbkCp8TjzD5g7Kt7bwbQv4oaG44
VBzTaMJpgGWzP1Lxv78mnWeOtH+WIuufw4vtjF5UHvRO8EC6f3kdqilem76+Ffn2
N+n3ajhvbPyHk398wyxmcNhm29DZ6Y8CehqWw3AlzMHVbCeEEeEqsQ2MmRxrBlYx
+U8R0Nw9JHJ1BqsrjkWWWMVCrTNzoeAGIu4Dbd/81JpxAG+FowNaVDI0Xlm0r9wG
psLhQr6ZFaEcxE07VU7E8jfoGvjbRfmZkrtdxr34tUoBAE/YXfZ6rVXVCjTqABIf
dcGNVMtVDV7cMvqjqiJa+9uHx467b0QZEaYn3CwW2V7qoa4D7iLf4WchsW9gvjq4
mUEnzQFbd63qFuBaTrE4paq9hkYcoSAjrrDtL12l3FHop4wTjJLCJXLSO7khd97w
qMQOKnWKI8edPrakz3nBx8lexgOWcoe/tMRYDF4dgYJLMm+ZNS0R90Xu9x5DMOvG
cYBKeQk72lr0znYNTowGdc+xZcuO2BjyU83SnyZuRsmAo6kg3nA=
=BYda
-----END PGP SIGNATURE-----

--y6ktu4jmqe3pswip--
