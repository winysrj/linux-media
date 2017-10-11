Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:56123 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752907AbdJKUrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 16:47:23 -0400
Received: by mail-qt0-f177.google.com with SMTP id x54so9190059qth.12
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 13:47:22 -0700 (PDT)
Message-ID: <1507754838.19342.11.camel@ndufresne.ca>
Subject: Re: [PATCH v3 1/2] staging: Introduce NVIDIA Tegra20 video decoder
 driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Oct 2017 16:47:18 -0400
In-Reply-To: <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
References: <cover.1507752381.git.digetx@gmail.com>
         <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-hQ+YrLKtwEhINVxeVYTt"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-hQ+YrLKtwEhINVxeVYTt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 11 octobre 2017 =C3=A0 23:08 +0300, Dmitry Osipenko a =C3=A9cri=
t :
> diff --git a/drivers/staging/tegra-vde/TODO b/drivers/staging/tegra-
> vde/TODO
> new file mode 100644
> index 000000000000..e98bbc7b3c19
> --- /dev/null
> +++ b/drivers/staging/tegra-vde/TODO
> @@ -0,0 +1,5 @@
> +TODO:
> +       - Figure out how generic V4L2 API could be utilized by this
> driver,
> +         implement it.
> +

That is a very interesting effort, I think it's the first time someone
is proposing an upstream driver for a Tegra platform. When I look
tegra_vde_h264_decoder_ctx, it looks like the only thing that the HW is
not parsing is the media header (pps/sps). Is that correct ?

I wonder how acceptable it would be to parse this inside the driver. It
is no more complex then parsing an EDID. If that was possible, wrapping
this driver as a v4l2 mem2mem should be rather simple. As a side
effect, you'll automatically get some userspace working, notably
GStreamer and FFmpeg.

For the case even parsing the headers is too much from a kernel point
of view, then I think you should have a look at the following effort.
It's a proposal base on yet to be merged Request API. Hugues is also
propose a libv4l2 adapter that makes the driver looks like a normal
v4l2 m2m, hiding all the userspace parsing and table filling. This
though, is long term plan to integrate state-less or parser-less
encoders into linux-media. It seems rather overkill for state-full
driver that requires parsed headers like PPS/SPS.

https://lwn.net/Articles/720797/

regards,
Nicolas
--=-hQ+YrLKtwEhINVxeVYTt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWd6DVwAKCRBxUwItrAao
HDQrAKDVFLfZTOGk1lK0E7rdaFkXPVUI1QCfasRs+MAVBvxhbQl6+N2IwHr2EkU=
=I5vO
-----END PGP SIGNATURE-----

--=-hQ+YrLKtwEhINVxeVYTt--
