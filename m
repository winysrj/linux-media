Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JWAi6-0004vT-GL
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:28:06 +0100
Date: Mon, 3 Mar 2008 14:21:57 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303132157.GA9749@paradigm.rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CBE8FD.9030303@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1413264146=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1413264146==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 04:03:09PM +0400, Manu Abraham wrote:
> >- make SET_PARAMS the call to honor delivery in dvbfe_params and remove
> >  the setting of the delivery of GET_INFO
> >
> >I'd prefere the 2nd option because currently the usage and naming
> >is an incoherent mess which should better not get more adopters ..
>=20
> Your 2nd option won't work at all. It is completely broken when you have
> to query statistics, before a SET_PARAMS.

I have no problem with beeing able to query stats - I have a problem
that a GET call changes in kernel state, and the SET calls options get
ignored where it should be the other way round.=20

Probably you can tell me the reason the delivery option in the
dvbfe_params gets ignored on a DVBFE_SET_PARAMS ? I dont see the
rational behind this... The option is there - correctly filled and
gets ignored or better overriden by previous ioctls - Every other
parameter for the delivery mode is in that struct.

Please tell me why the GET_INFO delsys/delivery option gets set as the next
to use delivery mode. Even if i want to have stats just dont fill them
when the delsys does not match the currently set delsys as that would
be the right thing - Querying DVB-S2 stats when tuned to DVB-S should
return nothing as there are no stats - but setting the delsys to DVB-S
is BROKEN as i asked for stats not to change the delsys.
=20
> Additionally, this was quite discussed in a long discussion a while=20
> back. You might like to read through those as well.

I did partially of it ... and i found the same corners of this API to be
broken by design.

> Maybe DVBFE_GET_INFO can probably be renamed to DVBFE_INFO if it really
> itches so much.

No - its much more fundamental problem ... Options belonging
together are passed in seperate ioctls in non obvious (read: strange)
ways into the kernel (delivery system via GET_INFO and delivery options
via SET_PARAMS).=20

Options which are together in the same struct are not used together e.g.
delivery mode and parameters are in the same struct which get passed by
an ioctl but get partially ignored or better overridden by previous=20
ioctls in non obvious ways...

As i said - incoherent mess from the user api ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHy/t1Uaz2rXW+gJcRAg0MAJ4p+9SbGBq8nuMHVpjhKBKScZ+j/gCgzInp
+OZEXM8MACsqzXFtC7t2mmw=
=9w1+
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--


--===============1413264146==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1413264146==--
