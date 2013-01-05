Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43711 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3AEOa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 09:30:58 -0500
Received: by mail-bk0-f53.google.com with SMTP id j5so7627256bkw.26
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 06:30:56 -0800 (PST)
Message-ID: <50E83746.4010001@googlemail.com>
Date: Sat, 05 Jan 2013 15:23:02 +0100
From: =?ISO-8859-15?Q?Maxi_F=FCrst?= <maxi.fuerst96@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Medion 7134 Bridge #2
Content-Type: multipart/mixed;
 boundary="------------070906080407050901010501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070906080407050901010501
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've got the CTX925 in my computer. I'm using Fedora 17 with the 
3.6.10-2.fc17.x86_64 kernel. My problem is that there ought to be 
support for the SD1878/SHA tuner used in the DVB-S section of the card 
but there isn't. The Tuner isn't detected and only the TDA10086 module 
is being loaded. Support for this tuner has been correctly added to the 
ttpci driver as far as i know. I wanted to ask if somebody could write a 
patch for this issue. If you need any further information ask me.

Attached you can find the relevant kernel messages with as much 
debugging information enabled as possible.

Max

--------------070906080407050901010501
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.txt"

[  143.729687] Linux media interface: v0.10
[  143.734039] Linux video capture interface: v2.00
[  143.740049] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[  143.740148] saa7134[0]: found at 0000:03:01.0, rev: 1, irq: 17, latenc=
y: 32, mmio: 0xd8000000
[  143.740160] saa7134[0]: subsystem: 021a:0001, board: Medion 7134 [card=
=3D12,insmod option]
[  143.740186] saa7134[0]: board init: gpio is 0
[  143.740190] saa7134[0]/core: hwinit1
[  143.740200] saa7134[0]: gpio: mode=3D0x0000000 in=3D0x0000000 out=3D0x=
0000000 [pre-init]
[  143.841113] saa7134[0]: i2c xfer: < a0 00 >
[  143.843030] saa7134[0]: i2c xfer: < a1 =3Da0 =3D12 =3D02 =3D00 =3D54 =3D=
20 =3D08 =3D00 =3D43 =3D43 =3D28 =3D0c =3D00 =3D52 =3D20 =3D12 =3D00 =3D8=
7 =3D82 =3D0f =3Dff =3D20 =3D2a =3D00 =3D00 =3D50 =3D12 =3D00 =3D00 =3D18=
 =3D0a =3D10 =3D01 =3D00 =3D00 =3D02 =3D02 =3D03 =3D01 =3D00 =3D06 =3Dad =
=3D00 =3D10 =3D02 =3D51 =3D00 =3D08 =3D01 =3D18 =3D48 =3D07 =3D03 =3D00 =3D=
00 =3D0c =3Dd2 =3D00 =3D00 =3D10 =3D00 =3D00 =3D12 =3D3c =3D60 =3D00 =3D0=
0 =3Dc0 =3D82 =3D10 =3D00 =3D00 =3D00 =3D00 =3D01 =3D58 =3D40 =3D1b =3D02=
 =3D8d =3D7d =3D56 =3D65 =3D3f =3D00 =3D5b =3D06 =3D02 =3D00 =3D00 =3D04 =
=3D00 =3D0c =3D00 =3D04 =3D00 =3D2b =3Da6 =3D7d =3D38 =3D2b =3Dd4 =3Dd3 =3D=
5b =3D3a =3D51 =3De5 =3D5e =3Dc6 =3D87 =3Df2 =3Dff =3Dff =3Da6 =3D2a =3D5=
8 =3D3a =3D5b =3D13 =3D86 =3Db2 =3D58 =3D1a =3Dd4 =3Dd3 =3D58 =3D5a =3D5d=
 =3D02 =3D22 =3D50 =3D1f =3D21 =3D8f =3D80 =3D87 =3Dbf =3D5b =3Dfb =3D5b =
=3D3f =3Dad =3D28 =3D50 =3D16 =3D7d =3D28 =3D1c =3D41 =3D18 =3D48 =3D87 =3D=
f3 =3D00 =3D01 =3D8d =3Df3 =3D00 =3D01 =3D50 =3D22 =3D58 =3D12 =3D7f =3D6=
0 =3D00 =3D91 =3D5e =3D18 =3Dff =3Dff =3Da6 =3D7d =3Dda =3Dd8 =3D79 =3D29=
 =3D52 =3D96 =3Dd4 =3Dd3 =3D5b =3D3a =3Dad =3D2b =3D41 =3D84 =3D22 =3Da6 =
=3D58 =3D66 =3D00 =3D93 =3D26 =3D29 =3Da6 =3D2a =3D58 =3D3a =3D5b =3D13 =3D=
a6 =3D29 =3D58 =3D1a =3D61 =3D2b =3Dd4 =3Dd3 =3D49 =3D82 =3D8f =3Dba =3D4=
9 =3D82 =3D8f =3Df2 =3D00 =3D01 =3D5d =3D12 =3D22 =3D7e =3D1f =3D21 =3D8f=
 =3D80 =3D87 =3Dbf =3D5b =3Dfb =3D5b =3D3f =3Dad =3D28 =3D50 =3D16 =3D7d =
