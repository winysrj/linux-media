Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JUL0R-0008Uv-Cz
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 13:03:27 +0100
Date: Wed, 27 Feb 2008 12:57:43 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Peter Hartley <pdh@utter.chaos.org.uk>
Message-ID: <20080227115743.GB29770@paradigm.rfc822.org>
References: <1204046724.994.21.camel@amd64.pyotr.org>
MIME-Version: 1.0
In-Reply-To: <1204046724.994.21.camel@amd64.pyotr.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams
	from same mux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0587065937=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0587065937==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 26, 2008 at 05:25:24PM +0000, Peter Hartley wrote:
> The attached patch adds a new value for dmx_output_t:
> DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. The main
> question I have, is, seeing as this was such a simple change, why didn't
> it already work like that? Does everyone else who wants to capture
> multiple video streams, take the whole multiplex into userspace and
> demux it themselves? Or do they take PES from each demux0 device and
> re-multiplex that into PS, not TS?

With getstream a little toy project of mine i basically just fetch the
whole stream with pid 0x2000 for budget cards, or join individual pids
on non-budget cards and do the whole remuxing stuff in userspace.

It is okay to have a MpegTS demux in kernel space as its a "unify the
interface" thingy for all different cards, but the section reassembly
is just a little featured moved to the kernel where it IMHO does not
belong to.

RFC1925 - The twelve networking thruths:

   (12) In protocol design, perfection has been reached not when there
           is nothing left to add, but when there is nothing left to
	   take away.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxVA3Uaz2rXW+gJcRAiV9AKCJpZntSY66QuQujiGgd6yv54yVqQCgvomy
YcZls2HUcYrG46x3txNLovo=
=Yug5
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--


--===============0587065937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0587065937==--
