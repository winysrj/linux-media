Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7b.bullet.ukl.yahoo.com ([217.146.182.217])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KIJh5-0007zT-LY
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 10:46:04 +0200
Date: Mon, 14 Jul 2008 08:45:29 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <646735.31020.qm@web23206.mail.ird.yahoo.com>
Subject: [linux-dvb] problems with multiproto & dvb-s2 with high SR,
	losing parts of stream
Reply-To: newspaperman_germany@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0942722688=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0942722688==
Content-Type: multipart/alternative; boundary="0-1516521856-1216025129=:31020"

--0-1516521856-1216025129=:31020
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Im using TT S2-3200 with recent multiproto driver + vdr-1.7.0.

These transponders aren't working properly:

Hispasat, 30=C2=B0West: 12012H, 30000, 8psk, (3/4 aus NIT)

Hispasat, 30=C2=B0West: 12052H, 30000, 8psk, (3/4 aus NIT)

Hispasat, 30=C2=B0West: 12092H, 30000, 8psk, (3/4 aus NIT)

Thor, 0,8=C2=B0West: 12015H, 30000, 3/4, 8PSK=20

Thor, 0,8=C2=B0West: 12128H, 30000, 3/4, 8PSK
     =20
     =20
     =20
     =20
    =20

first they didn't lock, but then I tried to change SR to 29998 and they did=
..

BUT now part of the stream gets lost. VDRs internal channelsearch can't rea=
d tv channels from that transponder. When setting VPid manually I get a dat=
arate of just 5 Mbit/s (instead of 12 Mbit/s).

Are these transponders working for you?!?

kind regards

Newsy
=0A=0A=0A      __________________________________________________________=
=0AGesendet von Yahoo! Mail.=0ADem pfiffigeren Posteingang.=0Ahttp://de.ove=
rview.mail.yahoo.com
--0-1516521856-1216025129=:31020
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D'0' cellpadding=3D'0' border=3D'0' ><tr><td valign=3D'=
top' style=3D'font: inherit;'>Im using TT S2-3200 with recent multiproto dr=
iver + vdr-1.7.0.<br><br>These transponders aren't working properly:<br>
Hispasat, 30=C2=B0West: 12012H, 30000, 8psk, (3/4 aus NIT)<br>
Hispasat, 30=C2=B0West: 12052H, 30000, 8psk, (3/4 aus NIT)<br>
Hispasat, 30=C2=B0West: 12092H, 30000, 8psk, (3/4 aus NIT)<br>
Thor, 0,8=C2=B0West: 12015H, 30000, 3/4, 8PSK <br>
Thor, 0,8=C2=B0West: 12128H, 30000, 3/4, 8PSK
     =20
     =20
     =20
     =20
     <br><br>first they didn't lock, but then I tried to change SR to 29998=
 and they did.<br><br>BUT now part of the stream gets lost. VDRs internal c=
hannelsearch can't read tv channels from that transponder. When setting VPi=
d manually I get a datarate of just 5 Mbit/s (instead of 12 Mbit/s).<br><br=
>Are these transponders working for you?!?<br><br>kind regards<br><br>Newsy=
<br></td></tr></table><br>=0A=0A=0A=0A      <hr size=3D1>=0AGesendet von <a=
  =0Ahref=3D"http://us.rd.yahoo.com/mailuk/taglines/isp/control/*http://us.=
rd.yahoo.com/evt=3D52427/*http://de.overview.mail.yahoo.com" target=3D_blan=
k>Yahoo! Mail</a>.=0A<br>=0ADem pfiffigeren Posteingang.
--0-1516521856-1216025129=:31020--



--===============0942722688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0942722688==--
