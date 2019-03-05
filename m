Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D173C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9E020675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfCEIsf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:48:35 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51021 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCEIsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 03:48:35 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 9D0D31C0011;
        Tue,  5 Mar 2019 08:48:30 +0000 (UTC)
Date:   Tue, 5 Mar 2019 09:49:02 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Ian Arkver <ian.arkver.dev@gmail.com>, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190305084902.vzaqr53q77oy2o7r@uno.localdomain>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
 <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
 <20190301130118.jy57g5wcsn7mqclk@pengutronix.de>
 <20190304123621.l3ocvdiya5z5wzal@paasikivi.fi.intel.com>
 <20190304165528.n4sqxjhfsplmt5km@pengutronix.de>
 <20190304181747.ax7nvbvhdul4vtna@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x3l2qte3mnfdjbab"
Content-Disposition: inline
In-Reply-To: <20190304181747.ax7nvbvhdul4vtna@kekkonen.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--x3l2qte3mnfdjbab
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari, Marco,

On Mon, Mar 04, 2019 at 08:17:48PM +0200, Sakari Ailus wrote:
> Hi Marco,
>
> On Mon, Mar 04, 2019 at 05:55:28PM +0100, Marco Felsch wrote:
> > > > (more device specific)
> > > > tc358746,default-mode = <CSI-Tx> /* Parallel-in -> CSI-out */
> > > > tc358746,default-mode = <CSI-Rx> /* CSI-in -> Parallel-out */
> > > >
> > > > or
> > > >
> > > > (more generic)
> > > > tc358746,default-dir = <PARALLEL_TO_CSI2>
> > > > tc358746,default-dir = <CSI2_TO_PARALLEL>
> > >
> > > The prefix for Toshiba is "toshiba". What would you think of
> > > "toshiba,csi2-direction" with values of either "rx" or "tx"? Or
> > > "toshiba,csi2-mode" with either "master" or "slave", which would be a
> > > little bit more generic, but could be slightly more probable to get wrong
> > > as well.
> >
> > You're right mixed the prefix with the device.. If we need to introduce
> > a property I would prefer the "toshiba,csi2-direction" one. I said if
> > because as Jacopo mentioned we can avoid the property by define port@0
> > as input and port@1 as output. I tink that's the best solution, since we
> > can avoid device specific bindings and it's common to use the last port
> > as output (e.g. video-mux).
>
> The ports represent hardware and I think I would avoid reordering them. I
> wonder what would the DT folks prefer.
>

I might have missed why you mention re-ordering? :)

> The device specific property is to the point at least: it describes an
> orthogonal part of the device configuration. That's why I'd pick that if I
> were to choose. But I'll let Rob to comment on this.

That's true indeed. Let's wait for inputs from DT people, I'm fine
with both approaches.

Thanks
   j

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--x3l2qte3mnfdjbab
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlx+N/4ACgkQcjQGjxah
VjyGrA//WUGnZjjZ31YrqIR6dnIgL7TiuA6fLLCba5SZ71z44agxBok9bIlZm7Hr
ykfTKtHKt+uClu5Rn82ifKehIKaAAqQJVOeT8FpJhvxP8UT84PxcUOrPoiMj3qOm
Ij+xKCmIk+i8LB3w7g55RW+c2OBKJSin6+v5YvIurCcEEnOCb6OuE6b8N/3oKJFJ
iXuzLgbQKrBNKDvH7/rmktU56ZObm5vKOuYTrxElXXED36EATQAT5yCtuouHP6GH
UWp+R02HelTPfaaj0LxEfmprNw1lu+0L2iUVFqDTbv5E5frlw/oBUQQrV0qv2eGl
mYRLvzllauX6KfBqs9TecVUYZNm1iOIIZ3Hxks8zjARjVYHQUDlqVwcu5WEBj9xy
tDLR2Y/7T0OvDeeL9BuNs+nTAZ8aAXH0WhZR97jOt1cwdQJfbVkhh8EC0bMd4+zO
rOxXN+/tiBFR1DzHGmRct3SXsy5qFMHmLHrsNZKk4h8HtgkocuZ/UmsrfA6JQyGp
zEDRVEVTamnA+8ikZfckFqtp5rk4kapfjbzKZefTRHj/SPX+Kx+8Jfx4GZx0GrxO
O2YDn0Cqj0REoXWGiEbZgjuFZN354Z3BLYZSh6praDE6i4gc6n6zaQ3leW/nXVLG
968QVLeTdncrZPvfCfeeKrVai87vwPGGD3LjfwJoqslzz/cRl+w=
=s6or
-----END PGP SIGNATURE-----

--x3l2qte3mnfdjbab--
