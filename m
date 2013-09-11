Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3IKOs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 10:48:26 -0400
Date: Wed, 11 Sep 2013 16:48:24 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: stoth@linuxtv.org
Cc: linux-media@vger.kernel.org
Message-ID: <1152216514.26450.1378910904534.open-xchange@email.1and1.fr>
Subject: avermedia A306 / PCIe-minicard (laptop) / CX23885
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_26449_1418322827.1378910904449"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_26449_1418322827.1378910904449
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello

Antti, redirected me toward you,

I have this HC81 equivalent i think : ) as a PCIe minicard, with a NON low =
power
xc3028


As I tald him, I'll be more than glad to continue,

And

If it's at the least at the same "stage" as the HC81 , I think it deserve's=
 to
be listed in "cards".h

So people will know right away, that this card has been identified by the V=
4L
community, and dont have

to redo, at least what I did ... :) (for my part)



Best regards



> ---------- Message d'origine ----------
> De=C2=A0: remi <remi@remis.cc>
> =C3=80=C2=A0:=C2=A0 Antti Palosaari <crope@iki.fi>
> Cc: linux-media@vger.kernel.org
> Date=C2=A0: 21 ao=C3=BBt 2013 =C3=A0 14:29
> Sujet=C2=A0: Re: avermedia A306 / PCIe-minicard (laptop) / CX23885
>
> Hello
>
> I suggest this patch,
>
> For v4l/cx23885.h
> =C2=A0 =C2=A0 v4l/cx23885-video.c
> and v4l/cx23885-cards.c
>
> Status,
>
> AVerMedia A306 MiniCard Hybrid DVB-T=C2=A0 / 14f1:8852 (rev 02) Subsystem=
:
> 1461:c139
>
> Is beeing regognized and loaded by the driver, by it's PCI ID ,
>
> The correct firmwares are loaded fully notably by the Xceive 3028 .
>
> I'm testing the mpeg side, not fully yet (firmware) .
>
> The full dmesg output, with all relevant drivers set debug=3D1 , is attec=
hed to
> the email .
>
> I do not have all the cables to test (it's a laptop ..:) )
> so testing is more than welcome.
>
> Best regards
>
> R=C3=A9mi PUTHOMME-ESSAISSI .
>
>
>
> root@medeb:~/v4l# diff -u=C2=A0 media_build/v4l/cx23885-cards.c
> media_build.remi/v4l/cx23885-cards.c
> --- media_build/v4l/cx23885-cards.c=C2=A0 =C2=A0 =C2=A02012-12-28 00:04:0=
5.000000000 +0100
> +++ media_build.remi/v4l/cx23885-cards.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 2013-=
08-21 14:15:54.173195979
> +0200
> @@ -604,8 +604,39 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE0_CH3 |
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE1_CH3,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 .amux=C2=A0 =C2=A0=3D CX25840_AUDIO6,
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} },
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}}
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 },
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0[CX23885_BOARD_AVERMEDIA_A306] =3D {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .name=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D "AVerTV Hybrid Minicard PCIe A306",
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tuner_type=C2=
=A0 =C2=A0 =C2=A0=3D TUNER_XC2028,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tuner_addr=C2=
=A0 =C2=A0 =C2=A0=3D 0x61, /* 0xc2 >> 1 */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tuner_bus=C2=A0=
 =C2=A0 =C2=A0 =3D 1,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .porta=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D CX23885_ANALOG_VIDEO,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.portb=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D CX23885_MPEG_ENCODER,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .input=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D {{
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .type=C2=A0 =C2=A0=3D CX23885_VMUX_TELEVISION,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .vmux=C2=A0 =C2=A0=3D CX25840_VIN2_CH1 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_VIN5_CH2 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE0_CH3 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE1_CH3,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .amux=C2=A0 =C2=A0=3D CX25840_AUDIO8,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }, {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .type=C2=A0 =C2=A0=3D CX23885_VMUX_SVIDEO,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .vmux=C2=A0 =C2=A0=3D CX25840_VIN8_CH1 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE_CH2 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_VIN7_CH3 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_SVIDEO_ON,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .amux=C2=A0 =C2=A0=3D CX25840_AUDIO6,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }, {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .type=C2=A0 =C2=A0=3D CX23885_VMUX_COMPONENT,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .vmux=C2=A0 =C2=A0=3D CX25840_VIN1_CH1 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE_CH2 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE0_CH3 |
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CX25840_NONE1_CH3,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 .amux=C2=A0 =C2=A0=3D CX25840_AUDIO6,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }},
> +
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0}=C2=A0 =C2=A0 =C2=A0 =C2=A0
> =C2=A0};
> =C2=A0const unsigned int cx23885_bcount =3D ARRAY_SIZE(cx23885_boards);
> =C2=A0
> @@ -841,7 +872,12 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .subvendor =3D 0x=
1461,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .subdevice =3D 0x=
d939,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .card=C2=A0 =C2=
=A0 =C2=A0 =3D CX23885_BOARD_AVERMEDIA_HC81R,
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0},
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0}, {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .subvendor =3D 0=
x1461,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .subdevice =3D 0=
xc139,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .card=C2=A0 =C2=
=A0 =C2=A0 =3D CX23885_BOARD_AVERMEDIA_A306,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 },
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0
> =C2=A0};
> =C2=A0const unsigned int cx23885_idcount =3D ARRAY_SIZE(cx23885_subids);
> =C2=A0
> @@ -1069,6 +1105,10 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XC3028L Reset =
Command */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bitmask =3D 1 << =
2;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0case CX23885_BOARD_AVERMEDIA_A306:
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XC3028L Reset=
 Command */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bitmask =3D 1 <<=
 2;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (bitmask) {
> @@ -1394,6 +1434,34 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0x=
00040004);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(60);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDIA_A306:
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_clear(MC417_C=
TL, 1);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* GPIO-0,1,2 se=
tup direction as output */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00070000);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* AF9013 demod =
reset */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00010001);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_clear(GP0_IO,=
 0x00010001);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00010001);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* demod tune? *=
