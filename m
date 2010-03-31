Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <simpietro@gmail.com>) id 1NwvnG-0002Ch-KF
	for linux-dvb@linuxtv.org; Wed, 31 Mar 2010 13:09:07 +0200
Received: from mail-fx0-f223.google.com ([209.85.220.223])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NwvnF-0002Ir-1x; Wed, 31 Mar 2010 13:09:06 +0200
Received: by fxm23 with SMTP id 23so1099235fxm.1
	for <linux-dvb@linuxtv.org>; Wed, 31 Mar 2010 04:09:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mailman.1.1270029602.3767.linux-dvb@linuxtv.org>
References: <mailman.1.1270029602.3767.linux-dvb@linuxtv.org>
From: Pietro Sim <simpietro@gmail.com>
Date: Wed, 31 Mar 2010 13:08:44 +0200
Message-ID: <q2icbde272d1003310408qf8eb2ff4s42a066c4d181a9f9@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 62, Issue 16
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0460188208=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0460188208==
Content-Type: multipart/alternative; boundary=001485f44a842c7070048316c6f2

--001485f44a842c7070048316c6f2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello
My tuner is : ASUS mycinema U3000 Hybrid
I don't know it doesn't work on linux ubuntu 64bit
Thanks

2010/3/31 <linux-dvb-request@linuxtv.org>

> Send linux-dvb mailing list submissions to
>        linux-dvb@linuxtv.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
>        http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> or, via email, send a message with subject or body 'help' to
>        linux-dvb-request@linuxtv.org
>
> You can reach the person managing the list at
>        linux-dvb-owner@linuxtv.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of linux-dvb digest..."
>
>
> Today's Topics:
>
>   1. missing /dev/dvb/ for DVB-t usb Mobidtv Trio (v-gear) (Otto Hase)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Wed, 31 Mar 2010 17:52:22 +1000
> From: Otto Hase <ohase@synergyom.com.au>
> Subject: [linux-dvb] missing /dev/dvb/ for DVB-t usb Mobidtv Trio
>        (v-gear)
> To: linux-dvb@linuxtv.org
> Message-ID: <201003311752.22801.>
> Content-Type: Text/Plain;  charset=3D"us-ascii"
>
> Hi
>
> I got stuck.  Anyway DVB-t usb Mobidtv Trio (v-gear) is (appears to be)
> same
> as MSI Digivox mini II V3.0
>
> I am running Suse 11.2 on Asus Laptop Intel(R) Core(TM)2 Duo CPU T7300 @
> 2.00GHz
>
> I installed what was recommended.
>
> What is missing is
>
> /dev/dvb
>
> It is my understanding that means that the tuner has not been installed ?=
!
>
> Please view dmesg
>
>   112.242186] usb 2-3: new high speed USB device using ehci_hcd and addre=
ss
> 3
> [  112.362196] usb 2-3: New USB device found, idVendor=3Deb1a, idProduct=
=3D2883
> [  112.362222] usb 2-3: New USB device strings: Mfr=3D0, Product=3D1,
> SerialNumber=3D2
> [  112.362238] usb 2-3: Product: V-Gear MobiDTV Trio
> [  112.362250] usb 2-3: SerialNumber: 200708
> [  112.362518] usb 2-3: configuration #1 chosen from 1 choice
> [  112.556151] em28xx: New device V-Gear MobiDTV Trio @ 480 Mbps
> (eb1a:2883,
> interface 0, class 0)
> [  112.556271] em28xx #0: chip ID is em2882/em2883
> [  112.635771] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12 65
> 03
> 6a 2a 94 10
> [  112.635824] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 41 00 60 00 00
> 00
> 02 00 00 00
> [  112.635866] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00 00
> 00
> 5b 1e 00 00
> [  112.635909] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00
> 00
> 00 00 00 00
> [  112.635951] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00
> 00
> d3 c4 00 00
> [  112.635993] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.636036] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2a
> 03
> 56 00 2d 00
> [  112.636077] em28xx #0: i2c eeprom 70: 47 00 65 00 61 00 72 00 20 00 4d
> 00
> 6f 00 62 00
> [  112.636119] em28xx #0: i2c eeprom 80: 69 00 44 00 54 00 56 00 20 00 54
> 00
> 72 00 69 00
> [  112.636160] em28xx #0: i2c eeprom 90: 6f 00 00 00 10 03 32 00 30 00 30
> 00
> 37 00 30 00
> [  112.636203] em28xx #0: i2c eeprom a0: 38 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.636244] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.637094] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.637139] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.637181] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.637228] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00
> 00
> 00 00 00 00
> [  112.637285] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0x6d1e=
c21d
> [  112.637301] em28xx #0: EEPROM info:
> [  112.637312] em28xx #0:       AC97 audio (5 sample rates)
> [  112.637325] em28xx #0:       500mA max power
> [  112.637339] em28xx #0:       Table at 0x24, strings=3D0x2a6a, 0x1094,
> 0x0000
> [  112.638516] em28xx #0: Identified as MSI VOX USB 2.0 (card=3D5)
> [  112.685010] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
> [  112.725795] tuner-simple 3-0061: creating new instance
> [  112.725817] tuner-simple 3-0061: type set to 37 (LG PAL (newer TAPC
> series))
> [  112.727157] em28xx #0: Config register raw data: 0xd0
> [  112.727907] em28xx #0: AC97 vendor ID =3D 0xffffffff
> [  112.728754] em28xx #0: AC97 features =3D 0x6a90
> [  112.728768] em28xx #0: Empia 202 AC97 audio processor detected
> [  112.751382] em28xx #0: v4l2 driver version 0.1.2
> [  112.780496] em28xx #0: V4L2 video device registered as video1
> [  112.780516] em28xx #0: V4L2 VBI device registered as vbi0
> [  112.780578] usbcore: registered new interface driver em28xx
> [  112.780595] em28xx driver loaded
> [  112.796832] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [  112.796843] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [  112.797500] Em28xx: Initialized (Em28xx Audio Extension) extension
>
>
> I wonder what I missed.  Can anyone help !
>
> thanks Otto
>
>
>
> ------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> End of linux-dvb Digest, Vol 62, Issue 16
> *****************************************
>



