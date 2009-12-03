Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-iw0-f198.google.com ([209.85.223.198])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <leszek@koltunski.pl>) id 1NG6nn-0006Aq-9u
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 09:12:39 +0100
Received: by iwn36 with SMTP id 36so715362iwn.3
	for <linux-dvb@linuxtv.org>; Thu, 03 Dec 2009 00:12:04 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 16:12:04 +0800
Message-ID: <8cd7f1780912030012h609a7a5w72d054ac5749eab1@mail.gmail.com>
From: Leszek Koltunski <leszek@koltunski.pl>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] /dev/dvb/adapter0/net0 <-- what is this for and how to
	use it?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0878459000=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0878459000==
Content-Type: multipart/alternative; boundary=000325579eb2ea17c10479ce8b35

--000325579eb2ea17c10479ce8b35
Content-Type: text/plain; charset=ISO-8859-1

Hello DVB gurus,

I've got a TwinHan DVB-S2 card. I compiled the 'liplianin' drivers and it's
working nicely; thanks for all your work!

One question: in /dev/dvb/adapter0 I can see

leszek@satellite:~$ ls -l /dev/dvb/adapter0/
total 0
crw-rw----+ 1 root video 212, 4 2009-12-02 18:22 ca0
crw-rw----+ 1 root video 212, 0 2009-12-02 18:22 demux0
crw-rw----+ 1 root video 212, 1 2009-12-02 18:22 dvr0
crw-rw----+ 1 root video 212, 3 2009-12-02 18:22 frontend0
crw-rw----+ 1 root video 212, 2 2009-12-02 18:22 net0

What is this 'net0' device and how do I use it? Can I use it to directly
multicast my (FTA) satellite stream to my lan by any chance?

I have found no documentation about this...

--000325579eb2ea17c10479ce8b35
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello DVB gurus,<br><br>I&#39;ve got a TwinHan DVB-S2 card. I compiled the =
&#39;liplianin&#39; drivers and it&#39;s working nicely; thanks for all you=
r work!<br><br>One question: in /dev/dvb/adapter0 I can see<br><br>leszek@s=
atellite:~$ ls -l /dev/dvb/adapter0/<br>
total 0<br>crw-rw----+ 1 root video 212, 4 2009-12-02 18:22 ca0<br>crw-rw--=
--+ 1 root video 212, 0 2009-12-02 18:22 demux0<br>crw-rw----+ 1 root video=
 212, 1 2009-12-02 18:22 dvr0<br>crw-rw----+ 1 root video 212, 3 2009-12-02=
 18:22 frontend0<br>
crw-rw----+ 1 root video 212, 2 2009-12-02 18:22 net0<br><br>What is this &=
#39;net0&#39; device and how do I use it? Can I use it to directly multicas=
t my (FTA) satellite stream to my lan by any chance?<br><br>I have found no=
 documentation about this...<br>

--000325579eb2ea17c10479ce8b35--


--===============0878459000==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0878459000==--
