Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth02.csee.siteprotect.eu ([83.246.86.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1Kbabz-0006hH-Ci
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 14:40:27 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth02.csee.siteprotect.eu (Postfix) with ESMTP id 1A196C68028
	for <linux-dvb@linuxtv.org>; Fri,  5 Sep 2008 14:39:54 +0200 (CEST)
Message-ID: <48C1289D.90607@beardandsandals.co.uk>
Date: Fri, 05 Sep 2008 13:39:57 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Frontends and phase locked loops
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1286492970=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1286492970==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
I have a question about the dvb api architecture and hardware that has
been puzzling me for some time.<br>
<br>
I had thought the idea of a phase locked loop was that it locked onto
and tracked a frequency compensating for drift in the sending and
receiving apparatus. I had also assumed that most frontends would use
PLL technology. So why do we need to have a in kernel thread to keep
the frontend tuned. I ask this out of curiosity only. I assume that it
is something to do with the nature of the dvb signal (is it spread
spectrum?).<br>
<br>
Roger<br>
<br>
</body>
</html>


--===============1286492970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1286492970==--
