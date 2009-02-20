Return-path: <linux-media-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:3360 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbZBTXQk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 18:16:40 -0500
Received: from phare.normalesup.org (phare.normalesup.org [129.199.129.80])
          by nef2.ens.fr (8.13.6/1.01.28121999) with ESMTP id n1KMog9U085546
          for <linux-media@vger.kernel.org>; Fri, 20 Feb 2009 23:50:42 +0100 (CET)
Date: Fri, 20 Feb 2009 23:50:42 +0100
From: Nicolas George <nicolas.george@normalesup.org>
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy T USB XXS: remote does not work with 1.20 firmware
Message-ID: <20090220225042.GA19663@phare.normalesup.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[This is a repost of a message sent to the obsolete linux-dvb@linuxtv.org l=
ist.]

Hi.

I am trying to get the remote controller with a Terratec Cinergy T USB XXS.
With the firmware dvb-usb-dib0700-1.10.fw, the remote sends codes (not
perfectly, but I can see where I am going).

On the other hand, with dvb-usb-dib0700-1.20.fw, the remote does not detect
anything. After some tracking, I found that in dib0700_rc_query_v1_20 (from
dib0700_devices.c), the status from usb_bulk_msg is always -110
(-ETIMEDOUT).

Is there some way I can help fixing things? I do not mind using the old
firmware, but I would like to help improving things.

Regards,

--=20
  Nicolas George

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmfM8IACgkQsGPZlzblTJO9LgCcDrL9YaaCQcY1wmineUUXJi/l
58EAnjUHzeiUlQms+uzysM0jtYcbqo5d
=H0pv
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
