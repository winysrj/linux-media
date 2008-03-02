Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JVxpd-0006Px-SR
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 00:43:06 +0100
Date: Mon, 3 Mar 2008 00:36:53 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080302233653.GA3067@paradigm.rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CB2D95.6040602@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1551877265=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1551877265==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

On Mon, Mar 03, 2008 at 02:43:33AM +0400, Manu Abraham wrote:
> Florian Lohoff wrote:
> >Hi,
> >i was wondering why i have a problem in my application that i need to
> >run scan once after loading the module, otherwise my DVBFE_SET_PARAMS
> >fails - I couldnt explain it until i looked into the kernel code - In
> >the dvb_frontend.c i see this code:
> >
> >1738         case DVBFE_SET_PARAMS: {
> >1739                 struct dvb_frontend_tune_settings fetunesettings;
> >1740                 enum dvbfe_delsys delsys =3D fepriv->fe_info.delive=
ry;
> >...
> >1783                 } else {
> >1784                         /* default values */
> >1785                         switch (fepriv->fe_info.delivery) {
> >...
> >1817                         default:
> >1818                                 up(&fepriv->sem);
> >1819                                 return -EINVAL;
> >1820                         }
> >
> >Should the code use fepriv->feparam.delivery instead of
> >fepriv->fe_info.delivery to sense the right delivery system ?
>=20
> Which demodulator driver are you using to test your application ?

STB0899 on a SkyStar HD - Using DVB-S2 on Astra=20
=20
> Though a bug, but that won't make any difference to what you are looking =
at,
> since the delay and others are used in the case of swzigzag, which=20
> doesn't exist
> at least for the existing demods using the track() callback at all.

The problem i see and some people off list already acknowledged is that
the DVBFE_GET_INFO actually _SETS_ informations in the kernel about the
delivery system which gets even cached across frontend opens. This is=20
why my application, which did not issue a GET_INFO but rather set the
delivery system in the dvbfeparam, failed. The delivery in the
dvbfeparam in the DVBFE_SET_PARAM ioctl gets ignored. When running scan=20
once after loading the module the delivery system gets set and suddenly
my little app works, but only for the frontend/delivery type i pressed
ctrl-c on running scan, and until i reload the module.

I changed the kernel dvb_frontend.c to actually use the dvbfeparam
delivery system type but then the demod driver stb0899 pukes into my
kernel log that it finds an unknown delivery system because it makes the ve=
ry
same assumption that it should use the delivery from GET_INFO and not
SET_PARAM ...=20

stb0899_drv.c:
1406 static int stb0899_get_info(struct dvb_frontend *fe, struct dvbfe_info=
 *fe_info)
1407 {
1408         struct stb0899_state *state =3D fe->demodulator_priv;
1409=20
1410         dprintk(verbose, FE_DEBUG, 1, "Get Info");
1411=20
1412         state->delsys =3D fe_info->delivery;
1413         switch (state->delsys) {

Line 1412 caches informations in the frontend demod without purpose - Get i=
nfo is just
that and not some state altering ioctl ...

> This would be a fix for any demod drivers using the set_params() callback.

Yep - something should be fixed - currently its a little inconsistent:

- A GET or READ call should never ever alter state - otherwise it should be=
 named
  different. Its the same with read/write, peek/poke, load/store set/get.
  Just because i ask about informations concerning the DVB-S frontend does
  not mean that i will not start DVB-S2 or DSS.
- If DVBFE_SET_PARAM passes a struct which contains a delivery system it
  should either be honored or not even be there. On a SET call with a struct
  every application writers assumption is that the values in the struct pas=
sed
  actually get honored.

And this MUST be coherent for all demods.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyzoVUaz2rXW+gJcRAmT8AJ4mxpyYkyTgCX2wai4nBqsSJig2VwCgujsZ
Jd9sPmd49yfH7zsNbJid28g=
=j6xI
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--


--===============1551877265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1551877265==--
