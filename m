Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth02.csee.siteprotect.eu ([83.246.86.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1Kbdfm-0004EG-OQ
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 17:56:35 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth02.csee.siteprotect.eu (Postfix) with ESMTP id E3825C6800E
	for <linux-dvb@linuxtv.org>; Fri,  5 Sep 2008 17:56:00 +0200 (CEST)
Message-ID: <48C15690.20706@beardandsandals.co.uk>
Date: Fri, 05 Sep 2008 16:56:00 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48C12136.1060200@beardandsandals.co.uk>
	<48C12A70.2000304@kipdola.com>
In-Reply-To: <48C12A70.2000304@kipdola.com>
Subject: Re: [linux-dvb] [MULTIPROTO PATCH] Allow old apps to use new cards
 (TT-3200)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1492263665=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1492263665==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Jelle De Loecker wrote:
<blockquote cite="mid:48C12A70.2000304@kipdola.com" type="cite">Roger
James schreef:
  <br>
  <blockquote type="cite">This is a rework of the patch posted by Anssi
Hannula some time ago
(<a class="moz-txt-link-freetext" href="http://www.spinics.net/lists/linux-dvb/msg26174.html">http://www.spinics.net/lists/linux-dvb/msg26174.html</a>). It allows an
unpatched application such as gnutv to access cards that only have new
api drivers. The example I have tested is the TT-3200 S2 driver in
Manu's multiproto tree. The patch requires that the new driver has the
default modulation type for old api access to be set in the .type field
of the its frontend info structure. For example for the stb0889
frontend this is.
    <br>
    <br>
&nbsp;....
    <br>
    <br>
The main patch to be applied is wholly to dvb_frontend.c and is given
at the end of this message. I would appreciate if people who are more
familiar with this environment than I am could verify that the approach
is correct. Sorry about the inline patches but I am cutting and pasting
from a terminal into a Linux box which is the wrong side of a firewall.
    <br>
    <br>
Roger
    <br>
  </blockquote>
  <br>
Thank you, Roger!
  <br>
  <br>
I've only decided to use her patch since yesterday (because mythtv
&amp; the new multiproto api really don't go well together) But I had
to use a very old revision of the drivers.
  <br>
I'll try this patch out first thing when I come home.
  <br>
  <br>
Do you know if this patch would allow regular disecq operations?
('Cause even with the old patch it wouldn't work in mythtv)
  <br>
  <br>
Greetings,
  <br>
  <br>
Jelle De Loecker
  <br>
  <br>
</blockquote>
Jelle,<br>
<br>
The neither versions of the patch impact on the DISEQC ioctls. If it
was not working before it may be due to mythtv not sending them.
However if the frontend module does not implement the DISEQC functions
they are just silently ignored. As far as I can see the frontends that
have implementations in the multiproto tree are cx24110, cx24123,
mt213, s5h1420, stb0899 (this is fe on the TT 3200) stv0299, tda10086,
tda8083 and tda80xx( 8044/8083?). Although if have not checked these in
detail.<br>
<br>
Roger<br>
</body>
</html>


--===============1492263665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1492263665==--
