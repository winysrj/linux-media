Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mx39.mail.ru ([194.67.23.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ua0lnj@bk.ru>) id 1JOk9P-0002OM-NF
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 02:41:35 +0100
Message-ID: <006401c86d18$549b3680$420619ac@mediatel.mrdv>
From: =?utf-8?B?0J/RgNC40LTQstC+0YDQvtCyINCQ0L3QtNGA0LXQuQ==?= <ua0lnj@bk.ru>
To: "Simeon Simeonov" <simeonov_2000@yahoo.com>,
	"linux-dvb" <linux-dvb@linuxtv.org>
References: <922065.65936.qm@web33106.mail.mud.yahoo.com>
Date: Tue, 12 Feb 2008 11:41:03 +1000
MIME-Version: 1.0
Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor commands
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1081285937=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1081285937==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0061_01C86D6C.2583CF70"

This is a multi-part message in MIME format.

------=_NextPart_000_0061_01C86D6C.2583CF70
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable


No, not use rotor yet...

  ----- Original Message -----=20
  From: Simeon Simeonov=20
  To: =D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =
=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 ; linux-dvb=20
  Sent: Tuesday, February 12, 2008 11:24 AM
  Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor =
commands


  Thanks =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9,

  Do you have a rotor? If it works OK which program do you use to drive =
it?


  ----- Original Message ----
  From: =D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =
=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 <ua0lnj@bk.ru>
  To: linux-dvb <linux-dvb@linuxtv.org>
  Sent: Monday, February 11, 2008 3:45:02 PM
  Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor =
commands

  =EF=BB=BF=20
  I think, this is becouse "Initial support for Mantis VP-1041" not =
usability yet.
  I use patch from Hans Werner for 1041, works better.
    ----- Original Message -----=20
    From: Simeon Simeonov=20
    To: linux-dvb=20
    Sent: Tuesday, February 12, 2008 6:47 AM
    Subject: [linux-dvb] mantis vp1041 with strange diseqc rotor =
commands


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
    http://www.linuxtv..org/cgi-bin/mailman/listinfo/linux-dvb



  -----Inline Attachment Follows-----

  _______________________________________________
  linux-dvb mailing list
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb




-------------------------------------------------------------------------=
-----
  Looking for last minute shopping deals? Find them fast with Yahoo! =
Search.
------=_NextPart_000_0061_01C86D6C.2583CF70
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BF<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8">
<STYLE type=3Dtext/css>DIV {
	MARGIN: 0px
}
</STYLE>

<META content=3D"MSHTML 6.00.6000.16587" name=3DGENERATOR></HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>No, not use rotor yet...</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
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
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A title=3Dua0lnj@bk.ru=20
  =
href=3D"mailto:ua0lnj@bk.ru">=D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=
=BE=D0=B2 =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9</A> ; <A=20
  title=3Dlinux-dvb@linuxtv.org =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb</A>=20
  </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Tuesday, February 12, =
2008 11:24=20
  AM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] mantis =
vp1041=20
  with strange diseqc rotor commands</DIV>
  <DIV><BR></DIV>
  <DIV=20
  style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman,new =
york,times,serif">
  <DIV=20
  style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman,new =
york,times,serif">Thanks=20
  =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9,<BR><BR>Do you have a rotor? If =
it works OK which program do you use to=20
  drive it?<BR><BR>
  <DIV=20
  style=3D"FONT-SIZE: 12pt; FONT-FAMILY: times new roman,new =
york,times,serif">-----=20
  Original Message ----<BR>From: =
=D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =
=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 &lt;<A=20
  href=3D"mailto:ua0lnj@bk.ru">ua0lnj@bk.ru</A>&gt;<BR>To: linux-dvb =
&lt;<A=20
  =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>&gt;<BR>Se=
nt:=20
  Monday, February 11, 2008 3:45:02 PM<BR>Subject: Re: [linux-dvb] =
mantis vp1041=20
  with strange diseqc rotor commands<BR><BR>=EF=BB=BF=20
  <STYLE></STYLE>

  <DIV>I think, this is becouse "<STRONG>Initial support for Mantis =
VP-1041"=20
  </STRONG>not usability yet.</DIV>
  <DIV>I use patch from Hans Werner for 1041, works better.</DIV>
  <BLOCKQUOTE=20
  style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: rgb(0,0,0) 2px solid; MARGIN-RIGHT: 0px">
    <DIV=20
    style=3D"FONT: 10pt arial; font-size-adjust: none; font-stretch: =
normal">-----=20
    Original Message ----- </DIV>
    <DIV=20
    style=3D"BACKGROUND: rgb(228,228,228) 0% 50%; FONT: 10pt arial; =
