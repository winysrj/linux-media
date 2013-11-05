Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:35203 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KEW1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 17:27:30 -0500
Received: by mail-qc0-f177.google.com with SMTP id u18so5140653qcx.8
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 14:27:30 -0800 (PST)
Date: Tue, 5 Nov 2013 19:25:06 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?B?wqBNYXVybw==?= Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?UTF-8?B?wqBHcmVn?= Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 4/4] media/solo6x10: Changes on the vb2-dma-sg API
Message-ID: <20131105192506.20afed89@pirotess.bifrost.iodev.co.uk>
In-Reply-To: <1374220729-8304-5-git-send-email-ricardo.ribalda@gmail.com>
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
	<1374220729-8304-5-git-send-email-ricardo.ribalda@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QUa3QeNB2I2+nlzdSdXaJvq"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/QUa3QeNB2I2+nlzdSdXaJvq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jul 2013 09:58:49 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:
> The struct vb2_dma_sg_desc has been replaced with the generic sg_table
> to describe the location of the video buffers.
>=20
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

<...>

--Sig_/QUa3QeNB2I2+nlzdSdXaJvq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSeXBCAAoJEBrCLcBAAV+GyxgH+QHdMWvrmMLg2AO+Skb78XCs
htJ0nqpH6Ai9BaecQmw3b4HJcrYsszudNG2F/Hqi2usCUtI9WlWcvyoC4l3I+1a+
zhmit7TBCps0Vnec6aAh1fW1lKN3vhWFfUCSwCWcAahtp2DGsVTfLST2Xt3rNe7W
9FI4Cgrtid0r0xQC06FYHrHxY1/ESZW0A86eZPhpHc3j7/NAfONrgQr40riinran
j/5XmSt4HoC+KsWfYqtP3XBkTuspm3XL+PBaOm7aKmXSqU1vw8moDWRJfFEjSCBf
9/cR/ltCy/+oAuvBXF/z0SuvC/+DIyaRp66jTe/FIf9zgKBOcU3djzqw4TyNPQo=
=Kisn
-----END PGP SIGNATURE-----

--Sig_/QUa3QeNB2I2+nlzdSdXaJvq--
