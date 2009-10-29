Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wp6.coowo.com ([202.133.244.154])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <matthias@tevii.com>) id 1N3Sjm-0004ss-Rx
	for linux-dvb@linuxtv.org; Thu, 29 Oct 2009 12:00:15 +0100
Message-ID: <E5A2419773A64B76B264FC3EEE980F59@JackPC>
From: <matthias@tevii.com>
To: <linux-media@vger.kernel.org>,
	<linux-dvb@linuxtv.org>
References: <267bb6670910290342x2a548ae5ib9122c22aa056f4b@mail.gmail.com>
In-Reply-To: <267bb6670910290342x2a548ae5ib9122c22aa056f4b@mail.gmail.com>
Date: Thu, 29 Oct 2009 18:59:35 +0800
MIME-Version: 1.0
Subject: Re: [linux-dvb] Questions before buying DVB card
Reply-To: linux-media@vger.kernel.org, matthias@tevii.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2076690134=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

這是 MIME 格式的 Multipart 郵件。

--===============2076690134==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0139_01CA58C9.F53EE110"

這是 MIME 格式的 Multipart 郵件。

------=_NextPart_000_0139_01CA58C9.F53EE110
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello dehqan,

Basically S650 & S660 have the same feature except:

S650:
-  CAN Tuner (Conexant chips inside)
- Metal Case
- Loop-through connector

S660:
- Silicon tuner (Montage chips)
-Plastic Housing
-Single Connector

Comparison:
S660 is replacing S650 gradually.
Montage chips consume much less power than Conexant.
So S660 runs much cooler than S650; we feel very confident in using =
plastic housing.=20
Working temperature (S650: 55 degree v.s. S660: under 40 degree)
S660 has auto power off feature (Stop providing power to LNB when =
application software stops)

S660 has the same linux driver as S470 PCIE card supporting kernel =
2.6.30 & 2.6.31
http://mercurial.intuxication.org/hg/s2-liplianin/rev/d0dfe416e0f6

Regards
TeVii
  ----- Original Message -----=20
  From: a dehqan=20
  To: linux-dvb@linuxtv.org ; linux-media@vger.kernel.org=20
  Sent: Thursday, October 29, 2009 6:42 PM
  Subject: [linux-dvb] Questions before buying DVB card


  In The Name Of God The compassionate merciful

  Hello;

  1- What is The best  USB DVB-s/s2 card that works fine in Linux .
  2- Has Tevii (usb dvb) S660 card been tested in Linux  ?if yes in =
which kernel and distro ? In wiki just s650 is mentioed .
  3- What are differences between s650 and s660 cards ?


  Regards dehqan



-------------------------------------------------------------------------=
-----


  _______________________________________________
  linux-dvb users mailing list
  For V4L/DVB development, please use instead =
linux-media@vger.kernel.org
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_0139_01CA58C9.F53EE110
Content-Type: text/html;
	charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Diso-8859-1" =
