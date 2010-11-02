Return-path: <mchehab@gaivota>
Received: from server.trebels.com ([217.20.117.122]:50034 "EHLO
	server.trebels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0KBKol (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 06:44:41 -0400
Subject: Re: [libdvben50221] stack leaks resources on non-MMI session
 reconnect.
From: Stephan Trebels <stephan@trebels.com>
To: DUBOST Brice <dubost@crans.ens-cachan.fr>
Cc: stephan@trebels.com, linux-media@vger.kernel.org,
	adq_dvb@lidskialf.net
In-Reply-To: <4CCFE4DE.8070706@crans.ens-cachan.fr>
References: <1279200014.14890.33.camel@stephan-laptop>
	 <4C5F2747.1010806@crans.ens-cachan.fr>
	 <4CCFE4DE.8070706@crans.ens-cachan.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eaHgoVwaHX8GdIzEH1Gz"
Date: Tue, 02 Nov 2010 11:38:29 +0100
Message-ID: <1288694309.3365.11604.camel@stephan-laptop>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


--=-eaHgoVwaHX8GdIzEH1Gz
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Brice,

I did not find more things to be changed, and it works fine for me now.
Given, that the responsiveness on this list is a bit underwhelming, I
wonder whether we can find someone with commit privileges, to push this
change.

Stephan

On Tue, 2010-11-02 at 11:15 +0100, DUBOST Brice wrote:=20
> On 08/08/2010 23:53, DUBOST Brice wrote:
> > On 15/07/2010 15:20, Stephan Trebels wrote:
> >>
> >> The issue was, that LIBDVBEN50221 did not allow a CAM to re-establish
> >> the session holding non-MMI resources if using the lowlevel interface.
> >> The session_number was recorded on open, but not freed on close (which
> >> IMO is an bug in the code, I attach the scaled down hg changeset). Wit=
h
> >> this change, the SMIT CAM with a showtime card works fine according to
> >> tests so far.
> >>
> >> The effect was, that the CAM tried to constantly close and re-open the
> >> session and the LIBDVBEN50221 kept telling it, that the resource is
> >> already allocated to a different session. Additionally this caused the
> >> library to use the _old_ session number in communications with the CAM=
,
> >> which did not even exist anymore, so caused all writes of CA PMTs to
> >> fail with EINTR.
> >>
> >> Stephan
> >>
> >
> > Hello
> >
> > Just to inform that this patch solves problems with CAM PowerCAM v4.3,
> > so I think it can interest more people.
> >
> > Before gnutv -cammenu (and other applications using libdvben50221) was
> > returning ti;eout (-3) errors constantly after the display of the syste=
m
> > IDs.
> >
> > Now, the menu is working flawlessly
> >
> > I cannot test the descrambling for the moment but it improved quite a
> > lot the situation (communication with th CAM is now possible).
> >
> > One note concerning the patch itself, the last "else if (resource_id =
=3D=3D
> > EN50221_APP_MMI_RESOURCEID)" is useless.
> >
> > Best regards
> >
> >
>=20
>=20
> Hello
>=20
>=20
> After more testing this Patches allow several CAM models to work and=20
> don't seem to make any regression.
>=20
> Is there anything to be improved/tested for having it included upstream ?
>=20
> Thank you
>=20
> Regards
>=20


--=-eaHgoVwaHX8GdIzEH1Gz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzP6iAACgkQaPIaLXoy76Nv4QCeOpRgEcDGCrf5JrfnRA0FVP7P
CiwAoKhTmK9AD4RKcpHEGajG+esp8/JK
=di0m
-----END PGP SIGNATURE-----

--=-eaHgoVwaHX8GdIzEH1Gz--

