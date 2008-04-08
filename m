Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <BAY114-W274A9CBE510CEF0781EC94DBF20@phx.gbl>
From: mehmet canser <mehmetcanser@hotmail.com>
To: Matthias Schwarzott <zzam@gentoo.org>, <linux-dvb@linuxtv.org>
Date: Tue, 8 Apr 2008 15:53:16 +0000
In-Reply-To: <200804081733.54539.zzam@gentoo.org>
References: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
	<200804081733.54539.zzam@gentoo.org>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com, Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1353845238=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <video4linux-list@redhat.com>

--===============1353845238==
Content-Type: multipart/alternative;
	boundary="_ece0dd6c-bb40-4b2a-a70f-cf99bcca47be_"

--_ece0dd6c-bb40-4b2a-a70f-cf99bcca47be_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


I m using this card and it is working.
My configuration: =20
  Avermedia A700 DVB-S Pro A700 - ubuntu hardy development 64 bit - kernel =
2.6.24-14
  Patch : http://dev.gentoo.org/~zzam/dvb/a700_full_20080313.diff

 Two satellite dishes: Turksat 42E and Hotbird 13E. Both working.

Digital TV and audio  work correctly, only signals weak.
Analog video (composite input) works, but i can't get sound from analog inp=
ut.=20
For
digital tv, I m using kaffeine and it works without problems. For
analog part, I use xawtv and tvtime, both shows video, but no sound.

=20
lspci  -vnn
04:09.0 Multimedia controller [0480]: Philips Semiconductors SAA7133/SAA713=
5 Video Broadcast Decoder [1131:7133] (rev d1)
    Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a1]
    Flags: bus master, medium devsel, latency 32, IRQ 17

    Memory at fdcff000 (32-bit, non-prefetchable) [size=3D2K]
    Capabilities: <access denied>

dmesg | grep DVB
[   36.655632] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S Pro=
 A700 [card=3D140,autodetected]

[   38.590558] DVB: registering new adapter (saa7133[0])
[   38.590561] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...

dmesg | grep saa
[   36.655100] saa7130/34: v4l2 driver version 0.2.14 loaded

[   36.655626] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17, latenc=
y: 32, mmio: 0xfdcff000
[   36.655632] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S Pro=
 A700 [card=3D140,autodetected]
[   36.655643] saa7133[0]: board init: gpio is 23200

[   37.011708] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011716] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011721] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   37.011726] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011730] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011735] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   37.011740] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011745] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011749] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   37.011754] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011759] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011764] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   37.011768] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011773] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.011778] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff

[   37.011783] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   37.019673] saa7133[0]: i2c scan: found device @ 0x1c  [???]
[   37.035662] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]

[   37.054218] saa7133[0]: registered device video0 [v4l2]
[   37.054249] saa7133[0]: registered device vbi0
[   38.590558] DVB: registering new adapter (saa7133[0])

Best regards,
Mehmet Canser


> From: zzam@gentoo.org
> To: linux-dvb@linuxtv.org
> Date: Tue, 8 Apr 2008 17:33:54 +0200
> CC: video4linux-list@redhat.com; eduardhc@gmail.com
> Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
>=20
> On Dienstag, 8. April 2008, Eduard Huguet wrote:
> > Hi,
> >     Things are very quiet lately regarding this card. Is there any
> > possibility that the card gets supported in any near future? I know
> > Matthias  Schwarzot had been working on it, but there's no messages fro=
m
> > him lately on the list.
> >
> > Best regards,
> >   Eduard
>=20
> I did not made any progress since last time we corresponded.
>=20
> But: I think we agree that the patch that only adds composite and s-video=
=20
> support works.
> So we could request pulling it into v4l-dvb repository.
>=20
> Regards
> Matthias
>=20
> --=20
> Matthias Schwarzott (zzam)

_________________________________________________________________
Pack up or back up=96use SkyDrive to transfer files or keep extra copies. L=
earn how.
hthttp://www.windowslive.com/skydrive/overview.html?ocid=3DTXT_TAGLM_WL_Ref=
resh_skydrive_packup_042008=