=3D28 =3D1c =3D41 =3D18 =3D48 =3D87 =3Df3 =3D00 =3D01 =3D8d =3Df3 =3D00 =3D=
01 =3D50 =3D22 =3D60 =3D29 =3D7f >
[  143.880020] saa7134[0]: i2c eeprom 00: a0 12 02 00 54 20 08 00 43 43 2=
8 0c 00 52 20 12
[  143.880034] saa7134[0]: i2c eeprom 10: 00 87 82 0f ff 20 2a 00 00 50 1=
2 00 00 18 0a 10
[  143.880047] saa7134[0]: i2c eeprom 20: 01 00 00 02 02 03 01 00 06 ad 0=
0 10 02 51 00 08
[  143.880059] saa7134[0]: i2c eeprom 30: 01 18 48 07 03 00 00 0c d2 00 0=
0 10 00 00 12 3c
[  143.880072] saa7134[0]: i2c eeprom 40: 60 00 00 c0 82 10 00 00 00 00 0=
1 58 40 1b 02 8d
[  143.880085] saa7134[0]: i2c eeprom 50: 7d 56 65 3f 00 5b 06 02 00 00 0=
4 00 0c 00 04 00
[  143.880097] saa7134[0]: i2c eeprom 60: 2b a6 7d 38 2b d4 d3 5b 3a 51 e=
5 5e c6 87 f2 ff
[  143.880110] saa7134[0]: i2c eeprom 70: ff a6 2a 58 3a 5b 13 86 b2 58 1=
a d4 d3 58 5a 5d
[  143.880122] saa7134[0]: i2c eeprom 80: 02 22 50 1f 21 8f 80 87 bf 5b f=
b 5b 3f ad 28 50
[  143.880135] saa7134[0]: i2c eeprom 90: 16 7d 28 1c 41 18 48 87 f3 00 0=
1 8d f3 00 01 50
[  143.880147] saa7134[0]: i2c eeprom a0: 22 58 12 7f 60 00 91 5e 18 ff f=
f a6 7d da d8 79
[  143.880160] saa7134[0]: i2c eeprom b0: 29 52 96 d4 d3 5b 3a ad 2b 41 8=
4 22 a6 58 66 00
[  143.880172] saa7134[0]: i2c eeprom c0: 93 26 29 a6 2a 58 3a 5b 13 a6 2=
9 58 1a 61 2b d4
[  143.880185] saa7134[0]: i2c eeprom d0: d3 49 82 8f ba 49 82 8f f2 00 0=
1 5d 12 22 7e 1f
[  143.880197] saa7134[0]: i2c eeprom e0: 21 8f 80 87 bf 5b fb 5b 3f ad 2=
8 50 16 7d 28 1c
[  143.880210] saa7134[0]: i2c eeprom f0: 41 18 48 87 f3 00 01 8d f3 00 0=
1 50 22 60 29 7f
[  143.880224] saa7134[0]: i2c xfer: < 01 ERROR: NO_DEVICE
[  143.880402] saa7134[0]: i2c xfer: < 03 ERROR: NO_DEVICE
[  143.880579] saa7134[0]: i2c xfer: < 05 ERROR: NO_DEVICE
[  143.880756] saa7134[0]: i2c xfer: < 07 ERROR: NO_DEVICE
[  143.880933] saa7134[0]: i2c xfer: < 09 ERROR: NO_DEVICE
[  143.881094] saa7134[0]: i2c xfer: < 0b ERROR: NO_DEVICE
[  143.881277] saa7134[0]: i2c xfer: < 0d ERROR: NO_DEVICE
[  143.881457] saa7134[0]: i2c xfer: < 0f ERROR: NO_DEVICE
[  143.881635] saa7134[0]: i2c xfer: < 11 >
[  143.883016] saa7134[0]: i2c scan: found device @ 0x10  [???]
[  143.883020] saa7134[0]: i2c xfer: < 13 ERROR: NO_DEVICE
[  143.883198] saa7134[0]: i2c xfer: < 15 ERROR: NO_DEVICE
[  143.883375] saa7134[0]: i2c xfer: < 17 ERROR: NO_DEVICE
[  143.883552] saa7134[0]: i2c xfer: < 19 ERROR: NO_DEVICE
[  143.883729] saa7134[0]: i2c xfer: < 1b ERROR: NO_DEVICE
[  143.883906] saa7134[0]: i2c xfer: < 1d ERROR: NO_DEVICE
[  143.884090] saa7134[0]: i2c xfer: < 1f ERROR: NO_DEVICE
[  143.884272] saa7134[0]: i2c xfer: < 21 ERROR: NO_DEVICE
[  143.884449] saa7134[0]: i2c xfer: < 23 ERROR: NO_DEVICE
[  143.884626] saa7134[0]: i2c xfer: < 25 ERROR: NO_DEVICE
[  143.884803] saa7134[0]: i2c xfer: < 27 ERROR: NO_DEVICE
[  143.884980] saa7134[0]: i2c xfer: < 29 ERROR: NO_DEVICE
[  143.885163] saa7134[0]: i2c xfer: < 2b ERROR: NO_DEVICE
[  143.885341] saa7134[0]: i2c xfer: < 2d ERROR: NO_DEVICE
[  143.885518] saa7134[0]: i2c xfer: < 2f ERROR: NO_DEVICE
[  143.885695] saa7134[0]: i2c xfer: < 31 ERROR: NO_DEVICE
[  143.885872] saa7134[0]: i2c xfer: < 33 ERROR: NO_DEVICE
[  143.886064] saa7134[0]: i2c xfer: < 35 ERROR: NO_DEVICE
[  143.886245] saa7134[0]: i2c xfer: < 37 ERROR: NO_DEVICE
[  143.886422] saa7134[0]: i2c xfer: < 39 ERROR: NO_DEVICE
[  143.886599] saa7134[0]: i2c xfer: < 3b ERROR: NO_DEVICE
[  143.886776] saa7134[0]: i2c xfer: < 3d ERROR: NO_DEVICE
[  143.886953] saa7134[0]: i2c xfer: < 3f ERROR: NO_DEVICE
[  143.887135] saa7134[0]: i2c xfer: < 41 ERROR: NO_DEVICE
[  143.887314] saa7134[0]: i2c xfer: < 43 ERROR: NO_DEVICE
[  143.887490] saa7134[0]: i2c xfer: < 45 ERROR: NO_DEVICE
[  143.887667] saa7134[0]: i2c xfer: < 47 ERROR: NO_DEVICE
[  143.887844] saa7134[0]: i2c xfer: < 49 ERROR: NO_DEVICE
[  143.888025] saa7134[0]: i2c xfer: < 4b ERROR: NO_DEVICE
[  143.888207] saa7134[0]: i2c xfer: < 4d ERROR: NO_DEVICE
[  143.888385] saa7134[0]: i2c xfer: < 4f ERROR: NO_DEVICE
[  143.888562] saa7134[0]: i2c xfer: < 51 ERROR: NO_DEVICE
[  143.888738] saa7134[0]: i2c xfer: < 53 ERROR: NO_DEVICE
[  143.888915] saa7134[0]: i2c xfer: < 55 ERROR: NO_DEVICE
[  143.889099] saa7134[0]: i2c xfer: < 57 ERROR: NO_DEVICE
[  143.889278] saa7134[0]: i2c xfer: < 59 ERROR: NO_DEVICE
[  143.889455] saa7134[0]: i2c xfer: < 5b ERROR: NO_DEVICE
[  143.889632] saa7134[0]: i2c xfer: < 5d ERROR: NO_DEVICE
[  143.889809] saa7134[0]: i2c xfer: < 5f ERROR: NO_DEVICE
[  143.889986] saa7134[0]: i2c xfer: < 61 ERROR: NO_DEVICE
[  143.890169] saa7134[0]: i2c xfer: < 63 ERROR: NO_DEVICE
[  143.890348] saa7134[0]: i2c xfer: < 65 ERROR: NO_DEVICE
[  143.890525] saa7134[0]: i2c xfer: < 67 ERROR: NO_DEVICE
[  143.890701] saa7134[0]: i2c xfer: < 69 ERROR: NO_DEVICE
[  143.890878] saa7134[0]: i2c xfer: < 6b ERROR: NO_DEVICE
[  143.891064] saa7134[0]: i2c xfer: < 6d ERROR: NO_DEVICE
[  143.891245] saa7134[0]: i2c xfer: < 6f ERROR: NO_DEVICE
[  143.891423] saa7134[0]: i2c xfer: < 71 ERROR: NO_DEVICE
[  143.891599] saa7134[0]: i2c xfer: < 73 ERROR: NO_DEVICE
[  143.891776] saa7134[0]: i2c xfer: < 75 ERROR: NO_DEVICE
[  143.891953] saa7134[0]: i2c xfer: < 77 ERROR: NO_DEVICE
[  143.892136] saa7134[0]: i2c xfer: < 79 ERROR: NO_DEVICE
[  143.892314] saa7134[0]: i2c xfer: < 7b ERROR: NO_DEVICE
[  143.892491] saa7134[0]: i2c xfer: < 7d ERROR: NO_DEVICE
[  143.892668] saa7134[0]: i2c xfer: < 7f ERROR: NO_DEVICE
[  143.892844] saa7134[0]: i2c xfer: < 81 ERROR: NO_DEVICE
[  143.893025] saa7134[0]: i2c xfer: < 83 ERROR: NO_DEVICE
[  143.893207] saa7134[0]: i2c xfer: < 85 ERROR: NO_DEVICE
[  143.893385] saa7134[0]: i2c xfer: < 87 >
[  143.895015] saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
[  143.895018] saa7134[0]: i2c xfer: < 89 ERROR: NO_DEVICE
[  143.895196] saa7134[0]: i2c xfer: < 8b ERROR: NO_DEVICE
[  143.895373] saa7134[0]: i2c xfer: < 8d ERROR: NO_DEVICE
[  143.895550] saa7134[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[  143.895727] saa7134[0]: i2c xfer: < 91 ERROR: NO_DEVICE
[  143.895904] saa7134[0]: i2c xfer: < 93 ERROR: NO_DEVICE
[  143.896090] saa7134[0]: i2c xfer: < 95 ERROR: NO_DEVICE
[  143.896272] saa7134[0]: i2c xfer: < 97 ERROR: NO_DEVICE
[  143.896449] saa7134[0]: i2c xfer: < 99 ERROR: NO_DEVICE
[  143.896626] saa7134[0]: i2c xfer: < 9b ERROR: NO_DEVICE
[  143.896803] saa7134[0]: i2c xfer: < 9d ERROR: NO_DEVICE
[  143.896980] saa7134[0]: i2c xfer: < 9f ERROR: NO_DEVICE
[  143.897162] saa7134[0]: i2c xfer: < a1 >
[  143.899014] saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
[  143.899018] saa7134[0]: i2c xfer: < a3 >
[  143.901015] saa7134[0]: i2c scan: found device @ 0xa2  [???]
[  143.901018] saa7134[0]: i2c xfer: < a5 ERROR: NO_DEVICE
[  143.901196] saa7134[0]: i2c xfer: < a7 ERROR: NO_DEVICE
[  143.901373] saa7134[0]: i2c xfer: < a9 ERROR: NO_DEVICE
[  143.901550] saa7134[0]: i2c xfer: < ab ERROR: NO_DEVICE
[  143.901727] saa7134[0]: i2c xfer: < ad ERROR: NO_DEVICE
[  143.901904] saa7134[0]: i2c xfer: < af ERROR: NO_DEVICE
[  143.902091] saa7134[0]: i2c xfer: < b1 ERROR: NO_DEVICE
[  143.902272] saa7134[0]: i2c xfer: < b3 ERROR: NO_DEVICE
[  143.902450] saa7134[0]: i2c xfer: < b5 ERROR: NO_DEVICE
[  143.902627] saa7134[0]: i2c xfer: < b7 ERROR: NO_DEVICE
[  143.902804] saa7134[0]: i2c xfer: < b9 ERROR: NO_DEVICE
[  143.902981] saa7134[0]: i2c xfer: < bb ERROR: NO_DEVICE
[  143.903163] saa7134[0]: i2c xfer: < bd ERROR: NO_DEVICE
[  143.903341] saa7134[0]: i2c xfer: < bf ERROR: NO_DEVICE
[  143.903518] saa7134[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[  143.903695] saa7134[0]: i2c xfer: < c3 >
[  143.905015] saa7134[0]: i2c scan: found device @ 0xc2  [???]
[  143.905019] saa7134[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[  143.905197] saa7134[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[  143.905374] saa7134[0]: i2c xfer: < c9 ERROR: NO_DEVICE
[  143.905551] saa7134[0]: i2c xfer: < cb ERROR: NO_DEVICE
[  143.905728] saa7134[0]: i2c xfer: < cd ERROR: NO_DEVICE
[  143.905905] saa7134[0]: i2c xfer: < cf ERROR: NO_DEVICE
[  143.906090] saa7134[0]: i2c xfer: < d1 ERROR: NO_DEVICE
[  143.906271] saa7134[0]: i2c xfer: < d3 ERROR: NO_DEVICE
[  143.906449] saa7134[0]: i2c xfer: < d5 ERROR: NO_DEVICE
[  143.906626] saa7134[0]: i2c xfer: < d7 ERROR: NO_DEVICE
[  143.906803] saa7134[0]: i2c xfer: < d9 ERROR: NO_DEVICE
[  143.906980] saa7134[0]: i2c xfer: < db ERROR: NO_DEVICE
[  143.907162] saa7134[0]: i2c xfer: < dd ERROR: NO_DEVICE
[  143.907340] saa7134[0]: i2c xfer: < df ERROR: NO_DEVICE
[  143.907517] saa7134[0]: i2c xfer: < e1 ERROR: NO_DEVICE
[  143.907694] saa7134[0]: i2c xfer: < e3 ERROR: NO_DEVICE
[  143.907871] saa7134[0]: i2c xfer: < e5 ERROR: NO_DEVICE
[  143.908063] saa7134[0]: i2c xfer: < e7 ERROR: NO_DEVICE
[  143.908244] saa7134[0]: i2c xfer: < e9 ERROR: NO_DEVICE
[  143.908421] saa7134[0]: i2c xfer: < eb ERROR: NO_DEVICE
[  143.908598] saa7134[0]: i2c xfer: < ed ERROR: NO_DEVICE
[  143.908775] saa7134[0]: i2c xfer: < ef ERROR: NO_DEVICE
[  143.908952] saa7134[0]: i2c xfer: < f1 ERROR: NO_DEVICE
[  143.909134] saa7134[0]: i2c xfer: < f3 ERROR: NO_DEVICE
[  143.909312] saa7134[0]: i2c xfer: < f5 ERROR: NO_DEVICE
[  143.909489] saa7134[0]: i2c xfer: < f7 ERROR: NO_DEVICE
[  143.909666] saa7134[0]: i2c xfer: < f9 ERROR: NO_DEVICE
[  143.909843] saa7134[0]: i2c xfer: < fb ERROR: NO_DEVICE
[  143.910024] saa7134[0]: i2c xfer: < fd ERROR: NO_DEVICE
[  143.910206] saa7134[0]: i2c xfer: < ff ERROR: NO_DEVICE
[  143.910347] saa7134[0]/ir: No I2C IR support for board c
[  143.910387] saa7134[0]: i2c xfer: < a0 14 [fe quirk] < a1 =3D00 =3D00 =
=3D00 >
[  143.913016] saa7134[0] unexpected config structure
[  143.913020] saa7134[0] Tuner type is 63
[  143.920457] saa7134[0]: i2c xfer: < 84 ERROR: NO_DEVICE
[  143.920645] saa7134[0]: i2c xfer: < 86 >
[  143.922286] saa7134[0]: i2c xfer: < 87 =3D8e =3D8e =3D8e =3D8e =3D8e =3D=
8e =3D8e =3D8e =3D8e =3D8e =3D8e =3D8e =3D8e =3D8e =3D8e =3D8e >
[  143.926023] tuner 6-0043: I2C RECV =3D 8e 8e 8e 8e 8e 8e 8e 8e 8e 8e 8=
e 8e 8e 8e 8e 8e=20
[  143.928960] saa7134[0]: i2c xfer: < 86 00 [fe quirk] < 87 =3D8e =3D8e =
=3D8e =3D8e =3D8e =3D8e =3D8e =3D8e >
[  143.934661] tda9887 6-0043: creating new instance
[  143.934668] tda9887 6-0043: tda988[5/6/7] found
[  143.934672] tuner 6-0043: type set to tda9887
[  143.934677] tuner 6-0043: tv freq set to 400.00
[  143.934681] tda9887 6-0043: Unsupported tvnorm entry - audio muted
[  143.934686] tda9887 6-0043: writing: b=3D0xc0 c=3D0x00 e=3D0x00
[  143.934691] saa7134[0]: i2c xfer: < 86 00 c0 00 00 >
[  143.937023] tuner 6-0043: saa7134[0] tuner I2C addr 0x86 with type 74 =
used for 0x06
[  143.937028] tuner 6-0043: Tuner 74 found with type(s) Radio TV.
[  143.939053] saa7134[0]: i2c xfer: < c0 ERROR: NO_DEVICE
[  143.939236] saa7134[0]: i2c xfer: < c2 >
[  143.941100] saa7134[0]: i2c xfer: < c3 =3D30 =3D30 =3D30 =3D30 =3D30 =3D=
30 =3D30 =3D30 =3D30 =3D30 =3D30 =3D30 =3D30 =3D30 =3D30 =3D30 >
[  143.945025] tuner 6-0061: I2C RECV =3D 30 30 30 30 30 30 30 30 30 30 3=
0 30 30 30 30 30=20
[  143.945044] tuner 6-0061: Setting mode_mask to 0x06
[  143.945047] tuner 6-0061: tuner 0x61: Tuner type absent
[  143.945050] tuner 6-0061: Tuner -1 found with type(s) Radio TV.
[  143.945070] tuner 6-0043: Calling set_type_addr for type=3D63, addr=3D=
0xff, mode=3D0x06, config=3D0x00
[  143.945075] tuner 6-0043: set addr discarded for type 74, mask 6. Aske=
d to change tuner at addr 0xff, with mask 6
[  143.945078] tuner 6-0061: Calling set_type_addr for type=3D63, addr=3D=
0xff, mode=3D0x06, config=3D0x00
[  143.945080] tuner 6-0061: defining GPIO callback
[  143.945084] saa7134[0]: i2c xfer: < c2 0b dc 9c 60 >
[  143.948027] saa7134[0]: i2c xfer: < c2 0b dc 86 54 >
[  143.953228] saa7134[0]: i2c xfer: < c3 =3D30 >
[  143.955031] tuner-simple 6-0061: creating new instance
[  143.955036] tuner-simple 6-0061: type set to 63 (Philips FMD1216ME MK3=
 Hybrid Tuner)
[  143.955041] tuner 6-0061: type set to Philips FMD1216ME MK3 Hybrid Tun=
er
[  143.955044] tuner 6-0061: tv freq set to 400.00
[  143.955051] tda9887 6-0043: Unsupported tvnorm entry - audio muted
[  143.955055] tda9887 6-0043: writing: b=3D0x00 c=3D0x00 e=3D0x00
[  143.955059] saa7134[0]: i2c xfer: < 86 00 00 00 00 >
[  143.957049] saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
[  143.959025] tuner 6-0061: saa7134[0] tuner I2C addr 0xc2 with type 63 =
used for 0x06
[  143.959029] tda9887 6-0043: Unsupported tvnorm entry - audio muted
[  143.959032] tda9887 6-0043: writing: b=3D0xc2 c=3D0x00 e=3D0x00
[  143.959035] saa7134[0]: i2c xfer: < 86 00 c2 00 00 >
[  143.961023] saa7134[0]/core: hwinit2
[  143.961032] tuner 6-0043: tv freq set to 400.00
[  143.961035] tda9887 6-0043: configure for: PAL-BGHN
[  143.961037] tda9887 6-0043: writing: b=3D0xd6 c=3D0x70 e=3D0x49
[  143.961040] saa7134[0]: i2c xfer: < 86 00 d6 70 49 >
[  143.963017] tuner 6-0061: tv freq set to 400.00
[  143.963021] tda9887 6-0043: configure for: PAL-BGHN
[  143.963024] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.963027] saa7134[0]: i2c xfer: < 86 00 14 70 49 >
[  143.965017] saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
[  143.967021] tuner 6-0043: tv freq set to 400.00
[  143.967024] tda9887 6-0043: configure for: PAL-BGHN
[  143.967026] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.967029] saa7134[0]: i2c xfer: < 86 00 14 70 49 >
[  143.969016] tuner 6-0061: tv freq set to 400.00
[  143.969020] tda9887 6-0043: configure for: PAL-BGHN
[  143.969022] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.969025] saa7134[0]: i2c xfer: < 86 00 14 70 49 >
[  143.971016] saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
[  143.973016] saa7134[0]/audio: ctl_mute=3D1 automute=3D0 input=3DTelevi=
sion  =3D>  mute=3D1 input=3Dmute
[  143.973025] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  143.973096] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  143.973102] tuner 6-0043: Putting tuner to sleep
[  143.973105] tda9887 6-0043: configure for: PAL-BGHN
[  143.973109] tda9887 6-0043: writing: b=3D0x34 c=3D0x70 e=3D0x49
[  143.973113] saa7134[0]: i2c xfer: < 86 00 34 70 49 >
[  143.975015] tuner 6-0061: Putting tuner to sleep
[  143.975019] saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[  143.977548] saa7134[0]: registered device video0 [v4l2]
[  143.979117] saa7134[0]: registered device vbi0
[  143.979269] saa7134[0]: registered device radio0
[  143.979338] saa7134[1]: found at 0000:03:04.0, rev: 1, irq: 20, latenc=
y: 32, mmio: 0xd8002000
[  143.979349] saa7134[1]: subsystem: 16be:0005, board: Medion 7134 Bridg=
e #2 [card=3D93,autodetected]
[  143.979382] saa7134[1]: board init: gpio is 41004d
[  143.979386] saa7134[1]/core: hwinit1
[  143.979396] saa7134[1]: gpio: mode=3D0x0000000 in=3D0x041004d out=3D0x=
0000000 [pre-init]
[  143.982554] tuner 6-0043: tv freq set to 400.00
[  143.982563] tda9887 6-0043: configure for: PAL-BGHN
[  143.982568] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.982575] saa7134[0]: i2c xfer: < 86 00 14 70 49 >
[  143.985047] tuner 6-0061: tv freq set to 400.00
[  143.985062] tda9887 6-0043: configure for: PAL-BGHN
[  143.985069] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.985395] tuner 6-0043: tv freq set to 400.00
[  143.985401] tda9887 6-0043: configure for: PAL-BGHN
[  143.985405] tda9887 6-0043: writing: b=3D0x14 c=3D0x70 e=3D0x49
[  143.986846] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  143.986855] tuner 6-0043: Changing to mode 1
[  143.986860] tuner 6-0043: radio freq set to 87.50
[  143.986864] tda9887 6-0043: configure for: Radio Stereo
[  143.986869] tda9887 6-0043: writing: b=3D0x0c c=3D0x90 e=3D0x3d
[  143.985075] saa7134[0]: i2c xfer: < 86 00 14 70 49 >
[  143.987136] saa7134[0]: i2c xfer: < 86 00 0c 90 3d >
[  143.989039] tuner 6-0061: tv freq set to 400.00
[  143.989052] tda9887 6-0043: configure for: Radio Stereo
[  143.989057] tda9887 6-0043: writing: b=3D0x0c c=3D0x90 e=3D0x3d
[  143.989041] saa7134[0]: i2c xfer: < 86 00 0c 90 3d >
[  143.991031] tuner 6-0061: Changing to mode 1
[  143.991041] tuner 6-0061: radio freq set to 87.50
[  143.991045] tda9887 6-0043: configure for: Radio Stereo
[  143.991050] tda9887 6-0043: writing: b=3D0x8c c=3D0x90 e=3D0x3d
[  143.991035] saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
[  143.993033] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  143.993038] video0: open (0)
[  143.993054] saa7134[0]: i2c xfer: < 86 00 8c 90 3d >
[  143.993807] video0: VIDIOC_QUERYCAP
[  143.995047]=20
[  143.998335] tuner 6-0043: Putting tuner to sleep
[  143.998342] tda9887 6-0043: configure for: Radio Stereo
[  143.998348] tda9887 6-0043: writing: b=3D0xac c=3D0x90 e=3D0x3d
[  143.997549] saa7134[0]: i2c xfer: < 86 00 8c 90 3d >
[  144.000038] saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
[  144.002031] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.002041] vbi0: open (0)
[  144.002061] saa7134[0]: i2c xfer: < 86
[  144.002061] vbi0: VIDIOC_QUERYCAP
[  144.002135] tuner 6-0043: Putting tuner to sleep
[  144.002139] tda9887 6-0043: configure for: Radio Stereo
[  144.002143] tda9887 6-0043: writing: b=3D0xac c=3D0x90 e=3D0x3d
[  144.002176]  00 ac 90 3d >
[  144.004031] tuner 6-0061: Putting tuner to sleep
[  144.004037] saa7134[0]: i2c xfer: < c2 07 ac 80 19 >
[  144.006025] radio0: open (0)
[  144.006031] saa7134[0]: i2c xfer: < 86
[  144.006046] radio0: VIDIOC_QUERYCAP
[  144.006116] tuner 6-0043: Putting tuner to sleep
[  144.006120] tda9887 6-0043: configure for: Radio Stereo
[  144.006124] tda9887 6-0043: writing: b=3D0xac c=3D0x90 e=3D0x3d
[  144.006174]  00 ac 90 3d >
[  144.008023] tuner 6-0061: Putting tuner to sleep
[  144.008030] saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[  144.010028] video0: release
[  144.010030] saa7134[0]: i2c xfer: < 86 00 ac 90 3d >
[  144.012042] tuner 6-0061: Putting tuner to sleep
[  144.012054] saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[  144.014047] vbi0: release
[  144.021169] saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[  144.023049] radio0: release
[  144.080132] saa7134[1]: i2c xfer: < a0 00 >
[  144.082029] saa7134[1]: i2c xfer: < a1 =3Dbe =3D16 =3D05 =3D00 =3D54 =3D=
20 =3D1c =3D00 =3D43 =3D43 =3Da9 =3D1c =3D55 =3Dd2 =3Db2 =3D92 =3D00 =3Df=
f =3D86 =3D0f =3Dff =3D20 =3Dff =3D00 =3D01 =3D50 =3D32 =3D79 =3D01 =3D3c=
 =3Dca =3D50 =3D01 =3D40 =3D01 =3D02 =3D02 =3D03 =3D01 =3D00 =3D06 =3Dff =
