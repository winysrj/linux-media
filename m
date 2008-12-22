Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-d06.mx.aol.com ([205.188.157.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1LErMn-0003wD-AB
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 21:27:05 +0100
References: <8CB31D4DD3B74C2-C48-6AA@WEBMAIL-MC16.sysops.aol.com>
	<20081222213122.3a72f99c@bk.ru>
To: goga777@bk.ru
Date: Mon, 22 Dec 2008 15:26:18 -0500
In-Reply-To: <20081222213122.3a72f99c@bk.ru>
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB328AAAF118F7-11CC-2@mblk-d34.sysops.aol.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT-3600 on kernel 2.6.27 doesn't work... any help?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1546530661=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1546530661==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB328AAE312F06_11CC_4_mblk-d34.sysops.aol.com"


----------MB_8CB328AAE312F06_11CC_4_mblk-d34.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"


 hi,=20
i'm probably using vdr...=20
it looks like szap-s2 is trying to access a wrong device driver that doesn't=
 support the new dvb-s2 api ioctls...


 but how do i find out?


=20

-----Original Message-----
From: Goga777 <goga777@bk.ru>
To: dbox2alpha@netscape.net
Sent: Mon, 22 Dec 2008 7:31 pm
Subject: Re: [linux-dvb] TT-3600 on kernel 2.6.27 doesn't work... any help?










=D0=9F=D1=80=D0=B8=D0=B2=D0=B5=D1=82=D1=81=D1=82=D0=B2=D1=83=D1=8E, dbox2alp=
ha@netscape.net

sorry I don't know answers

but I'm wondering - which software will you use for dvb watching on PS3  - v=
dr ,=20
kaffeine, mythtv ?

what do you think about PS3 as =D1=80=D0=B5=D0=B7=D1=81 platform with dvb-s2=
 support ? is it good=20
thing ?

> hi,=20
> I'm trying to get the TT-3600 USB DVB-S2 to work on a PlayStation 3 but so=
 far=20
I have not been successful.
>=20
> I'm using the latest DVB-S2 API and driver: s2-liplianin-aed3dd42ac28
> which compiles and installs fine.
> Driver also seems to initialize fine.
> But when I use szap-s2 FE_SET_PROPERTY DTV_CLEAR fails.
> problem with the following ioctl:=20
> ioctl32(szap-s2:32528): Unknown cmd fd(3) cmd(80086f52){t:'o';sz:8}=20
arg(ff835360) on /dev/dvb/adapter0/frontend0
>=20
> [root@ps3 szap-s2-a75cabee2e95]# ./szap-s2 -c channels.conf -rn 2
> reading channels from file 'channels.conf'
> zapping to 2 'SAT.1;ProSiebenSat.1':
> delivery DVB-S, modulation QPSK
> sat 0, frequency 12544 MHz H, symbolrate 22000000, coderate 5/6, rolloff 0=
.35
> vpid 0x00ff, apid 0x0100, sid 0x0020
> using '/dev/dvb/adapter0/frontend0
' and '/dev/dvb/adapter0/demux0'
> FE_SET_PROPERTY DTV_CLEAR failed: Invalid argument
> [root@ps3 szap-s2-a75cabee2e95]#
>=20
> Any help? Thanks.


--=20
=D0=A3=D0=B4=D0=B0=D1=87=D0=B8,
=D0=98=D0=B3=D0=BE=D1=80=D1=8C



=20


----------MB_8CB328AAE312F06_11CC_4_mblk-d34.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"


<div> <font face=3D"Arial, Helvetica, sans-serif">hi, <br>
i'm probably using vdr... <br>
it looks like szap-s2 is trying to access a wrong device driver that doesn't=
 support the new dvb-s2 api ioctls...<br>
</font></div>

<div> <font face=3D"Arial, Helvetica, sans-serif">but how do i find out?<br>
</font></div>

<div> <br>
</div>
-----Original Message-----<br>
From: Goga777 &lt;goga777@bk.ru&gt;<br>
To: dbox2alpha@netscape.net<br>
Sent: Mon, 22 Dec 2008 7:31 pm<br>
Subject: Re: [linux-dvb] TT-3600 on kernel 2.6.27 doesn't work... any help?<=
br>
<br>






<div id=3D"AOLMsgPart_0_fdb1c5fc-5a4b-48db-8bdf-814d65f899af" style=3D"margi=
n: 0px; font-family: Tahoma,Verdana,Arial,Sans-Serif; font-size: 12px; color=
: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">

<pre style=3D"font-size: 9pt;"><tt>=D0=9F=D1=80=D0=B8=D0=B2=D0=B5=D1=82=D1=
=81=D1=82=D0=B2=D1=83=D1=8E, <a __removedlink__648601457__href=3D"mailto:dbo=
x2alpha@netscape.net">dbox2alpha@netscape.net</a><br>
<br>
sorry I don't know answers<br>
<br>
but I'm wondering - which software will you use for dvb watching on PS3  - v=
dr , <br>
kaffeine, mythtv ?<br>
<br>
what do you think about PS3 as =D1=80=D0=B5=D0=B7=D1=81 platform with dvb-s2=
 support ? is it good <br>
thing ?<br>
<br>
&gt; hi, <br>
&gt; I'm trying to get the TT-3600 USB DVB-S2 to work on a PlayStation 3 but=
 so far <br>
I have not been successful.<br>
&gt; <br>
&gt; I'm using the latest DVB-S2 API and driver: s2-liplianin-aed3dd42ac28<b=
r>
&gt; which compiles and installs fine.<br>
&gt; Driver also seems to initialize fine.<br>
&gt; But when I use szap-s2 FE_SET_PROPERTY DTV_CLEAR fa
ils.<br>
&gt; problem with the following ioctl: <br>
&gt; ioctl32(szap-s2:32528): Unknown cmd fd(3) cmd(80086f52){t:'o';sz:8} <br=
>
arg(ff835360) on /dev/dvb/adapter0/frontend0<br>
&gt; <br>
&gt; [root@ps3 szap-s2-a75cabee2e95]# ./szap-s2 -c channels.conf -rn 2<br>
&gt; reading channels from file 'channels.conf'<br>
&gt; zapping to 2 'SAT.1;ProSiebenSat.1':<br>
&gt; delivery DVB-S, modulation QPSK<br>
&gt; sat 0, frequency 12544 MHz H, symbolrate 22000000, coderate 5/6, rollof=
f 0.35<br>
&gt; vpid 0x00ff, apid 0x0100, sid 0x0020<br>
&gt; using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br>
&gt; FE_SET_PROPERTY DTV_CLEAR failed: Invalid argument<br>
&gt; [root@ps3 szap-s2-a75cabee2e95]#<br>
&gt; <br>
&gt; Any help? Thanks.<br>
<br>
<br>
-- <br>
=D0=A3=D0=B4=D0=B0=D1=87=D0=B8,<br>
=D0=98=D0=B3=D0=BE=D1=80=D1=8C<br>
</tt></pre>
</div>
 <!-- end of AOLMsgPart_0_fdb1c5fc-5a4b-48db-8bdf-814d65f899af -->

<div id=3D'MAILCIAMB013-5c39494ff7eaf8' class=3D'aol_ad_footer'><BR/><FONT s=
tyle=3D"color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR  style=3D"MAR=
GIN-TOP: 10px"></HR>Listen to 350+ music, sports, & news radio stations &#15=
0; including songs for the holidays &#150; FREE while you browse. <a href=
=3D"http://toolbar.aol.com/aolradio/download.html?ncid=3Demlweusdown00000013=
">Start Listening Now</a>! </div>

----------MB_8CB328AAE312F06_11CC_4_mblk-d34.sysops.aol.com--


--===============1546530661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1546530661==--
