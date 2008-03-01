Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JVNb7-0005wj-BH
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 10:01:37 +0100
Date: Sat, 1 Mar 2008 09:55:38 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Andrea <mariofutire@googlemail.com>
Message-ID: <20080301085538.GA4003@paradigm.rfc822.org>
References: <47C8A135.9070209@googlemail.com>
MIME-Version: 1.0
In-Reply-To: <47C8A135.9070209@googlemail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help using DMX_SET_BUFFER_SIZE
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0007084471=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0007084471==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 01, 2008 at 12:20:05AM +0000, Andrea wrote:
> Hi,
>=20
> I've tried to add an extra argument to gnutv to set the size of the dvb_r=
ingbuffer via=20
> DMX_SET_BUFFER_SIZE.
>=20
> I have not really understood the difference between dvr and demux.
> It seems that gnutv uses the dvr to read from the DVB card and then copie=
s the content to a file.
>=20
> I call
>=20
> int dvbdemux_set_buffer(int fd, int bufsize)
> {
> 	return ioctl(fd, DMX_SET_BUFFER_SIZE, bufsize);
> }
>=20
> on the dvr (I think), but it does not make much of a change. The ioctl ca=
ll returns success.
> I've printed a lot of debug output (adding a few dprintk) and this is wha=
t I see when I run gnutv.
> Now, I set the buffer to 1024 * 1024 which is nowhere in the log.
> I cannot see in the log the 2 functions (demux and dvr) handling this ioc=
tl call:
> dvb_demux_do_ioctl and dvb_dvr_do_ioctl (I've added some printk as well).

In 2.6.25-rc3 the dvr kernel side looks like this:

1015         switch (cmd) {
1016         case DMX_SET_BUFFER_SIZE:
1017                 // FIXME: implement
1018                 ret =3D 0;
1019                 break;

i guess its clear why it doesnt make a difference ;)

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyRoKUaz2rXW+gJcRAqprAJsFB1RvImGclVAjTat4qc5WG6MCEwCfYSSE
7B4ZEEqeQ0bgDTZZvP7acXA=
=shUm
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--


--===============0007084471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0007084471==--
