Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2BFHJ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 02:09:56 -0500
Date: Mon, 6 Feb 2012 08:09:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Curtis McEnroe <programble@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tm6000: Don't use pointer after freeing it in
 tm6000_ir_fini()
Message-ID: <20120206070939.GA19754@avionic-0098.mockup.avionic-design.de>
References: <alpine.LNX.2.00.1201290239460.20079@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201290239460.20079@swampdragon.chaosbits.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jesper Juhl wrote:
> In tm6000_ir_fini() there seems to be a problem.=20
> rc_unregister_device(ir->rc); calls rc_free_device() on the pointer it is=
=20
> given, which frees it.
>=20
> Subsequently the function does:
>=20
>   if (!ir->polling)
>     __tm6000_ir_int_stop(ir->rc);
>=20
> and __tm6000_ir_int_stop() dereferences the pointer it is given, which
> has already been freed.
>=20
> and it also does:
>=20
>   tm6000_ir_stop(ir->rc);
>=20
> which also dereferences the (already freed) pointer.
>=20
> So, it seems that the call to rc_unregister_device() should be move
> below the calls to __tm6000_ir_int_stop() and tm6000_ir_stop(), so
> those don't operate on a already freed pointer.
>=20
> But, I must admit that I don't know this code *at all*, so someone who
> knows the code should take a careful look before applying this
> patch. It is based purely on inspection of facts of what is beeing
> freed where and not at all on understanding what the code does or why.
> I don't even have a means to test it, so beyond testing that the
> change compiles it has seen no testing what-so-ever.
>=20
> Anyway, here's a proposed patch.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/media/video/tm6000/tm6000-input.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/vi=
deo/tm6000/tm6000-input.c
> index 7844607..859eb90 100644
> --- a/drivers/media/video/tm6000/tm6000-input.c
> +++ b/drivers/media/video/tm6000/tm6000-input.c
> @@ -481,8 +481,6 @@ int tm6000_ir_fini(struct tm6000_core *dev)
> =20
>  	dprintk(2, "%s\n",__func__);
> =20
> -	rc_unregister_device(ir->rc);
> -
>  	if (!ir->polling)
>  		__tm6000_ir_int_stop(ir->rc);
> =20
> @@ -492,6 +490,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
>  	tm6000_flash_led(dev, 0);
>  	ir->pwled =3D 0;
> =20
> +	rc_unregister_device(ir->rc);
> =20
>  	kfree(ir);
>  	dev->ir =3D NULL;
> --=20
> 1.7.8.4

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk8vfLMACgkQZ+BJyKLjJp8fMACglxjNlCOZKFfoOzyPM4INKQMF
pbAAnA2o87NdaJs+WpgIahGLQqjtfjIU
=wmc3
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