font-size-adjust: none; font-stretch: normal; -moz-background-clip: =
-moz-initial; -moz-background-origin: -moz-initial; =
-moz-background-inline-policy: -moz-initial"><B>From:</B>=20
    <A title=3Dsimeonov_2000@yahoo.com =
href=3D"mailto:simeonov_2000@yahoo.com"=20
    target=3D_blank rel=3Dnofollow =
ymailto=3D"mailto:simeonov_2000@yahoo.com">Simeon=20
    Simeonov</A> </DIV>
    <DIV=20
    style=3D"FONT: 10pt arial; font-size-adjust: none; font-stretch: =
normal"><B>To:</B>=20
    <A title=3Dlinux-dvb@linuxtv.org =
href=3D"mailto:linux-dvb@linuxtv.org"=20
    target=3D_blank rel=3Dnofollow=20
    ymailto=3D"mailto:linux-dvb@linuxtv.org">linux-dvb</A> </DIV>
    <DIV=20
    style=3D"FONT: 10pt arial; font-size-adjust: none; font-stretch: =
normal"><B>Sent:</B>=20
    Tuesday, February 12, 2008 6:47 AM</DIV>
    <DIV=20
    style=3D"FONT: 10pt arial; font-size-adjust: none; font-stretch: =
normal"><B>Subject:</B>=20
    [linux-dvb] mantis vp1041 with strange diseqc rotor commands</DIV>
    <DIV><BR></DIV>Hi,<BR><BR>I am using the latest mantis drivers from =
Manu's=20
    repository:<BR><A href=3D"http://jusst.de/hg/mantis/" =
target=3D_blank=20
    rel=3Dnofollow>http://jusst.de/hg/mantis/</A><BR>with my Azureware =
twinhan=20
    vp1041 based card.<BR>Locking to DVB-S channels works fine almost =
all the=20
    time with the patched szap or patched mythtv.<BR>Did not try DVB-S2 =
yet. But=20
    what I am having troubles now is the diseqc. I have a switch behind =
a diseqc=20
    1.2 rotor (goto stored positions).<BR>The switching works fine under =
Windoz.=20
    I have no problems also using it with my other card in the same box =
-=20
    Twinhan 102g.<BR>Initially with the vp1041 card after a couple of =
diseqc=20
    commands I would get stb0899_diseqc_fifo_empy timeout. It turned out =
that I=20
    had to use some very long pauses before sending a repeat command. If =
<BR>for=20
    the 102g standart 15ms worked fine, for the vp1041 I had to use 1s! =
pause.=20
    Then the rotor will start<BR>&nbsp;moving very slowly with small =
steps&nbsp;=20
    - as if it is does one step , stops and then continues to the =
desired=20
    position.If one is patient enough the rotor gets to the desired =
position. I=20
    checked using voltmeter the voltages that come out of the card and =
they seem=20
    to be good. For sending the commands I used both mythtv and hacked =
version=20
    of Michel Verbraak's gotox program.<BR>Has anyone experienced =
something=20
    similar with stb0899 frontend? Perhaps you can give me an idea what =
might be=20
    going=20
    =
wrong?<BR><BR>Thanks,<BR>Simeon<BR><BR><BR><BR><BR><BR>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=20
    =
_________________________________________________________________________=
___________<BR>Be=20
    a better friend, newshound, and <BR>know-it-all with Yahoo! =
Mobile.&nbsp;=20
    Try it now.&nbsp; <A=20
    =
href=3D"http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ"=20
    target=3D_blank=20
    =
rel=3Dnofollow>http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tA=
cJ</A>=20
    =
<BR><BR><BR>_______________________________________________<BR>linux-dvb =

    mailing list<BR><A href=3D"mailto:linux-dvb@linuxtv.org" =
target=3D_blank=20
    rel=3Dnofollow=20
    =
ymailto=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A><BR><A =

    href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb"=20
    target=3D_blank=20
    =
rel=3Dnofollow>http://www.linuxtv..org/cgi-bin/mailman/listinfo/linux-dvb=
</A><BR></BLOCKQUOTE><!-- kill -->
  <DIV><BR><BR>-----Inline Attachment=20
  =
Follows-----<BR><BR>_______________________________________________<BR>li=
nux-dvb=20
  mailing list<BR><A href=3D"mailto:linux-dvb@linuxtv.org"=20
  =
ymailto=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A><BR><A =

  href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb"=20
  =
target=3D_blank>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
</A></DIV></DIV><BR></DIV></DIV><BR>
  <HR SIZE=3D1>
  Looking for last minute shopping deals? <A=20
  =
href=3D"http://us.rd.yahoo.com/evt=3D51734/*http://tools.search.yahoo.com=
/newsearch/category.php?category=3Dshopping">Find=20
  them fast with Yahoo! Search.</A></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_0061_01C86D6C.2583CF70--



--===============1081285937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1081285937==--