=3D00 =3D21 =3D02 =3D51 =3D96 =3D2b =3Da7 =3D58 =3D7a =3D1f =3D03 =3D8e =3D=
84 =3D5e =3Dda =3D7a =3D04 =3Db3 =3D05 =3D87 =3Db2 =3D3c =3Dff =3D24 =3D0=
0 =3Dc0 =3Dff =3D1c =3D00 =3Dff =3Dff =3Dff =3Dfd =3D79 =3D44 =3D9f =3Dc2=
 =3D8f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff >
[  144.119021] saa7134[1]: i2c eeprom 00: be 16 05 00 54 20 1c 00 43 43 a=
9 1c 55 d2 b2 92
[  144.119036] saa7134[1]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 3=
2 79 01 3c ca 50
[  144.119049] saa7134[1]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 0=
0 21 02 51 96 2b
[  144.119061] saa7134[1]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 0=
4 b3 05 87 b2 3c
[  144.119074] saa7134[1]: i2c eeprom 40: ff 24 00 c0 ff 1c 00 ff ff ff f=
d 79 44 9f c2 8f
[  144.119086] saa7134[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119099] saa7134[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119112] saa7134[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119124] saa7134[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119137] saa7134[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119149] saa7134[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119162] saa7134[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119174] saa7134[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119187] saa7134[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119200] saa7134[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119212] saa7134[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[  144.119226] saa7134[1]: i2c xfer: < 01 ERROR: NO_DEVICE
[  144.119404] saa7134[1]: i2c xfer: < 03 ERROR: NO_DEVICE
[  144.119581] saa7134[1]: i2c xfer: < 05 ERROR: NO_DEVICE
[  144.119758] saa7134[1]: i2c xfer: < 07 ERROR: NO_DEVICE
[  144.119935] saa7134[1]: i2c xfer: < 09 ERROR: NO_DEVICE
[  144.120125] saa7134[1]: i2c xfer: < 0b ERROR: NO_DEVICE
[  144.120307] saa7134[1]: i2c xfer: < 0d ERROR: NO_DEVICE
[  144.120486] saa7134[1]: i2c xfer: < 0f ERROR: NO_DEVICE
[  144.120663] saa7134[1]: i2c xfer: < 11 ERROR: NO_DEVICE
[  144.120840] saa7134[1]: i2c xfer: < 13 ERROR: NO_DEVICE
[  144.121022] saa7134[1]: i2c xfer: < 15 ERROR: NO_DEVICE
[  144.121208] saa7134[1]: i2c xfer: < 17 ERROR: NO_DEVICE
[  144.121386] saa7134[1]: i2c xfer: < 19 ERROR: NO_DEVICE
[  144.121563] saa7134[1]: i2c xfer: < 1b ERROR: NO_DEVICE
[  144.121740] saa7134[1]: i2c xfer: < 1d >
[  144.124017] saa7134[1]: i2c scan: found device @ 0x1c  [???]
[  144.124021] saa7134[1]: i2c xfer: < 1f ERROR: NO_DEVICE
[  144.124199] saa7134[1]: i2c xfer: < 21 ERROR: NO_DEVICE
[  144.124376] saa7134[1]: i2c xfer: < 23 ERROR: NO_DEVICE
[  144.124553] saa7134[1]: i2c xfer: < 25 ERROR: NO_DEVICE
[  144.124730] saa7134[1]: i2c xfer: < 27 ERROR: NO_DEVICE
[  144.124907] saa7134[1]: i2c xfer: < 29 ERROR: NO_DEVICE
[  144.125092] saa7134[1]: i2c xfer: < 2b ERROR: NO_DEVICE
[  144.125273] saa7134[1]: i2c xfer: < 2d ERROR: NO_DEVICE
[  144.125451] saa7134[1]: i2c xfer: < 2f ERROR: NO_DEVICE
[  144.125628] saa7134[1]: i2c xfer: < 31 ERROR: NO_DEVICE
[  144.125805] saa7134[1]: i2c xfer: < 33 ERROR: NO_DEVICE
[  144.125982] saa7134[1]: i2c xfer: < 35 ERROR: NO_DEVICE
[  144.126164] saa7134[1]: i2c xfer: < 37 ERROR: NO_DEVICE
[  144.126342] saa7134[1]: i2c xfer: < 39 ERROR: NO_DEVICE
[  144.126519] saa7134[1]: i2c xfer: < 3b ERROR: NO_DEVICE
[  144.126697] saa7134[1]: i2c xfer: < 3d ERROR: NO_DEVICE
[  144.126874] saa7134[1]: i2c xfer: < 3f ERROR: NO_DEVICE
[  144.127064] saa7134[1]: i2c xfer: < 41 ERROR: NO_DEVICE
[  144.127245] saa7134[1]: i2c xfer: < 43 ERROR: NO_DEVICE
[  144.127422] saa7134[1]: i2c xfer: < 45 ERROR: NO_DEVICE
[  144.127599] saa7134[1]: i2c xfer: < 47 ERROR: NO_DEVICE
[  144.127776] saa7134[1]: i2c xfer: < 49 ERROR: NO_DEVICE
[  144.127953] saa7134[1]: i2c xfer: < 4b ERROR: NO_DEVICE
[  144.128135] saa7134[1]: i2c xfer: < 4d ERROR: NO_DEVICE
[  144.128313] saa7134[1]: i2c xfer: < 4f ERROR: NO_DEVICE
[  144.128490] saa7134[1]: i2c xfer: < 51 ERROR: NO_DEVICE
[  144.128667] saa7134[1]: i2c xfer: < 53 ERROR: NO_DEVICE
[  144.128844] saa7134[1]: i2c xfer: < 55 ERROR: NO_DEVICE
[  144.129024] saa7134[1]: i2c xfer: < 57 ERROR: NO_DEVICE
[  144.129206] saa7134[1]: i2c xfer: < 59 ERROR: NO_DEVICE
[  144.129384] saa7134[1]: i2c xfer: < 5b ERROR: NO_DEVICE
[  144.129560] saa7134[1]: i2c xfer: < 5d ERROR: NO_DEVICE
[  144.129737] saa7134[1]: i2c xfer: < 5f ERROR: NO_DEVICE
[  144.129914] saa7134[1]: i2c xfer: < 61 ERROR: NO_DEVICE
[  144.130098] saa7134[1]: i2c xfer: < 63 ERROR: NO_DEVICE
[  144.130277] saa7134[1]: i2c xfer: < 65 ERROR: NO_DEVICE
[  144.130454] saa7134[1]: i2c xfer: < 67 ERROR: NO_DEVICE
[  144.130631] saa7134[1]: i2c xfer: < 69 ERROR: NO_DEVICE
[  144.130808] saa7134[1]: i2c xfer: < 6b ERROR: NO_DEVICE
[  144.130985] saa7134[1]: i2c xfer: < 6d ERROR: NO_DEVICE
[  144.131167] saa7134[1]: i2c xfer: < 6f ERROR: NO_DEVICE
[  144.131345] saa7134[1]: i2c xfer: < 71 ERROR: NO_DEVICE
[  144.131522] saa7134[1]: i2c xfer: < 73 ERROR: NO_DEVICE
[  144.131699] saa7134[1]: i2c xfer: < 75 ERROR: NO_DEVICE
[  144.131876] saa7134[1]: i2c xfer: < 77 ERROR: NO_DEVICE
[  144.132064] saa7134[1]: i2c xfer: < 79 ERROR: NO_DEVICE
[  144.132245] saa7134[1]: i2c xfer: < 7b ERROR: NO_DEVICE
[  144.132422] saa7134[1]: i2c xfer: < 7d ERROR: NO_DEVICE
[  144.132599] saa7134[1]: i2c xfer: < 7f ERROR: NO_DEVICE
[  144.132775] saa7134[1]: i2c xfer: < 81 ERROR: NO_DEVICE
[  144.132952] saa7134[1]: i2c xfer: < 83 ERROR: NO_DEVICE
[  144.133135] saa7134[1]: i2c xfer: < 85 ERROR: NO_DEVICE
[  144.133313] saa7134[1]: i2c xfer: < 87 ERROR: NO_DEVICE
[  144.133490] saa7134[1]: i2c xfer: < 89 ERROR: NO_DEVICE
[  144.133667] saa7134[1]: i2c xfer: < 8b ERROR: NO_DEVICE
[  144.133844] saa7134[1]: i2c xfer: < 8d ERROR: NO_DEVICE
[  144.134025] saa7134[1]: i2c xfer: < 8f ERROR: NO_DEVICE
[  144.134206] saa7134[1]: i2c xfer: < 91 ERROR: NO_DEVICE
[  144.134384] saa7134[1]: i2c xfer: < 93 ERROR: NO_DEVICE
[  144.134561] saa7134[1]: i2c xfer: < 95 ERROR: NO_DEVICE
[  144.134737] saa7134[1]: i2c xfer: < 97 ERROR: NO_DEVICE
[  144.134914] saa7134[1]: i2c xfer: < 99 ERROR: NO_DEVICE
[  144.135098] saa7134[1]: i2c xfer: < 9b ERROR: NO_DEVICE
[  144.135277] saa7134[1]: i2c xfer: < 9d ERROR: NO_DEVICE
[  144.135454] saa7134[1]: i2c xfer: < 9f ERROR: NO_DEVICE
[  144.135631] saa7134[1]: i2c xfer: < a1 >
[  144.137015] saa7134[1]: i2c scan: found device @ 0xa0  [eeprom]
[  144.137019] saa7134[1]: i2c xfer: < a3 >
[  144.139015] saa7134[1]: i2c scan: found device @ 0xa2  [???]
[  144.139019] saa7134[1]: i2c xfer: < a5 ERROR: NO_DEVICE
[  144.139197] saa7134[1]: i2c xfer: < a7 ERROR: NO_DEVICE
[  144.139374] saa7134[1]: i2c xfer: < a9 ERROR: NO_DEVICE
[  144.139551] saa7134[1]: i2c xfer: < ab ERROR: NO_DEVICE
[  144.139728] saa7134[1]: i2c xfer: < ad ERROR: NO_DEVICE
[  144.139905] saa7134[1]: i2c xfer: < af ERROR: NO_DEVICE
[  144.140091] saa7134[1]: i2c xfer: < b1 ERROR: NO_DEVICE
[  144.140272] saa7134[1]: i2c xfer: < b3 ERROR: NO_DEVICE
[  144.140450] saa7134[1]: i2c xfer: < b5 ERROR: NO_DEVICE
[  144.140627] saa7134[1]: i2c xfer: < b7 ERROR: NO_DEVICE
[  144.140804] saa7134[1]: i2c xfer: < b9 ERROR: NO_DEVICE
[  144.140981] saa7134[1]: i2c xfer: < bb ERROR: NO_DEVICE
[  144.141163] saa7134[1]: i2c xfer: < bd ERROR: NO_DEVICE
[  144.141341] saa7134[1]: i2c xfer: < bf ERROR: NO_DEVICE
[  144.141518] saa7134[1]: i2c xfer: < c1 ERROR: NO_DEVICE
[  144.141695] saa7134[1]: i2c xfer: < c3 ERROR: NO_DEVICE
[  144.141872] saa7134[1]: i2c xfer: < c5 ERROR: NO_DEVICE
[  144.142063] saa7134[1]: i2c xfer: < c7 ERROR: NO_DEVICE
[  144.142244] saa7134[1]: i2c xfer: < c9 ERROR: NO_DEVICE
[  144.142421] saa7134[1]: i2c xfer: < cb ERROR: NO_DEVICE
[  144.142598] saa7134[1]: i2c xfer: < cd ERROR: NO_DEVICE
[  144.142775] saa7134[1]: i2c xfer: < cf ERROR: NO_DEVICE
[  144.142952] saa7134[1]: i2c xfer: < d1 ERROR: NO_DEVICE
[  144.143135] saa7134[1]: i2c xfer: < d3 ERROR: NO_DEVICE
[  144.143313] saa7134[1]: i2c xfer: < d5 ERROR: NO_DEVICE
[  144.143491] saa7134[1]: i2c xfer: < d7 ERROR: NO_DEVICE
[  144.143667] saa7134[1]: i2c xfer: < d9 ERROR: NO_DEVICE
[  144.143844] saa7134[1]: i2c xfer: < db ERROR: NO_DEVICE
[  144.144025] saa7134[1]: i2c xfer: < dd ERROR: NO_DEVICE
[  144.144207] saa7134[1]: i2c xfer: < df ERROR: NO_DEVICE
[  144.144384] saa7134[1]: i2c xfer: < e1 ERROR: NO_DEVICE
[  144.144561] saa7134[1]: i2c xfer: < e3 ERROR: NO_DEVICE
[  144.144738] saa7134[1]: i2c xfer: < e5 ERROR: NO_DEVICE
[  144.144915] saa7134[1]: i2c xfer: < e7 ERROR: NO_DEVICE
[  144.145099] saa7134[1]: i2c xfer: < e9 ERROR: NO_DEVICE
[  144.145277] saa7134[1]: i2c xfer: < eb ERROR: NO_DEVICE
[  144.145454] saa7134[1]: i2c xfer: < ed ERROR: NO_DEVICE
[  144.145631] saa7134[1]: i2c xfer: < ef ERROR: NO_DEVICE
[  144.145808] saa7134[1]: i2c xfer: < f1 ERROR: NO_DEVICE
[  144.145985] saa7134[1]: i2c xfer: < f3 ERROR: NO_DEVICE
[  144.146168] saa7134[1]: i2c xfer: < f5 ERROR: NO_DEVICE
[  144.146346] saa7134[1]: i2c xfer: < f7 ERROR: NO_DEVICE
[  144.146523] saa7134[1]: i2c xfer: < f9 ERROR: NO_DEVICE
[  144.146700] saa7134[1]: i2c xfer: < fb ERROR: NO_DEVICE
[  144.146876] saa7134[1]: i2c xfer: < fd ERROR: NO_DEVICE
[  144.147065] saa7134[1]: i2c xfer: < ff ERROR: NO_DEVICE
[  144.147209] saa7134[1]/ir: No I2C IR support for board 5d
[  144.149367] saa7134[1]: i2c xfer: < 84 ERROR: NO_DEVICE
[  144.149550] saa7134[1]: i2c xfer: < 86 ERROR: NO_DEVICE
[  144.149729] saa7134[1]: i2c xfer: < 94 ERROR: NO_DEVICE
[  144.149907] saa7134[1]: i2c xfer: < 96 ERROR: NO_DEVICE
[  144.150068] saa7134[1]: i2c xfer: < c0 ERROR: NO_DEVICE
[  144.150251] saa7134[1]: i2c xfer: < c2 ERROR: NO_DEVICE
[  144.150429] saa7134[1]: i2c xfer: < c4 ERROR: NO_DEVICE
[  144.150606] saa7134[1]: i2c xfer: < c6 ERROR: NO_DEVICE
[  144.150783] saa7134[1]: i2c xfer: < c8 ERROR: NO_DEVICE
[  144.150923] saa7134[1]/core: hwinit2
[  144.150937] saa7134[1]/audio: ctl_mute=3D1 automute=3D0 input=3D(null)=
  =3D>  mute=3D1 input=3D(null)
[  144.150944] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.151030] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.151263] saa7134[1]: registered device video1 [v4l2]
[  144.152294] saa7134[1]: registered device vbi1
[  144.153887] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.153896] video1: open (0)
[  144.153914] video1: VIDIOC_QUERYCAP
[  144.154035] video1: release
[  144.154562] dvb_init() allocating 1 frontend
[  144.160879] tda1004x: tda1004x_read_byte: reg=3D0x0
[  144.160888] saa7134[0]: i2c xfer: < 10 00 [fe quirk] < 11 =3D46 >
[  144.163058] tda1004x: tda1004x_read_byte: success reg=3D0x0, data=3D0x=
46, ret=3D2
[  144.163080] tda1004x: tda1004x_enable_tuner_i2c
[  144.163084] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x2, data=
=3D0x2
[  144.163088] tda1004x: tda1004x_read_byte: reg=3D0x7
[  144.165520] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.165528] vbi1: open (0)
[  144.163093] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D83 >
[  144.165547] vbi1: VIDIOC_QUERYCAP
[  144.165637] vbi1: release
[  144.165832]=20
[  144.165840] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
83, ret=3D2
[  144.165844] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x83
[  144.165850] saa7134[0]: i2c xfer: < 10 07 83 >
[  144.168043] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x83, ret=3D1
[  144.182018] saa7134 ALSA driver for DMA sound loaded
[  144.182076] saa7134[0]/alsa: saa7134[0] at 0xd8000000 irq 17 registere=
d as card -1
[  144.182868] saa7134[1]/alsa: saa7134[1] at 0xd8002000 irq 20 registere=
d as card -1
[  144.189037] saa7134[0]: i2c xfer: < c3 =3D38 >
[  144.191047] tda1004x: tda1004x_disable_tuner_i2c
[  144.191054] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x2, data=
=3D0x0
[  144.191058] tda1004x: tda1004x_read_byte: reg=3D0x7
[  144.191063] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D83 >
[  144.193038] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
83, ret=3D2
[  144.193043] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x81
[  144.193049] saa7134[0]: i2c xfer: < 10 07 81 >
[  144.195045] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x81, ret=3D1
[  144.195053] tuner-simple 6-0061: attaching existing instance
[  144.195058] tuner-simple 6-0061: type set to 63 (Philips FMD1216ME MK3=
 Hybrid Tuner)
