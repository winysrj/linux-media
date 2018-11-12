Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51968 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbeKMCGK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 21:06:10 -0500
Message-ID: <2e1563512bd1cfc71ecff5f079faded11fd99c55.camel@bootlin.com>
Subject: Re: [RFC PATCHv2 1/5] videodev2.h: add tag support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 12 Nov 2018 17:12:13 +0100
In-Reply-To: <20181112083305.22618-2-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
         <20181112083305.22618-2-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wSQdjxgCFg53/3qsCeba"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wSQdjxgCFg53/3qsCeba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-11-12 at 09:33 +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Add support for 'tags' to struct v4l2_buffer. These can be used
> by m2m devices so userspace can set a tag for an output buffer and
> this value will then be copied to the capture buffer(s).
>=20
> This tag can be used to refer to capture buffers, something that
> is needed by stateless HW codecs.

I am getting the following warning when building with this patch:

videodev2.h:1044:9: warning: cast to pointer from integer of different
size [-Wint-to-pointer-cast]
  return (void *)v4l2_buffer_get_tag(buf);

That is because we are on a 32-bit architecture here, so pointers are
not 64-bit long, thus we can't have an equivalency between tag and
pointer.

It looks like this isn't used in the following patches, so perhaps it
should be dropped?

Cheers,

Paul

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/videodev2.h | 37 +++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index c8e8ff810190..a6f81f368e01 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -912,6 +912,11 @@ struct v4l2_plane {
>  	__u32			reserved[11];
>  };
> =20
> +struct v4l2_buffer_tag {
> +	__u32 low;
> +	__u32 high;
> +};
> +
>  /**
>   * struct v4l2_buffer - video buffer info
>   * @index:	id number of the buffer
> @@ -950,7 +955,10 @@ struct v4l2_buffer {
>  	__u32			flags;
>  	__u32			field;
>  	struct timeval		timestamp;
> -	struct v4l2_timecode	timecode;
> +	union {
> +		struct v4l2_timecode	timecode;
> +		struct v4l2_buffer_tag	tag;
> +	};
>  	__u32			sequence;
> =20
>  	/* memory location */
> @@ -988,6 +996,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
>  /* timecode field is valid */
>  #define V4L2_BUF_FLAG_TIMECODE			0x00000100
> +/* tag field is valid */
> +#define V4L2_BUF_FLAG_TAG			0x00000200
>  /* Buffer is prepared for queuing */
>  #define V4L2_BUF_FLAG_PREPARED			0x00000400
>  /* Cache handling flags */
> @@ -1007,6 +1017,31 @@ struct v4l2_buffer {
>  /* request_fd is valid */
>  #define V4L2_BUF_FLAG_REQUEST_FD		0x00800000
> =20
> +static inline void v4l2_buffer_set_tag(struct v4l2_buffer *buf, __u64 ta=
g)
> +{
> +	buf->tag.high =3D tag >> 32;
> +	buf->tag.low =3D tag & 0xffffffffULL;
> +	buf->flags |=3D V4L2_BUF_FLAG_TAG;
> +}
> +
> +static inline void v4l2_buffer_set_tag_ptr(struct v4l2_buffer *buf,
> +					   const void *tag)
> +{
> +	v4l2_buffer_set_tag(buf, (__u64)tag);
> +}
> +
> +static inline __u64 v4l2_buffer_get_tag(const struct v4l2_buffer *buf)
> +{
> +	if (!(buf->flags & V4L2_BUF_FLAG_TAG))
> +		return 0;
> +	return (((__u64)buf->tag.high) << 32) | (__u64)buf->tag.low;
> +}
> +
> +static inline void *v4l2_buffer_get_tag_ptr(const struct v4l2_buffer *bu=
f)
> +{
> +	return (void *)v4l2_buffer_get_tag(buf);
> +}
> +
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file desc=
riptor
>   *
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-wSQdjxgCFg53/3qsCeba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvppl0ACgkQ3cLmz3+f
v9HZ2gf9FY5ecua4OiINuKBVHKOUrqgwxKxeRRtMs5fmARCtBv/uA100hQI5OvDI
VUgkhqJLBjjH/z4vkgKAJdUZ0FEcipndqZ3kRlharSMzV0KKIe/Mivh2KtIUYRfQ
O1yWaFjLCNCFK89cb0yU18kDJxMQUxLfz2AC+XuJ0JZrC2rAS7EMLR62auedvhkq
j1BPkELwXfnoG3sZxLZkBcDW6n1ukJ9jefX16aJzA9Th+Jwph/28rNvEyjVGB1d+
MizWZKK23tRI/xZ0BNZEFiSTdJ4J/oWw+pLQR2fvIsQCZIW0loFuPq9jNKV61mlW
QBA/SY9SpviffZvuh8u0weKonLcTBg==
=VEdO
-----END PGP SIGNATURE-----

--=-wSQdjxgCFg53/3qsCeba--