http-equiv=3DContent-Type>
<META name=3DGENERATOR content=3D"MSHTML 8.00.6001.18828">
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>Hello =
dehqan,</FONT></DIV>
<DIV><FONT =
face=3D&#24494;&#36575;&#27491;&#40657;&#39636;></FONT>&nbsp;</DIV>
<DIV><FONT face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>Basically =
S650 &amp; S660 have the same feature=20
except:<BR><BR>S650:<BR>-&nbsp; CAN Tuner (Conexant chips inside)<BR>- =
Metal=20
Case<BR>- Loop-through connector<BR><BR>S660:<BR>- Silicon tuner =
(Montage=20
chips)<BR>-Plastic Housing<BR>-Single =
Connector<BR><BR>Comparison:<BR>S660=20
is&nbsp;replacing S650 gradually.<BR>Montage chips consume much less =
power than=20
Conexant.<BR>So S660 runs much cooler than S650; we feel very confident =
in using=20
plastic housing. </FONT></DIV>
<DIV><FONT face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>Working =
temperature (S650: 55 degree v.s. S660: under 40=20
degree)<BR>S660 has auto power off feature (Stop providing power to LNB =
when=20
application software stops)</FONT></DIV>
<DIV><FONT =
face=3D&#24494;&#36575;&#27491;&#40657;&#39636;></FONT>&nbsp;</DIV>
<DIV><FONT face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>S660&nbsp;has =
the&nbsp;same linux driver as S470 PCIE card=20
supporting kernel 2.6.30 &amp; 2.6.31<BR></FONT><A=20
title=3Dblocked::http://mercurial.intuxication.org/hg/s2-liplianin/rev/d0=
dfe416e0f6=20
href=3D"http://mercurial.intuxication.org/hg/s2-liplianin/rev/d0dfe416e0f=
6"><FONT=20
face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>http://mercurial.intuxica=
tion.org/hg/s2-liplianin/rev/d0dfe416e0f6</FONT></A><BR></DIV>
<DIV><FONT =
face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>Regards</FONT></DIV>
<DIV><FONT =
face=3D&#24494;&#36575;&#27491;&#40657;&#39636;>TeVii</FONT></DIV>
<BLOCKQUOTE=20
style=3D"BORDER-LEFT: #000000 2px solid; PADDING-LEFT: 5px; =
PADDING-RIGHT: 0px; MARGIN-LEFT: 5px; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt &#26032;&#32048;&#26126;&#39636;">----- =
Original Message ----- </DIV>
  <DIV=20
  style=3D"FONT: 10pt &#26032;&#32048;&#26126;&#39636;; BACKGROUND: =
#e4e4e4; font-color: black"><B>From:</B>=20
  <A title=3Ddehqan65@gmail.com href=3D"mailto:dehqan65@gmail.com">a =
dehqan</A>=20
  </DIV>
  <DIV style=3D"FONT: 10pt &#26032;&#32048;&#26126;&#39636;"><B>To:</B> =
<A title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> ; <A=20
  title=3Dlinux-media@vger.kernel.org=20
  =
href=3D"mailto:linux-media@vger.kernel.org">linux-media@vger.kernel.org</=
A>=20
  </DIV>
  <DIV style=3D"FONT: 10pt =
&#26032;&#32048;&#26126;&#39636;"><B>Sent:</B> Thursday, October 29, =
2009 6:42=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt =
&#26032;&#32048;&#26126;&#39636;"><B>Subject:</B> [linux-dvb] Questions =
before=20
  buying DVB card</DIV>
  <DIV><BR></DIV>In The Name Of God The compassionate=20
  merciful<BR><BR>Hello;<BR><BR>1- What is The best&nbsp; USB DVB-s/s2 =
card that=20
  works fine in Linux .<BR>2- Has Tevii (usb dvb) <A=20
  href=3D"http://www.tevii.com/Products_S660_1.asp">S660</A> card been =
tested in=20
  Linux&nbsp; ?if yes in which kernel and distro ? <A=20
  href=3D"http://linuxtv.org/wiki/index.php/TeVii_S650">In wiki</A> just =
s650 is=20
  mentioed .<BR>3- What are differences between <A=20
  href=3D"http://www.tevii.com/Products_S650_1.asp" =
target=3D_blank>s650</A> and <A=20
  href=3D"http://www.tevii.com/Products_S660_1.asp" =
target=3D_blank>s660</A> cards=20
  ?<BR><BR><BR>Regards dehqan<BR>
  <P>
  <HR>

  <P></P>_______________________________________________<BR>linux-dvb =
users=20
  mailing list<BR>For V4L/DVB development, please use instead=20
  =
linux-media@vger.kernel.org<BR>linux-dvb@linuxtv.org<BR>http://www.linuxt=
v.org/cgi-bin/mailman/listinfo/linux-dvb</BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0139_01CA58C9.F53EE110--




--===============2076690134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2076690134==--
