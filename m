Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dehqan65@gmail.com>) id 1Q4eD8-0007p0-W4
	for linux-dvb@linuxtv.org; Tue, 29 Mar 2011 21:04:16 +0200
Received: from mail-qy0-f182.google.com ([209.85.216.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Q4eD8-0006SO-FH; Tue, 29 Mar 2011 21:04:14 +0200
Received: by qyk27 with SMTP id 27so428731qyk.20
	for <linux-dvb@linuxtv.org>; Tue, 29 Mar 2011 12:04:12 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Mar 2011 23:34:12 +0430
Message-ID: <BANLkTimw3uptgMusYRhZyFCb3ZVD8jj20g@mail.gmail.com>
From: a dehqan <dehqan65@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Questions about some TV viewers
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0347535502=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0347535502==
Content-Type: multipart/alternative; boundary=001636832278c9e7e6049fa3b94c

--001636832278c9e7e6049fa3b94c
Content-Type: text/plain; charset=ISO-8859-1

In The Name Of Allah The compassionate merciful

Good day all
Hello;

1- I(humble) want  alsa "forward" the sound from tvtime to hw:1,0 .How to
map the analog output to the digital output using alsa ?

2 - I(humble) use this command to see a TV channel with VLC :

vlc v4l2:///dev/video0  :input-slave=alsa://hw:1,0 :v4l2-standard=1
:v4l2-tuner-frequency=583250

OR

mplayer -ao alsa -tv
alsa:adevice=hw.1,0:immediatemode=0:forceaudio:chanlist=us-bcast tv://

How to create a list of channels (with different frequencies) in VLC or
Mplayer?

Regards dehqan

--001636832278c9e7e6049fa3b94c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">In The Name Of Allah The compassionate merciful<br><br>Goo=
d day all <br>Hello;<br><br>1- I(humble) want=A0 alsa &quot;forward&quot; t=
he sound from tvtime to hw:1,0 .How to map the analog output to the digital=
 output using alsa ?<br>
<br>2 - I(humble) use this command to see a TV channel with VLC :<code><br>=
<br>vlc v4l2:///dev/video0=A0 :input-slave=3Dalsa://hw:1,0 :v4l2-standard=
=3D1 :v4l2-tuner-frequency=3D583250</code><br><br>OR<br><br>mplayer -ao als=
a -tv alsa:adevice=3Dhw.1,0:immediatemode=3D0:forceaudio:chanlist=3Dus-bcas=
t tv:// <br>
<br> How to create a list of channels (with different frequencies) in VLC o=
r Mplayer?<br><br>Regards dehqan<br></div>

--001636832278c9e7e6049fa3b94c--


--===============0347535502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0347535502==--
