Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34509 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaHZT0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 15:26:49 -0400
Date: Tue, 26 Aug 2014 20:26:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Message-ID: <20140826192624.GN17528@sirena.org.uk>
References: <1409073919-27336-1-git-send-email-broonie@kernel.org>
 <53FCDE16.1000205@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xfk/GcrKUmI+JXHT"
Content-Disposition: inline
In-Reply-To: <53FCDE16.1000205@infradead.org>
Subject: Re: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xfk/GcrKUmI+JXHT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 12:20:54PM -0700, Randy Dunlap wrote:
> On 08/26/14 10:25, Mark Brown wrote:

> > index d58101e788fc..65a351d75c95 100644
> > --- a/Documentation/video4linux/Makefile
> > +++ b/Documentation/video4linux/Makefile
> > @@ -1 +1 @@
> > -obj-m :=3D v4l2-pci-skeleton.o
> > +obj-$(CONFIG_VIDEO_PCI_SKELETON) :=3D v4l2-pci-skeleton.o
> > diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/=
Kconfig

> > +config VIDEO_PCI_SKELETON
> > +	tristate "Skeleton PCI V4L2 driver"
> > +	depends on PCI && COMPILE_TEST

> 	               && ??  No, don't require COMPILE_TEST.

That's a very deliberate choice.  There's no reason I can see to build
this code other than to check that it builds, it's reference code rather
than something that someone is expected to actually use in their system. =
=20
This seems like a perfect candidate for COMPILE_TEST.

> 		However, PCI || COMPILE_TEST would allow it to build on arm64
> 		if COMPILE_TEST is enabled, guaranteeing build errors.
> 		Is that what should happen?  I suppose so...

No, it's not - if it's going to depend on COMPILE_TEST at all it need to
be a hard dependency.

--xfk/GcrKUmI+JXHT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/N9cAAoJELSic+t+oim9zb8P/iExJaj9lkqkQ0X7qaoJjSXS
WlnJTCGTmanKfEX1/Z8/aca0GCB6KNJ2OXGsmnGdR7Uh54RF/bBkm/Afku/fCx4N
8mn/QdGDuZ9HLYio6j2OkiVkYAPhXDNIsZbUJ2wBaIEF5OKmprr7m5URrCLk6Dm4
CsFKc6iDOlHa2oXgTDiSuwhEcszsl/5f/L/EwShUAnu/gP1E3HmFgdGwRL7N7xk/
BJPKvqi44ti1XMO1vSLel5rcNbu+uFYXQwY2nMHX3Y3cNZdPvsxxowzDE/0kSRJh
789Ro+EArIKbDbZVq4f8zra7QOJp1LikJ8CRULvnht3PbM0OtuoM3l5+leVKbaQO
Dfqkf3zj7MsQxEgh3yaAp34YZUJHpGaRRjKL14Zvv8FRwWtXXbUV4NG0Z6NRGV2V
ILKtHQzADak3TcXrXXKxK8k4bFvylP9AzVqwivOxWYQVmFnRDzzgyP35srVFbKRc
/E8UwsbExvwPFZ8TdSz8WzBFTbJ956qCpGe9Znw5BCWbwwe7Fs1QB4e61lz75wbS
uSquoclQM86tEz9EkHNCx/1a6wiruteuHrJqxXazZz62eIb9SpMS1BAk+AKkgNRM
TNzNX9rz+93L0JES5+pf8AzLhuT10VMrPov/1E8ur1MA2PBvCX23A7Poe7PbSQK/
RqzI9TVFaS6uY6t9XQ5u
=UOzD
-----END PGP SIGNATURE-----

--xfk/GcrKUmI+JXHT--
