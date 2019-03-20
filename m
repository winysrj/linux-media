Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A463CC10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 16:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 802302184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 16:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfCTQpX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:45:23 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:40779 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfCTQpX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 12:45:23 -0400
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id B8632100005;
        Wed, 20 Mar 2019 16:45:18 +0000 (UTC)
Date:   Wed, 20 Mar 2019 17:45:57 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
Message-ID: <20190320164557.rd4fin4wc3fkdpj2@uno.localdomain>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org>
 <20190316175121.wdek74c7tfpmrhde@kekkonen.localdomain>
 <20190318083113.evrnuibomrsumne3@uno.localdomain>
 <CAAoAYcOL-7PFhbN6zEpheH794-jUPbU1R2c1ERbouhtQODyjYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="256h3zzfr2s36yzv"
Content-Disposition: inline
In-Reply-To: <CAAoAYcOL-7PFhbN6zEpheH794-jUPbU1R2c1ERbouhtQODyjYg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--256h3zzfr2s36yzv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Dave,
   thanks for the feedback!

On Mon, Mar 18, 2019 at 03:29:55PM +0000, Dave Stevenson wrote:
> Hi Jacopo.
>
> Sorry, for some reason linux-media messages aren't coming through to
> me at the moment.
>
> I'm interested mainly for tc358743 rather than adv748x, but they want
> the very similar functionality.
> I'll try to create patches for that source as well.
>
> On Mon, 18 Mar 2019 at 08:30, Jacopo Mondi <jacopo@jmondi.org> wrote:
> >
> > Hi Sakari,
> > +Maxime because of it's D-PHY work in the phy framework.
> >
> > On Sat, Mar 16, 2019 at 07:51:21PM +0200, Sakari Ailus wrote:
> > > Hi Jacopo,
> > >
> > > On Sat, Mar 16, 2019 at 04:47:57PM +0100, Jacopo Mondi wrote:
> > > > Add PHY-specific parameters to MIPI CSI-2 frame descriptor.
> > > >
> > > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > > ---
> > > >  include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
> > > >  1 file changed, 36 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > > > index 6311f670de3c..eca9633c83bf 100644
> > > > --- a/include/media/v4l2-subdev.h
> > > > +++ b/include/media/v4l2-subdev.h
> > > > @@ -317,11 +317,33 @@ struct v4l2_subdev_audio_ops {
> > > >     int (*s_stream)(struct v4l2_subdev *sd, int enable);
> > > >  };
> > > >
> > > > +#define V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES      4
> > > > +
> > > > +/**
> > > > + * struct v4l2_mbus_frame_desc_entry_csi2_dphy - MIPI D-PHY bus configuration
> > > > + *
> > > > + * @clock_lane:            physical lane index of the clock lane
> > > > + * @data_lanes:            an array of physical data lane indexes
> > > > + * @num_data_lanes:        number of data lanes
> > > > + */
> > > > +struct v4l2_mbus_frame_desc_entry_csi2_dphy {
> > > > +   u8 clock_lane;
> > > > +   u8 data_lanes[V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES];
> > > > +   u8 num_data_lanes;
> > >
> > > Do you need more than the number of the data lanes? I'd expect few devices
> > > to be able to do more than that. The PHY type comes already from the
> > > firmware but I guess it's good to do the separation here as well.
> >
> > Indeed lane reordering at run time seems like a quite unusual
> > operation. I would say I could drop that, but then, a structure and a
> > new field in v4l2_mbus_frame_desc for just an u8, isn't it an
> > overkill (unless we know it could be expanded, with say, D-PHY timings
> > as in Maxime's D-PHY phy support implementation. Again, not sure they
> > should be run-time negotiated, but...)
>
> If we're adding extra information, then can I suggest that the
> clock-noncontinuous flag is also added?

Great, this is a good point. I'll add this flag to the next version.

> If you've got muxed CSI2 buses (eg via the FSA642 [1] as a trivial
> CSI2 switch), then there is nothing stopping one source wanting
> continuous clocks, and one not. Encoding it in the receiver's DT node
> therefore doesn't work for one of the sources. Duplication of that
> definition between source and receiver has always seemed a likely
> source of errors to me, but I'm the relative newcomer here.
>

The duplication of the bus configuration parameters seems to be a
notable source of confusion :) Apart from this, if drivers move to
support fetching some parameters from the frame descriptor, at the
same time they should make sure they retain compatibility with "legacy"
implementations, where these informations come from DT only. I don't
think that's a big deal, as one should not exclude the other, but
establishing a policy for this going forward might be beneficial. I
would say, as long as your receiver does not mandate the source to
provide bus parameters in the frame descriptor, DT has always
precedence, as this would also make sure older DT still work as
intended on your platform.

Thanks
   j

