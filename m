Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57093 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeJSVTk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:19:40 -0400
Date: Fri, 19 Oct 2018 15:13:28 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Akinobu Mita <akinobu.mita@gmail.com>, petrcvekcz@gmail.com
Subject: Re: [PATCH] media: rename soc_camera I2C drivers
Message-ID: <20181019131328.GG11703@w540>
References: <3e42194ffb936ec9d0a4d361f06c6a4b0e88173f.1539949382.git.mchehab+samsung@kernel.org>
 <fa7f6ef2-af25-a554-2ecc-e99c9fb1e68d@cisco.com>
 <20181019093146.195d0be5@coco.lan>
 <7bd0c2fd-f852-e880-f1ae-85f27b44fc9b@cisco.com>
 <20181019125851.kch2qxv6mjshwk76@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Content-Disposition: inline
In-Reply-To: <20181019125851.kch2qxv6mjshwk76@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro, Hans, Sakari,

On Fri, Oct 19, 2018 at 03:58:51PM +0300, Sakari Ailus wrote:
> Hi Hans, Mauro,
>
> On Fri, Oct 19, 2018 at 02:39:27PM +0200, Hans Verkuil wrote:
> > On 10/19/18 14:31, Mauro Carvalho Chehab wrote:
> > > Em Fri, 19 Oct 2018 13:45:32 +0200
> > > Hans Verkuil <hansverk@cisco.com> escreveu:
> > >
> > >> On 10/19/18 13:43, Mauro Carvalho Chehab wrote:
> > >>> Those drivers are part of the legacy SoC camera framework.
> > >>> They're being converted to not use it, but sometimes we're
> > >>> keeping both legacy any new driver.
> > >>>
> > >>> This time, for example, we have two drivers on media with
> > >>> the same name: ov772x. That's bad.
> > >>>
> > >>> So, in order to prevent that to happen, let's prepend the SoC
> > >>> legacy drivers with soc_.
> > >>>
> > >>> No functional changes.
> > >>>
> > >>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > >>
> > >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >
> > > For now, let's just avoid the conflict if one builds both modules and
> > > do a modprobe ov772x.
> > >
> > >> Let's kill all of these in the next kernel. I see no reason for keep=
ing
> > >> them around.
> > >
> > > While people are doing those SoC conversions, I would keep it. We
> >
> > Which people are doing SoC conversions? Nobody is using soc-camera anym=
ore.
> > It is a dead driver. The only reason it hasn't been removed yet is lack=
 of
> > time since it is not just removing the driver, but also patching old bo=
ard
> > files that use soc_camera headers. Really left-overs since the correspo=
nding
> > soc-camera drivers have long since been removed.
> >
> > > could move it to staging, to let it clear that those drivers require
> > > conversion, and give people some time to work on it.
> >
> > There is nobody working on it. These are old sensors, and few will have
> > the hardware to test it. If someone needs such a sensor driver, then th=
ey
> > can always look at an older kernel version. It's still in git after all.
> >
> > Just kill it rather then polluting the media tree.
>
> I remember at least Jacopo has been doing some. There was someone else as
> well, but I don't remember right now who it was. That said, I'm not sure =
if
> there's anything happening to the rest.

Yes, I did port a few drivers and there are patches for others coming.

[PATCH v2 0/4] media: soc_camera: ov9640: switch driver to v4l2_async
=66rom Peter Cvek (now in Cc)
>
> Is there something that prevents removing these right away? As you said
> it's not functional and people can always check old versions if they want
> to port the driver to V4L2 sub-device framework.

All dependencies should have been solved so far, but given that
someone might want to do the porting at some point, I don't see how
bad would it be to have them in staging, even if people could look
into the git history...

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbydh4AAoJEHI0Bo8WoVY89rQQAJ8E7vcJCr1mULsqC+seVYM2
NKH++T9d8eVN9PXxoLXsKfS1ZDNwxZSj53TKyoCWDhBkOtV15P4EmiQLMk+hF/+P
ykl2tSXtvHl9ByEQUpOWKDU/6ByKlAfYp6gXiGayUeMiq8H3Chh2DFdLO1z2pLnC
RXIQb3xpktXpQ3QeMLZ5sIuO7ePP4ch876+t+Rqg+4O+GolReOz/t+wHQjWEVuqx
zFMTO21f2wO9y/dnyHP94T2IA6VIbBCMi+12z5yJAbfOqUJ4rt9Z/IpOIL0SSw6Q
mrDUWx1cTD8pwFcy3MjwIlB4/QTVW1S04qihuZFImnU3Mg52QIY8IPbmMhB33AkI
1r74dC1FiAC7Xl+ZvUibu43pm3JjkfxHJi98IVkkn7WEa7Ow/3HBAmwDI16K2jhg
LJT8JuJZTNAWbjnC8jzbtz4XxW0wNtE5hkiPr9KbHMm1MrNmKN/R5rrhibmalQDk
yPKdMpee1rRkQyRepy2hU1qCprGVD11HXrgvpRxn0OuOMd9dmuvo4AKCO3u1dq7Q
mJQyh1nzMi3V6ZgYhjnK8FeXkH63ugyJuoWkTOmdKDwE9ZhxV5xeJmD9xSWl/F1i
2t2yW4pgh5NZyd4uls3+rAu0n6iVf0BTemYSQSkNrAuJyUjXjZiEmwMUK4rC2y6c
6TRZ7+CPauK/azLnuKSC
=WYhl
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
