Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34972 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdFPQ4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 12:56:36 -0400
Received: by mail-it0-f47.google.com with SMTP id m62so38264000itc.0
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 09:56:36 -0700 (PDT)
Message-ID: <1497632193.6020.19.camel@ndufresne.ca>
Subject: Re: [PATCH 08/12] [media] vb2: add 'ordered' property to queues
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Fri, 16 Jun 2017 12:56:33 -0400
In-Reply-To: <20170616073915.5027-9-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
         <20170616073915.5027-9-gustavo@padovan.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-SlH54Ca4am+ZhhAqEYyB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-SlH54Ca4am+ZhhAqEYyB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 16 juin 2017 =C3=A0 16:39 +0900, Gustavo Padovan a =C3=A9crit=
=C2=A0:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
>=20
> For explicit synchronization (and soon for HAL3/Request API) we need
> the v4l2-driver to guarantee the ordering which the buffer were queued
> by userspace. This is already true for many drivers, but we never had
> the need to say it.

Phrased this way, that sound like a statement that a m2m decoder
handling b-frame will just never be supported. I think decoders are a
very important use case for explicit synchronization.

What I believe happens with decoders is simply that the allocation
order (the order in which empty buffers are retrieved from the queue)
will be different then the actual presentation order. Also, multiple
buffers endup being filled at the same time. Some firmware may inform
of the new order at the last minute, making indeed the fence useless,
but these are firmware and the information can be known earlier. Also,
this information would be known by userspace for the case (up-coming,
see STM patches and Rockchip comments [0]) or state-less decoder,
because it is available while parsing the bitstream. For this last
scenarios, the fact that ordering is not the same should disable the
fences since userspace can know which fences to wait for first. Those
drivers would need to set "ordered" to 0, which would be counter
intuitive.

I think this use case is too important to just ignore it. I would
expect that we at least have a todo with something sensible as a plan
to cover this.

>=20
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
> =C2=A0include/media/videobuf2-core.h | 4 ++++
> =C2=A01 file changed, 4 insertions(+)
>=20
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-cor=
e.h
> index aa43e43..a8b800e 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -491,6 +491,9 @@ struct vb2_buf_ops {
> =C2=A0 * @last_buffer_dequeued: used in poll() and DQBUF to immediately r=
eturn if the
> > =C2=A0 *		last decoded buffer was already dequeued. Set for capture que=
ues
> > =C2=A0 *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
> + * @ordered: if the driver can guarantee that the queue will be ordered =
or not.
> > + *		The default is not ordered unless the driver sets this flag. It
> > + *		is mandatory for using explicit fences.
> > =C2=A0 * @fileio:	file io emulator internal data, used only if emulator=
 is active
> > =C2=A0 * @threadio:	thread io internal data, used only if thread is act=
ive
> =C2=A0 */
> @@ -541,6 +544,7 @@ struct vb2_queue {
> > > =C2=A0	unsigned int			is_output:1;
> > > =C2=A0	unsigned int			copy_timestamp:1;
> > > =C2=A0	unsigned int			last_buffer_dequeued:1;
> > > +	unsigned int			ordered:1;
> =C2=A0
> > > =C2=A0	struct vb2_fileio_data		*fileio;
> > > =C2=A0	struct vb2_threadio_data	*threadio;
--=-SlH54Ca4am+ZhhAqEYyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAllEDcEACgkQcVMCLawGqBxlngCgwJp7YjXJaQ1NI3Vr9s1i8BPs
1P4AnRF7Nv7olc5b2PJ1H6K5NWACYEGE
=ww3u
-----END PGP SIGNATURE-----

--=-SlH54Ca4am+ZhhAqEYyB--
