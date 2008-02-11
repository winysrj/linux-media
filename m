Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mx33.mail.ru ([194.67.23.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ua0lnj@bk.ru>) id 1JOiLA-0003gT-Ol
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 00:45:36 +0100
Received: from [85.95.147.36] (port=31331 helo=lnj) by mx33.mail.ru with asmtp
	id 1JOiKd-000FpJ-00
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 02:45:03 +0300
Message-ID: <003a01c86d08$1f9fc730$420619ac@mediatel.mrdv>
From: =?utf-8?B?0J/RgNC40LTQstC+0YDQvtCyINCQ0L3QtNGA0LXQuQ==?= <ua0lnj@bk.ru>
To: "linux-dvb" <linux-dvb@linuxtv.org>
References: <197907.77856.qm@web33115.mail.mud.yahoo.com>
Date: Tue, 12 Feb 2008 09:45:02 +1000
MIME-Version: 1.0
Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor commands
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0637104321=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0637104321==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0037_01C86D5B.F085EF20"

This is a multi-part message in MIME format.

------=_NextPart_000_0037_01C86D5B.F085EF20
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I think, this is becouse "Initial support for Mantis VP-1041" not =
usability yet.
I use patch from Hans Werner for 1041, works better.
  ----- Original Message -----=20
  From: Simeon Simeonov=20
  To: linux-dvb=20
  Sent: Tuesday, February 12, 2008 6:47 AM
  Subject: [linux-dvb] mantis vp1041 with strange diseqc rotor commands


  Hi,

  I am using the latest mantis drivers from Manu's repository:
  http://jusst.de/hg/mantis/
  with my Azureware twinhan vp1041 based card.
  Locking to DVB-S channels works fine almost all the time with the =
patched szap or patched mythtv.
  Did not try DVB-S2 yet. But what I am having troubles now is the =
diseqc. I have a switch behind a diseqc 1.2 rotor (goto stored =
positions).
  The switching works fine under Windoz. I have no problems also using =
it with my other card in the same box - Twinhan 102g.
  Initially with the vp1041 card after a couple of diseqc commands I =
would get stb0899_diseqc_fifo_empy timeout. It turned out that I had to =
use some very long pauses before sending a repeat command. If=20
  for the 102g standart 15ms worked fine, for the vp1041 I had to use =
1s! pause. Then the rotor will start
   moving very slowly with small steps  - as if it is does one step , =
stops and then continues to the desired position.If one is patient =
enough the rotor gets to the desired position. I checked using voltmeter =
the voltages that come out of the card and they seem to be good. For =
sending the commands I used both mythtv and hacked version of Michel =
Verbraak's gotox program.
  Has anyone experienced something similar with stb0899 frontend? =
Perhaps you can give me an idea what might be going wrong?

  Thanks,
  Simeon





        =
_________________________________________________________________________=
___________
  Be a better friend, newshound, and=20
  know-it-all with Yahoo! Mobile.  Try it now.  =
http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ=20


  _______________________________________________
  linux-dvb mailing list
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

------=_NextPart_000_0037_01C86D5B.F085EF20
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BF<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8">
<META content=3D"MSHTML 6.00.6000.16587" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV>I think, this is becouse "<STRONG>Initial support for Mantis =
VP-1041"=20
</STRONG>not usability yet.</DIV>
<DIV>I use patch from Hans Werner for 1041, works better.</DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Dsimeonov_2000@yahoo.com =
href=3D"mailto:simeonov_2000@yahoo.com">Simeon=20
  Simeonov</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Tuesday, February 12, =
2008 6:47=20
  AM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> [linux-dvb] mantis =
vp1041 with=20
  strange diseqc rotor commands</DIV>
  <DIV><BR></DIV>Hi,<BR><BR>I am using the latest mantis drivers from =
Manu's=20
  repository:<BR><A=20
  =
href=3D"http://jusst.de/hg/mantis/">http://jusst.de/hg/mantis/</A><BR>wit=
h my=20
  Azureware twinhan vp1041 based card.<BR>Locking to DVB-S channels =
works fine=20
  almost all the time with the patched szap or patched mythtv.<BR>Did =
not try=20
  DVB-S2 yet. But what I am having troubles now is the diseqc. I have a =
switch=20
  behind a diseqc 1.2 rotor (goto stored positions).<BR>The switching =
works fine=20
  under Windoz. I have no problems also using it with my other card in =
the same=20
  box - Twinhan 102g.<BR>Initially with the vp1041 card after a couple =
of diseqc=20
  commands I would get stb0899_diseqc_fifo_empy timeout. It turned out =
that I=20
  had to use some very long pauses before sending a repeat command. If =
<BR>for=20
  the 102g standart 15ms worked fine, for the vp1041 I had to use 1s! =
pause.=20
  Then the rotor will start<BR>&nbsp;moving very slowly with small =
steps&nbsp; -=20
  as if it is does one step , stops and then continues to the desired=20
  position.If one is patient enough the rotor gets to the desired =
position. I=20
  checked using voltmeter the voltages that come out of the card and =
they seem=20
  to be good. For sending the commands I used both mythtv and hacked =
version of=20
  Michel Verbraak's gotox program.<BR>Has anyone experienced something =
similar=20
  with stb0899 frontend? Perhaps you can give me an idea what might be =
going=20
  =
wrong?<BR><BR>Thanks,<BR>Simeon<BR><BR><BR><BR><BR><BR>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=20
  =
_________________________________________________________________________=
___________<BR>Be=20
  a better friend, newshound, and <BR>know-it-all with Yahoo! =
Mobile.&nbsp; Try=20
  it now.&nbsp; <A=20
  =
href=3D"http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ">htt=
p://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ</A>=20
  =
<BR><BR><BR>_______________________________________________<BR>linux-dvb =

  mailing list<BR><A=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A><BR><A=20
  =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http:/=
/www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A><BR></BLOCKQUOTE><=
/BODY></HTML>

------=_NextPart_000_0037_01C86D5B.F085EF20--



--===============0637104321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0637104321==--