[  144.195065] DVB: registering new adapter (saa7134[0])
[  144.195071] DVB: registering adapter 0 frontend 0 (Philips TDA10046H D=
VB-T)...
[  144.196146] tda1004x: tda10046_init
[  144.196152] tda1004x: tda10046_fwupload: 16MHz Xtal, reducing I2C spee=
d
[  144.196156] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x80
[  144.196162] saa7134[0]: i2c xfer: < 10 07 80 >
[  144.198082] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x80, ret=3D1
[  144.198088] tda1004x: tda1004x_write_mask: reg=3D0x3b, mask=3D0x1, dat=
a=3D0x0
[  144.198091] tda1004x: tda1004x_read_byte: reg=3D0x3b
[  144.198096] saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  144.200033] tda1004x: tda1004x_read_byte: success reg=3D0x3b, data=3D0=
xff, ret=3D2
[  144.200038] tda1004x: tda1004x_write_byteI: reg=3D0x3b, data=3D0xfe
[  144.200042] saa7134[0]: i2c xfer: < 10 3b fe >
[  144.202044] tda1004x: tda1004x_write_byteI: success reg=3D0x3b, data=3D=
0xfe, ret=3D1
[  144.213066] tda1004x: tda1004x_write_byteI: reg=3D0x2d, data=3D0xf0
[  144.213076] saa7134[0]: i2c xfer: < 10 2d f0 >
[  144.215259] tda1004x: tda1004x_write_byteI: success reg=3D0x2d, data=3D=
0xf0, ret=3D1
[  144.215264] tda1004x: setting up plls for 53MHz sampling clock
[  144.215268] tda1004x: tda1004x_write_byteI: reg=3D0x2f, data=3D0x8
[  144.215273] saa7134[0]: i2c xfer: < 10 2f 08 >
[  144.217070] tda1004x: tda1004x_write_byteI: success reg=3D0x2f, data=3D=
0x8, ret=3D1
[  144.217076] tda1004x: tda10046_init_plls: setting up PLLs for a 16 MHz=
 Xtal
