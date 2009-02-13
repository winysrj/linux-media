Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s41.bay0.hotmail.com ([65.54.246.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nickotym@hotmail.com>) id 1LXrBu-0005aN-Sk
	for linux-dvb@linuxtv.org; Fri, 13 Feb 2009 07:06:33 +0100
Message-ID: <BAY102-W569AE29303E41F5A313FBACFB80@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Fri, 13 Feb 2009 00:05:47 -0600
MIME-Version: 1.0
Subject: [linux-dvb] HVR-1500 tuner seems to be recognized, but wont turn on.
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0184391393=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0184391393==
Content-Type: multipart/alternative;
	boundary="_47ca7f39-058f-40f8-82f5-9437687383fe_"

--_47ca7f39-058f-40f8-82f5-9437687383fe_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


I am hoping this problem has already been solved=2C but I couldn't find any=
thing mentioned in the archives going back a while.

I am running Kubuntu 8.10 with 2.6.27-11-generic on a Toshiba laptop with d=
ual AMD 64 processors. =20

I installed the drivers from the non-experimental ones at www.linuxtv.org u=
sing mercurial and that helped with some problems.  However=2C the tuner is=
 now recognized=2C but can't seem to turn on when called for by MythTV or d=
vbscan. =20

 Partial Results of dmesg follow:

[ 2627.107174] firmware: requesting xc3028-v27.fw
[ 2627.147757] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw=
=2C type: xc2028 firmware=2C ver 2.7
[ 2627.347546] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2627.870877] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)
[ 2627.870886] xc2028 2-0061: -5 returned from send
[ 2627.870890] xc2028 2-0061: Error -22 while loading base firmware
[ 2628.122478] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2628.645956] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)
[ 2628.645962] xc2028 2-0061: -5 returned from send
[ 2628.645965] xc2028 2-0061: Error -22 while loading base firmware
[ 2629.845869] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2630.368229] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)
[ 2630.368235] xc2028 2-0061: -5 returned from send
[ 2630.368239] xc2028 2-0061: Error -22 while loading base firmware
[ 2630.622469] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2631.144810] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)
[ 2631.144818] xc2028 2-0061: -5 returned from send
[ 2631.144820] xc2028 2-0061: Error -22 while loading base firmware
[ 2632.150462] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2632.679257] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)
[ 2632.679266] xc2028 2-0061: -5 returned from send
[ 2632.679270] xc2028 2-0061: Error -22 while loading base firmware
[ 2632.930465] xc2028 2-0061: Loading firmware for type=3DBASE (1)=2C id 00=
00000000000000.
[ 2634.086084] xc2028 2-0061: Loading firmware for type=3DD2633 DTV6 ATSC (=
10030)=2C id 0000000000000000.


lspci -vnn results (partial):

01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690M [Rade=
on X1200 Series] [1002:791f]                                               =
         =20
        Subsystem: Toshiba America Info Systems Device [1179:ff00]         =
    =20
        Flags: bus master=2C fast devsel=2C latency 64=2C IRQ 18           =
          =20
        Memory at f0000000 (64-bit=2C prefetchable) [size=3D128M]          =
        =20
        Memory at f8300000 (64-bit=2C non-prefetchable) [size=3D64K]       =
        =20
        I/O ports at 9000 [size=3D256]                                     =
      =20
        Memory at f8200000 (32-bit=2C non-prefetchable) [size=3D1M]        =
        =20
        Capabilities: <access denied>                                      =
    =20

0b:00.0 Multimedia video controller [0400]: Conexant Systems=2C Inc. CX2388=
5 PCI Video and Audio Decoder [14f1:8852] (rev 02)                         =
           =20
        Subsystem: Hauppauge computer works Inc. Device [0070:7717]        =
    =20
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 17            =
          =20
        Memory at f8000000 (64-bit=2C non-prefetchable) [size=3D2M]        =
        =20
        Capabilities: <access denied>                                      =
    =20
        Kernel driver in use: cx23885                                      =
    =20
        Kernel modules: cx23885                                            =
    =20

Please let me know what else might be needed to solve this.

Saw a link that recommended using v4l-dvb-experimental  drivers but wasn't =
sure if that was wise.


Thanks=2C=20

Nick



_________________________________________________________________
Windows Live=99: E-mail. Chat. Share. Get more ways to connect.=20
http://windowslive.com/explore?ocid=3DTXT_TAGLM_WL_t2_allup_explore_022009=