/
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_clear(GP0_IO,=
 0x00030003);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00020002);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00010001);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(10);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_clear(GP0_IO,=
 0x00020002);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XC3028L tuner=
 reset */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00040004);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_clear(GP0_IO,=
 0x00040004);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cx_set(GP0_IO, 0=
x00040004);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mdelay(60);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0}
> =C2=A0
> @@ -1623,6 +1691,21 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->ts_clk_en_va=
l =3D 0x1; /* Enable TS_CLK */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->src_sel_val=
=C2=A0 =C2=A0 =C2=A0=3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDIA_A306:
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Defaults for =
VID B */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts1->gen_ctrl_va=
l=C2=A0 =3D 0x4; /* Parallel */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts1->ts_clk_en_v=
al =3D 0x1; /* Enable TS_CLK */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts1->src_sel_val=
=C2=A0 =C2=A0=3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Defaults for =
VID C */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* DREQ_POL, SMO=
DE, PUNC_CLK, MCLK_POL Serial bus + punc clk
> */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->gen_ctrl_va=
l=C2=A0 =3D 0x10e;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->ts_clk_en_v=
al =3D 0x1; /* Enable TS_CLK */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->src_sel_val=
=C2=A0 =C2=A0 =C2=A0=3D CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EX=
P:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUA=
L_EXP:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ts2->gen_ctrl_val=
=C2=A0 =3D 0xc; /* Serial bus + punctured clock */
> @@ -1758,6 +1841,18 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDIA_A306:
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev->sd_cx25840 =
=3D v4l2_i2c_new_subdev(&dev->v4l2_dev,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &dev->i2c_bus[2].i2c_adap,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "cx25840", 0x88 >> 1, NULL);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dev->sd_cx25=
840) {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 dev->sd_cx25840->grp_id =3D CX23885_HW_AV_CORE;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* AUX-PLL 27MHz CLK */
> root@medeb:~/v4l# diff -u=C2=A0 media_build/v4l/cx23885-video.c
> media_build.remi/v4l/cx23885-video.c
> --- media_build/v4l/cx23885-video.c=C2=A0 =C2=A0 =C2=A02013-08-02 05:45:5=
9.000000000 +0200
> +++ media_build.remi/v4l/cx23885-video.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 2013-=
08-21 13:55:20.017625046
> +0200
> @@ -511,7 +511,8 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (dev->board =3D=
=3D CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (dev->board =3D=
=3D CX23885_BOARD_HAUPPAUGE_HVR1850) ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (dev->board =3D=
=3D CX23885_BOARD_MYGICA_X8507) ||
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(dev->board =3D=
=3D CX23885_BOARD_AVERMEDIA_HC81R)) {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(dev->board =3D=
=3D CX23885_BOARD_AVERMEDIA_HC81R)||
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(dev->board =3D=
=3D CX23885_BOARD_AVERMEDIA_A306)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Configure audi=
o routing */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v4l2_subdev_call(=
dev->sd_cx25840, audio, s_routing,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 INPUT(input)->amux, 0, 0);
> @@ -1888,6 +1889,20 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v4l2_subdev_call(sd, tuner, s_config=
, &cfg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (dev->board =3D=3D CX23885_BOARD_AVERMEDIA_A306) {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct xc2028_ctrl ctrl =3D {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* .fname =3D=
 "xc3028L-v36.fw", */
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fname=
 =3D "xc3028-v27.fw",
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .max_=
len =3D 64
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct v4l2_priv_tun_config cfg =
=3D {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tune=
r =3D dev->tuner_type,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .priv=
 =3D &ctrl
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v4l2_subdev_call(sd, tuner, s_con=
fig, &cfg);
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 }
> +
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0
> root@medeb:~/v4l# diff -u=C2=A0 media_build/v4l/cx23885.h
> media_build.remi/v4l/cx23885.h
> --- media_build/v4l/cx23885.h=C2=A0 =C2=A02013-03-25 05:45:50.000000000 +=
0100
> +++ media_build.remi/v4l/cx23885.h=C2=A0 =C2=A0 =C2=A0 2013-08-21 13:55:2=
0.010625134 +0200
> @@ -93,6 +93,7 @@
> =C2=A0#define CX23885_BOARD_PROF_8000=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 37
> =C2=A0#define CX23885_BOARD_HAUPPAUGE_HVR4400=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
38
> =C2=A0#define CX23885_BOARD_AVERMEDIA_HC81R=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 39
> +#define CX23885_BOARD_AVERMEDIA_A306=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A040
> =C2=A0
> =C2=A0#define GPIO_0 0x00000001
> =C2=A0#define GPIO_1 0x00000002
> root@medeb:~/v4l#
>
>
>
>
> > Le 20 ao=C3=BBt 2013 =C3=A0 21:31, remi <remi@remis.cc> a =C3=A9crit=C2=
=A0:
> >
> >
> > Hello
> >
> > Seeing that card=3D39 worked, and, that the A306 doesnt use the LowPowe=
r
> > version
> > of the XC3028 , HC81 is an expressCard =3D=3D lowpower
> >
> > A306 is the PCIe minicard version =3D=3D not LowPower ,
> >
> >
> > I decided to clone the HC81 entries in cx23885-video.c, cx23885.h ,
> > cx23885-cards.c
> >
> > And intruct it to load then the xc3028-v27.fw instead,
> >
> > Seems to me alot better , see below ,
> >
> > And I added so, the card=3D40 in the definitions ...
> >
> > I dont think submiting a patch for this woth it yet ...
> >
> > as none of the tuners get "created" ,
> >
> > For the analog video composite/s-video, i'll be able to test it when i =
find
> > the
> > right cable .
> >
> >
> >
> > root@medeb:~/v4l/media_build/v4l# grep A306 *
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 [CX23885_BOARD_AVERMEDIA_A3=
06] =3D {
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 .name=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D "AVerTV Hybrid Minicard
> > PCIe
> > A306",
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 .card=C2=A0 =C2=A0 =C2=A0 =3D CX23885_BOARD_AVERMEDIA_A306,
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDI=
A_A306:
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDI=
A_A306:
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDI=
A_A306:
> > cx23885-cards.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 case CX23885_BOARD_AVERMEDI=
A_A306:
> > cx23885.h:#define CX23885_BOARD_AVERMEDIA_A306=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 40
> > cx23885-video.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 (dev->board =3D=3D
> > CX23885_BOARD_AVERMEDIA_A306))
> > {
> > cx23885-video.c:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dev->board =3D=3D
> > CX23885_BOARD_AVERMEDIA_A306) {
> >
> >
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (dev->board =3D=3D CX23885_BOARD_AVERMEDIA_HC81R) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct xc2028_ctrl ctrl =3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fnam=
e =3D "xc3028L-v36.fw",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .max_=
len =3D 64
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct v4l2_priv_tun_config cfg =
=3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tune=
r =3D dev->tuner_type,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .priv=
 =3D &ctrl
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v4l2_subdev_call(sd, tuner, s_con=
fig, &cfg);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (dev->board =3D=3D CX23885_BOARD_AVERMEDIA_A306) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct xc2028_ctrl ctrl =3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* .fname =3D=
 "xc3028L-v36.fw", */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .fnam=
e =3D "xc3028-v27.fw",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .max_=
len =3D 64
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct v4l2_priv_tun_config cfg =
=3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .tune=
r =3D dev->tuner_type,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .priv=
 =3D &ctrl
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v4l2_subdev_call(sd, tuner, s_con=
fig, &cfg);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 }
> >
> >
> >
> > [32653.087693] cx23885 driver version 0.0.3 loaded
> > [32653.088091] CORE cx23885[0]: subsystem: 1461:c139, board: AVerTV Hyb=
rid
> > Minicard PCIe A306 [card=3D40,autodetected]
> > [32653.318339] cx23885[0]: scan bus 0:
> > [32653.329792] cx23885[0]: i2c scan: found device @ 0xa0=C2=A0 [eeprom]
> > [32653.336716] cx23885[0]: scan bus 1:
> > [32653.350543] cx23885[0]: i2c scan: found device @ 0xc2=C2=A0
> > [tuner/mt2131/tda8275/xc5000/xc3028]
> > [32653.355042] cx23885[0]: scan bus 2:
> > [32653.357050] cx23885[0]: i2c scan: found device @ 0x66=C2=A0 [???]
> > [32653.357699] cx23885[0]: i2c scan: found device @ 0x88=C2=A0 [cx25837=
]
> > [32653.358011] cx23885[0]: i2c scan: found device @ 0x98=C2=A0 [flatiro=
n]
> > [32653.391211] cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx2388=
5[0])
> > [32654.031992] cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware
> > (16382
> > bytes)
> > [32654.049675] tuner 2-0061: Tuner -1 found with type(s) Radio TV.
> > [32654.051827] xc2028: Xcv2028/3028 init called!
> > [32654.051830] xc2028 2-0061: creating new instance
> > [32654.051832] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> > [32654.051834] xc2028 2-0061: xc2028_set_config called
> > [32654.051963] cx23885[0]: registered device video0 [v4l2]
> > [32654.052165] cx23885[0]: registered device vbi0
> > [32654.052329] cx23885[0]: registered ALSA audio device
> > [32654.052593] xc2028 2-0061: request_firmware_nowait(): OK
> > [32654.052596] xc2028 2-0061: load_all_firmwares called
> > [32654.052598] xc2028 2-0061: Loading 80 firmware images from xc3028-v2=
7.fw,
> > type: xc2028 firmware, ver 2.7
> > [32654.052606] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id =
0,
> > size=3D8718.
> > [32654.052614] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7),=
 id
> > 0,
> > size=3D8712.
> > [32654.052623] xc2028 2-0061: Reading firmware type BASE FM (401), id 0=
,
> > size=3D8562.
> > [32654.052631] xc2028 2-0061: Reading firmware type BASE FM INPUT1 (c01=
), id
> > 0,
> > size=3D8576.
> > [32654.052640] xc2028 2-0061: Reading firmware type BASE (1), id 0,
> > size=3D8706.
> > [32654.052647] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
> > size=3D8682.
> > [32654.052652] xc2028 2-0061: Reading firmware type (0), id 100000007,
> > size=3D161.
> > [32654.052654] xc2028 2-0061: Reading firmware type MTS (4), id 1000000=
07,
> > size=3D169.
> > [32654.052657] xc2028 2-0061: Reading firmware type (0), id 200000007,
> > size=3D161.
> > [32654.052659] xc2028 2-0061: Reading firmware type MTS (4), id 2000000=
07,
> > size=3D169.
> > [32654.052661] xc2028 2-0061: Reading firmware type (0), id 400000007,
> > size=3D161.
> > [32654.052663] xc2028 2-0061: Reading firmware type MTS (4), id 4000000=
07,
> > size=3D169.
> > [32654.052666] xc2028 2-0061: Reading firmware type (0), id 800000007,
> > size=3D161.
> > [32654.052668] xc2028 2-0061: Reading firmware type MTS (4), id 8000000=
07,
> > size=3D169.
> > [32654.052670] xc2028 2-0061: Reading firmware type (0), id 3000000e0,
> > size=3D161.
> > [32654.052672] xc2028 2-0061: Reading firmware type MTS (4), id 3000000=
e0,
> > size=3D169.
> > [32654.052675] xc2028 2-0061: Reading firmware type (0), id c000000e0,
> > size=3D161.
> > [32654.052677] xc2028 2-0061: Reading firmware type MTS (4), id c000000=
e0,
> > size=3D169.
> > [32654.052679] xc2028 2-0061: Reading firmware type (0), id 200000,
> > size=3D161.
> > [32654.052681] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
> > size=3D169.
> > [32654.052684] xc2028 2-0061: Reading firmware type (0), id 4000000,
> > size=3D161.
> > [32654.052686] xc2028 2-0061: Reading firmware type MTS (4), id 4000000=
,
> > size=3D169.
> > [32654.052688] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC (10=
030),
> > id
> > 0, size=3D149.
> > [32654.052691] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68)=
, id
> > 0,
> > size=3D149.
> > [32654.052694] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70)=
, id
> > 0,
> > size=3D149.
> > [32654.052698] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id=
 0,
> > size=3D149.
> > [32654.052700] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id=
 0,
> > size=3D149.
> > [32654.052703] xc2028 2-0061: Reading firmware type D2620 DTV78 (108), =
id 0,
> > size=3D149.
> > [32654.052706] xc2028 2-0061: Reading firmware type D2633 DTV78 (110), =
id 0,
> > size=3D149.
> > [32654.052708] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), i=
d 0,
> > size=3D149.
> > [32654.052711] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), i=
d 0,
> > size=3D149.
> > [32654.052714] xc2028 2-0061: Reading firmware type FM (400), id 0,
> > size=3D135.
> > [32654.052716] xc2028 2-0061: Reading firmware type (0), id 10, size=3D=
161.
> > [32654.052718] xc2028 2-0061: Reading firmware type MTS (4), id 10,
> > size=3D169.
> > [32654.052721] xc2028 2-0061: Reading firmware type (0), id 1000400000,
> > size=3D169.
> > [32654.052723] xc2028 2-0061: Reading firmware type (0), id c00400000,
> > size=3D161.
> > [32654.052725] xc2028 2-0061: Reading firmware type (0), id 800000,
> > size=3D161.
> > [32654.052727] xc2028 2-0061: Reading firmware type (0), id 8000, size=
=3D161.
> > [32654.052729] xc2028 2-0061: Reading firmware type LCD (1000), id 8000=
,
> > size=3D161.
> > [32654.052732] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> > 8000,
> > size=3D161.
> > [32654.052734] xc2028 2-0061: Reading firmware type MTS (4), id 8000,
> > size=3D169.
> > [32654.052737] xc2028 2-0061: Reading firmware type (0), id b700, size=
=3D161.
> > [32654.052739] xc2028 2-0061: Reading firmware type LCD (1000), id b700=
,
> > size=3D161.
> > [32654.052741] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id
> > b700,
> > size=3D161.
> > [32654.052744] xc2028 2-0061: Reading firmware type (0), id 2000, size=
=3D161.
> > [32654.052745] xc2028 2-0061: Reading firmware type MTS (4), id b700,
> > size=3D169.
> > [32654.052748] xc2028 2-0061: Reading firmware type MTS LCD (1004), id =
b700,
> > size=3D169.
> > [32654.052750] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004)=
, id
> > b700, size=3D169.
> > [32654.052753] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
> > (60000000), id 0, size=3D192.
> > [32654.052756] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
> > (60000000), id 0, size=3D192.
> > [32654.052759] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
> > (60000000), id 0, size=3D192.
> > [32654.052762] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
> > (60000000), id 0, size=3D192.
> > [32654.052765] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36 SC=
ODE
> > HAS_IF_3800 (60210020), id 0, size=3D192.
> > [32654.052768] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
> > (60000000), id 0, size=3D192.
> > [32654.052771] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388
> > SCODE
> > HAS_IF_4080 (60410020), id 0, size=3D192.
> > [32654.052775] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
> > (60000000), id 0, size=3D192.
> > [32654.052778] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_4=
320
> > (60008000), id 8000, size=3D192.
> > [32654.052781] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
> > (60000000), id 0, size=3D192.
> > [32654.052783] xc2028 2-0061: Reading firmware type MTS LCD NOGD MONO I=
F
> > SCODE
> > HAS_IF_4500 (6002b004), id b700, size=3D192.
> > [32654.052788] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
> > HAS_IF_4600 (60023000), id 8000, size=3D192.
> > [32654.052792] xc2028 2-0061: Reading firmware type DTV6 QAM DTV7 DTV78=
 DTV8
> > ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=3D192.
> > [32654.052796] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
> > (60000000), id 0, size=3D192.
> > [32654.052799] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5260
> > (60000000), id 0, size=3D192.
> > [32654.052802] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_5=
320
> > (60008000), id f00000007, size=3D192.
> > [32654.052805] xc2028 2-0061: Reading firmware type DTV7 DTV78 DTV8 DIB=
COM52
> > CHINA SCODE HAS_IF_5400 (65000380), id 0, size=3D192.
> > [32654.052809] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538 S=
CODE
> > HAS_IF_5580 (60110020), id 0, size=3D192.
> > [32654.052813] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
> > (60000000), id 300000007, size=3D192.
> > [32654.052816] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
> > (60000000), id c00000007, size=3D192.
> > [32654.052819] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5900
> > (60000000), id 0, size=3D192.
> > [32654.052822] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6=
000
> > (60008000), id c04c000f0, size=3D192.
> > [32654.052825] xc2028 2-0061: Reading firmware type DTV6 QAM ATSC LG60 =
F6MHZ
> > SCODE HAS_IF_6200 (68050060), id 0, size=3D192.
> > [32654.052829] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
> > (60000000), id 10, size=3D192.
> > [32654.052834] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6=
320
> > (60008000), id 200000, size=3D192.
> > [32654.052837] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
> > (60000000), id 200000, size=3D192.
> > [32654.052840] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6=
500
> > (60008000), id c044000e0, size=3D192.
> > [32654.052843] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638 SC=
ODE
> > HAS_IF_6580 (60090020), id 0, size=3D192.
> > [32654.052847] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
> > (60000000), id 3000000e0, size=3D192.
> > [32654.052850] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6=
680
> > (60008000), id 3000000e0, size=3D192.
> > [32654.052853] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794
> > SCODE
> > HAS_IF_8140 (60810020), id 0, size=3D192.
> > [32654.052857] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
> > (60000000), id 0, size=3D192.
> > [32654.052860] xc2028 2-0061: Firmware files loaded.
> > [32654.057869] xc2028 2-0061: xc2028_set_analog_freq called
> > [32654.057872] xc2028 2-0061: generic_set_freq called
> > [32654.057874] xc2028 2-0061: should set frequency 400000 kHz
> > [32654.057876] xc2028 2-0061: check_firmware called
> > [32654.057877] xc2028 2-0061: checking firmware, user requested type=3D=
(0), id
> > 0000000c00001000, scode_tbl (0), scode_nr 0
> > [32654.257895] xc2028 2-0061: load_firmware called
> > [32654.257898] xc2028 2-0061: seek_firmware called, want type=3DBASE (1=
), id
> > 0000000000000000.
> > [32654.257900] xc2028 2-0061: Found firmware for type=3DBASE (1), id
> > 0000000000000000.
> > [32654.257902] xc2028 2-0061: Loading firmware for type=3DBASE (1), id
> > 0000000000000000.
> > [32655.425394] xc2028 2-0061: Load init1 firmware, if exists
> > [32655.425399] xc2028 2-0061: load_firmware called
> > [32655.425402] xc2028 2-0061: seek_firmware called, want type=3DBASE IN=
IT1
> > (4001),
> > id 0000000000000000.
> > [32655.425407] xc2028 2-0061: Can't find firmware for type=3DBASE INIT1
> > (4001),
> > id
> > 0000000000000000.
> > [32655.425412] xc2028 2-0061: load_firmware called
> > [32655.425414] xc2028 2-0061: seek_firmware called, want type=3DBASE IN=
IT1
> > (4001),
> > id 0000000000000000.
> > [32655.425418] xc2028 2-0061: Can't find firmware for type=3DBASE INIT1
> > (4001),
> > id
> > 0000000000000000.
> > [32655.425423] xc2028 2-0061: load_firmware called
> > [32655.425425] xc2028 2-0061: seek_firmware called, want type=3D(0), id
> > 0000000c00001000.
> > [32655.425429] xc2028 2-0061: Selecting best matching firmware (2 bits)=
 for
> > type=3D(0), id 0000000c00001000:
> > [32655.425432] xc2028 2-0061: Found firmware for type=3D(0), id
> > 0000000c000000e0.
> > [32655.425435] xc2028 2-0061: Loading firmware for type=3D(0), id
> > 0000000c000000e0.
> > [32655.440874] xc2028 2-0061: Trying to load scode 0
> > [32655.440875] xc2028 2-0061: load_scode called
> > [32655.440877] xc2028 2-0061: seek_firmware called, want type=3DSCODE
> > (20000000),
> > id 0000000c000000e0.
> > [32655.440879] xc2028 2-0061: Found firmware for type=3DSCODE (20000000=
), id
> > 0000000c04c000f0.
> > [32655.440881] xc2028 2-0061: Loading SCODE for type=3DMONO SCODE HAS_I=
F_6000
> > (60008000), id 0000000c04c000f0.
> > [32655.443192] xc2028 2-0061: xc2028_get_reg 0004 called
> > [32655.443855] xc2028 2-0061: xc2028_get_reg 0008 called
> > [32655.444521] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmwa=
re
> > version 2.7
> > [32655.557141] xc2028 2-0061: divisor=3D 00 00 64 00 (freq=3D400.000)
> > [32655.580856] cx23885_dev_checkrevision() Hardware revision =3D 0xb0
> > [32655.580862] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18,
> > latency:
> > 0,
> > mmio: 0xd3000000
> > root@medeb:~/v4l/media_build#
> >
> >
> >
> > Best regards
> >
> > R=C3=A9mi .
> >
> >
> > > Le 20 ao=C3=BBt 2013 =C3=A0 16:44, remi <remi@remis.cc> a =C3=A9crit=
=C2=A0:
> > >
> > >
> > > Hello
> > >
> > > FYI
> > >
> > > I digged into the firmware problem a little,
> > >
> > >
> > > xc3028L-v36.fw=C2=A0 gets loaded by default , and the errors are as y=
ou saw
> > > earlier
> > >
> > >
> > > forcing the /lib/firmware/xc3028-v27.fw :=C2=A0
> > >
> > > [ 3569.941404] xc2028 2-0061: Could not load firmware
> > > /lib/firmware/xc3028-v27.fw
> > >
> > >
> > > So i searched the original dell/windows driver :
> > >
> > >
> > > I have these files in there :
> > >
> > > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070# ls -lR
> > > .:
> > > total 5468
> > > drwxr-xr-x 2 gpunk gpunk=C2=A0 =C2=A0 4096 ao=C3=BBt=C2=A0 20 13:24 D=
river_X86
> > > -rwxr-xr-x 1 gpunk gpunk 5589827 sept. 12=C2=A0 2007 Setup.exe
> > > -rw-r--r-- 1 gpunk gpunk=C2=A0 =C2=A0 =C2=A0197 oct.=C2=A0 =C2=A09=C2=
=A0 2007 setup.iss
> > >
> > > ./Driver_X86:
> > > total 1448
> > > -rw-r--r-- 1 gpunk gpunk 114338 sept.=C2=A0 7=C2=A0 2007 A885VCap_ASU=
S_DELL_2.inf
> > > -rw-r--r-- 1 gpunk gpunk=C2=A0 15850 sept. 11=C2=A0 2007 a885vcap.cat
> > > -rw-r--r-- 1 gpunk gpunk 733824 sept.=C2=A0 7=C2=A0 2007 A885VCap.sys
> > > -rw-r--r-- 1 gpunk gpunk 147870 avril 20=C2=A0 2007 cpnotify.ax
> > > -rw-r--r-- 1 gpunk gpunk 376836 avril 20=C2=A0 2007 cx416enc.rom
> > > -rw-r--r-- 1 gpunk gpunk=C2=A0 65536 avril 20=C2=A0 2007 cxtvrate.dll
> > > -rw-r--r-- 1 gpunk gpunk=C2=A0 16382 avril 20=C2=A0 2007 merlinC.rom
> > > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070#
> > >
> > > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#=
 grep
> > > firmware *
> > > Fichier binaire A885VCap.sys concordant
> > > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#
> > >
> > >
> > >
> > > I'll try to find a way to extract "maybe" the right firmware for what=
 this