[  144.217080] tda1004x: tda1004x_write_byteI: reg=3D0x30, data=3D0x3
[  144.217085] saa7134[0]: i2c xfer: < 10 30 03 >
[  144.219044] tda1004x: tda1004x_write_byteI: success reg=3D0x30, data=3D=
0x3, ret=3D1
[  144.219050] tda1004x: tda1004x_write_byteI: reg=3D0x3e, data=3D0x67
[  144.219056] saa7134[0]: i2c xfer: < 10 3e 67 >
[  144.221039] tda1004x: tda1004x_write_byteI: success reg=3D0x3e, data=3D=
0x67, ret=3D1
[  144.221045] tda1004x: tda1004x_write_byteI: reg=3D0x4d, data=3D0xd7
[  144.221050] saa7134[0]: i2c xfer: < 10 4d d7 >
[  144.223050] tda1004x: tda1004x_write_byteI: success reg=3D0x4d, data=3D=
0xd7, ret=3D1
[  144.223056] tda1004x: tda1004x_write_byteI: reg=3D0x4e, data=3D0x3f
[  144.223062] saa7134[0]: i2c xfer: < 10 4e 3f >
[  144.225041] tda1004x: tda1004x_write_byteI: success reg=3D0x4e, data=3D=
0x3f, ret=3D1
[  144.225047] tda1004x: tda1004x_write_buf: reg=3D0x31, len=3D0x5
[  144.225050] tda1004x: tda1004x_write_byteI: reg=3D0x31, data=3D0x5c
[  144.225055] saa7134[0]: i2c xfer: < 10 31 5c >
[  144.227051] tda1004x: tda1004x_write_byteI: success reg=3D0x31, data=3D=
0x5c, ret=3D1
[  144.227056] tda1004x: tda1004x_write_byteI: reg=3D0x32, data=3D0x32
[  144.227062] saa7134[0]: i2c xfer: < 10 32 32 >
[  144.229034] tda1004x: tda1004x_write_byteI: success reg=3D0x32, data=3D=
0x32, ret=3D1
[  144.229039] tda1004x: tda1004x_write_byteI: reg=3D0x33, data=3D0xc2
[  144.229044] saa7134[0]: i2c xfer: < 10 33 c2 >
[  144.231040] tda1004x: tda1004x_write_byteI: success reg=3D0x33, data=3D=
0xc2, ret=3D1
[  144.231045] tda1004x: tda1004x_write_byteI: reg=3D0x34, data=3D0x96
[  144.231051] saa7134[0]: i2c xfer: < 10 34 96 >
[  144.233066] tda1004x: tda1004x_write_byteI: success reg=3D0x34, data=3D=
0x96, ret=3D1
[  144.233072] tda1004x: tda1004x_write_byteI: reg=3D0x35, data=3D0x6d
[  144.233080] saa7134[0]: i2c xfer: < 10 35 6d >
[  144.235055] tda1004x: tda1004x_write_byteI: success reg=3D0x35, data=3D=
0x6d, ret=3D1
[  144.279512] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.279733] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.280278] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.280478] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.282928] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  144.301271] saa7134[1]/core: dmabits: task=3D0x00 ctrl=3D0x40 irq=3D0x=
3000000 split=3Dyes
[  144.322197] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.322419] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.322896] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.323158] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.325605] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]
[  144.340706] saa7134[0]/core: dmabits: task=3D0x00 ctrl=3D0x40 irq=3D0x=
3000000 split=3Dyes
[  144.356026] tda1004x: tda1004x_write_mask: reg=3D0x37, mask=3D0xc0, da=
ta=3D0x0
[  144.356032] tda1004x: tda1004x_read_byte: reg=3D0x37
[  144.356038] saa7134[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  144.358016] tda1004x: tda1004x_read_byte: success reg=3D0x37, data=3D0=
xf8, ret=3D2
[  144.358019] tda1004x: tda1004x_write_byteI: reg=3D0x37, data=3D0x38
[  144.358022] saa7134[0]: i2c xfer: < 10 37 38 >
[  144.360014] tda1004x: tda1004x_write_byteI: success reg=3D0x37, data=3D=
0x38, ret=3D1
[  144.360018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.360021] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.362014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.364012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.364016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.366014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.368012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.368015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.370014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.372012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.372016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.374014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.376012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.376016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.378014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.380012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.380016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.382014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.384022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.384028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.386015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.388012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.388016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.390014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.392012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.392016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.394014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.396012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.396016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.398014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.400012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.400016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.402014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.404012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.404016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.406014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.408012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.408016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.410014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.412012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.412016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.414014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.416012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.416016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.418014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.420012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.420016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.422014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.424012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.424016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.426014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.428012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.428016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.430014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.432012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.432016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.434014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.436012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.436016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.438014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.440012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.440016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.442014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.444012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.444016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.446014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.448012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.448016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.450014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.452012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.452015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.454019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.456012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.456016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.458014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.460012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.460016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.462014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.464012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.464016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.466014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.468012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.468016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.470014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.472012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.472016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.474014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.476012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.476016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.478014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.480012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.480016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.482014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.484012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.484016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.486014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.488012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.488015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.490014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.492012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.492016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.494014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.496012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.496016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.498014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.500012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.500016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.502014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.504012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.504016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.506014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.508012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.508016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.510014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.512012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.512016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.514014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.516012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.516016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.518014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.520012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.520016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.522014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.524012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.524016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.526014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.528012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.528015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.530014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.532012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.532015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.534014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.536012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.536016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.538014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.540012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.540016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.542014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.544019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.544026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.546015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.548012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.548016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.550014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.552012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.552016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.554014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.556012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.556016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.558014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.560012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.560016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.562014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.564012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.564016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.566014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.568012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.568016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.570014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.572012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.572016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.574014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.576017] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.576022] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.578014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.580012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.580015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.582014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.584012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.584015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.586014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.588012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.588016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.590014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.592012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.592016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.594013] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.596012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.596015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.598014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.600012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.600016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.602014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.604012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.604016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.606014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.608012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.608016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.610014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.612012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.612016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.614014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.616012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.616015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.618014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.620012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.620015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.622014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.624012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.624016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.626014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.628012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.628016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.630014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.632012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.632015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.634014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.636012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.636016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.638014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.640012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.640015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.642014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.644011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.644015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.646014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.648012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.648016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.650014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.652012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.652016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.654014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.656012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.656016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.658014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.660011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.660015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.662014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.664012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.664015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.666014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.668012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.668015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.670014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.672012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.672016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.674014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.676012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.676015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.678014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.680012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.680016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.682014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.684011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.684015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.686014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.688012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.688016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.690014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.692012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.692016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.694014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.696012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.696016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.698014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.700012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.700016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.702014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.704027] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.704033] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.706015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.708012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.708016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.710014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.712012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.712016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.714014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.716012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.716016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.718014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.720012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.720016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.722014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.724012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.724016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.726014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.728012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.728016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.730014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.732012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.732016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.734014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.736012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.736017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.738014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.740012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.740016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.742014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.744012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.744016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.746014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.748012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.748016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.750014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.752012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.752016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.754015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.756012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.756016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.758014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.760012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.760016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.762014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.764012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.764016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.766014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.768012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.768016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.770014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.772012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.772016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.774014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.776012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.776016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.778014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.780012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.780016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.782014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.784012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.784016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.786014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.788012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.788016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.790014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.792012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.792016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.794014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.796012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.796016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.798014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.800012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.800016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.802014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.804012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.804016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.806014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.808012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.808016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.810014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.812012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.812016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.814014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.816012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.816016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.818014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.820012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.820016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.822014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.824012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.824016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.826014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.828012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.828016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.830014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.832012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.832016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.834014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.836012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.836016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.838014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.840012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.840016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.842014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.844012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.844016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.846014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.848012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.848016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.850014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.852012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.852016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.854014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.856012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.856016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.858014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.860012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.860016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.862014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.864020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.864026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.866015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.868013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.868017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.870014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.872012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.872016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.874014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.876012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.876016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.878014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.880012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.880016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.882014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.884012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.884016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.886014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.888012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.888016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.890014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.892012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.892016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.894014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.896012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.896016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.898014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.900012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.900016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.902014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.904012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.904016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.906014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.908051] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.908058] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.910027] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.912013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.912018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.914015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.916012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.916016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.918017] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.920012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.920016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.922018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.924012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.924016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.926014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.928013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.928017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.930014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.932012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.932016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.934014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.936012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.936016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.938014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.940012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.940016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.942014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.944012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.944016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.946014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.948012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.948016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.950014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.952012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.952016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.954035] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.956018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.956023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.958022] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.960012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.960016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.962014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.964012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.964016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.966014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.968012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.968016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.970014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.972012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.972016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.974014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.976012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.976016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.978014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.980012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.980016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.982014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.984012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.984015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.986014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.988012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.988016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.990014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.992012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.992016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.994014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  144.996012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  144.996016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  144.998014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.000014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.000018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.002014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.004012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.004016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.006014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.008012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.008015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.010014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.012012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.012016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.014014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.016012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.016016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.018014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.020012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.020016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.022014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.024022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.024028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.026015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.028013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.028017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.030014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.032012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.032016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.034014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.036012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.036016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.038014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.040012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.040016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.042014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.044012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.044016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.046014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.048012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.048016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.050014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.052012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.052016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.054014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.056012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.056016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.058014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.060012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.060016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.062014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.064012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.064016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.066014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.068012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.068016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.070014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.072012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.072016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.074014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.076017] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.076022] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.078014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.080012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.080016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.082014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.084012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.084016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.086014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.088012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.088016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.090014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.092012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.092016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.094014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.096012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.096016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.098014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.100012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.100016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.102014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.104012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.104016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.106014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.108012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.108016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.110014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.112012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.112016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.114014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.116012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.116016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.118014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.120012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.120016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.122014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.124012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.124016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.126014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.128012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.128016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.130014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.132012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.132016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.134014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.136012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.136016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.138014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.140012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.140016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.142014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.144012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.144016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.146014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.148012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.148016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.150014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.152012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.152016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.154014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.156012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.156016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.158014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.160012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.160016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.162014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.164012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.164016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.166014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.168012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.168016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.170014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.172012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.172016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.174014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.176012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.176016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.178014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.180012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.180016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.182014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.184020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.184026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.186015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.188012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.188016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.190014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.192012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.192016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.194014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.196012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.196016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.198014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.200012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.200015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.202014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.204020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.204024] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.206014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.208012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.208016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.210013] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.212012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.212015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.214014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.216012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.216015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.218014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.220012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.220015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.222014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.224012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.224016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.226014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.228012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.228015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.230014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.232012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.232015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.234014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.236012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.236015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.238014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.240012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.240015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.242014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.244012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.244015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.246014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.248012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.248015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.250014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.252012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.252015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.254014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.256012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.256015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.258014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.260011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.260015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.262014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.264012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.264016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.266014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.268011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.268015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.270014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.272012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.272015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.274014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.276012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.276015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.278014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.280012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.280016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.282014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.284012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.284015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.286014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.288012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.288016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.290014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.292012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.292015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.294014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.296012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.296015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.298014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.300012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.300016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.302014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.304012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.304016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.306014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.308012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.308015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.310014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.312012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.312015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.314014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.316012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.316016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.318014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.320012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.320015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.322014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.324012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.324015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.326014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.328012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.328015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.330014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.332012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.332016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.334014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.336012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.336015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.338014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.340012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.340015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.342024] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.344020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.344026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.346014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.348012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.348016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.350014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.352012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.352015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.354014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.356011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.356015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.358014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.360011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.360015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.362014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.364011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.364015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.366014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.368012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.368015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.370014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.372012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.372015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.374014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.376012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.376015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.378014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.380012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.380016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.382014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.384012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.384015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.386014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.388012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.388015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.390014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.392012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.392016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.394014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.396012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.396015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.398014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.400012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.400015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.402014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.404012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.404015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.406014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.408012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.408016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.410014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.412012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.412015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.414014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.416012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.416015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.418014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.420012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.420015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.422014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.424012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.424015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.426014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.428012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.428016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.430014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.432012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.432015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.434014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.436011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.436015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.438014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.440012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.440016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.442014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.444012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.444015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.446014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.448011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.448015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.450014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.452011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.452015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.454021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.456012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.456016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.458014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.460011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.460015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.462014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.464012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.464015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.466014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.468012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.468015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.470014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.472012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.472015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.474014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.476011] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.476015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.478014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.480012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.480015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.482014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.484012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.484015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.486014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.488012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.488016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.490014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.492012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.492015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.494014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.496012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.496015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.498014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.500012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.500015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.502014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.504019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.504025] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.506015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.508020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.508025] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.510034] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.512014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.512020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.514015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.516012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.516016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.518025] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.520018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.520022] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.522015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.524012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.524016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.526014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.528013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.528018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.530014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.532012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.532016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.534014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.536012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.536016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.538014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.540012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.540015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.542489] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.544019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.544026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.546015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.548012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.548016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.550014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.552012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.552016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.554025] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.556014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.556018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.558014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.560012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.560016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.562014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.564012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.564016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.566014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.568012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.568016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.570026] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.572030] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.572039] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.574016] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.576019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.576024] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.578015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.580022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.580028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.582020] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.584012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.584017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.586014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.588012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.588016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.590014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.592012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.592016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.594014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.596012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.596016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.598014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.600012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.600016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.602014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.604012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.604016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.606014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.608012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.608016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.610014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.612012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.612015] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.614014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.616012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.616016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.618014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.620012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.620016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.622027] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.624014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.624020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.626015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.628012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.628016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.630014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.632012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.632016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.634018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.636012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.636016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.638014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.640012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.640016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.642014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.644018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.644023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.646014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.648012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.648016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.650027] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.652030] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.652040] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.654016] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.656012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.656016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.658014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.660025] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.660032] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.662019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.664021] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.664028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.666015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.668012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.668016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.670014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.672012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.672016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.674014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.676012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.676016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.678014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.680012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.680016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.682014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.684012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.684016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.686014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.688012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.688016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.690014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.692012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.692016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.694014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.696012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.696016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.698014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.700012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.700016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.702074] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.704023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.704028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.706023] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.708019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.708023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.710015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.712012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.712016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.714014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.716012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.716016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.718014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.720012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.720016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.722014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.724020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.724026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.726018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.728013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.728017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.730014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.732012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.732016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.734014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.736023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.736029] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.738016] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.740012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.740016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.742014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.744012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.744016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.746014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.748012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.748016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.750014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.752033] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.752042] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.754026] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.756014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.756019] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.758014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.760016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.760021] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.762021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.764019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.764023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.766021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.768012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.768016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.770014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.772012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.772016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.774014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.776012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.776016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.778014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.780012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.780016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.782014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.784012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.784016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.786014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.788012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.788016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.790014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.792012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.792016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.794014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.796012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.796016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.798014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.800022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.800029] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.802017] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.804013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.804017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.806014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.808012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.808016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.810015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.812015] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.812019] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.814014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.816012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.816016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.818014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.820012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.820016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.822014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.824021] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.824028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.826016] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.828029] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.828038] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.830041] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.832023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.832028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.834019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.836016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.836020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.838023] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.840022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.840026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.842019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.844018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.844022] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.846018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.848016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.848020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.850018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.852016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.852020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.854018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.856016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.856020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.858020] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.860016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.860020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.862018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.864016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.864020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.866018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.868016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.868020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.870018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.872015] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.872019] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.874017] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.876015] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.876019] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.878017] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.880023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.880030] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.882019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.884016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.884020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.886018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.888016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.888020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.890028] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.892014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.892018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.894019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.896016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.896020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.898018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.900016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.900020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.902018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.904016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.904020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.906036] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.908036] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.908046] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.910023] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.912016] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.912021] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.914018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.916022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.916028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.918021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.920012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.920017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.922014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.924012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.924016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.926014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.928012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.928016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.930014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.932012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.932016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.934014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.936023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.936029] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.938015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.940012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.940016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.942014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.944012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.944016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.946014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.948012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.948016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.950014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.952012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.952016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.954033] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.956018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.956023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.958020] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.960012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.960016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.962014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.964012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.964016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.966014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.968012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.968016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.970014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.972012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.972016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.974014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.976012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.976016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.978067] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.980033] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.980041] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.982033] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.984041] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.984048] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.986026] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.988018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.988025] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.990019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.992893] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.992899] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.995028] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  145.997032] tda1004x: tda1004x_read_byte: reg=3D0x6
[  145.997040] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  145.999031] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.001022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.001031] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.003021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.005012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.005017] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.007019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.009028] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.009036] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.011029] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.013019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.013025] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.015031] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.017018] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.017023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.019021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.021025] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.021032] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.023034] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.026160] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.026168] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.029104] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.031014] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.031021] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.033019] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.035015] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.035020] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.037014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.039036] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.039041] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.041014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.043029] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.043035] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.045015] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.047012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.047016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.049014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.051012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.051016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.053014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.055075] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.055081] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.057020] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.059020] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.059026] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.061023] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.063022] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.063028] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.065027] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.068998] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.069034] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.071030] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.073032] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.073041] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.075017] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.077013] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.077018] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.079018] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.081012] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.081016] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.083025] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.085026] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.085031] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.087029] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.089025] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.089030] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.091026] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.093242] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.093250] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.096039] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.098023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.098030] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.100550] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.102023] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.102029] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.104025] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.106017] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.106024] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.108014] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.110017] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.110023] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.112021] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.114019] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.114024] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.119024] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.121031] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.121038] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  146.123030] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
80, ret=3D2
[  146.125026] tda1004x: tda1004x_read_byte: reg=3D0x6
[  146.125032] saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  146.127037] tda1004x: tda1004x_read_byte: success reg=3D0x6, data=3D0x=
b0, ret=3D2
[  146.127043] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x10, dat=
a=3D0x0
[  146.127046] tda1004x: tda1004x_read_byte: reg=3D0x7
[  146.127051] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  146.131665] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
80, ret=3D2
[  146.131670] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x80
[  146.131676] saa7134[0]: i2c xfer: < 10 07 80 >
[  146.134028] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x80, ret=3D1
[  146.134033] tda1004x: tda1004x_write_byteI: reg=3D0x11, data=3D0x67
[  146.134038] saa7134[0]: i2c xfer: < 10 11 67 >
[  146.136025] tda1004x: tda1004x_write_byteI: success reg=3D0x11, data=3D=
0x67, ret=3D1
[  146.136029] tda1004x: tda1004x_read_byte: reg=3D0x13
[  146.136033] saa7134[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  146.138018] tda1004x: tda1004x_read_byte: success reg=3D0x13, data=3D0=
x67, ret=3D2
[  146.138022] tda1004x: tda1004x_read_byte: reg=3D0x14
[  146.138025] saa7134[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D26 >
[  146.140027] tda1004x: tda1004x_read_byte: success reg=3D0x14, data=3D0=
x26, ret=3D2
[  146.140031] tda1004x: found firmware revision 26 -- ok
[  146.140035] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x20, dat=
a=3D0x0
[  146.140038] tda1004x: tda1004x_read_byte: reg=3D0x7
[  146.140042] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  146.142025] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
80, ret=3D2
[  146.142028] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x80
[  146.142031] saa7134[0]: i2c xfer: < 10 07 80 >
[  146.144040] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x80, ret=3D1
[  146.144045] tda1004x: tda1004x_write_byteI: reg=3D0x1, data=3D0x87
[  146.144049] saa7134[0]: i2c xfer: < 10 01 87 >
[  146.146020] tda1004x: tda1004x_write_byteI: success reg=3D0x1, data=3D=
0x87, ret=3D1
[  146.146023] tda1004x: tda1004x_write_byteI: reg=3D0x16, data=3D0x88
[  146.146026] saa7134[0]: i2c xfer: < 10 16 88 >
[  146.148029] tda1004x: tda1004x_write_byteI: success reg=3D0x16, data=3D=
0x88, ret=3D1
[  146.148034] tda1004x: tda1004x_write_byteI: reg=3D0x43, data=3D0xa
[  146.148038] saa7134[0]: i2c xfer: < 10 43 0a >
[  146.150021] tda1004x: tda1004x_write_byteI: success reg=3D0x43, data=3D=
0xa, ret=3D1
[  146.150025] tda1004x: tda1004x_write_mask: reg=3D0x3d, mask=3D0xf0, da=
ta=3D0x60
[  146.150028] tda1004x: tda1004x_read_byte: reg=3D0x3d
[  146.150032] saa7134[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D60 >
[  146.152023] tda1004x: tda1004x_read_byte: success reg=3D0x3d, data=3D0=
x60, ret=3D2
[  146.152027] tda1004x: tda1004x_write_byteI: reg=3D0x3d, data=3D0x60
[  146.152031] saa7134[0]: i2c xfer: < 10 3d 60 >
[  146.154021] tda1004x: tda1004x_write_byteI: success reg=3D0x3d, data=3D=
0x60, ret=3D1
[  146.154026] tda1004x: tda1004x_write_mask: reg=3D0x3b, mask=3D0xc0, da=
ta=3D0x40
[  146.154029] tda1004x: tda1004x_read_byte: reg=3D0x3b
[  146.154033] saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  146.156025] tda1004x: tda1004x_read_byte: success reg=3D0x3b, data=3D0=
xff, ret=3D2
[  146.156029] tda1004x: tda1004x_write_byteI: reg=3D0x3b, data=3D0x7f
[  146.156034] saa7134[0]: i2c xfer: < 10 3b 7f >
[  146.158024] tda1004x: tda1004x_write_byteI: success reg=3D0x3b, data=3D=
0x7f, ret=3D1
[  146.158029] tda1004x: tda1004x_write_mask: reg=3D0x3a, mask=3D0x80, da=
ta=3D0x0
[  146.158032] tda1004x: tda1004x_read_byte: reg=3D0x3a
[  146.158036] saa7134[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  146.161257] tda1004x: tda1004x_read_byte: success reg=3D0x3a, data=3D0=
x0, ret=3D2
[  146.161262] tda1004x: tda1004x_write_byteI: reg=3D0x3a, data=3D0x0
[  146.161267] saa7134[0]: i2c xfer: < 10 3a 00 >
[  146.163029] tda1004x: tda1004x_write_byteI: success reg=3D0x3a, data=3D=
0x0, ret=3D1
[  146.163034] tda1004x: tda1004x_write_byteI: reg=3D0x37, data=3D0x38
[  146.163039] saa7134[0]: i2c xfer: < 10 37 38 >
[  146.165029] tda1004x: tda1004x_write_byteI: success reg=3D0x37, data=3D=
0x38, ret=3D1
[  146.165035] tda1004x: tda1004x_write_mask: reg=3D0x3b, mask=3D0x3e, da=
ta=3D0x38
[  146.165038] tda1004x: tda1004x_read_byte: reg=3D0x3b
[  146.165042] saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  146.167027] tda1004x: tda1004x_read_byte: success reg=3D0x3b, data=3D0=
x7f, ret=3D2
[  146.167031] tda1004x: tda1004x_write_byteI: reg=3D0x3b, data=3D0x79
[  146.167035] saa7134[0]: i2c xfer: < 10 3b 79 >
[  146.169025] tda1004x: tda1004x_write_byteI: success reg=3D0x3b, data=3D=
0x79, ret=3D1
[  146.169030] tda1004x: tda1004x_write_byteI: reg=3D0x47, data=3D0x0
[  146.169035] saa7134[0]: i2c xfer: < 10 47 00 >
[  146.171022] tda1004x: tda1004x_write_byteI: success reg=3D0x47, data=3D=
0x0, ret=3D1
[  146.171025] tda1004x: tda1004x_write_byteI: reg=3D0x48, data=3D0xff
[  146.171028] saa7134[0]: i2c xfer: < 10 48 ff >
[  146.173023] tda1004x: tda1004x_write_byteI: success reg=3D0x48, data=3D=
0xff, ret=3D1
[  146.173027] tda1004x: tda1004x_write_byteI: reg=3D0x49, data=3D0x0
[  146.173031] saa7134[0]: i2c xfer: < 10 49 00 >
[  146.175014] tda1004x: tda1004x_write_byteI: success reg=3D0x49, data=3D=
0x0, ret=3D1
[  146.175017] tda1004x: tda1004x_write_byteI: reg=3D0x4a, data=3D0xff
[  146.175020] saa7134[0]: i2c xfer: < 10 4a ff >
[  146.177054] tda1004x: tda1004x_write_byteI: success reg=3D0x4a, data=3D=
0xff, ret=3D1
[  146.177059] tda1004x: tda1004x_write_byteI: reg=3D0x46, data=3D0x12
[  146.177062] saa7134[0]: i2c xfer: < 10 46 12 >
[  146.179048] tda1004x: tda1004x_write_byteI: success reg=3D0x46, data=3D=
0x12, ret=3D1
[  146.179052] tda1004x: tda1004x_write_byteI: reg=3D0x4f, data=3D0x1a
[  146.179056] saa7134[0]: i2c xfer: < 10 4f 1a >
[  146.181048] tda1004x: tda1004x_write_byteI: success reg=3D0x4f, data=3D=
0x1a, ret=3D1
[  146.181053] tda1004x: tda1004x_write_byteI: reg=3D0x1e, data=3D0x7
[  146.181057] saa7134[0]: i2c xfer: < 10 1e 07 >
[  146.183032] tda1004x: tda1004x_write_byteI: success reg=3D0x1e, data=3D=
0x7, ret=3D1
[  146.183037] tda1004x: tda1004x_write_byteI: reg=3D0x1f, data=3D0xc0
[  146.183041] saa7134[0]: i2c xfer: < 10 1f c0 >
[  146.185034] tda1004x: tda1004x_write_byteI: success reg=3D0x1f, data=3D=
0xc0, ret=3D1
[  146.185040] tda1004x: tda1004x_write_byteI: reg=3D0x3b, data=3D0xff
[  146.185044] saa7134[0]: i2c xfer: < 10 3b ff >
[  146.187027] tda1004x: tda1004x_write_byteI: success reg=3D0x3b, data=3D=
0xff, ret=3D1
[  146.187032] tda1004x: tda1004x_write_mask: reg=3D0x37, mask=3D0xc0, da=
ta=3D0xc0
[  146.187035] tda1004x: tda1004x_read_byte: reg=3D0x37
[  146.187039] saa7134[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  146.189028] tda1004x: tda1004x_read_byte: success reg=3D0x37, data=3D0=
x38, ret=3D2
[  146.189033] tda1004x: tda1004x_write_byteI: reg=3D0x37, data=3D0xf8
[  146.189037] saa7134[0]: i2c xfer: < 10 37 f8 >
[  146.191030] tda1004x: tda1004x_write_byteI: success reg=3D0x37, data=3D=
0xf8, ret=3D1
[  146.191035] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x1, data=
=3D0x1
[  146.191038] tda1004x: tda1004x_read_byte: reg=3D0x7
[  146.191043] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  146.193470] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
80, ret=3D2
[  146.193475] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x81
[  146.193480] saa7134[0]: i2c xfer: < 10 07 81 >
[  146.195030] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x81, ret=3D1
[  146.195037] tda1004x: tda1004x_enable_tuner_i2c
[  146.195041] tda1004x: tda1004x_write_mask: reg=3D0x7, mask=3D0x2, data=
=3D0x2
[  146.195043] tda1004x: tda1004x_read_byte: reg=3D0x7
[  146.195048] saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D81 >
[  146.197047] tda1004x: tda1004x_read_byte: success reg=3D0x7, data=3D0x=
81, ret=3D2
[  146.197051] tda1004x: tda1004x_write_byteI: reg=3D0x7, data=3D0x83
[  146.197056] saa7134[0]: i2c xfer: < 10 07 83 >
[  146.199047] tda1004x: tda1004x_write_byteI: success reg=3D0x7, data=3D=
0x83, ret=3D1
[  146.220028] saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[  146.222027] dvb_init() allocating 1 frontend
[  146.225059] tda10086: tda10086_attach
[  146.225108] saa7134[1]: i2c xfer: < 1c 1e [fe quirk] < 1d =3De1 >
[  146.230602] tda10086: tda10086_i2c_gate_ctrl
[  146.230612] saa7134[1]: i2c xfer: < 1c 00 [fe quirk] < 1d =3D09 >
[  146.233021] saa7134[1]: i2c xfer: < 1c 00 19 >
[  146.235037] saa7134[1]: i2c xfer: < c1 =3D7f >
[  146.237021] tda10086: tda10086_i2c_gate_ctrl
[  146.237025] saa7134[1]: i2c xfer: < 1c 00 [fe quirk] < 1d =3D19 >
[  146.239015] saa7134[1]: i2c xfer: < 1c 00 09 >
[  146.241017] tda10086: tda10086_i2c_gate_ctrl
[  146.241021] saa7134[1]: i2c xfer: < 1c 00 [fe quirk] < 1d =3D09 >
[  146.243018] saa7134[1]: i2c xfer: < 1c 00 19 >
[  146.247839] saa7134[1]: i2c xfer: < 10 20 >
[  146.250028] tda10086: tda10086_i2c_gate_ctrl
[  146.250034] saa7134[1]: i2c xfer: < 1c 00 [fe quirk] < 1d =3D19 >
[  146.252022] saa7134[1]: i2c xfer: < 1c 00 09 >
[  146.254016] DVB: registering new adapter (saa7134[1])
[  146.254021] DVB: registering adapter 1 frontend 0 (Philips TDA10086 DV=
B-S)...
[  146.255610] tda10086: tda10086_init
[  146.255618] saa7134[1]: i2c xfer: < 1c 00 00 >
[  146.269037] saa7134[1]: i2c xfer: < 1c 01 94 >
[  146.271042] saa7134[1]: i2c xfer: < 1c 02 35 >
[  146.273028] saa7134[1]: i2c xfer: < 1c 03 e4 >
[  146.275029] saa7134[1]: i2c xfer: < 1c 04 43 >
[  146.277024] saa7134[1]: i2c xfer: < 1c 0c 0c >
[  146.279025] saa7134[1]: i2c xfer: < 1c 1b b0 >
[  146.281024] saa7134[1]: i2c xfer: < 1c 20 89 >
[  146.283018] saa7134[1]: i2c xfer: < 1c 30 04 >
[  146.285018] saa7134[1]: i2c xfer: < 1c 32 00 >
[  146.287020] saa7134[1]: i2c xfer: < 1c 31 56 >
[  146.289018] saa7134[1]: i2c xfer: < 1c 55 2c >
[  146.291022] saa7134[1]: i2c xfer: < 1c 3a 17 >
[  146.293018] saa7134[1]: i2c xfer: < 1c 3b 00 >
[  146.295018] saa7134[1]: i2c xfer: < 1c 55 [fe quirk] < 1d =3D2c >
[  146.297018] saa7134[1]: i2c xfer: < 1c 55 0c >
[  146.299018] saa7134[1]: i2c xfer: < 1c 11 81 >
[  146.301018] saa7134[1]: i2c xfer: < 1c 12 81 >
[  146.303018] saa7134[1]: i2c xfer: < 1c 19 40 >
[  146.305019] saa7134[1]: i2c xfer: < 1c 56 80 >
[  146.307018] saa7134[1]: i2c xfer: < 1c 57 08 >
[  146.309018] saa7134[1]: i2c xfer: < 1c 10 2a >
[  146.311018] saa7134[1]: i2c xfer: < 1c 58 61 >
[  146.313017] saa7134[1]: i2c xfer: < 1c 58 [fe quirk] < 1d =3D61 >
[  146.315017] saa7134[1]: i2c xfer: < 1c 58 60 >
[  146.317017] saa7134[1]: i2c xfer: < 1c 05 0b >
[  146.319017] saa7134[1]: i2c xfer: < 1c 37 63 >
[  146.321017] saa7134[1]: i2c xfer: < 1c 3f 0a >
[  146.323017] saa7134[1]: i2c xfer: < 1c 40 64 >
[  146.325017] saa7134[1]: i2c xfer: < 1c 41 4f >
[  146.327017] saa7134[1]: i2c xfer: < 1c 42 43 >
[  146.329017] saa7134[1]: i2c xfer: < 1c 1a 11 >
[  146.331017] saa7134[1]: i2c xfer: < 1c 3d 80 >
[  146.333017] saa7134[1]: i2c xfer: < 1c 36 80 >
[  146.335017] saa7134[1]: i2c xfer: < 1c 34 78 >
[  146.337017] saa7134[1]: i2c xfer: < 1c 35 00 >
[  146.339017] tda10086: tda10086_sleep
[  146.339021] saa7134[1]: i2c xfer: < 1c 00 [fe quirk] < 1d =3D01 >
[  146.341017] saa7134[1]: i2c xfer: < 1c 00 09 >
[  149.309176] saa7134[1]/core: dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x=
0 split=3Dyes
[  149.309314] saa7134[1]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3D(null)]
[  149.344612] saa7134[0]/core: dmabits: task=3D0x00 ctrl=3D0x00 irq=3D0x=
0 split=3Dyes
[  149.344733] saa7134[0]/audio: mute/input: nothing to do [mute=3D1,inpu=
t=3Dmute]

--------------070906080407050901010501--
