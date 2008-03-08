Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1JY8W8-00060s-Fg
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 00:31:53 +0100
Received: from server42.ukservers.net (localhost.localdomain [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with ESMTP id F3BE8A71BB
	for <linux-dvb@linuxtv.org>; Sat,  8 Mar 2008 23:31:15 +0000 (GMT)
Received: from localhost (localhost [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with SMTP id 0AAD4A71B7
	for <linux-dvb@linuxtv.org>; Sat,  8 Mar 2008 23:31:14 +0000 (GMT)
Message-ID: <084701c88174$812f0170$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 9 Mar 2008 12:31:04 +1300
MIME-Version: 1.0
Subject: [linux-dvb] Signal strength via SNMP?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0447539309=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0447539309==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0842_01C881E1.7156FC90"

This is a multi-part message in MIME format.

------=_NextPart_000_0842_01C881E1.7156FC90
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi

I'd like to graph the cable dvb-c signal strength in cacti.

Has anyone done this, or can recommend how?  If I walk the snmp =
variables exposed, there doesn't appear to be anything useful natively =
there?


snmpwalk -c public -v 1 localhost | grep dvb
HOST-RESOURCES-MIB::hrSWRunName.3576 =3D STRING: "kdvb-ca-0:0"
HOST-RESOURCES-MIB::hrSWRunName.24833 =3D STRING: "kdvb-fe-0"
HOST-RESOURCES-MIB::hrSWRunPath.3576 =3D STRING: "kdvb-ca-0:0"
HOST-RESOURCES-MIB::hrSWRunPath.24833 =3D STRING: "kdvb-fe-0"
HOST-RESOURCES-MIB::hrSWRunParameters.14466 =3D STRING: "dvb"

snmpwalk -c public -v 1 localhost | grep DVB
HOST-RESOURCES-MIB::hrSWRunParameters.14470 =3D STRING: "DVB"



Any thoughts?
------=_NextPart_000_0842_01C881E1.7156FC90
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.3268" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I'd like to graph the cable dvb-c =
signal strength=20
in cacti.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Has anyone done this, or can recommend =
how?&nbsp;=20
If I walk the snmp variables exposed, there doesn't appear to be =
anything useful=20
natively there?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>snmpwalk -c public -v 1 localhost | =
grep=20
dvb<BR>HOST-RESOURCES-MIB::hrSWRunName.3576 =3D STRING:=20
"kdvb-ca-0:0"<BR>HOST-RESOURCES-MIB::hrSWRunName.24833 =3D STRING:=20
"kdvb-fe-0"<BR>HOST-RESOURCES-MIB::hrSWRunPath.3576 =3D STRING:=20
"kdvb-ca-0:0"<BR>HOST-RESOURCES-MIB::hrSWRunPath.24833 =3D STRING:=20
"kdvb-fe-0"<BR>HOST-RESOURCES-MIB::hrSWRunParameters.14466 =3D STRING:=20
"dvb"<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>snmpwalk -c public -v 1 localhost | =
grep=20
DVB<BR>HOST-RESOURCES-MIB::hrSWRunParameters.14470 =3D STRING:=20
"DVB"<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Any =
thoughts?</DIV></FONT></BODY></HTML>

------=_NextPart_000_0842_01C881E1.7156FC90--



--===============0447539309==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0447539309==--
