Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57246 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbcEKQdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 12:33:13 -0400
Date: Wed, 11 May 2016 18:32:52 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l2-async: Always unregister the subdev on
 failure
Message-ID: <20160511183252.6270d740@avionic-0020>
In-Reply-To: <429cc087-85e3-7bfa-b0b6-ab9434e5d47c@osg.samsung.com>
References: <1462981201-14768-1-git-send-email-alban.bedel@avionic-design.de>
	<429cc087-85e3-7bfa-b0b6-ab9434e5d47c@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dEvARbGol36I.XyfL7HY.4r"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/dEvARbGol36I.XyfL7HY.4r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 May 2016 12:22:44 -0400
Javier Martinez Canillas <javier@osg.samsung.com> wrote:

> Hello Alban,
>=20
> On 05/11/2016 11:40 AM, Alban Bedel wrote:
> > In v4l2_async_test_notify() if the registered_async callback or the
> > complete notifier returns an error the subdev is not unregistered.
> > This leave paths where v4l2_async_register_subdev() can fail but
> > leave the subdev still registered.
> >=20
> > Add the required calls to v4l2_device_unregister_subdev() to plug
> > these holes.
> >=20
> > Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-=
core/v4l2-async.c
> > index ceb28d4..43393f8 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -121,13 +121,19 @@ static int v4l2_async_test_notify(struct v4l2_asy=
nc_notifier *notifier,
> > =20
> >  	ret =3D v4l2_subdev_call(sd, core, registered_async);
> >  	if (ret < 0 && ret !=3D -ENOIOCTLCMD) {
> > +		v4l2_device_unregister_subdev(sd);
> >  		if (notifier->unbind)
> >  			notifier->unbind(notifier, sd, asd);
> >  		return ret;
> >  	}
> > =20
> > -	if (list_empty(&notifier->waiting) && notifier->complete)
> > -		return notifier->complete(notifier);
> > +	if (list_empty(&notifier->waiting) && notifier->complete) {
> > +		ret =3D notifier->complete(notifier);
> > +		if (ret < 0) {
> > +			v4l2_device_unregister_subdev(sd);
>=20
> Isn't a call to notifier->unbind() missing here as well?
>=20
> Also, I think the error path is becoming too duplicated and complex, so
> maybe we can have a single error path and use goto labels as is common
> in Linux? For example something like the following (not tested) can be
> squashed on top of your change:

Yes, that look better. I'll test it and report tomorrow.

Alban

--Sig_/dEvARbGol36I.XyfL7HY.4r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXM160AAoJEHSUmkuduC28aE4QAKZrOyZbsA9WhoT3yzZFgmhH
Vy6tR9p51/GuUm4WjgadD/aK0w6T6+clxwjgqQfxuIDqzk2HUhOKwtWDcrpi9+DL
FcW4NKiLHG7rp5Ib3gLJgLTVik0ckJCDg7PC+V45mRFjadaMHLKde9Va5mK50hva
+CuYO9W5FubDqW9APxEn2f2hQzT36d4gFyI+b7Uj0ayFKzkMxpybnChAohe07cXJ
OjV7+y1rYQpySYl3z1H8y1Zy/lTzz7txZx/XZMPry1iPNOFD4gAdx7Ru++CPOA7a
+ukAr93746YnphWx7X/dPlHZxXY10A3Ro5ufPJJaxyXYWXNucuh1ag+Tw63xkS9s
XsYUXRcE3s1AP++715ajMCgjgjCvZT+WXhdkn0UZCLkgqLD9PfxJbJ7Rza51MWi3
EaRzozKL1b2AZOgawuybI/MDL7nQ/mqxAFtBNj92rIyT7ayXaN+f1INTU/s54ifk
pzvR7i7wqdz0Ignk6HqAvGKMinsTzwsT9RNUiYjMZuo2ziiESoB1yuaQEGXPQ2Ts
Vafk/NS2yBw1dPe8Z+HViu7qKyWFNV65LADo4sN+OyC3Um+QV6xzuS2PuVmflIoW
Hz10YIQUOUVOd5IYFwxgWTpj6CWdpQ7EOyAXRrAzuW2RlsYLdKVhg8LiEZMAk/dW
CZwwHmL9jvIx++sAAqYX
=TgdH
-----END PGP SIGNATURE-----

--Sig_/dEvARbGol36I.XyfL7HY.4r--
