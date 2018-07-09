Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53997 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754438AbeGINlw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 09:41:52 -0400
Message-ID: <6acdb656fd6d07f3aa10ffd5cba82b58404f8a21.camel@bootlin.com>
Subject: Re: [PATCH] v4l2-ctrls: add
 v4l2_ctrl_request_hdl_find/put/ctrl_find functions
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 09 Jul 2018 15:41:50 +0200
In-Reply-To: <3f4dd554-0385-7ca7-4b1d-34144da8ff49@xs4all.nl>
References: <3f4dd554-0385-7ca7-4b1d-34144da8ff49@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uypuo+TUrS+htYTmoHB7"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-uypuo+TUrS+htYTmoHB7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-07-04 at 17:38 +0200, Hans Verkuil wrote:
> If a driver needs to find/inspect the controls set in a request then
> it can use these functions.
>=20
> E.g. to check if a required control is set in a request use this in the
> req_validate() implementation:
>=20
> 	int res =3D -EINVAL;
>=20
> 	hdl =3D v4l2_ctrl_request_hdl_find(req, parent_hdl);
> 	if (hdl) {
> 		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
> 			res =3D 0;
> 		v4l2_ctrl_request_hdl_put(hdl);
> 	}
> 	return res;

Thanks again for pulling this off, that's definitely what I neeeded!

I was able to test the patch and get it to work with sunxi-cedrus, with
one modification highlighted below.

Note that for my use case, I need to have access to the driver's private
data (context) to get the parent hdl. I'm iterating over request objects
and getting the context from a buffer object (checked via
vb2_request_object_is_buffer), a bit like it's done in
vb2_m2m_request_queue.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Paul, please test this. This should be what you need.
>=20
> Regards,
>=20
> 	Hans
> ---
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index 3ff17c87b3c8..03fd140736fd 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2976,6 +2976,31 @@ static const struct media_request_object_ops req_o=
ps =3D {
>  	.release =3D v4l2_ctrl_request_release,
>  };
>=20
> +struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_reques=
t *req,
> +					struct v4l2_ctrl_handler *parent)
> +{
> +	struct media_request_object *obj;
> +=09
> +	if (WARN_ON(req->state !=3D MEDIA_REQUEST_STATE_VALIDATING &&
> +		    req->state !=3D MEDIA_REQUEST_STATE_QUEUED))
> +		return NULL;
> +
> +	obj =3D media_request_object_find(req, &req_ops, parent);
> +	if (obj)
> +		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
> +
> +struct v4l2_ctrl *
> +v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
> +{
> +	struct v4l2_ctrl_ref *ref =3D find_ref_lock(hdl, id);
> +
> +	return (ref && ref->req =3D=3D ref) ? ref : NULL;

When req && ref->req =3D=3D ref, ref->ctrl should be returned instead of
ref.

Cheers,

Paul
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-uypuo+TUrS+htYTmoHB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltDZh4ACgkQ3cLmz3+f
v9HAxQf+NOg7dlWPUtDRNIx9XGScK27hw60J07VgvBxaqMa4CrL0NBr7hpObUQ+k
4ipIFwy1MBzYwtTR4FuT0/ogFiNRXWVkzB5sLhLl5QBEkOSGEbLj6UvB0pwM1xRH
sWBmC2icn4oazfYS6a4Bs/AJNgl8JniYaKEYA72o2yVNucHc0b25KKGevDmeZ3KQ
rPnObOmsxgXaUIWpE5BUesnxXZDax5B4kqymO7Lix2DeDsxUuZE+5kbpAYmXrcFs
A17KNF6/8AaqYkpRPOpX6gtggDwS3Qsfs1kpJel8gqla7tu21XTMaGUK3AN7U0G7
hEu1jhAwAE668eM+UjePs8/92OQwdg==
=vrO6
-----END PGP SIGNATURE-----

--=-uypuo+TUrS+htYTmoHB7--
