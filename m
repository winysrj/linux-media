Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1LWCPU-00033S-M2
	for linux-dvb@linuxtv.org; Sun, 08 Feb 2009 17:21:33 +0100
Received: by ewy13 with SMTP id 13so2031933ewy.17
	for <linux-dvb@linuxtv.org>; Sun, 08 Feb 2009 08:20:56 -0800 (PST)
Message-ID: <498F0667.50000@gmail.com>
Date: Sun, 08 Feb 2009 17:20:55 +0100
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <4984E294.6020401@gmail.com> <498B7945.4060200@gmail.com>
In-Reply-To: <498B7945.4060200@gmail.com>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Mantis Update was Re: Twinhan DTV Ter-CI (3030
 Mantis) ???
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2078871114=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2078871114==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<br>
Den 2009-02-06 00:41, Manu Abraham skrev:
<blockquote cite="mid:498B7945.4060200@gmail.com" type="cite">
  <pre wrap="">Carl Oscar Ejwertz wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">I was wondering if the support for this card is fixed or is going to be 
fixed in some tree?
I know that there has been support for the card in manu:s Mantis tree 
but hasn't been working for a long time.
For some reason the interface has been disabled in the sourcecode.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Have added initial support for this card, as well as a large
overhaul of the driver for a couple of performance impacts.

Please do test with the latest updates from <a class="moz-txt-link-freetext" href="http://jusst.de/hg/mantis">http://jusst.de/hg/mantis</a>.


Regards,
Manu

  </pre>
</blockquote>
Hi Manu!<br>
<br>
Tried the new drivers but it doesn't work.. I get errors in dmesg.<br>
<br>
[ 1304.254458] Mantis 0000:01:06.0: PCI INT A -&gt; Link[APC1] -&gt;
GSI 16 (level, low) -&gt; IRQ 16<br>
[ 1304.258997] DVB: registering new adapter (Mantis DVB adapter)<br>
[ 1304.676816] Mantis 0000:01:06.0: PCI INT A disabled<br>
[ 1304.678509] Mantis: probe of 0000:01:06.0 failed with error -1<br>
<br>
Is it something easy to fix?
</body>
</html>


--===============2078871114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2078871114==--
