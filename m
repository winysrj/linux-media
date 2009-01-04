Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f10.google.com ([209.85.217.10])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1LJYw6-0008Jo-61
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 20:47:00 +0100
Received: by gxk3 with SMTP id 3so1024623gxk.17
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 11:46:23 -0800 (PST)
Message-ID: <617be8890901041146y2460c8aax61207cc13131c769@mail.gmail.com>
Date: Sun, 4 Jan 2009 20:46:23 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1039518980=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1039518980==
Content-Type: multipart/alternative;
	boundary="----=_Part_201312_9916711.1231098383307"

------=_Part_201312_9916711.1231098383307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: "Alex Betis" <alex.betis@gmail.com>
> To: kedgedev@centrum.cz
> Date: Sat, 3 Jan 2009 22:48:45 +0200
> Subject: Re: [linux-dvb] DVB-S Channel searching problem


Hi,
    I've been more or less following this message thread. I just wanted to
share that I've never been able to perform a succesfult channel scan for
Astra 19.2 with my DVB-S card (which is an Avermedia DVB-S Pro, absolutely
not related to yours, but anyway...).

I suspect that it's some kind of driver problem that makes the card unable
to lock onto any of the frecuencies listed in default dvb-utils supplied
Astra-19.2 file. This file seems to contain a very small set of basic
frecuencies (only 2 im I'm not wrong, at least in Gentoo...). I don't know
if this should be enough, but anyway never worked for me.

However, I discovered a page that seems to maintain a more complete set of
frecuency files. Here you have the link for them:

    http://joshyfun.peque.org/transponders/kaffeine.html

Although they are referred as "Kaffeine" format they are perfectly
compatible with dvb-utils 'scan' program. Give them a try, they worked
perfect for me :D

Best regards,
  Eduard Huguet

------=_Part_201312_9916711.1231098383307
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:&nbsp;&quot;Alex Betis&quot; &lt;<a href="mailto:alex.betis@gmail.com">alex.betis@gmail.com</a>&gt;<br>
To:&nbsp;<a href="mailto:kedgedev@centrum.cz">kedgedev@centrum.cz</a><br>Date:&nbsp;Sat, 3 Jan 2009 22:48:45 +0200<br>Subject:&nbsp;Re: [linux-dvb] DVB-S Channel searching problem</blockquote><div><br>Hi, <br>&nbsp; &nbsp; I&#39;ve been more or less following this message thread. I just wanted to share that I&#39;ve never been able to perform a succesfult channel scan for Astra 19.2 with my DVB-S card (which is an Avermedia DVB-S Pro, absolutely not related to yours, but anyway...).<br>
<br>I suspect that it&#39;s some kind of driver problem that makes the card unable to lock onto any of the frecuencies listed in default dvb-utils supplied Astra-19.2 file. This file seems to contain a very small set of basic frecuencies (only 2 im I&#39;m not wrong, at least in Gentoo...). I don&#39;t know if this should be enough, but anyway never worked for me.<br>
<br>However, I discovered a page that seems to maintain a more complete set of frecuency files. Here you have the link for them:<br><br>&nbsp;&nbsp;&nbsp; <a href="http://joshyfun.peque.org/transponders/kaffeine.html">http://joshyfun.peque.org/transponders/kaffeine.html</a><br>
<br>Although they are referred as &quot;Kaffeine&quot; format they are perfectly compatible with dvb-utils &#39;scan&#39; program. Give them a try, they worked perfect for me :D<br><br>Best regards, <br>&nbsp; Eduard Huguet<br>
<br><br><br><br><br><br><br><br></div></div><br>

------=_Part_201312_9916711.1231098383307--


--===============1039518980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1039518980==--
