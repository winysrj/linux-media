Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s28.bay0.hotmail.com ([65.54.246.164])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <legssmit@hotmail.com>) id 1MJOz3-0006qQ-Ib
	for linux-dvb@linuxtv.org; Wed, 24 Jun 2009 11:41:38 +0200
Message-ID: <BAY111-W32D2A0319B9EE35C1A7008D1370@phx.gbl>
From: Legs Smit <legssmit@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 24 Jun 2009 09:41:01 +0000
MIME-Version: 1.0
Subject: [linux-dvb] s2-liplianin with TT S2-3600 gives TS continuity errors
 on high (niced!) cpu load
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1500905730=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1500905730==
Content-Type: multipart/alternative;
	boundary="_bb1b0025-c3ed-4af0-8d70-4ded530001d6_"

--_bb1b0025-c3ed-4af0-8d70-4ded530001d6_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


On my 2.6.26.8 kernel=2C vdr-1.7.0 system I am running the current s2-lipli=
anin drivers. VDR is patched with the vdr-1.7.0-s2api-07102008-h264-clean.d=
iff patch.

I have one TT S2-3600 (usb) card=2C 2 TT budget cards=2C and 1 1 TT full fe=
ature (1.3) card on my system.
All works fine=2C BUT when background jobs fill up my system (e.g. Noad=2C =
but also cpuburn-in) I get TS continuity errors on the TT-S2-3600 . The bac=
kground jobs work on lowest (19) priority=2C all others on normal (0) prio.
This ONLY occurs on the USB card=2C all PCI cards have no problems with thi=
s. It seems some part of the communication between the card and VDR is runn=
ing on a priority that is too low...
1) Can anyone confirm this kind of behaviour?2) How can I help to debug thi=
s problem?
I already tried vdr-1.7.5 -> same problemI have used multiproto S2-drivers =
before=2C and I can't remember that I had this problem then...
Thanks all for all this beautiful open source software!!!!!
_________________________________________________________________
Gratis emoticons voor in je Messenger!
http://www.msnmessengerexperience.nl/chuck/=

--_bb1b0025-c3ed-4af0-8d70-4ded530001d6_
Content-Type: text/html; charset="iso-8859-1"
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
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
<div>On my 2.6.26.8 kernel=2C vdr-1.7.0 system I am running the current s2-=
liplianin drivers. VDR is patched with the&nbsp=3Bvdr-1.7.0-s2api-07102008-=
h264-clean.diff patch.<br></div><div><br></div><div>I have one TT S2-3600 (=
usb) card=2C 2 TT budget cards=2C and 1 1 TT full feature (1.3) card on my =
system.</div><div><br></div><div>All works fine=2C BUT when background jobs=
 fill up my system (e.g. Noad=2C but also cpuburn-in) I get TS continuity e=
rrors on the TT-S2-3600 . The background jobs work on lowest (19) priority=
=2C all others on normal (0) prio.</div><div><br></div><div>This ONLY occur=
s on the USB card=2C all PCI cards have no problems with this. It seems som=
e part of the communication between the card and VDR is running on a priori=
ty that is too low...</div><div><br></div><div>1) Can anyone confirm this k=
ind of behaviour?</div><div>2) How can I help to debug this problem?</div><=
div><br></div><div>I already tried vdr-1.7.5 -&gt=3B same problem</div><div=
>I have used multiproto S2-drivers before=2C and I can't remember that I ha=
d this problem then...</div><div><br></div><div>Thanks all for all this bea=
utiful open source software!!!!!</div><br /><hr />Alle tips en trics. <a hr=
ef=3D'http://www.microsoft.com/netherlands/windowslive/Views/tipsItemDetail=
.aspx' target=3D'_new'>Ontdek nu de nieuwe Windows Live</a></body>
</html>=

--_bb1b0025-c3ed-4af0-8d70-4ded530001d6_--


--===============1500905730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1500905730==--