> > > card
> > > ,
> > >
> > > I'd love some help :)
> > >
> > > Good news there are ALOT of infos on how to initialize the card in th=
e
> > > .INF
> > > ,
> > > so
> > >
> > > many problems, i think, are partially solved (I need to implement the=
m )
> > >
> > > I'll send a copy of theses to anyone who wishes,
> > >
> > > Or see
> > > http://www.dell.com/support/drivers/us/en/04/DriverDetails?driverId=
=3DR169070=C2=A0
> > > =C2=A0
> > > =C2=A0
> > > =C2=A0:)
> > >
> > > Regards
> > >
> > > R=C3=A9mi
> > >
> > >
> > >
> > >
> > >
> > > > Le 20 ao=C3=BBt 2013 =C3=A0 12:32, remi <remi@remis.cc> a =C3=A9cri=
t=C2=A0:
> > > >
> > > >
> > > > Hello
> > > >
> > > > I have just putdown my screwdrivers :)
> > > >
> > > >
> > > > Yes it was three ICs
> > > >
> > > >
> > > > on the bottom-side , no heatsinks (digital reception, that's why i
> > > > guess)
> > > > ,
> > > > is
> > > > an AF9013-N1
> > > >
> > > > on the top-side, with a heatsink : CX23885-13Z , PCIe A/V controler
> > > >
> > > > on the top-side, with heat-sink + "radio-isolation" (aluminum box)
> > > > XC3028ACQ
> > > > ,
> > > > so the analog reception .
> > > >
> > > > =C2=A0
> > > > Its all on a PCIe bus, the reason why i baught it ... :)
> > > >
> > > >
> > > >
> > > > To resume :
> > > >
> > > >
> > > > AF9013-N1
> > > >
> > > > CX23885-13Z
> > > >
> > > > XC3028ACQ
> > > >
> > > >
> > > > the drivers while scanning
> > > >
> > > >
> > > > gpunk@medeb:~/Bureau$ dmesg |grep i2c
> > > > [=C2=A0 =C2=A0 2.363784] cx23885[0]: i2c scan: found device @ 0xa0=
=C2=A0 [eeprom]
> > > > [=C2=A0 =C2=A0 2.384721] cx23885[0]: i2c scan: found device @ 0xc2=
=C2=A0
> > > > [tuner/mt2131/tda8275/xc5000/xc3028]
> > > > [=C2=A0 =C2=A0 2.391502] cx23885[0]: i2c scan: found device @ 0x66=
=C2=A0 [???]
> > > > [=C2=A0 =C2=A0 2.392339] cx23885[0]: i2c scan: found device @ 0x88=
=C2=A0 [cx25837]
> > > > [=C2=A0 =C2=A0 2.392831] cx23885[0]: i2c scan: found device @ 0x98=
=C2=A0 [flatiron]
> > > > [=C2=A0 =C2=A0 5.306751] i2c /dev entries driver
> > > > gpunk@medeb:~/Bureau$
> > > >
> > > >
> > > > =C2=A04.560428] xc2028 2-0061: xc2028_get_reg 0008 called
> > > > [=C2=A0 =C2=A0 4.560989] xc2028 2-0061: Device is Xceive 0 version =
0.0, firmware
> > > > version
> > > > 0.0
> > > > [=C2=A0 =C2=A0 4.560990] xc2028 2-0061: Incorrect readback of firmw=
are version.
> > > > [ *=C2=A0 =C2=A0 4.561184] xc2028 2-0061: Read invalid device hardw=
are information
> > > > -
> > > > tuner
> > > > hung?
> > > > [ *=C2=A0 =C2=A0 4.561386] xc2028 2-0061: 0.0=C2=A0 =C2=A0 =C2=A0 0=
.0
> > > > [ *=C2=A0 =C2=A0 4.674072] xc2028 2-0061: divisor=3D 00 00 64 00 (f=
req=3D400.000)
> > > > [=C2=A0 =C2=A0 4.697830] cx23885_dev_checkrevision() Hardware revis=
ion =3D 0xb0
> > > > [=C2=A0 =C2=A0 4.698029] cx23885[0]/0: found at 0000:05:00.0, rev: =
2, irq: 18,
> > > > latency:
> > > > 0,
> > > > mmio: 0xd3000000
> > > >
> > > > * --> I bypassed the "goto fail" to start debugging a little bit th=
e
> > > > tuner-xc2028.c/ko ... lines 869
> > > > ...
> > > >
> > > >
> > > >
> > > > The firmware doesnt get all loaded .
> > > > gpunk@medeb:~/Bureau$=C2=A0 uname -a
> > > > Linux medeb 3.11.0-rc6remi #1 SMP PREEMPT Mon Aug 19 13:30:04 CEST =
2013
> > > > i686
> > > > GNU/Linux
> > > > gpunk@medeb:~/Bureau$
> > > >
> > > >
> > > > With yesterday's tarball from linuxtv.org / media-build git .
> > > >
> > > >
> > > >
> > > > Best regards
> > > >
> > > > R=C3=A9mi
> > > >
> > > >
> > > >
> > > >
> > > > > Le 19 ao=C3=BBt 2013 =C3=A0 17:18, Antti Palosaari <crope@iki.fi>=
 a =C3=A9crit=C2=A0:
> > > > >
> > > > >
> > > > > On 08/19/2013 05:18 PM, remi wrote:
> > > > > > Hello
> > > > > >
> > > > > > I have this card since months,
> > > > > >
> > > > > > http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=
=3D376&SI=3Dtrue
> > > > > >
> > > > > > I have finally retested it with the cx23885 driver : card=3D39
> > > > > >
> > > > > >
> > > > > >
> > > > > > If I could do anything to identify : [=C2=A0 =C2=A0 2.414734] c=
x23885[0]: i2c
> > > > > > scan:
> > > > > > found
> > > > > > device @ 0x66=C2=A0 [???]
> > > > > >
> > > > > > Or "hookup" the xc5000 etc
> > > > > >
> > > > > > I'll be more than glad .
> > > > > >
> > > > >
> > > > >
> > > > > >
> > > > > > ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner
> > > > > > looks
> > > > > > like
> > > > > > maybe the "device @ 0x66 i2c"
> > > > > >
> > > > > > I will double check , and re-write-down all the chips , i think=
 3 .
> > > > >
> > > > > You have to identify all the chips, for DVB-T there is tuner miss=
ing.
> > > > >
> > > > > USB-interface: cx23885
> > > > > DVB-T demodulator: AF9013
> > > > > RF-tuner: ?
> > > > >
> > > > > If there is existing driver for used RF-tuner it comes nice hacki=
ng
> > > > > project for some newcomer.
> > > > >
> > > > > It is just tweaking and hacking to find out all settings. AF9013
> > > > > driver
> > > > > also needs likely some changes, currently it is used only for dev=
ices
> > > > > having AF9015 with integrated AF9013, or AF9015 dual devices havi=
ng
> > > > > AF9015 + external AF9013 providing second tuner.
> > > > >
> > > > > I have bought quite similar AverMedia A301 ages back as I was loo=
king
> > > > > for that AF9013 model, but maybe I have bought just wrong one... =
:)
> > > > >
> > > > >
> > > > > regards
> > > > > Antti
> > > > >
> > > > >
> > > > > --
> > > > > http://palosaari.fi/
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-m=
edia"
> > > > > in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-inf=
o.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-med=
ia"
> > > > in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.=
html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html
------=_Part_26449_1418322827.1378910904449
Content-Type: text/plain; charset=US-ASCII; name=dmesg.a306.cx23885.txt
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=dmesg.a306.cx23885.txt

