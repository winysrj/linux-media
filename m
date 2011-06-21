Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mutoid@gmail.com>) id 1QYxxf-0000b3-N5
	for linux-dvb@linuxtv.org; Tue, 21 Jun 2011 12:13:36 +0200
Received: from mail-gy0-f182.google.com ([209.85.160.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1QYxxf-00053A-EU; Tue, 21 Jun 2011 12:13:35 +0200
Received: by gyf3 with SMTP id 3so846778gyf.41
	for <linux-dvb@linuxtv.org>; Tue, 21 Jun 2011 03:13:33 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Jun 2011 12:13:32 +0200
Message-ID: <BANLkTi=4Mo4BUhXnL3ALJVzCSBO9TbrY-w@mail.gmail.com>
From: mutoid <mutoid@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] impossible to tune card, but I can watch TV :?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2056185147=="
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============2056185147==
Content-Type: multipart/alternative; boundary=20cf305e252bae43b204a6361a4e

--20cf305e252bae43b204a6361a4e
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I have an Avermedia Super 007, installed in a headless Linux machine to
multicast some TV channels.

I use "mumudvb" and works fine, without problem. I can stream 4 TV channels
and 4 radios at once

But now I need to extract EPG data, using dbvtune and tv_grab_dvb

I tried 2 configurations:

* Kworld USB DVB-T + dvbtune + tv_grab_dvb = works fine

~# dvbtune -c 1 -f 770000
Using DVB card "Afatech AF9013 DVB-T"
tuning DVB-T (in United Kingdom) to 770000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
Getting frontend event
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC
Event:  Frequency: 780600000
        SymbolRate: 0
        FEC_inner:  2

Bit error rate: 0
Signal strength: 51993
SNR: 120
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC


* Avermedia Super 007 + dvbtune = no working

~# dvbtune -c 0 -f 770000
Using DVB card "Philips TDA10046H DVB-T"
tuning DVB-T (in United Kingdom) to 770000000 Hz
polling....
Getting frontend event
FE_STATUS:
polling....
polling....
polling....
polling....

Why can I use dvbtune with one USB card but not with a PCI card?

Thanks.

--20cf305e252bae43b204a6361a4e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<div><br></div><div>I have an=A0Avermedia Super 007, installed in a h=
eadless Linux machine to multicast some TV channels.</div><div><br></div><d=
iv>I use &quot;mumudvb&quot; and works fine, without problem. I can stream =
4 TV channels and 4 radios at once</div>
<div><br></div><div>But now I need to extract EPG data, using dbvtune and t=
v_grab_dvb</div><div><br></div><div>I tried 2 configurations:</div><div><br=
></div><div>* Kworld USB DVB-T + dvbtune +=A0tv_grab_dvb =3D works fine</di=
v>
<div><br></div><div><div>~# dvbtune -c 1 -f 770000</div><div>Using DVB card=
 &quot;Afatech AF9013 DVB-T&quot;</div><div>tuning DVB-T (in United Kingdom=
) to 770000000 Hz</div><div>polling....</div><div>Getting frontend event</d=
iv>
<div>FE_STATUS:</div><div>polling....</div><div>Getting frontend event</div=
><div>FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE=
_HAS_SYNC</div><div>Event: =A0Frequency: 780600000</div><div>=A0 =A0 =A0 =
=A0 SymbolRate: 0</div>
<div>=A0 =A0 =A0 =A0 FEC_inner: =A02</div><div><br></div><div>Bit error rat=
e: 0</div><div>Signal strength: 51993</div><div>SNR: 120</div><div>FE_STATU=
S: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC</div=
></div>
<div><br></div><div><br></div><div>* Avermedia Super 007 + dvbtune =3D no w=
orking=A0</div><div><br></div><div><div>~# dvbtune -c 0 -f 770000</div><div=
>Using DVB card &quot;Philips TDA10046H DVB-T&quot;</div><div>tuning DVB-T =
(in United Kingdom) to 770000000 Hz</div>
<div>polling....</div><div>Getting frontend event</div><div>FE_STATUS:</div=
><div>polling....</div><div>polling....</div></div><div><meta http-equiv=3D=
"content-type" content=3D"text/html; charset=3Dutf-8">polling....</div><div=
><meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dutf-8">p=
olling....</div>
<div><br></div><div>Why can I use dvbtune with one USB card but not with a =
PCI card?</div><div><br></div><div>Thanks.</div><div><br></div><div><br></d=
iv>

--20cf305e252bae43b204a6361a4e--


--===============2056185147==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2056185147==--
