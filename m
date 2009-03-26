Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:37982 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZCZSqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 14:46:19 -0400
Date: Thu, 26 Mar 2009 19:45:53 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Steven Toth <stoth@linuxtv.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	Darron Broad <darron@kewl.org>,
	"v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Allow the user to restrict the RC5 address
Message-ID: <20090326194553.3903ae61@laptop.hypervisor.org>
In-Reply-To: <49CBB11E.2030604@linuxtv.org>
References: <20090326033453.7d90236d@laptop.hypervisor.org>
	<200903260824.01970.hverkuil@xs4all.nl>
	<49CBB11E.2030604@linuxtv.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Mka7ID8Tb7CjMiIr9Gh3a7o";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Mka7ID8Tb7CjMiIr9Gh3a7o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2009 12:45:18 -0400 Steven Toth (ST) wrote:

ST> I too tend to have multiple remotes, I don't think it's that unusual for
ST> long standing Hauppauge customers to have many boards with many types of
ST> remotes.
ST>=20
ST> > It might be better to have an option to explicitly allow old Hauppauge
ST> > remotes that send 0x00.
ST> >
ST> I could live with this. It relegates older remotes but those remotes
ST> are no longer made. This feels like a good compromise.

How about changing the parameter such that it is a filter mask? The default
value of 0x0 would accept all remotes. For non-zero values, each bit set in
the parameter would filter the device address corresponding to that bit, e.=
g.
0x1 would filter address 0x0, 0x80000000 would filter address 0x1f, etc.

Cheers,

	- Udo

--Sig_/Mka7ID8Tb7CjMiIr9Gh3a7o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknLzWIACgkQnhRzXSM7nSnkcQCbBeWKW2FNgGLQipKL13UmmDOv
7nQAni1M9XaV544fhJb1D/1CbaYndy2J
=hCXk
-----END PGP SIGNATURE-----

--Sig_/Mka7ID8Tb7CjMiIr9Gh3a7o--
