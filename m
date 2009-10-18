Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:42709 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZJRUIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2009 16:08:15 -0400
Received: by qyk32 with SMTP id 32so2593780qyk.4
        for <linux-media@vger.kernel.org>; Sun, 18 Oct 2009 13:08:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <156a113e0910151156l75ec4d3dma073f7ec67682c47@mail.gmail.com>
References: <156a113e0910130955w428d536i7fc3ac8355293030@mail.gmail.com>
	 <156a113e0910140541y1fc5025fx3ce84352e3fdf5a2@mail.gmail.com>
	 <156a113e0910141524m348b7fa6u807cf11324328c60@mail.gmail.com>
	 <156a113e0910151156l75ec4d3dma073f7ec67682c47@mail.gmail.com>
Date: Sun, 18 Oct 2009 22:08:19 +0200
Message-ID: <156a113e0910181308y5c11d402u482a09674f5a1c3f@mail.gmail.com>
Subject: Re: More about "Winfast TV USB Deluxe"
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636418603b84fa304763b3067
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001636418603b84fa304763b3067
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi again.

Started to look at getting the remote to work also.
I used "Terratec Cinergy 250 USB" as template and added the needed
information in:

em28xx-cards.c
em28xx.h
em28xx-input.c
ir-common.h
ir-keymaps.c

Compiled it with: make, make install and rebooted.

But it seems that I've missed something since ir-kbd-i2c loads, but it
doesn't seem to look for any ir devices.
Tried loading ir-kbd-i2c with debug=3D1, but not even an error message
shows up in dmesg, it looks just as before.

What I've added in the files is in a text file attachment.

The keymap I added is just garabage and the polling structure in
em28xx is probably wrong too.
But I have to start somewhere.....

/Magnus