--=20
Rispetta l'ambiente: se non ti =E8 necessario, non stampare questa mail.

Prima di stampare questa pagina verifica che sia necessario. Proteggiamo
l'Ambiente.

Ai sensi del D.Lgs. 196/03, si precisa che le informazioni contenute in
questo documento e/o negli allegati sono riservate ad uso esclusivo del
destinatario. In caso di ricevimento del presente documento da parte di
soggetto diverso dal destinatario indicato, questi, in ogni caso, e'
diffidato dal leggerlo, di farne uso a qualsiasi titolo ed e' gentilmente
pregato di contattarci telefonicamente quanto prima, nonche' distruggere la
copia erroneamente ricevuta.

--001485f44a842c7070048316c6f2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello<br>My tuner is : ASUS mycinema U3000 Hybrid<br>I don&#39;t know it do=
esn&#39;t work on linux ubuntu 64bit<br>Thanks<br><br><div class=3D"gmail_q=
uote">2010/3/31  <span dir=3D"ltr">&lt;<a href=3D"mailto:linux-dvb-request@=
linuxtv.org">linux-dvb-request@linuxtv.org</a>&gt;</span><br>

<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Send linux-dvb ma=
iling list submissions to<br>
 =A0 =A0 =A0 =A0<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.=
org</a><br>
<br>
To subscribe or unsubscribe via the World Wide Web, visit<br>
 =A0 =A0 =A0 =A0<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/=
linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinf=
o/linux-dvb</a><br>
or, via email, send a message with subject or body &#39;help&#39; to<br>
 =A0 =A0 =A0 =A0<a href=3D"mailto:linux-dvb-request@linuxtv.org">linux-dvb-=
request@linuxtv.org</a><br>
<br>
You can reach the person managing the list at<br>
 =A0 =A0 =A0 =A0<a href=3D"mailto:linux-dvb-owner@linuxtv.org">linux-dvb-ow=
ner@linuxtv.org</a><br>
<br>
When replying, please edit your Subject line so it is more specific<br>
than &quot;Re: Contents of linux-dvb digest...&quot;<br>
<br>
<br>
Today&#39;s Topics:<br>
<br>
 =A0 1. missing /dev/dvb/ for DVB-t usb Mobidtv Trio (v-gear) (Otto Hase)<b=
r>
<br>
<br>
----------------------------------------------------------------------<br>
<br>
Message: 1<br>
Date: Wed, 31 Mar 2010 17:52:22 +1000<br>
From: Otto Hase &lt;<a href=3D"mailto:ohase@synergyom.com.au">ohase@synergy=
om.com.au</a>&gt;<br>
Subject: [linux-dvb] missing /dev/dvb/ for DVB-t usb Mobidtv Trio<br>
 =A0 =A0 =A0 =A0(v-gear)<br>
To: <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
Message-ID: &lt;201003311752.22801.&gt;<br>
Content-Type: Text/Plain; =A0charset=3D&quot;us-ascii&quot;<br>
<br>
Hi<br>
<br>
I got stuck. =A0Anyway DVB-t usb Mobidtv Trio (v-gear) is (appears to be) s=
ame<br>
as MSI Digivox mini II V3.0<br>
<br>
I am running Suse 11.2 on Asus Laptop Intel(R) Core(TM)2 Duo CPU T7300 @<br=
>
2.00GHz<br>
<br>
I installed what was recommended.<br>
<br>
What is missing is<br>
<br>
/dev/dvb<br>
<br>
It is my understanding that means that the tuner has not been installed ?!<=
br>
<br>
Please view dmesg<br>
<br>
 =A0 112.242186] usb 2-3: new high speed USB device using ehci_hcd and addr=
