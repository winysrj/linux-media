Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrew.williams@joratech.com>) id 1KhtBD-0006vU-TH
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 23:42:55 +0200
MIME-Version: 1.0
Date: Tue, 23 Sep 2008 07:42:22 +1000
Content-class: urn:content-classes:message
Message-ID: <546B4176F0487A4CBA62FC16EFC1D9D603D4BC@EXCHANGE.joratech.com>
References: <E57779B45D7559418D2EA8B6EC615674047F0A11@EXCHANGE.joratech.com>
	<546B4176F0487A4CBA62FC16EFC1D9D603D4B9@EXCHANGE.joratech.com>
	<48D7D1D8.4090305@iki.fi>
From: "Andrew Williams" <andrew.williams@joratech.com>
To: "Antti Palosaari" <crope@iki.fi>,
	"Jose Alberto Reguero" <jareguero@telefonica.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) /
	Afatech af9015 missing adapter1
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0747097695=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0747097695==
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C91CFC.189E3F49"
Content-class: urn:content-classes:message

This is a multi-part message in MIME format.

------_=_NextPart_001_01C91CFC.189E3F49
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,=20
=20
Thanks for getting back to me.

From: Antti Palosaari [mailto:crope@iki.fi]
Sent: Tue 23/09/2008 3:11 AM
To: Andrew Williams; Jose Alberto Reguero
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / =
Afatech af9015 missing adapter1



Andrew Williams wrote:
> Good day everybody,
> Apologies if this is in HTML, sending from Outlook Web Access at the =
moment.
>
> I am having a problem with the KWorld PlusTV Dual DVB-T Stick (DVB-T
> 399U) / Afatech af9015 USB stick.
>
<-snip->
>
> Again, thanks for all the good work.

I have disabled 2nd adapter by default recently due to problems.
Enabling 2nd FE causes driver sensitivity problems seen as mosaic pixels
in picture. I don't know if this problem exists all devices... 2nd
adapter can be enabled with module param, modprobe dvb-usb-af9015
dual_mode=3D1 enables it. I will of course enable it by default when
problem is found.

I did small change for GPIO setting to avoid warmboot/coldboot problem
you have seen. Please test.
http://linuxtv.org/hg/~anttip/af9015_test

I also changed mxl5005s tuner RSSI enabled - Jose Alberto has found that
old mxl5005 driver was using it always enabled and therefore better
performance for his hardware.

regards
Antti
--
http://palosaari.fi/

Thank you kindly Antti.
I will try the above and let you know.
=20
Regarding the pixelation:
I have experienced it, but my dvico dual digital 4 rev 2 in the same =
machine was doing it as well.
I bought a distribution amp as my 2 splitters (4 way and 3 way) =
introduced about 12db attenuation.
My signal level has gone to about 75% up from 62% and the dvico is not =
pixelating anymore.
=20
Will try the kworld/afatech from the above =
http://linuxtv.org/hg/~anttip/af9015_test in about 10 hours when I get =
home and
will let you know about the warm booting, dual tuners as well as the =
pixelation and whether teh distribution amp has eliminated it.
=20
Thanks muchly





------_=_NextPart_001_01C91CFC.189E3F49
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">=0A=
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">=0A=
<HTML>=0A=
<HEAD>=0A=
=0A=
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7652.24">=0A=
<TITLE>Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / =
Afatech af9015 missing adapter1</TITLE>=0A=
</HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText65274 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2>Hello, =
</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial size=3D2>Thanks for getting back to =0A=
me.</FONT></DIV></DIV>=0A=
<DIV dir=3Dltr><BR><FONT face=3DTahoma size=3D2><B>From:</B> Antti =
Palosaari =0A=
[mailto:crope@iki.fi]<BR><B>Sent:</B> Tue 23/09/2008 3:11 =
AM<BR><B>To:</B> =0A=
Andrew Williams; Jose Alberto Reguero<BR><B>Cc:</B> =0A=
linux-dvb@linuxtv.org<BR><B>Subject:</B> Re: [linux-dvb] KWorld PlusTV =
Dual =0A=
DVB-T Stick (DVB-T 399U) / Afatech af9015 missing =
adapter1<BR></FONT><BR></DIV>=0A=
<DIV>=0A=
<P><FONT size=3D2>Andrew Williams wrote:<BR>&gt; Good day =
everybody,<BR>&gt; =0A=
Apologies if this is in HTML, sending from Outlook Web Access at the =0A=
moment.<BR>&gt;<BR>&gt; I am having a problem with the KWorld PlusTV =
Dual DVB-T =0A=
Stick (DVB-T<BR>&gt; 399U) / Afatech af9015 USB =
stick.<BR>&gt;<BR></FONT><FONT =0A=
size=3D2>&lt;-snip-&gt;<BR>&gt;<BR>&gt; Again, thanks for all the good =0A=
work.<BR><BR>I have disabled 2nd adapter by default recently due to =0A=
problems.<BR>Enabling 2nd FE causes driver sensitivity problems seen as =
mosaic =0A=
pixels<BR>in picture. I don't know if this problem exists all devices... =0A=
2nd<BR>adapter can be enabled with module param, modprobe =0A=
dvb-usb-af9015<BR>dual_mode=3D1 enables it. I will of course enable it =
by default =0A=
when<BR>problem is found.<BR><BR>I did small change for GPIO setting to =
avoid =0A=
warmboot/coldboot problem<BR>you have seen. Please test.<BR><A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015_test">http://linuxtv.org/hg/=
~anttip/af9015_test</A><BR><BR>I =0A=
also changed mxl5005s tuner RSSI enabled - Jose Alberto has found =
that<BR>old =0A=
mxl5005 driver was using it always enabled and therefore =
better<BR>performance =0A=
for his hardware.<BR><BR>regards<BR>Antti<BR>--<BR><A =0A=
href=3D"http://palosaari.fi/">http://palosaari.fi/</A></FONT></P><FONT =0A=
size=3D2></FONT></DIV>=0A=
<DIV><FONT size=3D2>Thank you kindly Antti.</FONT></DIV>=0A=
<DIV><FONT size=3D2>I will try the above and let you know.</FONT></DIV>=0A=
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV><FONT size=3D2>Regarding the pixelation:</FONT></DIV>=0A=
<DIV><FONT size=3D2>I have experienced it, but my dvico dual digital 4 =
rev 2 in =0A=
the same machine was doing it as well.</FONT></DIV>=0A=
<DIV><FONT size=3D2>I bought a distribution amp as my 2 splitters (4 way =
and 3 =0A=
way) introduced about 12db attenuation.</FONT></DIV>=0A=
<DIV><FONT size=3D2>My signal level has gone to about 75% up from 62% =
and the =0A=
dvico is not pixelating anymore.</FONT></DIV>=0A=
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV><FONT size=3D2>Will try the kworld/afatech from the above <A =0A=
href=3D"http://linuxtv.org/hg/~anttip/af9015_test">http://linuxtv.org/hg/=
~anttip/af9015_test</A>&nbsp;in =0A=
about 10 hours when I get home and</FONT></DIV>=0A=
<DIV><FONT size=3D2>will let you know about the warm booting, dual =
tuners&nbsp;as =0A=
well as the pixelation and whether teh distribution amp has eliminated =0A=
it.</FONT></DIV>=0A=
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV><FONT size=3D2>Thanks muchly</DIV>=0A=
<P><BR></P></FONT>=0A=
=0A=
</BODY>=0A=
</HTML>
------_=_NextPart_001_01C91CFC.189E3F49--


--===============0747097695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0747097695==--
