Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3F6C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3224020811
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 08:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfCRIXU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 04:23:20 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48109 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfCRIXU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 04:23:20 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 523181C0004;
        Mon, 18 Mar 2019 08:23:15 +0000 (UTC)
Date:   Mon, 18 Mar 2019 09:23:53 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, dave.stevenson@raspberrypi.org
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
Message-ID: <20190318082353.b4khazdi4l77aobr@uno.localdomain>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org>
 <356313ee-2370-e5dc-4c19-2f2c900a410f@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7mc3balm7kemphhl"
Content-Disposition: inline
In-Reply-To: <356313ee-2370-e5dc-4c19-2f2c900a410f@cogentembedded.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--7mc3balm7kemphhl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

On Sat, Mar 16, 2019 at 07:20:28PM +0300, Sergei Shtylyov wrote:
> On 03/16/2019 06:47 PM, Jacopo Mondi wrote:
>
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
> [...]
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
>
>    The union members have csi2_ prefix in their names, no?
>

Correct! Thanks Sergei for noticing this!

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

--7mc3balm7kemphhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyPVZkACgkQcjQGjxah
VjwZ2BAAqOAK2825qyic0rMzneY/hpKoWjYLrjthYtPuFTsqe+pFO5htcSe3oxkc
AsFSvXs+wtG9e+mDy/BG7YSgke/6bMdZY1/mJIg3OMZfOHJNZ17mx93xLdlfXunI
aQLAFCMMBfhLoCAEZ25P8ErZotl4VszE3irSFNcgNTzoVVoMi/9zthyXo6hDdLI9
H0mFzhYoHYq13md2BFN1mnAy9YKWi06TNjPByzS5tUVSstx5UVii9sbbFSKzIPm0
OqjX0LViEMjCv+v6E5Sb/pmmCPtC9p9KmZ6oBHM/5Ggb//YjbZySSKCpNPnPjn2D
LhCMwaxUN4Hj2YOEJMfow15tNjraxJ6lSC0wv2t6iWiNgcgixma5yWYzChRnaIHz
WFh7zh02QxO7rWti7mn1HuSluIwaGSqnWcqdwxzBob1hFHD2BulJBsu1E/HCCHog
g4MUQlPL6PaMtljk1A/VCOncyvSM+qclpBxYJrQjWU4Q8TySSdbiC0la76rjgTI9
9L7r2xRkJOhZl8t/dZcpxYrxVaekxWtHbBLQwRpfaJaNmwxbib4pJ02fMUpy/k04
xS55hOi9uNgrkZwfxwU3ZP2mOz/3qFMDyan953+ENHJKC4QaPBjwwvhxoGDOyLVe
+Rq5cQTOGHjqUEHdBHMNTMcq6CYUDX17B9Sz1uyRcTSWhCi2yew=
=W/Ed
-----END PGP SIGNATURE-----

--7mc3balm7kemphhl--
