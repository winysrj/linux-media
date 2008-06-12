Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K6uoU-00088L-Hl
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 23:58:37 +0200
Received: from [10.1.2.1] (unknown [80.123.101.150])
	by bsmtp.bon.at (Postfix) with ESMTP id B03CCCDF90
	for <linux-dvb@linuxtv.org>; Thu, 12 Jun 2008 23:58:00 +0200 (CEST)
Message-ID: <48519BEB.3030609@schoeller-soft.net>
Date: Thu, 12 Jun 2008 23:58:03 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200806071627.30907.dkuhlen@gmx.net>	<484C056E.7010002@schoeller-soft.net>
	<200806092248.01786.dkuhlen@gmx.net>
In-Reply-To: <200806092248.01786.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0309718210=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0309718210==
Content-Type: multipart/alternative;
 boundary="------------070308040908060500080907"

This is a multi-part message in MIME format.
--------------070308040908060500080907
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Dominik Kuhlen schrieb:
> Hmm, this is strange. looks like you are using old drivers or old 
> dvb-core module that doesn't support the new ioctls
> Did you load the modules with
> insmod ./dvb-core.ko
> insmod ./dvb-usb.ko
> insmod ./lnbp22.ko
> insmod ./stb0899.ko
> insmod ./stb6100.ko
> insmod ./dvb-usb-pctv452e.ko
> to be sure that no old/other modules were used?
>
>   

Yes, I did as described. I also checked if no old modules are loaded. 
Just do be sure I downloaded the newest kernel from the PS3-kernel tree 
and compiled it before following the step by step how to.

However the error is still the same.
Well I try a shoot into the blue and say this is a compatibility problem 
of the code with the ppc architecture. Since this is the only 
significant difference I can think of.

Michael

--------------070308040908060500080907
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Dominik Kuhlen schrieb:
<blockquote cite="mid:200806092248.01786.dkuhlen@gmx.net" type="cite"><!---->Hmm,
this is strange. looks like you are using old drivers or old dvb-core
module that doesn't support the new ioctls<br>
  <pre wrap="">Did you load the modules with
insmod ./dvb-core.ko
insmod ./dvb-usb.ko
insmod ./lnbp22.ko
insmod ./stb0899.ko
insmod ./stb6100.ko
insmod ./dvb-usb-pctv452e.ko
to be sure that no old/other modules were used?

  </pre>
</blockquote>
<br>
Yes, I did as described. I also checked if no old modules are loaded.
Just do be sure I downloaded the newest kernel from the PS3-kernel tree
and compiled it before following the step by step how to.<br>
<br>
However the error is still the same.<br>
Well I try a shoot into the blue and say this is a compatibility
problem of the code with the ppc architecture. Since this is the only
significant difference I can think of.<br>
<br>
Michael<br>
</body>
</html>

--------------070308040908060500080907--


--===============0309718210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0309718210==--
