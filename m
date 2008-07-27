Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s4.bay0.hotmail.com ([65.54.246.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ota1998@hotmail.com>) id 1KNAqQ-00044d-EX
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 20:19:47 +0200
Message-ID: <BAY102-W517C29F3CDEEDB203A1C38BC800@phx.gbl>
From: toy ota <ota1998@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 27 Jul 2008 20:19:11 +0200
In-Reply-To: <mailman.1.1217152801.8804.linux-dvb@linuxtv.org>
References: <mailman.1.1217152801.8804.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] TT S2-3200 lock question
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1617939203=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1617939203==
Content-Type: multipart/alternative;
	boundary="_0efe0828-c375-4d0e-9741-e138b803391a_"

--_0efe0828-c375-4d0e-9741-e138b803391a_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable




Hello=2C

There are on AtlanticBird3 2 TPs used to broadcast signal towards TNT emitt=
ers. (2 TNTs mux are put together in 1 TP).
I can get a lock on AB3 11636V DVB-S but not on 11139V DVB-S2.
My question: card/driver expect what to declare that lock is acquired ?
Does driver says "no lock" if he can't recognize DVB frames ? Does a valid =
PMT or something else is expected ?
Or he says "lock ok" when he can read a stream of unformatted bits ?
I would like to capture bits even if there are not DVB compliant.

Thanks.

PS: it's a shame that there is no doc. available about STB0899.=20


_________________________________________________________________
Emportez vos amis et vos emails partout=85 A la c=F4te=2C en ville ou dans =
le fin fond des Ardennes !
http://windowslivemobile.msn.com/?lang=3Dfr-BE=

--_0efe0828-c375-4d0e-9741-e138b803391a_
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
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
<br><br>Hello=2C<br><br>There are on AtlanticBird3 2 TPs used to broadcast =
signal towards TNT emitters. (2 TNTs mux are put together in 1 TP).<br>I ca=
n get a lock on AB3 11636V DVB-S but not on 11139V DVB-S2.<br>My question: =
card/driver expect what to declare that lock is acquired ?<br>Does driver s=
ays "no lock" if he can't recognize DVB frames ? Does a valid PMT or someth=
ing else is expected ?<br>Or he says "lock ok" when he can read a stream of=
 unformatted bits ?<br>I would like to capture bits even if there are not D=
VB compliant.<br><br>Thanks.<br><br>PS: it's a shame that there is no doc. =
available about STB0899. <br><br><br /><hr />Emportez vos amis et vos email=
s partout=85  <a href=3D'http://windowslivemobile.msn.com/?lang=3Dfr-BE' ta=
rget=3D'_new'>A la c=F4te=2C en ville ou dans le fin fond des Ardennes !</a=
></body>
</html>=

--_0efe0828-c375-4d0e-9741-e138b803391a_--


--===============1617939203==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1617939203==--
