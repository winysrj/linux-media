Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeEDUBE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:01:04 -0400
Date: Fri, 4 May 2018 17:00:59 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] v4l: Add macros for printing V4L 4cc values
Message-ID: <20180504170053.66f96b1c@vento.lan>
In-Reply-To: <1522846930-2967-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522846930-2967-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  4 Apr 2018 16:02:10 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Add two macros that facilitate printing V4L fourcc values with printf
> family of functions. v4l2_fourcc_conv provides the printf conversion
> specifier for printing formats and v4l2_fourcc_to_conv provides the actual
> arguments for that conversion specifier.
>=20
> These macros are useful in both user and kernel code, therefore put them
> into videodev2.h.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/videodev2.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index caec178..93184929 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -82,6 +82,31 @@
>  	((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 2=
4))
>  #define v4l2_fourcc_be(a, b, c, d)	(v4l2_fourcc(a, b, c, d) | (1 << 31))
> =20
> +/**
> + * v4l2_fourcc_conv - Printf fourcc conversion specifiers for V4L2 forma=
ts
> + *
> + * Use as part of the format string. The values are obtained using
> + * @v4l2_fourcc_to_conv macro.
> + *
> + * Example ("format" is the V4L2 pixelformat in __u32):
> + *
> + * printf("V4L2 format is: " v4l2_fourcc_conv "\n", v4l2_fourcc_to_conv(=
format);
> + */
> +#define v4l2_fourcc_conv "%c%c%c%c%s"
> +
> +/**
> + * v4l2_fourcc_to_conv - Arguments for V4L2 fourcc format conversion
> + *
> + *=C2=A0@fourcc: V4L2 pixelformat, as in __u32
> + *
> + * Yields to a comma-separated list of arguments for printf that matches=
 with
> + * conversion specifiers provided by @v4l2_fourcc_conv.
> + */
> +#define v4l2_fourcc_to_conv(fourcc)					\
> +	(fourcc) & 0x7f, ((fourcc) >> 8) & 0x7f, ((fourcc) >> 16) & 0x7f, \
> +	((fourcc) >> 24) & 0x7f, (fourcc) & (1 << 31) ? "-BE" : ""
> +

IMO, it doesn't make sense to have this at uAPI.


Thanks,
Mauro
