Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KCu9K-0006JS-FS
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 12:28:51 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	B4CF01800132
	for <linux-dvb@linuxtv.org>; Sun, 29 Jun 2008 10:28:14 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: linux-dvb@linuxtv.org
Date: Sun, 29 Jun 2008 20:28:14 +1000
Message-Id: <20080629102814.9177D11581F@ws1-7.us4.outblaze.com>
Subject: Re: [linux-dvb] Tuning problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1291473089=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1291473089==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121473529423232"

This is a multi-part message in MIME format.

--_----------=_121473529423232
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Ian,



Try updating to the latest scan file from the dvb-apps mercurial.=20=20

Channel 7 have changed their parameters in the last year and some tuners au=
tomatically try other combinations then instructed, that is why it is worki=
ng with one and not the other.

The new Channel 7 parameters are:
# Seven
T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE

As for the SBS problem it might be just poor reception or the tuner wasn't =
designed for the Australian frequencies correctly.

Regards,
Stephen.



<Original  Message>
Dear Linux-DVBers,

I now own two USB DVB-T receivers (dongles): a Gigabyte U7000-RH and a
digitalNow tinyUSB2.

I use them on my Kubuntu 7.10 workstation.

I've had the digitalNow for a year or so and it has been working fine
(and easy to get going) with kaffeine except that I couldn't receive SBS
reliably (in Adelaide, Australia) although I was able to tune to it from
time to time. With the Tour de France starting next week (coverage
broadcast by SBS), I took a punt yesterday and bought a Gigabyte
U7000-RH and, yes, it too was easy to get going, and, luckily, receives
SBS nicely -but it can't tune to Channel 7 at all!

My kaffeine installation now has a channel list that covers all the
local terrestrial TV stations. If I connect the digitalNow device, I can
watch 2, 9, 7 & 10 and if I connect the Gigabyte device I can watch SBS,
2, 9 and 10.

I'm presuming that means that by channel tuning data is OK. I don't know
whether it's relevant, but I notice that SBS seems to be the highest
frequency local station and Channel Seven seems to be the lowest. There
seems to be a problem with both devices at the opposite ends of the
frequency range.

Any suggestions? (other the juggling the two devices!)

bye

ian

     # Australia / Adelaide / Mt Lofty
     # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarc=
hy
     # ABC
     T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
     # Seven
     T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
     # Nine
     T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
     # Ten
     T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
     # SBS
     T 564500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121473529423232
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
<span id=3D"obmessage"><pre>Ian,<br><br>Try updating to the latest scan fil=
e from the dvb-apps mercurial.  <br><br>Channel 7 have changed their parame=
ters in the last year and some tuners automatically try other combinations =
then instructed, that is why it is working with one and not the other.<br><=
br>The new Channel 7 parameters are:<br># Seven<br>T 177500000 7MHz 3/4 NON=
E QAM64 8k 1/16 NONE<br><br>As for the SBS problem it might be just poor re=
ception or the tuner wasn't designed for the Australian frequencies correct=
ly.<br><br>Regards,<br>Stephen.<br><br><br><br>&lt;Original  Message&gt;<br=
>Dear Linux-DVBers,<br><br>I now own two USB DVB-T receivers (dongles): a G=
igabyte U7000-RH and a<br>digitalNow tinyUSB2.<br><br>I use them on my Kubu=
ntu 7.10 workstation.<br><br>I've had the digitalNow for a year or so and i=
t has been working fine<br>(and easy to get going) with kaffeine except tha=
t I couldn't receive SBS<br>reliably (in Adelaide, Australia) although I wa=
s able to tune to it from<br>time to time. With the Tour de France starting=
 next week (coverage<br>broadcast by SBS), I took a punt yesterday and boug=
ht a Gigabyte<br>U7000-RH and, yes, it too was easy to get going, and, luck=
ily, receives<br>SBS nicely -but it can't tune to Channel 7 at all!<br><br>=
My kaffeine installation now has a channel list that covers all the<br>loca=
l terrestrial TV stations. If I connect the digitalNow device, I can<br>wat=
ch 2, 9, 7 &amp; 10 and if I connect the Gigabyte device I can watch SBS,<b=
r>2, 9 and 10.<br><br>I'm presuming that means that by channel tuning data =
is OK. I don't know<br>whether it's relevant, but I notice that SBS seems t=
o be the highest<br>frequency local station and Channel Seven seems to be t=
he lowest. There<br>seems to be a problem with both devices at the opposite=
 ends of the<br>frequency range.<br><br>Any suggestions? (other the jugglin=
g the two devices!)<br><br>bye<br><br>ian<br><br>     # Australia / Adelaid=
e / Mt Lofty<br>     # T freq bw fec_hi fec_lo mod transmission-mode guard-=
interval hierarchy<br>     # ABC<br>     T 226500000 7MHz 3/4 NONE QAM64 8k=
 1/16 NONE<br>     # Seven<br>     T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 =
NONE<br>     # Nine<br>     T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE<br=
>     # Ten<br>     T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE<br>     # =
SBS<br>     T 564500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE<br><br><br></pre></=
span></div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121473529423232--



--===============1291473089==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1291473089==--