--_47ca7f39-058f-40f8-82f5-9437687383fe_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
I am hoping this problem has already been solved=2C but I couldn't find any=
thing mentioned in the archives going back a while.<br><br>I am running Kub=
untu 8.10 with 2.6.27-11-generic on a Toshiba laptop with dual AMD 64 proce=
ssors.&nbsp=3B <br><br>I installed the drivers from the non-experimental on=
es at www.linuxtv.org using mercurial and that helped with some problems.&n=
bsp=3B However=2C the tuner is now recognized=2C but can't seem to turn on =
when called for by MythTV or dvbscan.&nbsp=3B <br><br>&nbsp=3BPartial Resul=
ts of dmesg follow:<br><br>[ 2627.107174] firmware: requesting xc3028-v27.f=
w<br>[ 2627.147757] xc2028 2-0061: Loading 80 firmware images from xc3028-v=
27.fw=2C type: xc2028 firmware=2C ver 2.7<br>[ 2627.347546] xc2028 2-0061: =
Loading firmware for type=3DBASE (1)=2C id 0000000000000000.<br>[ 2627.8708=
77] xc2028 2-0061: i2c output error: rc =3D -5 (should be 4)<br>[ 2627.8708=
86] xc2028 2-0061: -5 returned from send<br>[ 2627.870890] xc2028 2-0061: E=
rror -22 while loading base firmware<br>[ 2628.122478] xc2028 2-0061: Loadi=
ng firmware for type=3DBASE (1)=2C id 0000000000000000.<br>[ 2628.645956] x=
c2028 2-0061: i2c output error: rc =3D -5 (should be 4)<br>[ 2628.645962] x=
c2028 2-0061: -5 returned from send<br>[ 2628.645965] xc2028 2-0061: Error =
-22 while loading base firmware<br>[ 2629.845869] xc2028 2-0061: Loading fi=
rmware for type=3DBASE (1)=2C id 0000000000000000.<br>[ 2630.368229] xc2028=
 2-0061: i2c output error: rc =3D -5 (should be 4)<br>[ 2630.368235] xc2028=
 2-0061: -5 returned from send<br>[ 2630.368239] xc2028 2-0061: Error -22 w=
hile loading base firmware<br>[ 2630.622469] xc2028 2-0061: Loading firmwar=
e for type=3DBASE (1)=2C id 0000000000000000.<br>[ 2631.144810] xc2028 2-00=
61: i2c output error: rc =3D -5 (should be 4)<br>[ 2631.144818] xc2028 2-00=
61: -5 returned from send<br>[ 2631.144820] xc2028 2-0061: Error -22 while =
loading base firmware<br>[ 2632.150462] xc2028 2-0061: Loading firmware for=
 type=3DBASE (1)=2C id 0000000000000000.<br>[ 2632.679257] xc2028 2-0061: i=
2c output error: rc =3D -5 (should be 4)<br>[ 2632.679266] xc2028 2-0061: -=
5 returned from send<br>[ 2632.679270] xc2028 2-0061: Error -22 while loadi=
ng base firmware<br>[ 2632.930465] xc2028 2-0061: Loading firmware for type=
=3DBASE (1)=2C id 0000000000000000.<br>[ 2634.086084] xc2028 2-0061: Loadin=
g firmware for type=3DD2633 DTV6 ATSC (10030)=2C id 0000000000000000.<br><b=
r><br>lspci -vnn results (partial):<br><br>01:05.0 VGA compatible controlle=
r [0300]: ATI Technologies Inc RS690M [Radeon X1200 Series] [1002:791f]&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <b=
r>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: Toshi=
ba America Info Systems Device [1179:ff00]&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br=
>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=
=2C fast devsel=2C latency 64=2C IRQ 18&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at f0000000 (64-bit=2C=
 prefetchable) [size=3D128M]&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Memory at f8300000 (64-bit=2C non-prefetchable) [size=3D64K]&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at 9000 [size=3D256]&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Memory at f8200000 (32-bit=2C non-prefetchable) [size=
=3D1M]&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: &lt=3Baccess de=
nied&gt=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br><br>0b:00.0 Multimedia=
 video controller [0400]: Conexant Systems=2C Inc. CX23885 PCI Video and Au=
dio Decoder [14f1:8852] (rev 02)&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Subsystem: Hauppauge computer works Inc. Device [0070:7717]&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 17&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memor=
y at f8000000 (64-bit=2C non-prefetchable) [size=3D2M]&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Capabilities: &lt=3Baccess denied&gt=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Kernel driver in use: cx23885&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
 <br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel module=
s: cx23885&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B <br><br>Please let me know what else might be needed =
to solve this.<br><br>Saw a link that recommended using v4l-dvb-experimenta=
l&nbsp=3B drivers but wasn't sure if that was wise.<br><br><br>Thanks=2C <b=
r><br>Nick<br><br><br><br /><hr />Windows Live=99: E-mail. Chat. Share. Get=
 more ways to connect.  <a href=3D'http://windowslive.com/explore?ocid=3DTX=
T_TAGLM_WL_t2_allup_explore_022009' target=3D'_new'>Check it out.</a></body=
>
</html>=

--_47ca7f39-058f-40f8-82f5-9437687383fe_--


--===============0184391393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0184391393==--
