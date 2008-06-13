Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s14.blu0.hotmail.com ([65.55.116.89])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark1344@hotmail.de>) id 1K7C8A-0007bl-8o
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 18:28:03 +0200
Message-ID: <BLU138-W2192CC104E6C0B94581EF2B8AC0@phx.gbl>
From: Mark H <mark1344@hotmail.de>
To: <linux-dvb@linuxtv.org>
Date: Fri, 13 Jun 2008 18:27:17 +0200
In-Reply-To: <1213306648l.7615l.1l@manu-laptop>
References: <BLU138-W23877FC9494783EB764EF9B8AD0@phx.gbl>
	<1213306648l.7615l.1l@manu-laptop>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Re :  LinuxDVB for STi7109
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0763955156=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0763955156==
Content-Type: multipart/alternative;
	boundary="_978cb4c5-51d5-4abb-8704-703c73680e7d_"

--_978cb4c5-51d5-4abb-8704-703c73680e7d_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


> Well if they run linux I dont see how they can provide a proprietary=20
> implementation... I guess the shortest to get support on linux is to=20
> ask them to release the source code!
I know there are many controversial discussions with respect to closed sour=
ce
projects for Linux. The fact is that ST Microelectronics has implemented ke=
rnel
modules with a proprietary interface (STAPI) for the DVB and is not willing=
 to
disclose the interface details to open source projects. On the other hand S=
TM
provides STLinux distribution for boards based on STi7109 & Co. This distri=
bution
contains open source drivers only the output part of the system (V4Land ALS=
A).

A copy of the chip datasheet is available on the web. Though, its legality =
is questionnable.

There have been some questions about the API two years ago so I was wonderi=
ng
whether anybody has started working on an implementation.

Regards,
Mark

_________________________________________________________________
Windows Live Messenger: Direkter Zugriff auf Ihre E-Mails! Ohne Neuanmeldun=
g!
http://get.live.com/de-de/messenger/overview=

--_978cb4c5-51d5-4abb-8704-703c73680e7d_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt;
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
&gt; Well if they run linux I dont see how they can provide a proprietary <=
br>&gt; implementation... I guess the shortest to get support on linux is t=
o <br>&gt; ask them to release the source code!<br>I know there are many co=
ntroversial discussions with respect to closed source<br>projects for Linux=
. The fact is that ST Microelectronics has implemented kernel<br>modules wi=
th a proprietary interface (STAPI) for the DVB and is not willing to<br>dis=
close the interface details to open source projects. On the other hand STM<=
br>provides STLinux distribution for boards based on STi7109 &amp; Co. This=
 distribution<br>contains open source drivers only the output part of the s=
ystem (V4Land ALSA).<br><br>A copy of the chip datasheet is available on th=
e web. Though, its legality is questionnable.<br><br>There have been some q=
uestions about the API two years ago so I was wondering<br>whether anybody =
has started working on an implementation.<br><br>Regards,<br>Mark<br><br />=
<hr />Windows Live Messenger <a href=3D'http://redirect.gimas.net/?cat=3Dhm=
tl&n=3DM0804WLM&d=3Dhttp://get.live.com/de-de/messenger/overview' target=3D=
'_new'>Automatisch =FCber neue E-Mails informiert!</a></body>
</html>=

--_978cb4c5-51d5-4abb-8704-703c73680e7d_--


--===============0763955156==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0763955156==--
