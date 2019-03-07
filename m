Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98743C10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 22:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 700A920851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 22:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfCGW1u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 17:27:50 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:49207 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfCGW1u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 17:27:50 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id DD1C9FF803;
        Thu,  7 Mar 2019 22:27:46 +0000 (UTC)
Date:   Thu, 7 Mar 2019 23:28:18 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 31/31] media: rcar-csi2: Implement has_route()
Message-ID: <20190307222818.3tjy77cve7hacfsv@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-32-jacopo+renesas@jmondi.org>
 <20190307125610.xtsobfteeu7ju45e@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r24mbb5u32pp2uat"
Content-Disposition: inline
In-Reply-To: <20190307125610.xtsobfteeu7ju45e@paasikivi.fi.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--r24mbb5u32pp2uat
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Thu, Mar 07, 2019 at 02:56:10PM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Tue, Mar 05, 2019 at 07:51:50PM +0100, Jacopo Mondi wrote:
> > Now that the rcar-csi2 subdevice supports internal routing, add an
> > has_route() operation used during graph traversal.
> >
> > The internal routing between the sink and the source pads depends on the
> > virtual channel used to transmit the video stream from the remote
> > subdevice to the R-Car CSI-2 receiver.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 35 +++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > index cc7077b40f18..6c46bcc0ee83 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -1028,7 +1028,42 @@ static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
> >   * Platform Device Driver.
> >   */
> >
> > +static bool rcar_csi2_has_route(struct media_entity *entity,
> > +				unsigned int pad0, unsigned int pad1)
> > +{
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > +	struct v4l2_mbus_frame_desc fd;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	/* Support only direct sink->source routes. */
> > +	if (pad0 != RCAR_CSI2_SINK)
> > +		return false;
> > +
> > +	/* Get the frame description: from CSI-2 VC to source pad number. */
> > +	ret = rcsi2_get_remote_frame_desc(priv, &fd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	for (i = 0; i < fd.num_entries; i++) {
> > +		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
> > +		int source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
>
> A newline here would make this prettier IMO.
>

Yes, it's probably nicer (and actually reported by checkpatch...)

> > +		if (source_pad < 0) {
> > +			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
> > +				entry->bus.csi2.channel);
> > +			return -EINVAL;
>
> -EINVAL will be cast as true... same above.
>

Argh, dumb! Thank you

> This op wasn't really intended to fail. That should instead happen in e.g.
> link or route configuration.
>
> I think that if the two endpoints are in an agreement on the fundamental
> CSI-2 bus parameters, I'd expect this just to work. Or is your CSI-2
> receiver restricted to fewer virtual channels?

Not exactly. The CSI-2 receivers are connected to the VIN instances
through 4 data channels and there is a number of valid
"(CSI-2/VC) -> VIN" routes which are captured in the per-SoC
"rvin_group_route" structure.

Each source pad of the CSI-2 receiver represent an output channel, and the
media links to the VINs represent a possible valid route. So far, without
VC support, all 4 outputs where enabled, and the data was output to
all the connected VINs.

With the introduction of virtual channels support for the R-Car CSI-2
receiver in Niklas' [29/31], the video stream to VINs is now only output
to the channel corresponding to the VC reported by the remote's frame
descriptor (in this setup, the one reported on the adv748x source pad).
This work as streaming VC(i) on Channel(i) (which corresponds to pad(i+1))
is always a safe combination as long as one receiver is use (*) and
this is reflected by this operation, that reports that the stream received
on the sink pad is now internally routed only to the source pad that
corresponds to the enabled output channel.

>
> Alternatively we could make the frame descriptors settable as well so that
> the receiver driver could use them to configure the transmitter. That'd
> probably not be trivial to implement though.
>

I think that might be something to be considered in future, as
controlling the VC from the transmitter makes it very hard for VINs to
validate combinations when multiple receivers are active at the same
time, while setting routes on the VINs and propagating them backward
would centralize the validation of the VIN/CSI-2/VC combinations.

That's something quite far-fetched though, and I might got lost a bit,
so I think what is here at the moment is fine :)

Thanks
  j

*) Niklas: am I wrong or things might get interesting when
more than one CSI-2 receiver is enabled simultaneously and if I got
this right, this might lead to, ie. having both CSI40/VC0 and
CSI20/VC0 sent to the same VIN0 only?

> > +		}
> > +
> > +		if (source_pad == pad1)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> >  static const struct media_entity_operations rcar_csi2_entity_ops = {
> > +	.has_route = rcar_csi2_has_route,
> >  	.link_validate = v4l2_subdev_link_validate,
> >  };
> >
>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--r24mbb5u32pp2uat
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyBmwIACgkQcjQGjxah
Vjz/yBAAl9gltRhEDU9i8TmZ2CLpa75V1rYRV8tFThGnM83HoSFIgtSLjjjSavjH
wtzghgD5gyw++yQdHO/xlWp6KDZA1V9nyHjZjg3lTt6YLbgSLhASmVDoJMaKvTPj
JsjgFnCHIURQr06Kvdz9ykK3P0BfNGltFjD2Ta95zDOm9e4svZbLT7Z39YfFjsYI
IY//imDuGx/WodlQf0lA3jENzrTn6iF2IG+//IbFtcHzAIYSORKGOkMzRnpP7tfY
xuuTFb1w4+ZwZYQUzENazp8ugtUceW/W0q4adx8zEMMFaG4gQoJjdzTqwAfxFnTS
RK3AiWcZRjA4ueN+ZwZcFM80I7oj+Fsr0WKDpbfn5LdY9kllLy57YbLUDP5+HVtv
/rimSEhqTurGjCsCslALCQjrmR5NC9CeBYY+xI+urqB6JKl+LHqOhJe2pHp5HZ/+
C5CrWo5mlTWa0N8k8/P/PcmfH0F6S/wzy5q7cdFNEUOMSe/NcZgC73eiC5G/BMfI
8j1wsorxMB60fmGHZhnI4JpYJJ366l+9rWCv1oHb8vqyfco/mwsSdjroRPjkM04j
ox80mdiHDA5VJUuTs+1PWnSSklcFxXGI0EC7cpXw+rU7FbW3mgD2a/sLMCpTiuxc
oV7AHHu4T5fAzjRFyTX/PZEGUhE2Amr7mnQ7oRC5mKYJ/pHZRBw=
=jKY8
-----END PGP SIGNATURE-----

--r24mbb5u32pp2uat--
