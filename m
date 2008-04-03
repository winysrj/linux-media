Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m336WBZP004805
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 02:32:11 -0400
Received: from smtp8.yandex.ru (smtp8.yandex.ru [213.180.200.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m336Vxpd030996
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 02:31:59 -0400
Received: from ppp83-237-250-149.pppoe.mtu-net.ru ([83.237.250.149]:51871 "EHLO
	[192.168.1.5]" smtp-auth: "nshmyrev" TLS-CIPHER: "DHE-RSA-AES256-SHA
	keybits 256/256 version TLSv1/SSLv3" TLS-PEER-CN1: <none>)
	by mail.yandex.ru with ESMTP id S7455894AbYDCGbn (ORCPT
	<rfc822;video4linux-list@redhat.com>); Thu, 3 Apr 2008 10:31:43 +0400
From: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
To: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
In-Reply-To: <20080402183820.6c917a0a@tux.abusar.org.br>
References: <20080401190033.68c821ed@tux.abusar.org.br>
	<1207093795.16537.4.camel@localhost.localdomain>
	<20080402183820.6c917a0a@tux.abusar.org.br>
Date: Thu, 03 Apr 2008 10:29:04 +0400
Message-Id: <1207204144.2386.1.camel@localhost.localdomain>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: Remote controller for Powercolor Real Angel 330
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1106536155=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============1106536155==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-+oePw1YRp3adjs4IkuS1"


--=-+oePw1YRp3adjs4IkuS1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


=D0=92 =D0=A1=D1=80=D0=B4, 02/04/2008 =D0=B2 18:38 -0300, D=C3=A2niel Fraga=
 =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, 02 Apr 2008 03:49:54 +0400
> "Nickolay V. Shmyrev" <nshmyrev@yandex.ru> wrote:
>=20
> >=20
> > =D0=92 =D0=92=D1=82=D1=80, 01/04/2008 =D0=B2 19:00 -0300, D=C3=A2niel F=
raga =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > 	The support for Powercolor Real Angel 330 is almost complete.
> > > Everything works. I just need to finish the codes for remote controll=
er.
> > >=20
> > > 	I have the following:
> > >=20
> > > 1) cx88-input.c
> > >=20
> > >                 ir_codes =3D ir_codes_powercolor_real_angel;
> > >                 ir->gpio_addr =3D MO_GP2_IO;
> > >                 ir->mask_keycode =3D 0x7f;
> > >                 ir->polling =3D 1; /* ms */
> > >=20
> > > 2) ir-keymaps.c:
> > >=20
> > >         [0x03] =3D KEY_1,
> > >         [0x05] =3D KEY_2,
> > >         [0x07] =3D KEY_3,
> > >         [0x11] =3D KEY_8,
> > >         [0x13] =3D KEY_9,
> > >         [0x71] =3D KEY_SWITCHVIDEOMODE,   /* switch inputs */
> > >         [0x41] =3D KEY_UP,
> > >         [0x43] =3D KEY_DOWN,
> > >         [0x21] =3D KEY_RIGHT,
> > >         [0x23] =3D KEY_LEFT,
> > >         [0x25] =3D KEY_PAUSE,
> > >         [0x27] =3D KEY_PLAY,
> > >         [0x17] =3D KEY_STOP,
> > >         [0x47] =3D KEY_FASTFORWARD,
> > >         [0x45] =3D KEY_REWIND,
> > >         [0x37] =3D KEY_RECORD,
> > >         [0x35] =3D KEY_SEARCH,            /* autoscan */
> > >         [0x15] =3D KEY_SHUFFLE,           /* snapshot */
> > >         [0x53] =3D KEY_PREVIOUS,          /* previous channel */
> > >         [0x15] =3D KEY_DIGITS,            /* single, double, tripple =
digit */=20
> > > 	[0x57] =3D KEY_MODE,              /* stereo/mono */=20
> > > 	[0x51] =3D KEY_TEXT,              /* teletext */ =20
> > >=20
> > > 	All these keys work perfectly. But some keys use the same code.
> > > For example, if I press "5" on the remote, I get "1" and if I press
> > > "6", I get "2".
> > >=20
> > > 	***
> > >=20
> > > 	I noticed that some keys generate more than one code... I tried
> > > all ir types (RC5, PD, OTHER) without success. Does anybody have any
> > > clues about that?
> > >=20
> > > 	Could the mask_keycode be wrong? Any hints?
> > >=20
> >=20
> > Keymask is wrong most probably. Get the right one with RegSpy
> > application from Dscaler project in Windows.
>=20
> 	Hi Nicholas. Thanks for the answer.
> =09
> 	I got Regspy running and I can monitor MO_GP2_IO. The problem
> is:
>=20
> 1) when I press key "1", MO_GP2_IO changes to 0x883. Then if I press it
> again (the same key "1") it changes to 0x803. And it will switch
> between 883 and 803 each time I press "1"
>=20
> 2) for key "2" it alternates between 0x885 and 0x805
>=20
> 3) for key "3" it alternates between 0x887 and 0x807
>=20
> 4) for key "4" it alternates between 0x881 and 0x801
>=20
> 5) for key "5" it alternates between 0x883 and 0x803
>=20
> 	What exactly should I look at Regspy? Thank you!

Hm, looks strange. Probably something else is not powered properly. Did
you check your initial mask and gpio? Could you just share regspy output
and give us a link? Also please show use the changes you've made to add
your card support.


--=-+oePw1YRp3adjs4IkuS1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?koi8-r?Q?=FC=D4=C1?= =?koi8-r?Q?_=DE=C1=D3=D4=D8?=
	=?koi8-r?Q?_=D3=CF=CF=C2=DD=C5=CE=C9=D1?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=C1=CE=C1?=
	=?koi8-r?Q?_=C3=C9=C6=D2=CF=D7=CF=CA?=
	=?koi8-r?Q?_=D0=CF=C4=D0=C9=D3=D8=C0?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBH9HktLCDh4YwOt9kRApGRAJ4y3OjvxqXN4milXxPYenQcquSVswCcCrrw
ItfwHBG0lRTZ1h1w+8v/nyc=
=Whps
-----END PGP SIGNATURE-----

--=-+oePw1YRp3adjs4IkuS1--


--===============1106536155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1106536155==--
