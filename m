Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59319 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109AbbLPVtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 16:49:50 -0500
Message-ID: <1450302584.6121.31.camel@collabora.com>
Subject: Re: problem with coda when running qt-gstreamer and video reaches
 its end (resending in plain text)
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Piotr Lewicki <piotr.lewicki@elfin.de>
Cc: linux-media@vger.kernel.org
Date: Wed, 16 Dec 2015 16:49:44 -0500
In-Reply-To: <1450277389.3421.53.camel@pengutronix.de>
References: <5671618A.5000300@elfin.de> <5671627C.8020205@elfin.de>
	 <1450277389.3421.53.camel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-a0RFtS69m8B7Ke805aLF"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-a0RFtS69m8B7Ke805aLF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 16 d=C3=A9cembre 2015 =C3=A0 15:49 +0100, Philipp Zabel a =C3=
=A9crit=C2=A0:
> > # [ 1382.828875] coda 2040000.vpu: CODA PIC_RUN timeout
> > # [ 1383.938704] coda 2040000.vpu: CODA PIC_RUN timeout
> >=C2=A0
> > The video is stopped but I can see last frame on the screen although in=
=C2=A0
> > qt application it should receive end-of-stream message and stop the=C2=
=A0
> > video (resulting with black screen).
>=20
> Looks like the coda driver is constantly fed empty buffers, which don't
> increase the bitstream payload level, and the PIC_RUN times out with a
> bitstream buffer underflow. What GStreamer version is this?

I believe this is side effect of how the MFC driver worked in it's
early stage. We had to keep pushing empty buffer to drain the driver.
So GStreamer still poll/queue/poll/queue/... until all capture buffers
are received. I notice recently that this behaviour can induce high CPU
load with some other drivers that don't do any active wait when a empty
buffer is queued. I would therefor suggest to change this code to only
push one empty buffer for your use case. An submitted patch to support
CMD_STOP can be found here, though is pending a re-submition by it's
author.

https://bugzilla.gnome.org/show_bug.cgi?id=3D733864

For proper EOS detection with CODA driver (using EPIPE return value),
you indeed need GStreamer 1.6+.

cheers,
Nicolas
--=-a0RFtS69m8B7Ke805aLF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlZx3HgACgkQcVMCLawGqByKkwCeNHkq2GE65G0U+bgluYNK58Ua
/Q8AoJcUEHdn9k1W3yhrq/kmh6I1fgt0
=gYFu
-----END PGP SIGNATURE-----

--=-a0RFtS69m8B7Ke805aLF--