ess 3<br>
[ =A0112.362196] usb 2-3: New USB device found, idVendor=3Deb1a, idProduct=
=3D2883<br>
[ =A0112.362222] usb 2-3: New USB device strings: Mfr=3D0, Product=3D1,<br>
SerialNumber=3D2<br>
[ =A0112.362238] usb 2-3: Product: V-Gear MobiDTV Trio<br>
[ =A0112.362250] usb 2-3: SerialNumber: 200708<br>
[ =A0112.362518] usb 2-3: configuration #1 chosen from 1 choice<br>
[ =A0112.556151] em28xx: New device V-Gear MobiDTV Trio @ 480 Mbps (eb1a:28=
83,<br>
interface 0, class 0)<br>
[ =A0112.556271] em28xx #0: chip ID is em2882/em2883<br>
[ =A0112.635771] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12 65=
 03<br>
6a 2a 94 10<br>
[ =A0112.635824] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 41 00 60 00 00=
 00<br>
02 00 00 00<br>
[ =A0112.635866] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00 00=
 00<br>
5b 1e 00 00<br>
[ =A0112.635909] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00=
 00<br>
00 00 00 00<br>
[ =A0112.635951] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
d3 c4 00 00<br>
[ =A0112.635993] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.636036] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2a=
 03<br>
56 00 2d 00<br>
[ =A0112.636077] em28xx #0: i2c eeprom 70: 47 00 65 00 61 00 72 00 20 00 4d=
 00<br>
6f 00 62 00<br>
[ =A0112.636119] em28xx #0: i2c eeprom 80: 69 00 44 00 54 00 56 00 20 00 54=
 00<br>
72 00 69 00<br>
[ =A0112.636160] em28xx #0: i2c eeprom 90: 6f 00 00 00 10 03 32 00 30 00 30=
 00<br>
37 00 30 00<br>
[ =A0112.636203] em28xx #0: i2c eeprom a0: 38 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.636244] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.637094] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.637139] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.637181] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.637228] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00=
 00<br>
00 00 00 00<br>
[ =A0112.637285] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0x6d1e=
c21d<br>
[ =A0112.637301] em28xx #0: EEPROM info:<br>
[ =A0112.637312] em28xx #0: =A0 =A0 =A0 AC97 audio (5 sample rates)<br>
[ =A0112.637325] em28xx #0: =A0 =A0 =A0 500mA max power<br>
[ =A0112.637339] em28xx #0: =A0 =A0 =A0 Table at 0x24, strings=3D0x2a6a, 0x=
1094, 0x0000<br>
[ =A0112.638516] em28xx #0: Identified as MSI VOX USB 2.0 (card=3D5)<br>
[ =A0112.685010] tuner 3-0061: chip found @ 0xc2 (em28xx #0)<br>
[ =A0112.725795] tuner-simple 3-0061: creating new instance<br>
[ =A0112.725817] tuner-simple 3-0061: type set to 37 (LG PAL (newer TAPC<br=
>
series))<br>
[ =A0112.727157] em28xx #0: Config register raw data: 0xd0<br>
[ =A0112.727907] em28xx #0: AC97 vendor ID =3D 0xffffffff<br>
[ =A0112.728754] em28xx #0: AC97 features =3D 0x6a90<br>
[ =A0112.728768] em28xx #0: Empia 202 AC97 audio processor detected<br>
[ =A0112.751382] em28xx #0: v4l2 driver version 0.1.2<br>
[ =A0112.780496] em28xx #0: V4L2 video device registered as video1<br>
[ =A0112.780516] em28xx #0: V4L2 VBI device registered as vbi0<br>
[ =A0112.780578] usbcore: registered new interface driver em28xx<br>
[ =A0112.780595] em28xx driver loaded<br>
[ =A0112.796832] em28xx-audio.c: probing for em28x1 non standard usbaudio<b=
r>
[ =A0112.796843] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger<br>
[ =A0112.797500] Em28xx: Initialized (Em28xx Audio Extension) extension<br>
<br>
<br>
I wonder what I missed. =A0Can anyone help !<br>
<br>
thanks Otto<br>
<br>
<br>
<br>
------------------------------<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
<br>
End of linux-dvb Digest, Vol 62, Issue 16<br>
*****************************************<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>Rispetta l&#39;ambiente=
: se non ti =E8 necessario, non stampare questa mail.<br><br>Prima di stamp=
are questa pagina verifica che sia necessario. Proteggiamo l&#39;Ambiente.<=
br>

<br>Ai sensi del D.Lgs. 196/03, si precisa che le informazioni contenute in=
 questo documento e/o negli allegati sono riservate ad uso esclusivo del de=
stinatario. In caso di ricevimento del presente documento da parte di sogge=
tto diverso dal destinatario indicato, questi, in ogni caso, e&#39; diffida=
to dal leggerlo, di farne uso a qualsiasi titolo ed e&#39; gentilmente preg=
ato di contattarci telefonicamente quanto prima, nonche&#39; distruggere la=
 copia erroneamente ricevuta.<br>

<br>

--001485f44a842c7070048316c6f2--


--===============0460188208==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0460188208==--
