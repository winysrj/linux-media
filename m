Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound1-1.us4.outblaze.com ([208.36.123.129])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <guzowskip@linuxmail.org>) id 1NAElC-0003TT-WD
	for linux-dvb@linuxtv.org; Tue, 17 Nov 2009 04:29:43 +0100
Received: from wfilter3.us4.outblaze.com (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by outbound1-1.us4.outblaze.com (Postfix) with ESMTP id 307B87A061C
	for <linux-dvb@linuxtv.org>; Tue, 17 Nov 2009 03:29:37 +0000 (GMT)
MIME-Version: 1.0
From: guzowskip@linuxmail.org
To: linux-dvb@linuxtv.org
Date: Mon, 16 Nov 2009 21:29:36 -0600
Message-Id: <20091117032936.D7AF71CE833@ws1-6.us4.outblaze.com>
Subject: [linux-dvb] Video lost after OS upgrade
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0382889259=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0382889259==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_125842857663592"

This is a multi-part message in MIME format.

--_----------=_125842857663592
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello all,

I was happily watching TV with mplayer from my cable set-top box via a
Pinnacle HDTV Pro USB Stick and Ubuntu 9.04.=A0

The command I was using and which worked was/is:=A0

mplayer -vo xv tv:// -tv
driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.1,0:norm=3Dntsc:chanlist=
=3Dus-cable:channel=3D3

After ugrading to Ubuntu 9.10, when I launch mplayer with this command, I
get an empty black window with no video or audio.=A0 Any ideas and/or=A0 he=
lp
would be greatly appreciated.

Paul in NW FL, USA

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com!


--_----------=_125842857663592
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

Hello all,<br><br>I was happily watching TV with mplayer from my cable set-=
top box via a Pinnacle HDTV Pro USB Stick and Ubuntu 9.04.&nbsp; <br><br>Th=
e command I was using and which worked was/is:&nbsp; <br><br>mplayer -vo xv=
 tv:// -tv driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.1,0:norm=3Dnts=
c:chanlist=3Dus-cable:channel=3D3<br><br>After ugrading to Ubuntu 9.10, whe=
n I launch mplayer with this command, I get an empty black window with no v=
ideo or audio.&nbsp; Any ideas and/or&nbsp; help would be greatly appreciat=
ed.<br><br>Paul in NW FL, USA<br><br><br>
<div>

</div>
<BR>

--=20
<div>Be Yourself @ mail.com <br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com" target=3D"_bla=
nk">www.mail.com</a>!</div>

--_----------=_125842857663592--



--===============0382889259==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0382889259==--
