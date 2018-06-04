Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46035 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbeFDM5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:57:32 -0400
Date: Mon, 4 Jun 2018 14:57:27 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Simon Horman <horms@verge.net.au>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180604125727.GH10472@w540>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180604095308.pnlmd4aalxceuozq@verge.net.au>
 <20180604113154.GC19674@bigcity.dyn.berto.se>
 <20180604122511.cfb7cg7ojihel5mx@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <20180604122511.cfb7cg7ojihel5mx@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BXr400anF0jyguTS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Mon, Jun 04, 2018 at 02:25:15PM +0200, Simon Horman wrote:
> On Mon, Jun 04, 2018 at 01:31:54PM +0200, Niklas S=C3=B6derlund wrote:
> > Hi Simon,
> >
> > On 2018-06-04 11:53:09 +0200, Simon Horman wrote:
> > > On Mon, May 21, 2018 at 07:27:43PM +0200, Jacopo Mondi wrote:
> > >
> > > > The 'bus-width' and 'pclk-sample' properties are not parsed by the =
VIN
> > > > driver and only confuse users. Remove them in all Gen2 SoC that use
> > > > them.
> > >
> > > I think that the rational for removing properties (or not) is their
> > > presence in the bindings as DT should describe the hardware and not t=
he
> > > current state of the driver implementation.
> > >
> > > I see that 'bus-width' may be removed from the binding, as per discus=
sion
> > > in a different sub-thread. I'd like that discussion to reach a conclu=
sion
> > > before considering that part of this patch any further.
> > >
> > > And I'd appreciate Niklas's feedback on the 'pclk-sample' portion.
> >
> > My thoughts on 'pclk-sample' is the same as for 'bus-width', they
> > describe the hardware. So we either should keep or remove both. As our
> > discussion in the other thread I'm leaning towards that both should be
> > kept.

Am I wrong, or we discussed about the face there is no way to specify
the bus widht of the VIN parallel input interface?

>
> Thanks, that sounds reasonable to me.

So they should be documented if we want to keep them. Currently, they
are not.

And again, someone integrating a sensor may try to play around with those
properties, expecting them to change the interface behavior and wasting time
trying to figure out where the error is, on sensor side or VIN side, before
realizing those properties are actually ignored.

Anyway, the most important thing, if we want to keep them is to
provide a patch to document them as optional properties of the VIN
endpoint.

Thanks
   j

>
> I'm marking (v4 of) this as deferred pending a conclusion to that
> conversation.
>

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbFTc3AAoJEHI0Bo8WoVY8YSwQALktvG/UQlCbEdUYzu/+X9Uo
0CeAdPoRZjkCwo4jCISLCuKAIzFgZNdsAMGb1ggKf0zwHSvzh4JhszHiUjkvjEDw
aLcR6p07kdBiaSk+a7moV0yjffXrvtrFXUl8MzmlIgbVuIHZQoXVab+DDi2ebyFV
Eyw4SRiD0gkqZr/nj9pE6UTe7e6UHaKmNwiMsTgVBMfpC3ozMnhOTIVloyl2kvN/
3p0XrQIe1rbz5gAcygs0YwsCyKNilf0r9iIg7sCOx2T69vLwD4fCvWYXY4NKFIxH
skzsD5WYl/jnH0yFM1TUwx1lBo3DnsgX2zsNKQc+Jp7niEVlyM9ewKq+dDNcQaKc
7e+TSmR4s0Ouauf07IQzL6XFTFCBkZ1JBHwygJ/cXF/6JllX9SFmPHThZoHiYUye
vSaMGZF9QpWCzIeW/Y+thYbF2wVGVZ88+3G5FAB3JVKSTSf1/AdcMqQ80cFMiCVS
bczJFYrphM0DstFUB4SWXJvURlkfGfkS/cXU4V2VBaoApnAtnEtkVNxiV4AU8ExE
r3MNPGsRUtH5zzn8rNPBx3VLVQR2e3Y3wiGYJs+DUx4Usf7kjWLyMt2TGo3xB9pZ
FYmCeMXC784C2LtsQBM9bakJNrtov0/KbhYuKmiA4cBtkToBfgT9CYTkGWmCVGZm
XUnqAPzHUKtCzniFc8Zo
=fR5f
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
