Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42967 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3HEJLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 05:11:53 -0400
Message-ID: <51FF6C4D.2030306@ti.com>
Date: Mon, 5 Aug 2013 12:11:41 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/6] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-3-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-3-git-send-email-archit@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ho60lEwMK3NrTvVwHk5ed6st83R4Xniat"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--ho60lEwMK3NrTvVwHk5ed6st83R4Xniat
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/08/13 17:03, Archit Taneja wrote:
> Create functions which the VPE driver can use to create a VPDMA descrip=
tor and
> add it to a VPDMA descriptor list. These functions take a pointer to an=
 existing
> list, and append the configuration/data/control descriptor header to th=
e list.
>=20
> In the case of configuration descriptors, the creation of a payload blo=
ck may be
> required(the payloads can hold VPE MMR values, or scaler coefficients).=
 The
> allocation of the payload buffer and it's content is left to the VPE dr=
iver.
> However, the VPDMA library provides helper macros to create payload in =
the
> correct format.
>=20
> Add debug functions to dump the descriptors in a way such that it's eas=
y to see
> the values of different fields in the descriptors.

There are lots of defines and inline functions in this patch. But at
least the ones I looked at were only used once.

For example, dtd_set_xfer_length_height() is called only in one place.
Then dtd_set_xfer_length_height() uses DTD_W1(), and again it's the only
place where DTD_W1() is used.

So instead of:

dtd_set_xfer_length_height(dtd, c_rect->width, height);

You could as well do:

dtd->xfer_length_height =3D (c_rect->width << DTD_LINE_LENGTH_SHFT) | hei=
ght;

Now, presuming the compiler optimizes correctly, there should be no
difference between the two options above. My only point is that I wonder
if having multiple "layers" there improves readability at all. Some
helper funcs are rather trivial, like:

+static inline void dtd_set_w1(struct vpdma_dtd *dtd, u32 value)
+{
+	dtd->w1 =3D value;
+}

Then there are some, like dtd_set_type_ctl_stride(), that contains lots
of parameters. Hmm, okay, dtd_set_type_ctl_stride() is called in two
places, so at least in that case it makes sense to have that helper
func. But dtd_set_type_ctl_stride() uses DTD_W0(), and that's again the
only place where it's used.

So, I don't know. I'm not suggesting to change anything, I just started
wondering if all those macros and helpers actually help or not.

> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpdma.c      | 269 +++++++++++
>  drivers/media/platform/ti-vpe/vpdma.h      |  48 ++
>  drivers/media/platform/ti-vpe/vpdma_priv.h | 695 +++++++++++++++++++++=
++++++++
>  3 files changed, 1012 insertions(+)
>=20
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/plat=
form/ti-vpe/vpdma.c
> index b15b3dd..b957381 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -21,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/videodev2.h>
> =20
>  #include "vpdma.h"
>  #include "vpdma_priv.h"
> @@ -425,6 +426,274 @@ int vpdma_submit_descs(struct vpdma_data *vpdma, =
struct vpdma_desc_list *list)
>  	return 0;
>  }
> =20
> +static void dump_cfd(struct vpdma_cfd *cfd)
> +{
> +	int class;
> +
> +	class =3D cfd_get_class(cfd);
> +
> +	pr_debug("config descriptor of payload class: %s\n",
> +		class =3D=3D CFD_CLS_BLOCK ? "simple block" :
> +		"address data block");
> +
> +	if (class =3D=3D CFD_CLS_BLOCK)
> +		pr_debug("word0: dst_addr_offset =3D 0x%08x\n",
> +			cfd_get_dest_addr_offset(cfd));
> +
> +	if (class =3D=3D CFD_CLS_BLOCK)
> +		pr_debug("word1: num_data_wrds =3D %d\n", cfd_get_block_len(cfd));
> +
> +	pr_debug("word2: payload_addr =3D 0x%08x\n", cfd_get_payload_addr(cfd=
));
> +
> +	pr_debug("word3: pkt_type =3D %d, direct =3D %d, class =3D %d, dest =3D=
 %d, "
> +		"payload_len =3D %d\n", cfd_get_pkt_type(cfd),
> +		cfd_get_direct(cfd), class, cfd_get_dest(cfd),
> +		cfd_get_payload_len(cfd));
> +}

There's quite a bit of code in these dump functions, and they are always
called. I'm sure getting that data is good for debugging, but I presume
they are quite useless for normal use. So I think they should be
compiled in only if some Kconfig option is selected.

> +/*
> + * data transfer descriptor
> + *
> + * All fields are 32 bits to make them endian neutral

What does that mean? Why would 32bit fields make it endian neutral?

> + */
> +struct vpdma_dtd {
> +	u32			type_ctl_stride;
> +	union {
> +		u32		xfer_length_height;
> +		u32		w1;
> +	};
> +	dma_addr_t		start_addr;
> +	u32			pkt_ctl;
> +	union {
> +		u32		frame_width_height;	/* inbound */
> +		dma_addr_t	desc_write_addr;	/* outbound */

Are you sure dma_addr_t is always 32 bit?

> +	};
> +	union {
> +		u32		start_h_v;		/* inbound */
> +		u32		max_width_height;	/* outbound */
> +	};
> +	u32			client_attr0;
> +	u32			client_attr1;
> +};

I'm not sure if I understand the struct right, but presuming this one
struct is used for both writing and reading, and certain set of fields
is used for writes and other set for reads, would it make sense to have
two different structs, instead of using unions? Although they do have
many common fields, and the unions are a bit scattered there, so I don't
know if that would be cleaner...

 Tomi



--ho60lEwMK3NrTvVwHk5ed6st83R4Xniat
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR/2xNAAoJEPo9qoy8lh71f1QQAJMdHtTHIga5RXsYCT6+espc
kfgHddoopby+RQ6NaqZY7Exuf+ImEMNpUJu3Qlgf6XYvyuzdga2Ha4i/zsOkE0ui
pb58x6fFMXbDTn/F3NB8DNJ8bXUXi2onfDJoyo9P2B7g3iufpbGUojGgrS0X9JgN
hinW+fs4loV2fyDUAZxKlw5g2uo2Tn3dCOajKNfx159dI9eYevIuPxmIDdca0ncx
hhzLYZUfwzok22pxZGXb/0D3QVHHYQe6fpA+4lfzWVRCtdHwK1gOPNoWu6Y8tcwt
iKNNm7OgipwN5PUwIM9Q8+d/K4dT94WRYn66+NolKdmDE7Pew+RSxUEvoJfDyI86
z18h0wdezPXklfPBKMYh48Rebgc4iRaZBv3OyRRyPJo4y6rlD93meQSPc9rF/BIV
bmGz7t6boy7XAsX2IP/tt4v86WAIumRFKVEhAI4mdtFJWNXgCHYtwSDB6ARtHe2h
oPl1h1UroXsjLq7FSFIXwJbz5hZe0pic5Zts3BDCrTi7PrY8/PJdEpaFxx9iaiWa
TEHa+JtLkV4noK5XwM2+GQZ6oXYt3zYLuNNSV6m4Tk/bGMlgDnVQ/+PYl+qxU1gc
aMuyY6RoEqxRUJmp+86O77FjnCiLylu3qFk8ks7gg0w4eZVPl132TKV5zvfgWtdX
jrJVYITVF9dvOlt06SOz
=1oV1
-----END PGP SIGNATURE-----

--ho60lEwMK3NrTvVwHk5ed6st83R4Xniat--
