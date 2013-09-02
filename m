Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab3IBBlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 21:41:40 -0400
Message-ID: <1378086079.25743.87.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 2/4] [media] lirc_bt829: Fix physical address type
From: Ben Hutchings <ben@decadent.org.uk>
To: Fabio Estevam <festevam@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 02:41:19 +0100
In-Reply-To: <CAOMZO5C_fOqe+9a1BVWxnQ3hrYZaxf5AN4WNrOacQdkng8h-Jg@mail.gmail.com>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
	 <1378082375.25743.61.camel@deadeye.wl.decadent.org.uk>
	 <CAOMZO5C_fOqe+9a1BVWxnQ3hrYZaxf5AN4WNrOacQdkng8h-Jg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yvgOAdgzr1FhVTnmrQN7"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-yvgOAdgzr1FhVTnmrQN7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-09-01 at 22:37 -0300, Fabio Estevam wrote:
> On Sun, Sep 1, 2013 at 9:39 PM, Ben Hutchings <ben@decadent.org.uk> wrote=
:
>=20
> >         pci_addr_phys =3D pdev->resource[0].start;
> > -       dev_info(&pdev->dev, "memory at 0x%08X\n",
> > -                (unsigned int)pci_addr_phys);
> > +       dev_info(&pdev->dev, "memory at 0x%08llX\n",
> > +                (unsigned long long)pci_addr_phys);
>=20
> You could use %pa instead for printing phys_addr_t:
>=20
> dev_info(&pdev->dev, "memory at %pa\n", &pci_addr_phys);

Could do, but I'm not sure it's clearer.  And all these %p formats
defeat type-checking anyway.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-yvgOAdgzr1FhVTnmrQN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPsv+e/yOyVhhEJAQooOBAAttqIoG9zlESj5vQOyMcLCK3Rzgaq/JGr
qU6hWuf5nZYzmg+qJWbxUf/V4QLGG3QM+yFizM67KGvZc+Y0m/IDgTEPpWrX3KmW
L/stlanFo+A5QbR6EbmZ9fcq7eyVE3ZRq6M2tJE4I+Fq76vOmANUDY3tAJq/9KNq
Fe3c7z8dn2IMw9g401lItru7m5v2Xl8VDOGhuvNDzyVJw+XGUgXrGz2FskFt18C8
mXJLBvnPR5kppSg7sgKBw2+bERXW7tkJFJtNPSGtcuPUy03PdEerCnVt2H9FJa59
LQVWTLAKcYagLnLrsIZmOHc0xPOiwjxx482Pma+GBfR7Bq114YCWrX3IOpNSdk/G
rAGPmCBwju1RZ1NEGIP23YmSzOcomRyIbrKhnJMnUvx8QynSZYWNwq3T9k8eQJKL
7wj5niYyCN84HMZlHkV9Z6/8GgM12dE6dABTFUXmadVH35dE7pu1mz+ZSEqW+nPL
mDM11V4r3zdW3xHN3p8KNefnTsPsvLvQ08JiQZTun54vKLPHGbXZhLKL7bVmiB1h
eFhVFVwvPpoPv49AAqXexGHMv2zVECrkH/IHGk8t/VNYBZrXFKQF6dZzeAIqaMS0
Q40OMPx68lcKsou+HRM2l3wuDckZg0a+d77Cm+7f5ZS3U3VxdfbsadogbqevCghh
irzmzFPPL9w=
=m0b3
-----END PGP SIGNATURE-----

--=-yvgOAdgzr1FhVTnmrQN7--
