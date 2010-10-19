Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tonelli.francesco82@gmail.com>) id 1P882H-0005E7-Iy
	for linux-dvb@linuxtv.org; Tue, 19 Oct 2010 10:59:09 +0200
Received: from mail-bw0-f54.google.com ([209.85.214.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P882H-0003V4-0B; Tue, 19 Oct 2010 10:59:09 +0200
Received: by bwz15 with SMTP id 15so60788bwz.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Oct 2010 01:59:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Oct 2010 10:59:08 +0200
Message-ID: <AANLkTinxN0xNihc0GcZQ8DxXYMzonLEBJKAZMM5kNEhW@mail.gmail.com>
From: Francesco Tonelli <tonelli.francesco82@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] w_scan
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0569348974=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============0569348974==
Content-Type: multipart/alternative; boundary=00504502d9ff781b7b0492f481a9

--00504502d9ff781b7b0492f481a9
Content-Type: text/plain; charset=ISO-8859-1

Hello everybody.

I have some problem to use w_scan application.

I have got a server with two DVB cards (terrestrial and satellite).

I would like to scan frequencies and tuning some satellite channel and save
the output in a file (channel.conf for example) and lately to view the
streams with Kaffeine or VLC.

My location is out of Barcelona city, Spain.

I started with:

root@SERVER-DVB:/home/dvb# *w_scan -fs -s S19E2*

and the output is:

w_scan version 20091230 (compiled for DVB API 5.1)
using settings for 19.2 east Astra 1F/1G/1H/1KR/1L
frontend_type DVB-S, channellist 6
output format vdr-1.6
Info: using DVB adapter auto detection.
    /dev/dvb/adapter0/frontend0 -> DVB-S "ST STV0299 DVB-S": good :-)
    /dev/dvb/adapter1/frontend0 -> DVB-T "Conexant CX22702 DVB-T": specified
was DVB-S -> SEARCH NEXT ONE.
Using DVB-S frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 3.2
frontend ST STV0299 DVB-S supports
INVERSION_AUTO
DVB-S
using LNB "UNIVERSAL"
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
(time: 00:00) set_frontend:1631: ERROR: Setting frontend parameters failed
(API v3.2)
: 22 Invalid argument

initial_tune:2077: Setting frontend failed S  f = 10714 kHz H SR = 22000
5/6 0,35  QPSK
(time: 00:01) set_frontend:1631: ERROR: Setting frontend parameters failed
(API v3.2)
: 22 Invalid argument

initial_tune:2077: Setting frontend failed S  f = 10729 kHz V SR = 22000
5/6 0,35  QPSK
(time: 00:01) set_frontend:1631: ERROR: Setting frontend parameters failed
(API v3.2)
: 22 Invalid argument

initial_tune:2077: Setting frontend failed S  f = 10744 kHz H SR = 22000
5/6 0,35  QPSK
(time: 00:01) set_frontend:1631: ERROR: Setting frontend parameters failed
(API v3.2)
: 22 Invalid argument

[...........]


Anyone can help me?

Thanks!

--00504502d9ff781b7b0492f481a9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello everybody.<br><br>I have some problem to use w_scan application.<br><=
br>I have got a server with two DVB cards (terrestrial and satellite).<br><=
br>I would like to scan frequencies and tuning some satellite channel and s=
ave the output in a file (channel.conf for example) and lately to view the =
streams with Kaffeine or VLC.<br>
<br>My location is out of Barcelona city, Spain.<br><br>I started with: <br=
><br>root@SERVER-DVB:/home/dvb# <b>w_scan -fs -s S19E2</b><br><br>and the o=
utput is:<br><br>w_scan version 20091230 (compiled for DVB API 5.1)<br>
using settings for 19.2 east Astra 1F/1G/1H/1KR/1L<br>frontend_type DVB-S, =
channellist 6<br>output format vdr-1.6<br>Info: using DVB adapter auto dete=
ction.<br>=A0=A0=A0 /dev/dvb/adapter0/frontend0 -&gt; DVB-S &quot;ST STV029=
9 DVB-S&quot;: good :-)<br>
=A0=A0=A0 /dev/dvb/adapter1/frontend0 -&gt; DVB-T &quot;Conexant CX22702 DV=
B-T&quot;: specified was DVB-S -&gt; SEARCH NEXT ONE.<br>Using DVB-S fronte=
nd (adapter /dev/dvb/adapter0/frontend0)<br>-_-_-_-_ Getting frontend capab=
ilities-_-_-_-_ <br>
Using DVB API 3.2<br>frontend ST STV0299 DVB-S supports<br>INVERSION_AUTO<b=
r>DVB-S<br>using LNB &quot;UNIVERSAL&quot;<br>-_-_-_-_-_-_-_-_-_-_-_-_-_-_-=
_-_-_-_-_-_-_-_-_ <br>(time: 00:00) set_frontend:1631: ERROR: Setting front=
end parameters failed (API v3.2)<br>
: 22 Invalid argument<br><br>initial_tune:2077: Setting frontend failed S=
=A0 f =3D 10714 kHz H SR =3D 22000=A0 5/6 0,35=A0 QPSK<br>(time: 00:01) set=
_frontend:1631: ERROR: Setting frontend parameters failed (API v3.2)<br>: 2=
2 Invalid argument<br>
<br>initial_tune:2077: Setting frontend failed S=A0 f =3D 10729 kHz V SR =
=3D 22000=A0 5/6 0,35=A0 QPSK<br>(time: 00:01) set_frontend:1631: ERROR: Se=
tting frontend parameters failed (API v3.2)<br>: 22 Invalid argument<br><br=
>initial_tune:2077: Setting frontend failed S=A0 f =3D 10744 kHz H SR =3D 2=
2000=A0 5/6 0,35=A0 QPSK<br>
(time: 00:01) set_frontend:1631: ERROR: Setting frontend parameters failed =
(API v3.2)<br>: 22 Invalid argument<br><br>[...........]<br><br><br>Anyone =
can help me?<br><br>Thanks!<br><br>

--00504502d9ff781b7b0492f481a9--


--===============0569348974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0569348974==--
