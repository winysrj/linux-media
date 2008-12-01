Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail55.messagelabs.com ([216.82.241.163])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aturbide@rogers.com>) id 1L7GP0-0003U9-J4
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 22:34:01 +0100
Received: from cr344472a (unknown [172.28.23.228])
	by imap1.toshiba.ca (Postfix) with SMTP id 41ED13FC7A
	for <linux-dvb@linuxtv.org>; Mon,  1 Dec 2008 16:25:14 -0500 (EST)
Message-ID: <003301c953fc$84e23110$0000fea9@cr344472a>
From: "Alain Turbide" <aturbide@rogers.com>
To: <linux-dvb@linuxtv.org>
References: <99503.50867.qm@web88302.mail.re4.yahoo.com>
Date: Mon, 1 Dec 2008 16:31:15 -0500
MIME-Version: 1.0
Subject: Re: [linux-dvb] [FIXEd]  Bug Report - Twinhan vp-1020,
	bt_8xx driver + frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0953259766=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0953259766==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0025_01C953D2.3B3EF8B0"

This is a multi-part message in MIME format.

------=_NextPart_000_0025_01C953D2.3B3EF8B0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Digging=20in=20a=20little=20further.The=20dst_algo=20(which=20the=20twinha=
n=20uses)=20is=20set=20to=20return=20=200=20as=20the=20default=20setting=20=
for=20the=20SW=20algo=20in=20dst.c,=20yet=20in=20dvb_frontend.h,=20the=20D=
VBFE_ALGO_SW=20algo=20is=20defined=20as=202.=20=20Which=20is=20the=20corre=
ct=20one=20here?=20Should=20dst.c=20be=20changed=20to=20return=202=20as=20=
sw=20or=20is=200=20the=20correct=20number=20for=20the=20SW=20algo=20and=20=
thus=20DVBFE_ALGO_SW=20be=20changed=20to=20return=200?
=20=20-----=20Original=20Message=20-----=20
=20=20From:=20Alain=20
=20=20To:=20linux-dvb@linuxtv.org=20
=20=20Sent:=20Monday,=20December=2001,=202008=2012:18=20PM
=20=20Subject:=20Re:=20[linux-dvb]=20Bug=20Report=20-=20Twinhan=20vp-1020,=
bt_8xx=20driver=20+=20frontend


=20=20Found=20the=20problem=20I=20believe.=20=20The=20original=20code=20al=
ways=20ran=20dvb_frontend_swzigzag(fe)=20even=20if=20the=20algo=20=20is=20=
0
=20=20This=20fixes=20the=20issue=20for=20me.