> Cheers
>   Dave
>
> [1] https://www.onsemi.com/PowerSolutions/product.do?id=FSA642
> available on a board such as
> http://www.ivmech.com/magaza/en/development-modules-c-4/ivport-dual-v2-raspberry-pi-camera-module-v2-multiplexer-p-109
>
> > >
> > > Could you use V4L2_FWNODE_CSI2_MAX_DATA_LANES? Or we could rename it. But I
> > > think it'd be good to stick to a single definition.
> > >
> >
> > I initially moved and renamed that define, then went back and added a
> > new one as I was not sure where to put this new global and D-PHY
> > specific define. I'll look into unifying them.
> >
> > Thanks
> >   j
> >
> >
> > > > +};
> > > > +
> > > > +/**
> > > > + * struct v4l2_mbus_frame_desc_entry_csi2_cphy - MIPI C-PHY bus configuration
> > > > + */
> > > > +struct v4l2_mbus_frame_desc_entry_csi2_cphy {
> > > > +   /* TODO */
> > > > +};
> > > > +
> > > >  /**
> > > >   * struct v4l2_mbus_frame_desc_entry_csi2
> > > >   *
> > > > - * @channel: CSI-2 virtual channel
> > > > - * @data_type: CSI-2 data type ID
> > > > + * @channel:       CSI-2 virtual channel
> > > > + * @data_type:     CSI-2 data type ID
> > > >   */
> > > >  struct v4l2_mbus_frame_desc_entry_csi2 {
> > > >     u8 channel;
> > > > @@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
> > > >     V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
> > > >     V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
> > > >     V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> > > > -   V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> > > > +   V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
> > > > +   V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
> > > >  };
> > > >
> > > >  /**
> > > >   * struct v4l2_mbus_frame_desc - media bus data frame description
> > > > - * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
> > > > - * @entry: frame descriptors array
> > > > - * @num_entries: number of entries in @entry array
> > > > + * @type:          type of the bus (enum v4l2_mbus_frame_desc_type)
> > > > + * @entry:         frame descriptors array
> > > > + * @phy:           PHY specific parameters
> > > > + * @phy.dphy:              MIPI D-PHY specific bus configurations
> > > > + * @phy.cphy:              MIPI C-PHY specific bus configurations
> > > > + * @num_entries:   number of entries in @entry array
> > > >   */
> > > >  struct v4l2_mbus_frame_desc {
> > > >     enum v4l2_mbus_frame_desc_type type;
> > > >     struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
> > > > +   union {
> > > > +           struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
> > > > +           struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
> > > > +   } phy;
> > > >     unsigned short num_entries;
> > > >  };
> > > >
> > >
> > > --
> > > Regards,
> > >
> > > Sakari Ailus
> > > sakari.ailus@linux.intel.com
> > -----BEGIN PGP SIGNATURE-----
> >
> > iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyPV1EACgkQcjQGjxah
> > VjxkUxAAkdhZTDN90GEkYfaiIIhthYaaz3Hd2ByI51aTqbNR4wq/6+WeqqmCUVJP
> > wSB4cD3NQp6ZfJLbw97+XZ1oIZj7n4IRNDD050a3z4MFmVkJiz7dJ/yetBZhaqvA
> > eutDDqk+OM6GJc0d2IUTOuiX69JSA9ToUXJrcMbkCp8TjzD5g7Kt7bwbQv4oaG44
> > VBzTaMJpgGWzP1Lxv78mnWeOtH+WIuufw4vtjF5UHvRO8EC6f3kdqilem76+Ffn2
> > N+n3ajhvbPyHk398wyxmcNhm29DZ6Y8CehqWw3AlzMHVbCeEEeEqsQ2MmRxrBlYx
> > +U8R0Nw9JHJ1BqsrjkWWWMVCrTNzoeAGIu4Dbd/81JpxAG+FowNaVDI0Xlm0r9wG
> > psLhQr6ZFaEcxE07VU7E8jfoGvjbRfmZkrtdxr34tUoBAE/YXfZ6rVXVCjTqABIf
> > dcGNVMtVDV7cMvqjqiJa+9uHx467b0QZEaYn3CwW2V7qoa4D7iLf4WchsW9gvjq4
> > mUEnzQFbd63qFuBaTrE4paq9hkYcoSAjrrDtL12l3FHop4wTjJLCJXLSO7khd97w
> > qMQOKnWKI8edPrakz3nBx8lexgOWcoe/tMRYDF4dgYJLMm+ZNS0R90Xu9x5DMOvG
> > cYBKeQk72lr0znYNTowGdc+xZcuO2BjyU83SnyZuRsmAo6kg3nA=
> > =BYda
> > -----END PGP SIGNATURE-----

--256h3zzfr2s36yzv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlySbkUACgkQcjQGjxah
Vjx/9RAAp969kMZkrkLbeIlUjVuZ8LI2V7muL6Fucehj3pvD9Ec0P5B9RvS3FdAV
a3i2+lU0+5zr/OcPpBd6D8b+r/Rv5/XGHswTAGbfUOMnHeEAVddJKBBbSOctw6qb
sl4ieIaur72Gvx746gFydvIkVR5RTnowF9qU28slQvWk6dusUYdx5kksexkNb6x0
bkKpYEPbJlPv46ScjEGSTyFmIEq/urWv/MlzL0rd4MMnI9QoC3+JU7eX+xVciMP0
P5ma3bNyJzQzLkQgz4gNtAL3DRVbIjYxq80Gc6fjUVez5dsNzJVt2aAZNHWY/XrZ
2J0TNsKApjySA8x8yQD3lYhC0R6cIk4EXv0IuyJeiw/vSNG2HWxNMcjmvToS88aM
9wW8jhPYOI+MxqiG/cDPx9mD+zcCp/zF/xoQiOonVwD+40WAZDMVetpIczUrLrUY
jH9ME5dHZNhKJ803p4xSqUZTEDa4QIyGcZAd0Pc0mw8mAGOFeYXj4z47WY3/izSz
D0gPMjMN/te5ep92mJM5NClbIoqqWCP7yGu/nAxWf9lVYMfQ6TojvkmrpCLmqZXl
9bPeXHVxpjzZkVfi30SDmY6Hkp63iK5rQxqBy/4TNcQMhpaI5iCscLZ8vhoAqYEa
mvwm43S3mMav0mstIHXdqrsx6Z5MSJ6MTVX7QWqaqZ1mYL6rnBo=
=Xr5x
-----END PGP SIGNATURE-----

--256h3zzfr2s36yzv--