--_ece0dd6c-bb40-4b2a-a70f-cf99bcca47be_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt;
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
I m using this card and it is working.<br>My configuration:&nbsp; <br>&nbsp=
; Avermedia A700 DVB-S Pro A700 - ubuntu hardy development 64 bit - kernel =
2.6.24-14<br>&nbsp; Patch : <a href=3D"http://dev.gentoo.org/%7Ezzam/dvb/a7=
00_full_20080313.diff" target=3D"_blank">http://dev.gentoo.org/~zzam/dvb/a7=
00_full_20080313.diff</a><br>
&nbsp;Two satellite dishes: Turksat 42E and Hotbird 13E. Both working.<br><=
br>Digital TV and audio&nbsp; work correctly, only signals weak.<br>Analog =
video (composite input) works, but i can't get sound from analog input. <br=
>For
digital tv, I m using kaffeine and it works without problems. For
analog part, I use xawtv and tvtime, both shows video, but no sound.<br>
&nbsp;<br>lspci&nbsp; -vnn<br>04:09.0 Multimedia controller [0480]: Philips=
 Semiconductors SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1=
)<br>&nbsp;&nbsp;&nbsp; Subsystem: Avermedia Technologies Inc Unknown devic=
e [1461:a7a1]<br>&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, laten=
cy 32, IRQ 17<br>
&nbsp;&nbsp;&nbsp; Memory at fdcff000 (32-bit, non-prefetchable) [size=3D2K=
]<br>&nbsp;&nbsp;&nbsp; Capabilities: &lt;access denied&gt;<br><br>dmesg | =
grep DVB<br>[&nbsp;&nbsp; 36.655632] saa7133[0]: subsystem: 1461:a7a1, boar=
d: Avermedia DVB-S Pro A700 [card=3D140,autodetected]<br>
[&nbsp;&nbsp; 38.590558] DVB: registering new adapter (saa7133[0])<br>[&nbs=
p;&nbsp; 38.590561] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...<=
br><br>dmesg | grep saa<br>[&nbsp;&nbsp; 36.655100] saa7130/34: v4l2 driver=
 version 0.2.14 loaded<br>
[&nbsp;&nbsp; 36.655626] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: =
17, latency: 32, mmio: 0xfdcff000<br>[&nbsp;&nbsp; 36.655632] saa7133[0]: s=
ubsystem: 1461:a7a1, board: Avermedia DVB-S Pro A700 [card=3D140,autodetect=
ed]<br>[&nbsp;&nbsp; 36.655643] saa7133[0]: board init: gpio is 23200<br>
[&nbsp;&nbsp; 37.011708] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011716] saa7133[0]: i2c eeprom=
 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1721] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011726] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011730] saa7133[0]: i2c eeprom=
 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1735] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011740] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011745] saa7133[0]: i2c eeprom=
 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1749] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011754] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011759] saa7133[0]: i2c eeprom=
 a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1764] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011768] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.011773] saa7133[0]: i2c eeprom=
 d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.01=
1778] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff =
ff ff<br>
[&nbsp;&nbsp; 37.011783] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff<br>[&nbsp;&nbsp; 37.019673] saa7133[0]: i2c scan: =
found device @ 0x1c&nbsp; [???]<br>[&nbsp;&nbsp; 37.035662] saa7133[0]: i2c=
 scan: found device @ 0xa0&nbsp; [eeprom]<br>
[&nbsp;&nbsp; 37.054218] saa7133[0]: registered device video0 [v4l2]<br>[&n=
bsp;&nbsp; 37.054249] saa7133[0]: registered device vbi0<br>[&nbsp;&nbsp; 3=
8.590558] DVB: registering new adapter (saa7133[0])<br><br>Best regards,<br=
>Mehmet Canser<br><br><br>&gt; From: zzam@gentoo.org<br>&gt; To: linux-dvb@=
linuxtv.org<br>&gt; Date: Tue, 8 Apr 2008 17:33:54 +0200<br>&gt; CC: video4=
linux-list@redhat.com; eduardhc@gmail.com<br>&gt; Subject: Re: [linux-dvb] =
Any progress on the AverMedia A700 (DVB-S Pro)?<br>&gt; <br>&gt; On Diensta=
g, 8. April 2008, Eduard Huguet wrote:<br>&gt; &gt; Hi,<br>&gt; &gt;     Th=
ings are very quiet lately regarding this card. Is there any<br>&gt; &gt; p=
ossibility that the card gets supported in any near future? I know<br>&gt; =
&gt; Matthias  Schwarzot had been working on it, but there's no messages fr=
om<br>&gt; &gt; him lately on the list.<br>&gt; &gt;<br>&gt; &gt; Best rega=
rds,<br>&gt; &gt;   Eduard<br>&gt; <br>&gt; I did not made any progress sin=
ce last time we corresponded.<br>&gt; <br>&gt; But: I think we agree that t=
he patch that only adds composite and s-video <br>&gt; support works.<br>&g=
t; So we could request pulling it into v4l-dvb repository.<br>&gt; <br>&gt;=
 Regards<br>&gt; Matthias<br>&gt; <br>&gt; -- <br>&gt; Matthias Schwarzott =
(zzam)<br><br /><hr />Pack up or back up=96use SkyDrive to transfer files o=
r keep extra copies. <a href=3D'hthttp://www.windowslive.com/skydrive/overv=
iew.html?ocid=3DTXT_TAGLM_WL_Refresh_skydrive_packup_042008' target=3D'_new=
'>Learn how.</a></body>
</html>=

--_ece0dd6c-bb40-4b2a-a70f-cf99bcca47be_--


--===============1353845238==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1353845238==--