=20=20---=20dvb_frontend.c=20=20=20=20=20=202008-12-01=2012:07:28.00000000=
0=20-0500
=20=20+++=20/dvb_frontend.c=20=20=20=20=202008-12-01=2012:07:16.000000000=20=
-0500
=20=20@@=20-645,6=20+645,8=20@@
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20break;
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20default:
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20dprintk("%s:=20UNDEFINED=20ALGO=20!\n",=20__fun=
c__);
=20=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20dvb_frontend_swzigzag(fe);
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20break;
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20}
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20}=20else=20{





--------------------------------------------------------------------------=
----



--------------------------------------------------------------------------=
----


=20=20_______________________________________________
=20=20linux-dvb=20mailing=20list
=20=20linux-dvb@linuxtv.org
=20=20http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

______________________________________________________________________
This=20email=20has=20been=20scanned=20by=20the=20MessageLabs=20Email=20Sec=
urity=20System.
For=20more=20information=20please=20visit=20http://www.messagelabs.com/ema=
il=20
______________________________________________________________________
------=_NextPart_000_0025_01C953D2.3B3EF8B0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE=20HTML=20PUBLIC=20"-//W3C//DTD=20HTML=204.0=20Transitional//EN">=

<HTML><HEAD>
<META=20http-equiv=3DContent-Type=20content=3D"text/html;=20charset=3Diso-=
8859-1">
<STYLE=20type=3Dtext/css>DIV=20{
=09MARGIN:=200px
}
</STYLE>

<META=20content=3D"MSHTML=206.00.6000.16735"=20name=3DGENERATOR></HEAD>
<BODY=20bgColor=3D#ffffff>
<DIV><FONT=20face=3DArial=20size=3D2>Digging=20in=20a=20little=20further.T=
he=20dst_algo=20(which=20
the&nbsp;twinhan=20uses)&nbsp;is=20set=20to=20return=20&nbsp;0=20as=20the=20=
default&nbsp;setting=20
for=20the=20SW=20algo&nbsp;in=20dst.c,=20yet=20in=20dvb_frontend.h,=20the=20=
DVBFE_ALGO_SW=20algo=20is=20
defined=20as=202.&nbsp;=20Which=20is=20the=20correct=20one=20here?=20Shoul=
d=20dst.c=20be=20changed=20to=20
return=202=20as=20sw=20or=20is=200=20the=20correct=20number=20for=20the=20=
SW=20algo=20and=20thus=20DVBFE_ALGO_SW=20
be=20changed=20to=20return=200?</FONT></DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT:=200px;=20PADDING-LEFT:=205px;=20MARGIN-LEFT:=205px=
;=20BORDER-LEFT:=20#000000=202px=20solid;=20MARGIN-RIGHT:=200px">
=20=20<DIV=20style=3D"FONT:=2010pt=20arial">-----=20Original=20Message=20-=
----=20</DIV>
=20=20<DIV=20
=20=20style=3D"BACKGROUND:=20#e4e4e4;=20FONT:=2010pt=20arial;=20font-color=
:=20black"><B>From:</B>=20
=20=20<A=20title=3Daturbide@rogers.com=20href=3D"mailto:aturbide@rogers.co=
m">Alain</A>=20
</DIV>
=20=20<DIV=20style=3D"FONT:=2010pt=20arial"><B>To:</B>=20<A=20title=3Dlinu=
x-dvb@linuxtv.org=20
=20=20href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A>=20</=
DIV>
=20=20<DIV=20style=3D"FONT:=2010pt=20arial"><B>Sent:</B>=20Monday,=20Decem=
ber=2001,=202008=2012:18=20
=20=20PM</DIV>
=20=20<DIV=20style=3D"FONT:=2010pt=20arial"><B>Subject:</B>=20Re:=20[linux=
-dvb]=20Bug=20Report=20-=20
=20=20Twinhan=20vp-1020,bt_8xx=20driver=20+=20frontend</DIV>
=20=20<DIV><BR></DIV>
=20=20<DIV=20
=20=20style=3D"FONT-SIZE:=2012pt;=20FONT-FAMILY:=20times=20new=20roman,=20=
new=20york,=20times,=20serif">
=20=20<DIV>
=20=20<DIV>Found=20the=20problem=20I=20believe.&nbsp;=20The=20original=20c=
ode=20always=20ran=20
=20=20dvb_frontend_swzigzag(fe)=20even=20if=20the=20algo&nbsp;=20is=200</D=
IV>
=20=20<DIV>This=20fixes=20the=20issue=20for=20me.</DIV>
=20=20<DIV>&nbsp;</DIV>
=20=20<DIV>---=20dvb_frontend.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=202008-12-01=
=20
=20=2012:07:28.000000000=20-0500<BR>+++=20/dvb_frontend.c&nbsp;&nbsp;&nbsp=
;&nbsp;=20
=20=202008-12-01=2012:07:16.000000000=20-0500<BR>@@=20-645,6=20+645,8=20
=20=20@@<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=20=20break;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;=20
=20=20default:<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=20=20dprintk("%s:=20UNDEFINED=20ALGO=20!\n",=20
=20=20__func__);<BR>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=20=20dvb_frontend_swzigzag(fe);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
=20
=20=20break;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;=20
=20=20}<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=20=20}=20else=20{<BR><BR></DIV></DIV>
=20=20<DIV=20
=20=20style=3D"FONT-SIZE:=2012pt;=20FONT-FAMILY:=20times=20new=20roman,=20=
new=20york,=20times,=20serif"><BR>
=20=20<DIV=20
=20=20style=3D"FONT-SIZE:=2012pt;=20FONT-FAMILY:=20times=20new=20roman,=20=
new=20york,=20times,=20serif"><FONT=20
=20=20face=3DTahoma=20size=3D2>
=20=20<HR=20SIZE=3D1>
=20=20</FONT></DIV></DIV></DIV>
=20=20<P>
=20=20<HR>

=20=20<P></P>_______________________________________________<BR>linux-dvb=20=
mailing=20
=20=20list<BR>linux-dvb@linuxtv.org<BR>http://www.linuxtv.org/cgi-bin/mail=
man/listinfo/linux-dvb</BLOCKQUOTE>
<BR>
______________________________________________________________________<BR>=

This=20email=20has=20been=20scanned=20by=20the=20MessageLabs=20Email=20Sec=
urity=20System.<BR>
For=20more=20information=20please=20visit=20http://www.messagelabs.com/ema=
il=20<BR>
______________________________________________________________________<BR>=

</BODY></HTML>

------=_NextPart_000_0025_01C953D2.3B3EF8B0--



--===============0953259766==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0953259766==--
