Return-path: <linux-media-owner@vger.kernel.org>
Received: from wrz3028.rz.uni-wuerzburg.de ([132.187.3.28]:35629 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab1HFQF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2011 12:05:29 -0400
Date: Sat, 6 Aug 2011 18:05:26 +0200
From: Steve Wolter <swolter@sdf.lonestar.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Support for Hauppauge WinTV HVR-3300
Message-ID: <20110806160526.GA2666@achter.swolter.sdf1.org>
References: <20110806144444.GA11588@achter.swolter.sdf1.org>
 <CAGoCfiw8R_RsYdHucMqRCXPndZGO7bG=0ogw9k9vpd-xYuPtAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <CAGoCfiw8R_RsYdHucMqRCXPndZGO7bG=0ogw9k9vpd-xYuPtAw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Devin,

Devin Heitmueller schrieb:
> On Sat, Aug 6, 2011 at 10:44 AM, Steve Wolter <swolter@sdf.lonestar.org> =
wrote:
> > Dear linux-media list,
> >
> > I have recently bought a Hauppauge WinTV HVR-3300 and am trying to make
> > it run with Linux.
[...]
>=20
> Like the 4400 and 5500, the 3300 uses both DVB-S and DVB-T demodulator
> chips for which there is currently no driver.  Somebody would have to
> write those drivers from
> scratch in order for any of those products to be supported.
>=20
> In other words, it's not a case of just needing to add a few lines of
> code for another board profile.

Fair enough, thanks for the feedback, I think that project is out of my
scope for now. I'm mainly interested in the analog demodulation at the
moment, have the DVB capacity mainly for future use. Do you know anything
about the analog TV decoder in there? Is this decoupled from the DVB
stuff and could be made to work on its own?

If it's any help, I've tried to fiddle around with several forced card
options, and tveeprom auto-detects the tuners as:

 tveeprom 13-0050: Hauppauge model 53009, rev C1F5, serial# 6493293
 tveeprom 13-0050: MAC address is 00:0d:fe:63:14:6d
 tveeprom 13-0050: tuner model is NXP 18271C2 (idx 155, type 54)
 tveeprom 13-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATS=
C/DVB Digital (eeprom 0xf4)
 tveeprom 13-0050: audio processor is CX23888 (idx 40)
 tveeprom 13-0050: decoder processor is CX23888 (idx 34)
 tveeprom 13-0050: has no radio, has IR receiver, has no IR transmitter

Best regards, Steve

--=20
 Steve Wolter ( W=FCrzburg Univ.) | Web page: http://swolter.sdf1.org
                                | vCard:    http://swolter.sdf1.org/swolter=
=2Evcf
 A witty saying proves nothing. | Schedule: http://swolter.sdf1.org/sched.c=
gi
    -- Voltaire (1694-1778)     | E-mail:   swolter@sdf.lonestar.org

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOPWZG7ZhDb8MHkiIRAn6yAKCnnAsxur03ex+3Y2sKguXPJaV/TwCgtVPG
HeLOafLn8F3TzN0qHZLtbFI=
=0MmL
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
