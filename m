Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44134 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756932AbeFQAcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 20:32:02 -0400
Message-ID: <eb07f5fa149bc56775a2e7bc3695f581ac2c0135.camel@collabora.com>
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Sat, 16 Jun 2018 20:31:58 -0400
In-Reply-To: <d2d1d0938384a54bf1c268c83a2684c618bc4af9.camel@collabora.com>
References: <20180612104827.11565-1-ezequiel@collabora.com>
                 <46417cb4adca9289841287c8590b0ce92059298f.camel@collabora.com>
         <d2d1d0938384a54bf1c268c83a2684c618bc4af9.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-88lbedzBOV+Qo6VNf+aL"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-88lbedzBOV+Qo6VNf+aL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 juin 2018 =C3=A0 17:05 -0300, Ezequiel Garcia a =C3=A9crit :
> > Will the end result have "device node name /dev/..." on both entity
> > 1
> > and 6 ?=20
>=20
> No. There is just one devnode /dev/videoX, which is accepts
> both CAPTURE and OUTPUT directions.

My question is more ifthe dev node path will be provided somehow,
because it's not displayed in this topology=C3=A9

Nicolas
--=-88lbedzBOV+Qo6VNf+aL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWyWr/gAKCRBxUwItrAao
HIUFAKCKlI0TEphtNdNmc4zFnYt5lkLuEwCfUKQiIivwvYNCvkYu79UAHqb+GXk=
=bckY
-----END PGP SIGNATURE-----

--=-88lbedzBOV+Qo6VNf+aL--
