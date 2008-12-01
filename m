Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web88302.mail.re4.yahoo.com ([216.39.53.225])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aturbide@rogers.com>) id 1L7CQn-0008CX-VJ
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 18:19:36 +0100
Date: Mon, 1 Dec 2008 09:18:52 -0800 (PST)
From: Alain <aturbide@rogers.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <99503.50867.qm@web88302.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] Bug Report - Twinhan vp-1020,
	bt_8xx driver + frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1965127690=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1965127690==
Content-Type: multipart/alternative; boundary="0-495838956-1228151932=:50867"

--0-495838956-1228151932=:50867
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Found the problem I believe.=A0 The original code always ran dvb_frontend_s=
wzigzag(fe) even if the algo=A0 is 0=0AThis fixes the issue for me.=0A=0A--=
- dvb_frontend.c=A0=A0=A0=A0=A0 2008-12-01 12:07:28.000000000 -0500=0A+++ /=
dvb_frontend.c=A0=A0=A0=A0 2008-12-01 12:07:16.000000000 -0500=0A@@ -645,6 =
+645,8 @@=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 default:=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintk(=
"%s: UNDEFINED ALGO !\n", __func__);=0A+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dvb_frontend_swzi=
gzag(fe);=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 } else {=0A=0A=0A=0A=0A=0A________________________________=0A
--0-495838956-1228151932=:50867
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><DIV>
<DIV>Found the problem I believe.&nbsp; The original code always ran dvb_frontend_swzigzag(fe) even if the algo&nbsp; is 0</DIV>
<DIV>This fixes the issue for me.</DIV>
<DIV>&nbsp;</DIV>
<DIV>--- dvb_frontend.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2008-12-01 12:07:28.000000000 -0500<BR>+++ /dvb_frontend.c&nbsp;&nbsp;&nbsp;&nbsp; 2008-12-01 12:07:16.000000000 -0500<BR>@@ -645,6 +645,8 @@<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; default:<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dprintk("%s: UNDEFINED ALGO !\n", __func__);<BR>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 dvb_frontend_swzigzag(fe);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<BR><BR></DIV></DIV>
<DIV style="FONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, times, serif"><BR>
<DIV style="FONT-SIZE: 12pt; FONT-FAMILY: times new roman, new york, times, serif"><FONT face=Tahoma size=2>
<HR SIZE=1>
</FONT></DIV></DIV></div></body></html>
--0-495838956-1228151932=:50867--


--===============1965127690==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1965127690==--