2009/10/15 Magnus Alm <magnus.alm@gmail.com>:
> yay
>
> [ 2478.224015] tda9887 4-0043: configure for: Radio Stereo
> [ 2478.224017] tda9887 4-0043: writing: b=3D0xcc c=3D0x90 e=3D0x3d
>
> /Magnus
>
> 2009/10/15 Magnus Alm <magnus.alm@gmail.com>:
>> Strange, but changeing the tvaudio_addr =3D 0xb0 to 88, (half of the
>> decimal value of b0) made tvaudio find my tda9874.
>>
>> [ 1186.725140] tvaudio: TV audio decoder + audio/video mux driver
>> [ 1186.725142] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
>> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
>> pic16c54 (PV951), ta8874z
>> [ 1186.725151] tvaudio 4-0058: chip found @ 0xb0
>> [ 1186.736444] tvaudio 4-0058: chip_read2: reg254=3D0x11
>> [ 1186.749704] tvaudio 4-0058: chip_read2: reg255=3D0x2
>> [ 1186.749708] tvaudio 4-0058: tda9874a_checkit(): DIC=3D0x11, SIC=3D0x2=
.
>> [ 1186.749710] tvaudio 4-0058: found tda9874a.
>> [ 1186.749712] tvaudio 4-0058: tda9874h/a/ah found @ 0xb0 (em28xx #0)
>> [ 1186.749714] tvaudio 4-0058: matches:.
>> [ 1186.749716] tvaudio 4-0058: chip_write: reg0=3D0x0
>> [ 1186.760012] tvaudio 4-0058: chip_write: reg1=3D0xc0
>> [ 1186.772014] tvaudio 4-0058: chip_write: reg2=3D0x2
>> [ 1186.784013] tvaudio 4-0058: chip_write: reg11=3D0x80
>> [ 1186.796010] tvaudio 4-0058: chip_write: reg12=3D0x0
>> [ 1186.808013] tvaudio 4-0058: chip_write: reg13=3D0x0
>> [ 1186.820012] tvaudio 4-0058: chip_write: reg14=3D0x1
>> [ 1186.832015] tvaudio 4-0058: chip_write: reg15=3D0x0
>> [ 1186.844012] tvaudio 4-0058: chip_write: reg16=3D0x14
>> [ 1186.856018] tvaudio 4-0058: chip_write: reg17=3D0x50
>> [ 1186.868011] tvaudio 4-0058: chip_write: reg18=3D0xf9
>> [ 1186.880745] tvaudio 4-0058: chip_write: reg19=3D0x80
>> [ 1186.892347] tvaudio 4-0058: chip_write: reg20=3D0x80
>> [ 1186.904015] tvaudio 4-0058: chip_write: reg24=3D0x80
>> [ 1186.916011] tvaudio 4-0058: chip_write: reg255=3D0x0
>> [ 1186.928021] tvaudio 4-0058: tda9874a_setup(): A2, B/G [0x00].
>> [ 1186.928091] tvaudio 4-0058: thread started
>>
>> Now I probably need to set some gpio's too....
>>
>> /Magnus
>>
>> 2009/10/14 Magnus Alm <magnus.alm@gmail.com>:
>>> Loaded em28xx with i2c_scan and i2c_debug and tvaudio with tda9874a
>>> option and debug.
>>>
>>> sudo modprobe -v em28xx i2c_scan=3D1 i2c_debug=3D1
>>> sudo modprobe -v tvaudio tda9874a=3D1 debug=3D1
>>>
>>> And got this ouput:
>>>
>>> [91083.588182] em28xx #0: found i2c device @ 0x30 [???]
>>> [91083.590179] em28xx #0: found i2c device @ 0x3e [???]
>>> [91083.590804] em28xx #0: found i2c device @ 0x42 [???]
>>> [91083.600308] em28xx #0: found i2c device @ 0x86 [tda9887]
>>> [91083.603805] em28xx #0: found i2c device @ 0xa0 [eeprom]
>>> [91083.606183] em28xx #0: found i2c device @ 0xb0 [tda9874]
>>> [91083.608808] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
>>> [91083.617682] em28xx #0: Identified as Leadtek Winfast USB II Deluxe (=
card=3D28)
>>> [91083.617684] em28xx #0:
>>> [91083.617684]
>>> [91083.617687] em28xx #0: The support for this board weren't valid yet.
>>> [91083.617688] em28xx #0: Please send a report of having this working
>>> [91083.617690] em28xx #0: not to V4L mailing list (and/or to other addr=
esses)
>>> [91083.617691]
>>> [91083.980702] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
>>> (em28xx #0)
>>> [91086.173114] tvaudio: TV audio decoder + audio/video mux driver
>>> [91086.173116] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
>>> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
>>> pic16c54 (PV951), ta8874z
>>> [91086.173125] tvaudio 4-00b0: chip found @ 0x160
>>> [91086.173127] tvaudio 4-00b0: no matching chip description found
>>> [91086.173131] tvaudio: probe of 4-00b0 failed with error -5
>>>
>>>
>>> It seems to be a tda9874 there -> em28xx #0: found i2c device @ 0xb0 [t=
da9874]
>>>
>>> But does tvaudio stop @ 0x160 (decimal value of 0xa0 rigth? ) and
>>> doesn't look further?
>>> I mean does tvaudio find my boards eeprom, cant talk to it and gives up=
?
>>>
>>>
>>> /Magnus
>>>
>>>
>>> 2009/10/13 Magnus Alm <magnus.alm@gmail.com>:
>>>> Hi!
>>>>
>>>> Thanks to Devin's moral support I =A0now have sound in television. ;-)
>>>>
>>>> Thanks!!
>>>>
>>>> I pooked around some more managed to get radio to function with these =
settings:
>>>>
>>>> [EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE] =3D {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =3D "Leadtek Winf=
ast USB II Deluxe",
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.valid =A0 =A0 =A0 =A0=3D EM28XX_BOARD_=
NOT_VALIDATED,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.tuner_type =A0 =3D TUNER_PHILIPS_FM121=
6ME_MK3,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.tda9887_conf =3D TDA9887_PRESENT |
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TDA9887=
_PORT1_ACTIVE,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.decoder =A0 =A0 =A0=3D EM28XX_SAA711X,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.input =A0 =A0 =A0 =A0=3D { {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.type =A0 =A0 =3D EM28X=
X_VMUX_TELEVISION,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.vmux =A0 =A0 =3D SAA71=
15_COMPOSITE4,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.amux =A0 =A0 =3D EM28X=
X_AMUX_AUX,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}, {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.type =A0 =A0 =3D EM28X=
X_VMUX_COMPOSITE1,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.vmux =A0 =A0 =3D SAA71=
15_COMPOSITE5,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.amux =A0 =A0 =3D EM28X=
X_AMUX_LINE_IN,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}, {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.type =A0 =A0 =3D EM28X=
X_VMUX_SVIDEO,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.vmux =A0 =A0 =3D SAA71=
15_SVIDEO3,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.amux =A0 =A0 =3D EM28X=
X_AMUX_LINE_IN,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} },
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.radio =A0 =A0=3D {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.type =A0 =A0 =3D EM28X=
X_RADIO,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.amux =A0 =A0 =3D EM28X=
X_AMUX_AUX,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>> =A0 =A0 =A0 =A0},
>>>>
>>>> I tested with different settings on tda9887 and modprobe "tda9887
>>>> port1=3D1" seemed to work be best.
>>>>
>>>> One odd thing when the modules is load is this:
>>>>
>>>> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
>>>> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
>>>> [15680.473089] tda9887 4-0043: creating new instance
>>>> [15680.473091] tda9887 4-0043: tda988[5/6/7] found
>>>> [15680.485719] tuner 4-0061: chip found @ 0xc2 (em28xx #0)
>>>> [15680.486169] tuner-simple 4-0000: unable to probe Alps TSBE1,
>>>> proceeding anyway. =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0<-- What is that?
>>>> [15680.486171] tuner-simple 4-0000: creating new instance
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 <--
>>>> [15680.486174] tuner-simple 4-0000: type set to 10 (Alps TSBE1)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<--
>>>> [15680.496562] tuner-simple 4-0061: creating new instance
>>>> [15680.496566] tuner-simple 4-0061: type set to 38 (Philips PAL/SECAM
>>>> multi (FM1216ME MK3))
>>>>
>>>>
>>>> Another question, my box has a tda9874ah chip and if =A0understand the
>>>> data sheet it gives support for stereo (even Nicam if that is still
>>>> used anymore.).
>>>> So I tried to configure my box the same way as
>>>> [EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU] by adding these lines:
>>>>
>>>> .tvaudio_addr =3D 0xb0, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 <---- address of
>>>> tda9874 according to ic2-addr.h
>>>> .adecoder =A0 =A0 =3D EM28XX_TVAUDIO,
>>>>
>>>> But it didnt work, got the following message when I plugged it in:
>>>>
>>>> [15677.928972] em28xx #0: Please send a report of having this working
>>>> [15677.928974] em28xx #0: not to V4L mailing list (and/or to other add=
resses)
>>>> [15677.928975]
>>>> [15678.288360] saa7115 4-0021: saa7114 found (1f7114d0e000000) @ 0x42
>>>> (em28xx #0)
>>>> [15680.457094] tvaudio: TV audio decoder + audio/video mux driver
>>>> [15680.457097] tvaudio: known chips: tda9840, tda9873h, tda9874h/a/ah,
>>>> tda9875, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425,
>>>> pic16c54 (PV951), ta8874z
>>>> [15680.457105] tvaudio 4-00b0: chip found @ 0x160
>>>> [15680.457107] tvaudio 4-00b0: no matching chip description found
>>>> [15680.457111] tvaudio: probe of 4-00b0 failed with error -5
>>>> [15680.459343] tuner 4-0000: chip found @ 0x0 (em28xx #0)
>>>> [15680.473017] tuner 4-0043: chip found @ 0x86 (em28xx #0)
>>>> [15680.473089] tda9887 4-0043: creating new instance
>>>>
>>>>
>>>> It might be so that my box is not wired to fully utilize the chip or I
>>>> did something wrong.
>>>>
>>>>
>>>> /Magnus
>>>>
>>>
>>
>

--001636418603b84fa304763b3067
Content-Type: text/plain; charset=US-ASCII; name="trying to use the remote.txt"
Content-Disposition: attachment; filename="trying to use the remote.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0y8ahsa0

ICAgICAgICAgICAgICAgIFtFTTI4MjBfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1VTQklJX0RFTFVY
RV0gPSB7CgkJLm5hbWUgICAgICAgICA9ICJMZWFkdGVrIFdpbmZhc3QgVVNCIElJIERlbHV4ZSIs
CgkJLnZhbGlkICAgICAgICA9IEVNMjhYWF9CT0FSRF9OT1RfVkFMSURBVEVELAoJCS50dW5lcl90
eXBlICAgPSBUVU5FUl9QSElMSVBTX0ZNMTIxNk1FX01LMywKICAgICAgICAgICAgICAgIC5oYXNf
aXJfaTJjICAgPSAxLAogICAgICAgICAgICAgICAgLnR2YXVkaW9fYWRkciA9IDB4NTgsCiAgICAg
ICAgICAgICAgICAudGRhOTg4N19jb25mID0gVERBOTg4N19QUkVTRU5UIHwKCQkJCVREQTk4ODdf
UE9SVDJfQUNUSVZFfAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFREQTk4ODdfUVNT
LAogICAgICAgICAgICAgICAgLmRlY29kZXIgICAgICA9IEVNMjhYWF9TQUE3MTFYLAogICAgICAg
ICAgICAgICAgLmFkZWNvZGVyICAgICA9IEVNMjhYWF9UVkFVRElPLAogICAgICAgICAgICAgICAg
LmlucHV0ICAgICAgICA9IHsgewoJCQkudHlwZSAgICAgPSBFTTI4WFhfVk1VWF9URUxFVklTSU9O
LAoJCQkudm11eCAgICAgPSBTQUE3MTE1X0NPTVBPU0lURTQsCgkJCS5hbXV4ICAgICA9IEVNMjhY
WF9BTVVYX0FVWCwKICAJCX0sIHsKCQkJLnR5cGUgICAgID0gRU0yOFhYX1ZNVVhfQ09NUE9TSVRF
MSwKCQkJLnZtdXggICAgID0gU0FBNzExNV9DT01QT1NJVEU1LAoJCQkuYW11eCAgICAgPSBFTTI4
WFhfQU1VWF9MSU5FX0lOLAoJCX0sIHsKCQkJLnR5cGUgICAgID0gRU0yOFhYX1ZNVVhfU1ZJREVP
LAoJCQkudm11eCAgICAgPSBTQUE3MTE1X1NWSURFTzMsCgkJCS5hbXV4ICAgICA9IEVNMjhYWF9B
TVVYX0xJTkVfSU4sCgkJfSB9LAogICAgICAgICAgICAgICAgICAgICAgICAucmFkaW8JICA9IHsK
CQkJLnR5cGUgICAgID0gRU0yOFhYX1JBRElPLAoJCQkuYW11eCAgICAgPSBFTTI4WFhfQU1VWF9B
VVgsCiAgICAgICAgICAgICAgICB9CiAgICAgICAgfSwKCgoKCWNhc2UgRU0yODIwX0JPQVJEX0xF
QURURUtfV0lORkFTVF9VU0JJSV9ERUxVWEU6CiNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPCBLRVJO
RUxfVkVSU0lPTigyLCA2LCAzMCkKCQlpci0+aXJfY29kZXMgPSAmaXJfY29kZXNfd2luZmFzdF9k
ZWx1eGVfdGFibGU7CgkJaXItPmdldF9rZXkgPSBlbTI4eHhfZ2V0X2tleV93aW5mYXN0X2RlbHV4
ZTsKCQlzbnByaW50Zihpci0+bmFtZSwgc2l6ZW9mKGlyLT5uYW1lKSwKCQkJICJpMmMgSVIgKEVN
Mjh4eCBXaW5mYXN0IFVTQiBJSSBEZWx1eGUpIik7CiNlbHNlCgkJZGV2LT5pbml0X2RhdGEuaXJf
Y29kZXMgPSAmaXJfY29kZXNfd2luZmFzdF9kZWx1eGVfdGFibGU7CgkJZGV2LT5pbml0X2RhdGEu
Z2V0X2tleSA9IGVtMjh4eF9nZXRfa2V5X3dpbmZhc3RfZGVsdXhlOwoJCWRldi0+aW5pdF9kYXRh
Lm5hbWUgPSAiaTJjIElSIChFTTI4eHggV2luZmFzdCBVU0IgSUkgRGVsdXhlKSI7CiNlbmRpZgoJ
CWJyZWFrOwoKZW0yOHh4LmgKCmludCBlbTI4eHhfZ2V0X2tleV93aW5mYXN0X2RlbHV4ZShzdHJ1
Y3QgSVJfaTJjICppciwgdTMyICppcl9rZXksCgkJCQkgICAgIHUzMiAqaXJfcmF3KTsKCmVtMjh4
eC1pbnB1dC5jCgppbnQgZW0yOHh4X2dldF9rZXlfd2luZmFzdF9kZWx1eGUoc3RydWN0IElSX2ky
YyAqaXIsIHUzMiAqaXJfa2V5LAoJCQkJICAgICB1MzIgKmlyX3JhdykKewoJdW5zaWduZWQgY2hh
ciBidWZbM107CgoJLyogcG9sbCBJUiBjaGlwICovCgojaWYgTElOVVhfVkVSU0lPTl9DT0RFIDwg
S0VSTkVMX1ZFUlNJT04oMiwgNiwgMzApCglpZiAoMyAhPSBpMmNfbWFzdGVyX3JlY3YoJmlyLT5j
LCBidWYsIDMpKSB7CiNlbHNlCglpZiAoMyAhPSBpMmNfbWFzdGVyX3JlY3YoaXItPmMsIGJ1Ziwg
MykpIHsKI2VuZGlmCgkJaTJjZHByaW50aygicmVhZCBlcnJvclxuIik7CgkJcmV0dXJuIC1FSU87
Cgl9CgoJaTJjZHByaW50aygia2V5ICUwMnhcbiIsIGJ1ZlsyXSYweDNmKTsKCWlmIChidWZbMF0g
IT0gMHgwMCkKCQlyZXR1cm4gMDsKCgkqaXJfa2V5ID0gYnVmWzJdJjB4M2Y7CgkqaXJfcmF3ID0g
YnVmWzJdJjB4M2Y7CgoJcmV0dXJuIDE7Cn0KCmlyLWtleW1hcHMuYwovKiBFTTI4eHggV2luZmFz
dCBVU0IgSUkgRGVsdXhlIHJlbW90ZSAqLwpzdGF0aWMgc3RydWN0IGlyX3NjYW5jb2RlIGlyX2Nv
ZGVzX3dpbmZhc3RfZGVsdXhlW10gPSB7Cgl7IDB4MTQsIEtFWV9QT1dFUjJ9LAkJLyogUE9XRVIg
T0ZGICovCgl7IDB4MGMsIEtFWV9NVVRFfSwJCS8qIE1VVEUgKi8gCgoJeyAweDE4LCBLRVlfVFZ9
LAkJLyogVFYgKi8KCXsgMHgwZSwgS0VZX1ZJREVPfSwJCS8qIEFWICovCgl7IDB4MGIsIEtFWV9B
VURJT30sCQkvKiBTViAqLwoJeyAweDBmLCBLRVlfUkFESU99LAkJLyogRk0gKi8KCgl7IDB4MDAs
IEtFWV8xfSwKCXsgMHgwMSwgS0VZXzJ9LAoJeyAweDAyLCBLRVlfM30sCgl7IDB4MDMsIEtFWV80
fSwKCXsgMHgwNCwgS0VZXzV9LAoJeyAweDA1LCBLRVlfNn0sCgl7IDB4MDYsIEtFWV83fSwKCXsg
MHgwNywgS0VZXzh9LAoJeyAweDA4LCBLRVlfOX0sCgl7IDB4MDksIEtFWV8wfSwKCXsgMHgwYSwg
S0VZX0lORk99LAkJLyogT1NEICovCgl7IDB4MWMsIEtFWV9CQUNLU1BBQ0V9LAkJLyogTEFTVCAq
LwoKCXsgMHgwZCwgS0VZX1BMQVl9LAkJLyogUExBWSAqLwoJeyAweDFlLCBLRVlfQ0FNRVJBfSwJ
CS8qIFNOQVBTSE9UICovCgl7IDB4MWEsIEtFWV9SRUNPUkR9LAkJLyogUkVDT1JEICovCgl7IDB4
MTcsIEtFWV9TVE9QfSwJCS8qIFNUT1AgKi8KCXsgMHgxZiwgS0VZX1VQfSwJCS8qIFVQICovCgl7
IDB4NDQsIEtFWV9ET1dOfSwJCS8qIERPV04gKi8KCXsgMHg0NiwgS0VZX1RBQn0sCQkvKiBCQUNL
ICovCgl7IDB4NGEsIEtFWV9aT09NfSwJCS8qIEZVTExTRUNSRUVOICovCgoJeyAweDEwLCBLRVlf
Vk9MVU1FVVB9LAkJLyogVk9MVU1FVVAgKi8KCXsgMHgxMSwgS0VZX1ZPTFVNRURPV059LAkvKiBW
T0xVTUVET1dOICovCgl7IDB4MTIsIEtFWV9DSEFOTkVMVVB9LAkJLyogQ0hBTk5FTFVQICovCgl7
IDB4MTMsIEtFWV9DSEFOTkVMRE9XTn0sCS8qIENIQU5ORUxET1dOICovCgl7IDB4MTUsIEtFWV9F
TlRFUn0sCQkvKiBPSyAqLyAKfTsKc3RydWN0IGlyX3NjYW5jb2RlX3RhYmxlIGlyX2NvZGVzX3dp
bmZhc3RfZGVsdXhlX3RhYmxlID0gewoJLnNjYW4gPSBpcl9jb2Rlc193aW5mYXN0X2RlbHV4ZSwK
CS5zaXplID0gQVJSQVlfU0laRShpcl9jb2Rlc193aW5mYXN0X2RlbHV4ZSksCn07CkVYUE9SVF9T
WU1CT0xfR1BMKGlyX2NvZGVzX3dpbmZhc3RfZGVsdXhlX3RhYmxlKTsKCmlyLWNvbW1vbi5oCmV4
dGVybiBzdHJ1Y3QgaXJfc2NhbmNvZGVfdGFibGUgaXJfY29kZXNfd2luZmFzdF9kZWx1eGVfdGFi
bGU7CgoK
--001636418603b84fa304763b3067--
