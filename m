Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mindphlux@gmail.com>) id 1KLFlh-0008Fq-Sb
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 13:10:58 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1416769fka.1
	for <linux-dvb@linuxtv.org>; Tue, 22 Jul 2008 04:10:54 -0700 (PDT)
Message-ID: <b1539db60807220410o5168bddfo9343a6e856bcc5c4@mail.gmail.com>
Date: Tue, 22 Jul 2008 13:10:53 +0200
From: "Daniel Herda" <mindphlux@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Bad UNCs (bad Signal) on KNC1 TV Station DVB-S2
	(STB0899)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0412925099=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0412925099==
Content-Type: multipart/alternative;
	boundary="----=_Part_62582_21515204.1216725054010"

------=_Part_62582_21515204.1216725054010
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I recently bought a KNC1 TV Station with the STB0899 Chipset. I compiled the
latest multiproto and patched scan and szap2 accordingly. Scanning works
fine, zapping works too.

However, it looks like the signal I am getting is very very bad, e.g szap2
tells me:

status 1e | signal 00b8 | snr 00ba | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

I think this is the reason why my mythtv (also with DVB-S2 patches applied)
is producing lots of artifacts and jitters. Really unwatchable.

Does the "fffffffe" really indicate that there has been that many
uncorrectable blocks, or is it really a driver issue that outputs fffffffe
instead of 0?

Are there any patches that I can apply to make tuning better?

Thank you!

Kind Regards,
Daniel

------=_Part_62582_21515204.1216725054010
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hello,<br><br>I recently bought a KNC1 TV Station with the STB0899 Chipset. I compiled the latest multiproto and patched scan and szap2 accordingly. Scanning works fine, zapping works too.<br><br>However, it looks like the signal I am getting is very very bad, e.g szap2 tells me:<br>
<br>status 1e | signal 00b8 | snr 00ba | ber 00000000 | unc fffffffe | FE_HAS_LOCK<br><br>I think this is the reason why my mythtv (also with DVB-S2 patches applied) is producing lots of artifacts and jitters. Really unwatchable.<br>
<br>Does the &quot;fffffffe&quot; really indicate that there has been that many uncorrectable blocks, or is it really a driver issue that outputs fffffffe instead of 0?<br><br>Are there any patches that I can apply to make tuning better?<br>
<br>Thank you!<br><br>Kind Regards,<br>Daniel<br><br><br><br><br></div>

------=_Part_62582_21515204.1216725054010--


--===============0412925099==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0412925099==--
