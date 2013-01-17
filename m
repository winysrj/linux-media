Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <stelios.koroneos@gmail.com>) id 1Tve2Y-0002RN-Lr
	for linux-dvb@linuxtv.org; Thu, 17 Jan 2013 02:13:10 +0100
Received: from mail-ea0-f171.google.com ([209.85.215.171])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Tve2Y-0000bW-EE; Thu, 17 Jan 2013 02:13:10 +0100
Received: by mail-ea0-f171.google.com with SMTP id c13so142642eaa.16
	for <linux-dvb@linuxtv.org>; Wed, 16 Jan 2013 17:13:09 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 17 Jan 2013 03:13:09 +0200
Message-ID: <CAEK=Pet9zJaB0GBrswNeB-21N4+S4r6Jq3ceoNKudm3x-1Co9w@mail.gmail.com>
From: Stelios Koroneos <stelios.koroneos@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Baseband I/Q raw data from dvb-s. Is it possible ?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0970093207=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0970093207==
Content-Type: multipart/alternative; boundary=047d7b3a7ff8b1e0e704d371b2f8

--047d7b3a7ff8b1e0e704d371b2f8
Content-Type: text/plain; charset=ISO-8859-1

Greetings to all !
I am looking for a way to access the raw baseband I/Q either for dvb-s or
dvb-s2 but i am kind of confused if this is possible and with which card.
As far as i can tell the STB0899 demodulator provides this info but i am
not sure if this is available by the driver, or if there are any other
alternatives.

The reason i want to access the I/Q is because i am in the process of
building a high speed random number generator that will use the thermal
noise
 produced by the LNB

Any info,pointers would be highly appreciated

Stelios

--047d7b3a7ff8b1e0e704d371b2f8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Greetings to all !<div>I am looking for a way to access the raw baseband I/=
Q either for dvb-s or dvb-s2 but i am kind of confused if this is possible =
and with which card.</div><div>As far as i can tell the STB0899 demodulator=
 provides this info but i am not sure if this is available by the driver, o=
r if there are any other alternatives.</div>
<div><br></div><div>The reason i want to access the I/Q is because i am in =
the process of building a high speed random number generator that will use =
the thermal noise</div><div>=A0produced by the LNB</div><div><br></div><div=
>
Any info,pointers would be highly appreciated</div><div><br></div><div>Stel=
ios</div><div><br></div>

--047d7b3a7ff8b1e0e704d371b2f8--


--===============0970093207==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0970093207==--
