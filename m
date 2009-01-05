Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-m22.mx.aol.com ([64.12.137.3] helo=imo-m22.mail.aol.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dbox2alpha@netscape.net>) id 1LJuar-0003mf-29
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 19:54:30 +0100
References: <496204D8.6090602@okg-computer.de><20090105130757.GW12059@titan.makhutov-it.de>
	<49620916.7060704@dark-green.com>
To: gimli@dark-green.com
Date: Mon, 05 Jan 2009 13:53:43 -0500
In-Reply-To: <49620916.7060704@dark-green.com>
MIME-Version: 1.0
From: dbox2alpha@netscape.net
Message-Id: <8CB3D7E10E304E0-1674-1438@WEBMAIL-MY25.sysops.aol.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0056847908=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0056847908==
Content-Type: multipart/alternative;
 boundary="--------MB_8CB3D7E10EEF08E_1674_293F_WEBMAIL-MY25.sysops.aol.com"


----------MB_8CB3D7E10EEF08E_1674_293F_WEBMAIL-MY25.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"


=20


 i can confirm the very same problem symptoms with a technotrend dvb-s2 3600=
 usb device.


=20

-----Original Message-----
From: gimli <gimli@dark-green.com>
To: Artem Makhutov <artem@makhutov.org>
Cc: linux-dvb@linuxtv.org
Sent: Mon, 5 Jan 2009 2:20 pm
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream










Artem Makhutov schrieb:
> Hi,
>=20
> On Mon, Jan 05, 2009 at 02:02:16PM +0100, Jens Krehbiel-Gr=C3=A4ther wrote=
:
>> Hi!
>>
>> I use a Pinnacle USB-Receiver (PCTV Sat HDTV Pro). The module is=20
>> dvb-usb-pctv452e.
>>
>> I use the repository from Igor Liplianin (actual hg release). The module=20
>> compiles and loads fine. The scanning with scan-s2 and zapping with=20
>> szap-s2 also wirk fine.
>> But when I record TV from the USB-device with "cat=20
>> /dev/dvb/adapter0/dvr0 > (filename)" I got the TV-Stream of the actual=20
>> tv-station (zapped with "szap-s2 -r SAT.1" for example).
>> This recorded video has artefacts, even missed frames.
>>
>> Anyone else having this problem? I remember that on multiproto there was=20
>> a similar problem with the pctv452e until Dominik Kuhlen patched=20
>> somthing since then the video was OK. Is it possible that the same=20
>> "error" is in the S2API-driver?
>=20
> I have similar problems with my SkyStar HD (stb0899), but I
> am still using the multiproto drivers.
>=20
> Regards, Artem
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi=3D2
0have also a similar problem on the TerraTec Cinergy S2 PCI HD
with the S2API drivers from the Liplianin tree.

mfg

Edgar (gimli) Hucek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



=20


----------MB_8CB3D7E10EEF08E_1674_293F_WEBMAIL-MY25.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"


<div> <br>
</div>

<div> <font face=3D"Arial, Helvetica, sans-serif">i can confirm the very sam=
e problem symptoms with a technotrend dvb-s2 3600 usb device.<br>
</font></div>

<div> <br>
</div>
-----Original Message-----<br>
From: gimli &lt;gimli@dark-green.com&gt;<br>
To: Artem Makhutov &lt;artem@makhutov.org&gt;<br>
Cc: linux-dvb@linuxtv.org<br>
Sent: Mon, 5 Jan 2009 2:20 pm<br>
Subject: Re: [linux-dvb] S2API (pctv452e) artefacts in video stream<br>
<br>






<div id=3D"AOLMsgPart_0_cd65f49f-62ce-4f6a-ab1e-7d5cca9ff993" style=3D"margi=
n: 0px; font-family: Tahoma,Verdana,Arial,Sans-Serif; font-size: 12px; color=
: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">

<pre style=3D"font-size: 9pt;"><tt>Artem Makhutov schrieb:<br>
&gt; Hi,<br>
&gt; <br>
&gt; On Mon, Jan 05, 2009 at 02:02:16PM +0100, Jens Krehbiel-Gr=C3=A4ther wr=
ote:<br>
&gt;&gt; Hi!<br>
&gt;&gt;<br>
&gt;&gt; I use a Pinnacle USB-Receiver (PCTV Sat HDTV Pro). The module is <b=
r>
&gt;&gt; dvb-usb-pctv452e.<br>
&gt;&gt;<br>
&gt;&gt; I use the repository from Igor Liplianin (actual hg release). The m=
odule <br>
&gt;&gt; compiles and loads fine. The scanning with scan-s2 and zapping with=
 <br>
&gt;&gt; szap-s2 also wirk fine.<br>
&gt;&gt; But when I record TV from the USB-device with "cat <br>
&gt;&gt; /dev/dvb/adapter0/dvr0 &gt; (filename)" I got the TV-Stream of the=20=
actual <br>
&gt;&gt; tv-station (zapped with "szap-s2 -r SAT.1" for example).<br>
&gt;&gt; This recorded video has artefacts, even missed frames.<br>
&gt;&gt;<br>
&gt;&gt; Anyone else having this problem? I remember that on multiproto ther=
e was <br>
&gt;&gt; a similar prob
lem with the pctv452e until Dominik Kuhlen patched <br>
&gt;&gt; somthing since then the video was OK. Is it possible that the same=20=
<br>
&gt;&gt; "error" is in the S2API-driver?<br>
&gt; <br>
&gt; I have similar problems with my SkyStar HD (stb0899), but I<br>
&gt; am still using the multiproto drivers.<br>
&gt; <br>
&gt; Regards, Artem<br>
&gt; <br>
&gt; _______________________________________________<br>
&gt; linux-dvb mailing list<br>
&gt; <a __removedlink__1232922682__href=3D"mailto:linux-dvb@linuxtv.org">lin=
ux-dvb@linuxtv.org</a><br>
&gt; <a __removedlink__1232922682__href=3D"http://www.linuxtv.org/cgi-bin/ma=
ilman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/m=
ailman/listinfo/linux-dvb</a><br>
<br>
Hi have also a similar problem on the TerraTec Cinergy S2 PCI HD<br>
with the S2API drivers from the Liplianin tree.<br>
<br>
mfg<br>
<br>
Edgar (gimli) Hucek<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a __removedlink__1232922682__href=3D"mailto:linux-dvb@linuxtv.org">linux-dv=
b@linuxtv.org</a><br>
<a __removedlink__1232922682__href=3D"http://www.linuxtv.org/cgi-bin/mailman=
/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailma=
n/listinfo/linux-dvb</a><br>
</tt></pre>
</div>
 <!-- end of AOLMsgPart_0_cd65f49f-62ce-4f6a-ab1e-7d5cca9ff993 -->

<div id=3D'MAILCIAMB026-5c3d49625737200' class=3D'aol_ad_footer'><BR/><FONT=20=
style=3D"color: black; font: normal 10pt ARIAL, SAN-SERIF;"><HR  style=3D"MA=
RGIN-TOP: 10px"></HR>Get a <b>free MP3</b> every day with the Spinner.com To=
olbar. <a href=3D"http://toolbar.aol.com/spinner/download.html?ncid=3Demlweu=
sdown00000020">Get it Now</a>. </div>

----------MB_8CB3D7E10EEF08E_1674_293F_WEBMAIL-MY25.sysops.aol.com--


--===============0056847908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0056847908==--