WyAzNzQ0Ljk5NzY3Ml0gbWVkaWE6IExpbnV4IG1lZGlhIGludGVyZmFjZTogdjAuMTAKWyAzNzQ1
LjAwMDMwM10gTGludXggdmlkZW8gY2FwdHVyZSBpbnRlcmZhY2U6IHYyLjAwClsgMzc0NS4wMDAz
MDhdIFdBUk5JTkc6IFlvdSBhcmUgdXNpbmcgYW4gZXhwZXJpbWVudGFsIHZlcnNpb24gb2YgdGhl
IG1lZGlhIHN0YWNrLgpbIDM3NDUuMDAwMzA4XSAJQXMgdGhlIGRyaXZlciBpcyBiYWNrcG9ydGVk
IHRvIGFuIG9sZGVyIGtlcm5lbCwgaXQgZG9lc24ndCBvZmZlcgpbIDM3NDUuMDAwMzA4XSAJZW5v
dWdoIHF1YWxpdHkgZm9yIGl0cyB1c2FnZSBpbiBwcm9kdWN0aW9uLgpbIDM3NDUuMDAwMzA4XSAJ
VXNlIGl0IHdpdGggY2FyZS4KWyAzNzQ1LjAwMDMwOF0gTGF0ZXN0IGdpdCBwYXRjaGVzIChuZWVk
ZWQgaWYgeW91IHJlcG9ydCBhIGJ1ZyB0byBsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmcpOgpb
IDM3NDUuMDAwMzA4XSAJZGZiOWY5NGU4ZTVlN2Y3M2M4ZTJiY2I3ZDRmYjFkZTU3ZTdjMzMzZCBb
bWVkaWFdIHN0azExNjA6IEJ1aWxkIGFzIGEgbW9kdWxlIGlmIFNORCBpcyBtIGFuZCBhdWRpbyBz
dXBwb3J0IGlzIHNlbGVjdGVkClsgMzc0NS4wMDAzMDhdIAk5ZjE1OTUyNDU1NzRhMmRjMWZiMzc1
ZGY2NjVlNGQ5ZmUzMzZhOWM0IFttZWRpYV0gY3gyMzg4NS12aWRlbzogZml4IHR3byB3YXJuaW5n
cwpbIDM3NDUuMDAwMzA4XSAJNWJjMDhlMTkyMWU0NjEwMTQ1N2QzYmUwOTgzNTY5NzQ5MDE3N2Zk
ZCBbbWVkaWFdIGN4MjM4ODVbdjRdOiBGaXggaW50ZXJydXB0IHN0b3JtIHdoZW4gZW5hYmxpbmcg
SVIgcmVjZWl2ZXIKWyAzNzQ1LjAwMTc3M10gV0FSTklORzogWW91IGFyZSB1c2luZyBhbiBleHBl
cmltZW50YWwgdmVyc2lvbiBvZiB0aGUgbWVkaWEgc3RhY2suClsgMzc0NS4wMDE3NzNdIAlBcyB0
aGUgZHJpdmVyIGlzIGJhY2twb3J0ZWQgdG8gYW4gb2xkZXIga2VybmVsLCBpdCBkb2Vzbid0IG9m
ZmVyClsgMzc0NS4wMDE3NzNdIAllbm91Z2ggcXVhbGl0eSBmb3IgaXRzIHVzYWdlIGluIHByb2R1
Y3Rpb24uClsgMzc0NS4wMDE3NzNdIAlVc2UgaXQgd2l0aCBjYXJlLgpbIDM3NDUuMDAxNzczXSBM
YXRlc3QgZ2l0IHBhdGNoZXMgKG5lZWRlZCBpZiB5b3UgcmVwb3J0IGEgYnVnIHRvIGxpbnV4LW1l
ZGlhQHZnZXIua2VybmVsLm9yZyk6ClsgMzc0NS4wMDE3NzNdIAlkZmI5Zjk0ZThlNWU3ZjczYzhl
MmJjYjdkNGZiMWRlNTdlN2MzMzNkIFttZWRpYV0gc3RrMTE2MDogQnVpbGQgYXMgYSBtb2R1bGUg
aWYgU05EIGlzIG0gYW5kIGF1ZGlvIHN1cHBvcnQgaXMgc2VsZWN0ZWQKWyAzNzQ1LjAwMTc3M10g
CTlmMTU5NTI0NTU3NGEyZGMxZmIzNzVkZjY2NWU0ZDlmZTMzNmE5YzQgW21lZGlhXSBjeDIzODg1
LXZpZGVvOiBmaXggdHdvIHdhcm5pbmdzClsgMzc0NS4wMDE3NzNdIAk1YmMwOGUxOTIxZTQ2MTAx
NDU3ZDNiZTA5ODM1Njk3NDkwMTc3ZmRkIFttZWRpYV0gY3gyMzg4NVt2NF06IEZpeCBpbnRlcnJ1
cHQgc3Rvcm0gd2hlbiBlbmFibGluZyBJUiByZWNlaXZlcgpbIDM3NDUuMDAzMzQ4XSBXQVJOSU5H
OiBZb3UgYXJlIHVzaW5nIGFuIGV4cGVyaW1lbnRhbCB2ZXJzaW9uIG9mIHRoZSBtZWRpYSBzdGFj
ay4KWyAzNzQ1LjAwMzM0OF0gCUFzIHRoZSBkcml2ZXIgaXMgYmFja3BvcnRlZCB0byBhbiBvbGRl
ciBrZXJuZWwsIGl0IGRvZXNuJ3Qgb2ZmZXIKWyAzNzQ1LjAwMzM0OF0gCWVub3VnaCBxdWFsaXR5
IGZvciBpdHMgdXNhZ2UgaW4gcHJvZHVjdGlvbi4KWyAzNzQ1LjAwMzM0OF0gCVVzZSBpdCB3aXRo
IGNhcmUuClsgMzc0NS4wMDMzNDhdIExhdGVzdCBnaXQgcGF0Y2hlcyAobmVlZGVkIGlmIHlvdSBy
ZXBvcnQgYSBidWcgdG8gbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnKToKWyAzNzQ1LjAwMzM0
OF0gCWRmYjlmOTRlOGU1ZTdmNzNjOGUyYmNiN2Q0ZmIxZGU1N2U3YzMzM2QgW21lZGlhXSBzdGsx
MTYwOiBCdWlsZCBhcyBhIG1vZHVsZSBpZiBTTkQgaXMgbSBhbmQgYXVkaW8gc3VwcG9ydCBpcyBz
ZWxlY3RlZApbIDM3NDUuMDAzMzQ4XSAJOWYxNTk1MjQ1NTc0YTJkYzFmYjM3NWRmNjY1ZTRkOWZl
MzM2YTljNCBbbWVkaWFdIGN4MjM4ODUtdmlkZW86IGZpeCB0d28gd2FybmluZ3MKWyAzNzQ1LjAw
MzM0OF0gCTViYzA4ZTE5MjFlNDYxMDE0NTdkM2JlMDk4MzU2OTc0OTAxNzdmZGQgW21lZGlhXSBj
eDIzODg1W3Y0XTogRml4IGludGVycnVwdCBzdG9ybSB3aGVuIGVuYWJsaW5nIElSIHJlY2VpdmVy
ClsgMzc0NS4wMDc3MTFdIGN4MjM4ODUgZHJpdmVyIHZlcnNpb24gMC4wLjMgbG9hZGVkClsgMzc0
NS4wMDc4NDZdIGN4MjM4ODVbMF06IGN4MjM4ODVfZGV2X3NldHVwKCkgTWVtb3J5IGNvbmZpZ3Vy
ZWQgZm9yIFBDSWUgYnJpZGdlIHR5cGUgODg1ClsgMzc0NS4wMDc4NTBdIGN4MjM4ODVbMF06IGN4
MjM4ODVfaW5pdF90c3BvcnQocG9ydG5vPTEpClsgMzc0NS4wMDgxMjNdIENPUkUgY3gyMzg4NVsw
XTogc3Vic3lzdGVtOiAxNDYxOmMxMzksIGJvYXJkOiBBVmVyVFYgSHlicmlkIE1pbmljYXJkIFBD
SWUgQTMwNiBbY2FyZD00MCxhdXRvZGV0ZWN0ZWRdClsgMzc0NS4wMDgxMjVdIGN4MjM4ODVbMF06
IGN4MjM4ODVfcGNpX3F1aXJrcygpClsgMzc0NS4wMDgxMzBdIGN4MjM4ODVbMF06IGN4MjM4ODVf
ZGV2X3NldHVwKCkgdHVuZXJfdHlwZSA9IDB4NDcgdHVuZXJfYWRkciA9IDB4NjEgdHVuZXJfYnVz
ID0gMQpbIDM3NDUuMDA4MTMzXSBjeDIzODg1WzBdOiBjeDIzODg1X2Rldl9zZXR1cCgpIHJhZGlv
X3R5cGUgPSAweDAgcmFkaW9fYWRkciA9IDB4MApbIDM3NDUuMDA4MTM1XSBjeDIzODg1WzBdOiBj
eDIzODg1X3Jlc2V0KCkKWyAzNzQ1LjEwODE1OF0gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFtX2No
YW5uZWxfc2V0dXAoKSBDb25maWd1cmluZyBjaGFubmVsIFtWSUQgQV0KWyAzNzQ1LjEwODE3Ml0g
Y3gyMzg4NVswXTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0dXAoKSBFcmFzaW5nIGNoYW5uZWwg
W2NoMl0KWyAzNzQ1LjEwODE3M10gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0
dXAoKSBDb25maWd1cmluZyBjaGFubmVsIFtUUzEgQl0KWyAzNzQ1LjEwODE4OF0gY3gyMzg4NVsw
XTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0dXAoKSBFcmFzaW5nIGNoYW5uZWwgW2NoNF0KWyAz
NzQ1LjEwODE5MF0gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0dXAoKSBFcmFz
aW5nIGNoYW5uZWwgW2NoNV0KWyAzNzQ1LjEwODE5MV0gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFt
X2NoYW5uZWxfc2V0dXAoKSBDb25maWd1cmluZyBjaGFubmVsIFtUUzIgQ10KWyAzNzQ1LjEwODIw
Nl0gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0dXAoKSBDb25maWd1cmluZyBj
aGFubmVsIFtUViBBdWRpb10KWyAzNzQ1LjEwODIyM10gY3gyMzg4NVswXTogY3gyMzg4NV9zcmFt
X2NoYW5uZWxfc2V0dXAoKSBFcmFzaW5nIGNoYW5uZWwgW2NoOF0KWyAzNzQ1LjEwODIyNV0gY3gy
Mzg4NVswXTogY3gyMzg4NV9zcmFtX2NoYW5uZWxfc2V0dXAoKSBFcmFzaW5nIGNoYW5uZWwgW2No
OV0KWyAzNzQ1LjIzODQwOV0gY3gyMzg4NVswXTogc2NhbiBidXMgMDoKWyAzNzQ1LjI0OTg2OV0g
Y3gyMzg4NVswXTogaTJjIHNjYW46IGZvdW5kIGRldmljZSBAIDB4YTAgIFtlZXByb21dClsgMzc0
NS4yNTY3NjFdIGN4MjM4ODVbMF06IHNjYW4gYnVzIDE6ClsgMzc0NS4yNzA2MzBdIGN4MjM4ODVb
MF06IGkyYyBzY2FuOiBmb3VuZCBkZXZpY2UgQCAweGMyICBbdHVuZXIvbXQyMTMxL3RkYTgyNzUv
eGM1MDAwL3hjMzAyOF0KWyAzNzQ1LjI3NTExNF0gY3gyMzg4NVswXTogc2NhbiBidXMgMjoKWyAz
NzQ1LjI3NzE0M10gY3gyMzg4NVswXTogaTJjIHNjYW46IGZvdW5kIGRldmljZSBAIDB4NjYgIFs/
Pz9dClsgMzc0NS4yNzc3OTZdIGN4MjM4ODVbMF06IGkyYyBzY2FuOiBmb3VuZCBkZXZpY2UgQCAw
eDg4ICBbY3gyNTgzN10KWyAzNzQ1LjI3ODEwNl0gY3gyMzg4NVswXTogaTJjIHNjYW46IGZvdW5k
IGRldmljZSBAIDB4OTggIFtmbGF0aXJvbl0KWyAzNzQ1LjMwOTU1OV0gY3gyNTg0MCAxMy0wMDQ0
OiBkZXRlY3RpbmcgY3gyNTg0MCBjbGllbnQgb24gYWRkcmVzcyAweDg4ClsgMzc0NS4zMDk3ODZd
IGN4MjU4NDAgMTMtMDA0NDogZGV2aWNlX2lkID0gMHgwMDAwClsgMzc0NS4zMTA0NzJdIGN4MjU4
NDAgMTMtMDA0NDogY3gyMzg4NSBBL1YgZGVjb2RlciBmb3VuZCBAIDB4ODggKGN4MjM4ODVbMF0p
ClsgMzc0NS45NTY3MThdIGN4MjU4NDAgMTMtMDA0NDogbG9hZGVkIHY0bC1jeDIzODg1LWF2Y29y
ZS0wMS5mdyBmaXJtd2FyZSAoMTYzODIgYnl0ZXMpClsgMzc0NS45NTczNTRdIGN4MjU4NDAgMTMt
MDA0NDogUExMIHJlZ3MgPSBpbnQ6IDE1LCBmcmFjOiAyODc2MTA1LCBwb3N0OiA0ClsgMzc0NS45
NTczNTZdIGN4MjU4NDAgMTMtMDA0NDogUExMID0gMTA3Ljk5OTk5OSBNSHoKWyAzNzQ1Ljk1NzM1
OF0gY3gyNTg0MCAxMy0wMDQ0OiBQTEwvOCA9IDEzLjQ5OTk5OSBNSHoKWyAzNzQ1Ljk1NzM1OV0g
Y3gyNTg0MCAxMy0wMDQ0OiBBREMgU2FtcGxpbmcgZnJlcSA9IDE0LjMxNzM4MiBNSHoKWyAzNzQ1
Ljk1NzM2MV0gY3gyNTg0MCAxMy0wMDQ0OiBDaHJvbWEgc3ViLWNhcnJpZXIgZnJlcSA9IDMuNTc5
NTQ1IE1IegpbIDM3NDUuOTU3MzYzXSBjeDI1ODQwIDEzLTAwNDQ6IGhibGFuayAxMjIsIGhhY3Rp
dmUgNzIwLCB2YmxhbmsgMjYsIHZhY3RpdmUgNDg3LCB2Ymxhbms2NTYgMjYsIHNyY19kZWMgNTQz
LCBidXJzdCAweDViLCBsdW1hX2xwZiAxLCB1dl9scGYgMSwgY29tYiAweDY2LCBzYyAweDA4N2Mx
ZgpbIDM3NDUuOTU5MTMyXSBjeDI1ODQwIDEzLTAwNDQ6IGRlY29kZXIgc2V0IHZpZGVvIGlucHV0
IDcsIGF1ZGlvIGlucHV0IDgKWyAzNzQ1Ljk3NTUwN10gdHVuZXIgMTItMDA2MTogU2V0dGluZyBt
b2RlX21hc2sgdG8gMHgwNgpbIDM3NDUuOTc1NTExXSB0dW5lciAxMi0wMDYxOiB0dW5lciAweDYx
OiBUdW5lciB0eXBlIGFic2VudApbIDM3NDUuOTc1NTE0XSB0dW5lciAxMi0wMDYxOiBUdW5lciAt
MSBmb3VuZCB3aXRoIHR5cGUocykgUmFkaW8gVFYuClsgMzc0NS45NzU1MjNdIHR1bmVyIDEyLTAw
NjE6IENhbGxpbmcgc2V0X3R5cGVfYWRkciBmb3IgdHlwZT03MSwgYWRkcj0weDYxLCBtb2RlPTB4
MDQsIGNvbmZpZz0gIChudWxsKQpbIDM3NDUuOTc1NTI1XSB0dW5lciAxMi0wMDYxOiBkZWZpbmlu
ZyBHUElPIGNhbGxiYWNrClsgMzc0NS45Nzg0OTRdIHhjMjAyODogWGN2MjAyOC8zMDI4IGluaXQg
Y2FsbGVkIQpbIDM3NDUuOTc4NDk4XSB4YzIwMjggMTItMDA2MTogY3JlYXRpbmcgbmV3IGluc3Rh
bmNlClsgMzc0NS45Nzg1MDFdIHhjMjAyOCAxMi0wMDYxOiB0eXBlIHNldCB0byBYQ2VpdmUgeGMy
MDI4L3hjMzAyOCB0dW5lcgpbIDM3NDUuOTc4NTAzXSB0dW5lciAxMi0wMDYxOiB0eXBlIHNldCB0
byBYY2VpdmUgWEMzMDI4ClsgMzc0NS45Nzg1MDddIHR1bmVyIDEyLTAwNjE6IGN4MjM4ODVbMF0g
dHVuZXIgSTJDIGFkZHIgMHhjMiB3aXRoIHR5cGUgNzEgdXNlZCBmb3IgMHgwNApbIDM3NDUuOTc4
NTA5XSB4YzIwMjggMTItMDA2MTogeGMyMDI4X3NldF9jb25maWcgY2FsbGVkClsgMzc0NS45Nzg1
OTVdIGN4MjM4ODVbMF06IHJlZ2lzdGVyZWQgZGV2aWNlIHZpZGVvMCBbdjRsMl0KWyAzNzQ1Ljk3
ODYwMl0geGMyMDI4IDEyLTAwNjE6IHJlcXVlc3RfZmlybXdhcmVfbm93YWl0KCk6IE9LClsgMzc0
NS45Nzg2MDVdIHhjMjAyOCAxMi0wMDYxOiBsb2FkX2FsbF9maXJtd2FyZXMgY2FsbGVkClsgMzc0
NS45Nzg2MDhdIHhjMjAyOCAxMi0wMDYxOiBMb2FkaW5nIDgwIGZpcm13YXJlIGltYWdlcyBmcm9t
IHhjMzAyOC12MjcuZncsIHR5cGU6IHhjMjAyOCBmaXJtd2FyZSwgdmVyIDIuNwpbIDM3NDUuOTc4
NjE2XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEJBU0UgRjhNSFogKDMp
LCBpZCAwLCBzaXplPTg3MTguClsgMzc0NS45Nzg2MjddIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5n
IGZpcm13YXJlIHR5cGUgQkFTRSBGOE1IWiBNVFMgKDcpLCBpZCAwLCBzaXplPTg3MTIuClsgMzc0
NS45Nzg2MzldIGN4MjM4ODVbMF06IHJlZ2lzdGVyZWQgZGV2aWNlIHZiaTAKWyAzNzQ1Ljk3ODY0
MV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBCQVNFIEZNICg0MDEpLCBp
ZCAwLCBzaXplPTg1NjIuClsgMzc0NS45Nzg2NTVdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZp
cm13YXJlIHR5cGUgQkFTRSBGTSBJTlBVVDEgKGMwMSksIGlkIDAsIHNpemU9ODU3Ni4KWyAzNzQ1
Ljk3ODY2Nl0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBCQVNFICgxKSwg
aWQgMCwgc2l6ZT04NzA2LgpbIDM3NDUuOTc4Njc3XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBm
aXJtd2FyZSB0eXBlIEJBU0UgTVRTICg1KSwgaWQgMCwgc2l6ZT04NjgyLgpbIDM3NDUuOTc4Njg1
XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMTAwMDAwMDA3
LCBzaXplPTE2MS4KWyAzNzQ1Ljk3ODY4OF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdh
cmUgdHlwZSBNVFMgKDQpLCBpZCAxMDAwMDAwMDcsIHNpemU9MTY5LgpbIDM3NDUuOTc4NjkyXSB4
YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMjAwMDAwMDA3LCBz
aXplPTE2MS4KWyAzNzQ1Ljk3ODY5NV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUg
dHlwZSBNVFMgKDQpLCBpZCAyMDAwMDAwMDcsIHNpemU9MTY5LgpbIDM3NDUuOTc4Njk5XSB4YzIw
MjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgNDAwMDAwMDA3LCBzaXpl
PTE2MS4KWyAzNzQ1Ljk3ODcwMl0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBNVFMgKDQpLCBpZCA0MDAwMDAwMDcsIHNpemU9MTY5LgpbIDM3NDUuOTc4NzA2XSB4YzIwMjgg
MTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgODAwMDAwMDA3LCBzaXplPTE2
MS4KWyAzNzQ1Ljk3ODcwOV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBN
VFMgKDQpLCBpZCA4MDAwMDAwMDcsIHNpemU9MTY5LgpbIDM3NDUuOTc4NzEzXSB4YzIwMjggMTIt
MDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMzAwMDAwMGUwLCBzaXplPTE2MS4K
WyAzNzQ1Ljk3ODcxNl0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMg
KDQpLCBpZCAzMDAwMDAwZTAsIHNpemU9MTY5LgpbIDM3NDUuOTc4NzE5XSB4YzIwMjggMTItMDA2
MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgYzAwMDAwMGUwLCBzaXplPTE2MS4KWyAz
NzQ1Ljk3ODcyMl0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgKDQp
LCBpZCBjMDAwMDAwZTAsIHNpemU9MTY5LgpbIDM3NDUuOTc4NzI2XSB4YzIwMjggMTItMDA2MTog
UmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgMjAwMDAwLCBzaXplPTE2MS4KWyAzNzQ1Ljk3
ODcyOV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgKDQpLCBpZCAy
MDAwMDAsIHNpemU9MTY5LgpbIDM3NDUuOTc4NzMzXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBm
aXJtd2FyZSB0eXBlICgwKSwgaWQgNDAwMDAwMCwgc2l6ZT0xNjEuClsgMzc0NS45Nzg3MzZdIHhj
MjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgTVRTICg0KSwgaWQgNDAwMDAwMCwg
c2l6ZT0xNjkuClsgMzc0NS45Nzg3NDBdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJl
IHR5cGUgRDI2MzMgRFRWNiBBVFNDICgxMDAzMCksIGlkIDAsIHNpemU9MTQ5LgpbIDM3NDUuOTc4
NzQ0XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjIwIERUVjYgUUFN
ICg2OCksIGlkIDAsIHNpemU9MTQ5LgpbIDM3NDUuOTc4NzQ5XSB4YzIwMjggMTItMDA2MTogUmVh
ZGluZyBmaXJtd2FyZSB0eXBlIEQyNjMzIERUVjYgUUFNICg3MCksIGlkIDAsIHNpemU9MTQ5Lgpb
IDM3NDUuOTc4NzU0XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjIw
IERUVjcgKDg4KSwgaWQgMCwgc2l6ZT0xNDkuClsgMzc0NS45Nzg3NThdIHhjMjAyOCAxMi0wMDYx
OiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRDI2MzMgRFRWNyAoOTApLCBpZCAwLCBzaXplPTE0OS4K
WyAzNzQ1Ljk3ODc2Ml0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEMjYy
MCBEVFY3OCAoMTA4KSwgaWQgMCwgc2l6ZT0xNDkuClsgMzc0NS45Nzg3NjZdIHhjMjAyOCAxMi0w
MDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRDI2MzMgRFRWNzggKDExMCksIGlkIDAsIHNpemU9
MTQ5LgpbIDM3NDUuOTc4NzcwXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IEQyNjIwIERUVjggKDIwOCksIGlkIDAsIHNpemU9MTQ5LgpbIDM3NDUuOTc4Nzc0XSB4YzIwMjgg
MTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIEQyNjMzIERUVjggKDIxMCksIGlkIDAsIHNp
emU9MTQ5LgpbIDM3NDUuOTc4Nzc4XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0
eXBlIEZNICg0MDApLCBpZCAwLCBzaXplPTEzNS4KWyAzNzQ1Ljk3ODc4Ml0geGMyMDI4IDEyLTAw
NjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSAoMCksIGlkIDEwLCBzaXplPTE2MS4KWyAzNzQ1Ljk3
ODc4NV0gY3gyMzg4NVswXTogcmVnaXN0ZXJlZCBBTFNBIGF1ZGlvIGRldmljZQpbIDM3NDUuOTc4
Nzg4XSBjeDI1ODQwIDEzLTAwNDQ6IGNoYW5naW5nIHZpZGVvIHN0ZCB0byBmbXQgMQpbIDM3NDUu
OTc4NzkwXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyAoNCksIGlk
IDEwLCBzaXplPTE2OS4KWyAzNzQ1Ljk3ODc5NF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgdHlwZSAoMCksIGlkIDEwMDA0MDAwMDAsIHNpemU9MTY5LgpbIDM3NDUuOTc4Nzk3XSB4
YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgYzAwNDAwMDAwLCBz
aXplPTE2MS4KWyAzNzQ1Ljk3ODgwMF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUg
dHlwZSAoMCksIGlkIDgwMDAwMCwgc2l6ZT0xNjEuClsgMzc0NS45Nzg4MDNdIHhjMjAyOCAxMi0w
MDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgKDApLCBpZCA4MDAwLCBzaXplPTE2MS4KWyAzNzQ1
Ljk3ODgwN10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBMQ0QgKDEwMDAp
LCBpZCA4MDAwLCBzaXplPTE2MS4KWyAzNzQ1Ljk3ODgxMF0geGMyMDI4IDEyLTAwNjE6IFJlYWRp
bmcgZmlybXdhcmUgdHlwZSBMQ0QgTk9HRCAoMzAwMCksIGlkIDgwMDAsIHNpemU9MTYxLgpbIDM3
NDUuOTc4ODE0XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyAoNCks
IGlkIDgwMDAsIHNpemU9MTY5LgpbIDM3NDUuOTc4ODE4XSB4YzIwMjggMTItMDA2MTogUmVhZGlu
ZyBmaXJtd2FyZSB0eXBlICgwKSwgaWQgYjcwMCwgc2l6ZT0xNjEuClsgMzc0NS45Nzg4MjFdIHhj
MjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgTENEICgxMDAwKSwgaWQgYjcwMCwg
c2l6ZT0xNjEuClsgMzc0NS45Nzg4MjVdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJl
IHR5cGUgTENEIE5PR0QgKDMwMDApLCBpZCBiNzAwLCBzaXplPTE2MS4KWyAzNzQ1Ljk3ODgyOF0g
eGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSAoMCksIGlkIDIwMDAsIHNpemU9
MTYxLgpbIDM3NDUuOTc4ODMyXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IE1UUyAoNCksIGlkIGI3MDAsIHNpemU9MTY5LgpbIDM3NDUuOTc4ODM1XSB4YzIwMjggMTItMDA2
MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIE1UUyBMQ0QgKDEwMDQpLCBpZCBiNzAwLCBzaXplPTE2
OS4KWyAzNzQ1Ljk3ODgzOV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBN
VFMgTENEIE5PR0QgKDMwMDQpLCBpZCBiNzAwLCBzaXplPTE2OS4KWyAzNzQ1Ljk3ODg0M10geGMy
MDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNfSUZfMzI4MCAoNjAw
MDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODg0OF0geGMyMDI4IDEyLTAwNjE6IFJl
YWRpbmcgZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNfSUZfMzMwMCAoNjAwMDAwMDApLCBpZCAwLCBz
aXplPTE5Mi4KWyAzNzQ1Ljk3ODg1M10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUg
dHlwZSBTQ09ERSBIQVNfSUZfMzQ0MCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1
Ljk3ODg1N10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNf
SUZfMzQ2MCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODg2MV0geGMyMDI4
IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEVFY2IEFUU0MgT1JFTjM2IFNDT0RFIEhB
U19JRl8zODAwICg2MDIxMDAyMCksIGlkIDAsIHNpemU9MTkyLgpbIDM3NDUuOTc4ODY3XSB4YzIw
MjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl80MDAwICg2MDAw
MDAwMCksIGlkIDAsIHNpemU9MTkyLgpbIDM3NDUuOTc4ODcxXSB4YzIwMjggMTItMDA2MTogUmVh
ZGluZyBmaXJtd2FyZSB0eXBlIERUVjYgQVRTQyBUT1lPVEEzODggU0NPREUgSEFTX0lGXzQwODAg
KDYwNDEwMDIwKSwgaWQgMCwgc2l6ZT0xOTIuClsgMzc0NS45Nzg4NzddIHhjMjAyOCAxMi0wMDYx
OiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzQyMDAgKDYwMDAwMDAwKSwgaWQg
MCwgc2l6ZT0xOTIuClsgMzc0NS45Nzg4ODJdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13
YXJlIHR5cGUgTU9OTyBTQ09ERSBIQVNfSUZfNDMyMCAoNjAwMDgwMDApLCBpZCA4MDAwLCBzaXpl
PTE5Mi4KWyAzNzQ1Ljk3ODg4Nl0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBTQ09ERSBIQVNfSUZfNDQ1MCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3
ODg5MV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNVFMgTENEIE5PR0Qg
TU9OTyBJRiBTQ09ERSBIQVNfSUZfNDUwMCAoNjAwMmIwMDQpLCBpZCBiNzAwLCBzaXplPTE5Mi4K
WyAzNzQ1Ljk3ODg5OF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBMQ0Qg
Tk9HRCBJRiBTQ09ERSBIQVNfSUZfNDYwMCAoNjAwMjMwMDApLCBpZCA4MDAwLCBzaXplPTE5Mi4K
WyAzNzQ1Ljk3ODkwM10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBEVFY2
IFFBTSBEVFY3IERUVjc4IERUVjggWkFSTElOSzQ1NiBTQ09ERSBIQVNfSUZfNDc2MCAoNjIwMDAz
ZTApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODkxMV0geGMyMDI4IDEyLTAwNjE6IFJlYWRp
bmcgZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNfSUZfNDk0MCAoNjAwMDAwMDApLCBpZCAwLCBzaXpl
PTE5Mi4KWyAzNzQ1Ljk3ODkxNV0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBTQ09ERSBIQVNfSUZfNTI2MCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3
ODkyMF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhB
U19JRl81MzIwICg2MDAwODAwMCksIGlkIGYwMDAwMDAwNywgc2l6ZT0xOTIuClsgMzc0NS45Nzg5
MjRdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRFRWNyBEVFY3OCBEVFY4
IERJQkNPTTUyIENISU5BIFNDT0RFIEhBU19JRl81NDAwICg2NTAwMDM4MCksIGlkIDAsIHNpemU9
MTkyLgpbIDM3NDUuOTc4OTMxXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBl
IERUVjYgQVRTQyBPUkVONTM4IFNDT0RFIEhBU19JRl81NTgwICg2MDExMDAyMCksIGlkIDAsIHNp
emU9MTkyLgpbIDM3NDUuOTc4OTM4XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0
eXBlIFNDT0RFIEhBU19JRl81NjQwICg2MDAwMDAwMCksIGlkIDMwMDAwMDAwNywgc2l6ZT0xOTIu
ClsgMzc0NS45Nzg5NDJdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NP
REUgSEFTX0lGXzU3NDAgKDYwMDAwMDAwKSwgaWQgYzAwMDAwMDA3LCBzaXplPTE5Mi4KWyAzNzQ1
Ljk3ODk0N10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBTQ09ERSBIQVNf
SUZfNTkwMCAoNjAwMDAwMDApLCBpZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODk1MV0geGMyMDI4
IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl82MDAwICg2
MDAwODAwMCksIGlkIGMwNGMwMDBmMCwgc2l6ZT0xOTIuClsgMzc0NS45Nzg5NTZdIHhjMjAyOCAx
Mi0wMDYxOiBSZWFkaW5nIGZpcm13YXJlIHR5cGUgRFRWNiBRQU0gQVRTQyBMRzYwIEY2TUhaIFND
T0RFIEhBU19JRl82MjAwICg2ODA1MDA2MCksIGlkIDAsIHNpemU9MTkyLgpbIDM3NDUuOTc4OTYz
XSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0eXBlIFNDT0RFIEhBU19JRl82MjQw
ICg2MDAwMDAwMCksIGlkIDEwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODk2N10geGMyMDI4IDEyLTAw
NjE6IFJlYWRpbmcgZmlybXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl82MzIwICg2MDAwODAw
MCksIGlkIDIwMDAwMCwgc2l6ZT0xOTIuClsgMzc0NS45Nzg5NzJdIHhjMjAyOCAxMi0wMDYxOiBS
ZWFkaW5nIGZpcm13YXJlIHR5cGUgU0NPREUgSEFTX0lGXzYzNDAgKDYwMDAwMDAwKSwgaWQgMjAw
MDAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODk3N10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgdHlwZSBNT05PIFNDT0RFIEhBU19JRl82NTAwICg2MDAwODAwMCksIGlkIGMwNDQwMDBl
MCwgc2l6ZT0xOTIuClsgMzc0NS45Nzg5ODJdIHhjMjAyOCAxMi0wMDYxOiBSZWFkaW5nIGZpcm13
YXJlIHR5cGUgRFRWNiBBVFNDIEFUSTYzOCBTQ09ERSBIQVNfSUZfNjU4MCAoNjAwOTAwMjApLCBp
ZCAwLCBzaXplPTE5Mi4KWyAzNzQ1Ljk3ODk4OF0geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmly
bXdhcmUgdHlwZSBTQ09ERSBIQVNfSUZfNjYwMCAoNjAwMDAwMDApLCBpZCAzMDAwMDAwZTAsIHNp
emU9MTkyLgpbIDM3NDUuOTc4OTkyXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2FyZSB0
eXBlIE1PTk8gU0NPREUgSEFTX0lGXzY2ODAgKDYwMDA4MDAwKSwgaWQgMzAwMDAwMGUwLCBzaXpl
PTE5Mi4KWyAzNzQ1Ljk3ODk5N10geGMyMDI4IDEyLTAwNjE6IFJlYWRpbmcgZmlybXdhcmUgdHlw
ZSBEVFY2IEFUU0MgVE9ZT1RBNzk0IFNDT0RFIEhBU19JRl84MTQwICg2MDgxMDAyMCksIGlkIDAs
IHNpemU9MTkyLgpbIDM3NDUuOTc5MDIxXSB4YzIwMjggMTItMDA2MTogUmVhZGluZyBmaXJtd2Fy
ZSB0eXBlIFNDT0RFIEhBU19JRl84MjAwICg2MDAwMDAwMCksIGlkIDAsIHNpemU9MTkyLgpbIDM3
NDUuOTc5MDI1XSB4YzIwMjggMTItMDA2MTogRmlybXdhcmUgZmlsZXMgbG9hZGVkLgpbIDM3NDUu
OTc5ODE2XSBjeDI1ODQwIDEzLTAwNDQ6IFBMTCByZWdzID0gaW50OiAxNSwgZnJhYzogMjg3NjEw
NSwgcG9zdDogNApbIDM3NDUuOTc5ODIwXSBjeDI1ODQwIDEzLTAwNDQ6IFBMTCA9IDEwNy45OTk5
OTkgTUh6ClsgMzc0NS45Nzk4MjJdIGN4MjU4NDAgMTMtMDA0NDogUExMLzggPSAxMy40OTk5OTkg
TUh6ClsgMzc0NS45Nzk4MjVdIGN4MjU4NDAgMTMtMDA0NDogQURDIFNhbXBsaW5nIGZyZXEgPSAx
NC4zMTczODIgTUh6ClsgMzc0NS45Nzk4MjddIGN4MjU4NDAgMTMtMDA0NDogQ2hyb21hIHN1Yi1j
YXJyaWVyIGZyZXEgPSAzLjU3OTU0NSBNSHoKWyAzNzQ1Ljk3OTgzMV0gY3gyNTg0MCAxMy0wMDQ0
OiBoYmxhbmsgMTIyLCBoYWN0aXZlIDcyMCwgdmJsYW5rIDI2LCB2YWN0aXZlIDQ4NywgdmJsYW5r
NjU2IDI2LCBzcmNfZGVjIDU0MywgYnVyc3QgMHg1YiwgbHVtYV9scGYgMSwgdXZfbHBmIDEsIGNv
bWIgMHg2Niwgc2MgMHgwODdjMWYKWyAzNzQ1Ljk4Mjk2MV0gdHVuZXIgMTItMDA2MTogdHYgZnJl
cSBzZXQgdG8gNDAwLjAwClsgMzc0NS45ODI5NjRdIHhjMjAyOCAxMi0wMDYxOiB4YzIwMjhfc2V0
X2FuYWxvZ19mcmVxIGNhbGxlZApbIDM3NDUuOTgyOTY3XSB4YzIwMjggMTItMDA2MTogZ2VuZXJp
Y19zZXRfZnJlcSBjYWxsZWQKWyAzNzQ1Ljk4Mjk3MF0geGMyMDI4IDEyLTAwNjE6IHNob3VsZCBz
ZXQgZnJlcXVlbmN5IDQwMDAwMCBrSHoKWyAzNzQ1Ljk4Mjk3Ml0geGMyMDI4IDEyLTAwNjE6IGNo
ZWNrX2Zpcm13YXJlIGNhbGxlZApbIDM3NDUuOTgyOTc0XSB4YzIwMjggMTItMDA2MTogY2hlY2tp
bmcgZmlybXdhcmUsIHVzZXIgcmVxdWVzdGVkIHR5cGU9KDApLCBpZCAwMDAwMDAwMDAwMDAxMDAw
LCBzY29kZV90YmwgKDApLCBzY29kZV9uciAwClsgMzc0Ni4wMjE3MzldIGN4MjM4ODVbMF06IGN4
MjM4ODVfc3JhbV9jaGFubmVsX3NldHVwKCkgQ29uZmlndXJpbmcgY2hhbm5lbCBbVFYgQXVkaW9d
ClsgMzc0Ni4xODUzNTRdIHhjMjAyOCAxMi0wMDYxOiBsb2FkX2Zpcm13YXJlIGNhbGxlZApbIDM3
NDYuMTg1MzU4XSB4YzIwMjggMTItMDA2MTogc2Vla19maXJtd2FyZSBjYWxsZWQsIHdhbnQgdHlw
ZT1CQVNFICgxKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyAzNzQ2LjE4NTM2MV0geGMyMDI4IDEy
LTAwNjE6IEZvdW5kIGZpcm13YXJlIGZvciB0eXBlPUJBU0UgKDEpLCBpZCAwMDAwMDAwMDAwMDAw
MDAwLgpbIDM3NDYuMTg1MzYzXSB4YzIwMjggMTItMDA2MTogTG9hZGluZyBmaXJtd2FyZSBmb3Ig
dHlwZT1CQVNFICgxKSwgaWQgMDAwMDAwMDAwMDAwMDAwMC4KWyAzNzQ3LjM1NzM4NF0geGMyMDI4
IDEyLTAwNjE6IExvYWQgaW5pdDEgZmlybXdhcmUsIGlmIGV4aXN0cwpbIDM3NDcuMzU3Mzg5XSB4
YzIwMjggMTItMDA2MTogbG9hZF9maXJtd2FyZSBjYWxsZWQKWyAzNzQ3LjM1NzM5Ml0geGMyMDI4
IDEyLTAwNjE6IHNlZWtfZmlybXdhcmUgY2FsbGVkLCB3YW50IHR5cGU9QkFTRSBJTklUMSAoNDAw
MSksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgMzc0Ny4zNTczOTldIHhjMjAyOCAxMi0wMDYxOiBD
YW4ndCBmaW5kIGZpcm13YXJlIGZvciB0eXBlPUJBU0UgSU5JVDEgKDQwMDEpLCBpZCAwMDAwMDAw
MDAwMDAwMDAwLgpbIDM3NDcuMzU3NDAzXSB4YzIwMjggMTItMDA2MTogbG9hZF9maXJtd2FyZSBj
YWxsZWQKWyAzNzQ3LjM1NzQwNV0geGMyMDI4IDEyLTAwNjE6IHNlZWtfZmlybXdhcmUgY2FsbGVk
LCB3YW50IHR5cGU9QkFTRSBJTklUMSAoNDAwMSksIGlkIDAwMDAwMDAwMDAwMDAwMDAuClsgMzc0
Ny4zNTc0MTBdIHhjMjAyOCAxMi0wMDYxOiBDYW4ndCBmaW5kIGZpcm13YXJlIGZvciB0eXBlPUJB
U0UgSU5JVDEgKDQwMDEpLCBpZCAwMDAwMDAwMDAwMDAwMDAwLgpbIDM3NDcuMzU3NDE0XSB4YzIw
MjggMTItMDA2MTogbG9hZF9maXJtd2FyZSBjYWxsZWQKWyAzNzQ3LjM1NzQxNl0geGMyMDI4IDEy
LTAwNjE6IHNlZWtfZmlybXdhcmUgY2FsbGVkLCB3YW50IHR5cGU9KDApLCBpZCAwMDAwMDAwMDAw
MDAxMDAwLgpbIDM3NDcuMzU3NDIwXSB4YzIwMjggMTItMDA2MTogRm91bmQgZmlybXdhcmUgZm9y
IHR5cGU9KDApLCBpZCAwMDAwMDAwMDAwMDBiNzAwLgpbIDM3NDcuMzU3NDIzXSB4YzIwMjggMTIt
MDA2MTogTG9hZGluZyBmaXJtd2FyZSBmb3IgdHlwZT0oMCksIGlkIDAwMDAwMDAwMDAwMGI3MDAu
ClsgMzc0Ny4zNzI5NDNdIHhjMjAyOCAxMi0wMDYxOiBUcnlpbmcgdG8gbG9hZCBzY29kZSAwClsg
Mzc0Ny4zNzI5NDRdIHhjMjAyOCAxMi0wMDYxOiBsb2FkX3Njb2RlIGNhbGxlZApbIDM3NDcuMzcy
OTQ2XSB4YzIwMjggMTItMDA2MTogc2Vla19maXJtd2FyZSBjYWxsZWQsIHdhbnQgdHlwZT1TQ09E
RSAoMjAwMDAwMDApLCBpZCAwMDAwMDAwMDAwMDBiNzAwLgpbIDM3NDcuMzcyOTQ4XSB4YzIwMjgg
MTItMDA2MTogU2VsZWN0aW5nIGJlc3QgbWF0Y2hpbmcgZmlybXdhcmUgKDEgYml0cykgZm9yIHR5
cGU9U0NPREUgKDIwMDAwMDAwKSwgaWQgMDAwMDAwMDAwMDAwYjcwMDoKWyAzNzQ3LjM3Mjk1MF0g
eGMyMDI4IDEyLTAwNjE6IEZvdW5kIGZpcm13YXJlIGZvciB0eXBlPVNDT0RFICgyMDAwMDAwMCks
IGlkIDAwMDAwMDAwMDAwMDgwMDAuClsgMzc0Ny4zNzI5NTJdIHhjMjAyOCAxMi0wMDYxOiBMb2Fk
aW5nIFNDT0RFIGZvciB0eXBlPU1PTk8gU0NPREUgSEFTX0lGXzQzMjAgKDYwMDA4MDAwKSwgaWQg
MDAwMDAwMDAwMDAwODAwMC4KWyAzNzQ3LjM3NTI2OF0geGMyMDI4IDEyLTAwNjE6IHhjMjAyOF9n
ZXRfcmVnIDAwMDQgY2FsbGVkClsgMzc0Ny4zNzU5MzJdIHhjMjAyOCAxMi0wMDYxOiB4YzIwMjhf
Z2V0X3JlZyAwMDA4IGNhbGxlZApbIDM3NDcuMzc2NjE1XSB4YzIwMjggMTItMDA2MTogRGV2aWNl
IGlzIFhjZWl2ZSAzMDI4IHZlcnNpb24gMS4wLCBmaXJtd2FyZSB2ZXJzaW9uIDIuNwpbIDM3NDcu
NDg5MDUyXSB4YzIwMjggMTItMDA2MTogZGl2aXNvcj0gMDAgMDAgNjQgMDAgKGZyZXE9NDAwLjAw
MCkKWyAzNzQ3LjQ4OTczNV0gY3gyNTg0MCAxMy0wMDQ0OiBkZWNvZGVyIHNldCB2aWRlbyBpbnB1
dCAtMjE0NzQ4MzQzOSwgYXVkaW8gaW5wdXQgOApbIDM3NDcuNDg5NzM4XSBjeDI1ODQwIDEzLTAw
NDQ6IHZpZF9pbnB1dCAweDgwMDAwMGQxClsgMzc0Ny40ODk3NDBdIGN4MjU4NDAgMTMtMDA0NDog
bXV4IGNmZyAweGQxIGNvbXA9MQpbIDM3NDcuNTAxNDMwXSBjeDI1ODQwIDEzLTAwNDQ6IGRlY29k
ZXIgc2V0IHZpZGVvIGlucHV0IC0yMTQ3NDgzNDM5LCBhdWRpbyBpbnB1dCA4ClsgMzc0Ny41MDE0
MzNdIGN4MjU4NDAgMTMtMDA0NDogdmlkX2lucHV0IDB4ODAwMDAwZDEKWyAzNzQ3LjUwMTQzNF0g
Y3gyNTg0MCAxMy0wMDQ0OiBtdXggY2ZnIDB4ZDEgY29tcD0xClsgMzc0Ny41MTMxNzVdIGN4MjM4
ODVbMF06IGN4MjM4ODVfNDE3X3JlZ2lzdGVyKCkKWyAzNzQ3LjUxMzE3N10gY3gyMzg4NVswXTog
Y3gyMzg4NV92aWRlb19kZXZfYWxsb2MoKQpbIDM3NDcuNTEzMjk2XSBjeDIzODg1WzBdOiByZWdp
c3RlcmVkIGRldmljZSB2aWRlbzEgW21wZWddClsgMzc0Ny41MTMyOThdIGN4MjM4ODVbMF06IGN4
MjM4ODVfaW5pdGlhbGl6ZV9jb2RlYygpClsgMzc0Ny41MTMzMThdIEZpcm13YXJlIGFuZC9vciBt
YWlsYm94IHBvaW50ZXIgbm90IGluaXRpYWxpemVkIG9yIGNvcnJ1cHRlZCwgc2lnbmF0dXJlID0g
MHhmZWZlZmVmZSwgY21kID0gUElOR19GVwpbIDM3NDguMTA5OTQ2XSBjeDIzODg1WzBdOiBWZXJp
ZnlpbmcgZmlybXdhcmUgLi4uClsgMzc0OS40ODA3MTldIEVSUk9SOiBGaXJtd2FyZSBsb2FkIGZh
aWxlZCAoY2hlY2tzdW0gbWlzbWF0Y2gpLgpbIDM3NDkuNDgwNzM0XSBjeDIzODg1X2luaXRpYWxp
emVfY29kZWMoKSBmL3cgbG9hZCBmYWlsZWQKWyAzNzQ5LjQ4MDczOV0gY3gyMzg4NV9kZXZfY2hl
Y2tyZXZpc2lvbigpIEhhcmR3YXJlIHJldmlzaW9uID0gMHhiMApbIDM3NDkuNDgwNzQ0XSBjeDIz
ODg1WzBdLzA6IGZvdW5kIGF0IDAwMDA6MDU6MDAuMCwgcmV2OiAyLCBpcnE6IDE4LCBsYXRlbmN5
OiAwLCBtbWlvOiAweGQzMDAwMDAwCnJvb3RAbWVkZWI6fi92NGwjIAo=
------=_Part_26449_1418322827.1378910904449--
