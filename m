Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bsmtp.bon.at ([213.33.87.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.schoeller@schoeller-soft.net>)
	id 1K8DjK-0006jI-PZ
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 14:22:41 +0200
Received: from [10.1.2.1] (unknown [80.123.101.150])
	by bsmtp.bon.at (Postfix) with ESMTP id 818F2CDFD0
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 14:22:01 +0200 (CEST)
Message-ID: <48565AE7.2010404@schoeller-soft.net>
Date: Mon, 16 Jun 2008 14:21:59 +0200
From: =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200806071627.30907.dkuhlen@gmx.net>	<484C056E.7010002@schoeller-soft.net>	<200806092248.01786.dkuhlen@gmx.net>
	<48519BEB.3030609@schoeller-soft.net>
In-Reply-To: <48519BEB.3030609@schoeller-soft.net>
Subject: Re: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1689714292=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1689714292==
Content-Type: multipart/alternative;
 boundary="------------090502050705060306030903"

This is a multi-part message in MIME format.
--------------090502050705060306030903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

I did an other test and compiled an new kernel Version 2.6.26-rc5 from=20
the ps3 kernel tree and disabled all video 4 linux and dvb support in=20
the kernel. After that I dried that step by step howto again. With the=20
same result. So I was thinking maybe thats exactly the wrong way and=20
someone is missing...are there any optins in the "Device=20
Driver->multimedia device" tabs that must be enabled so that the hole=20
stuff works.

BTW I noticed an really odd message when compiling multiproto drivers. I=20
don't know remember exactly but It goes something like "VIDEO PLANB:=20
need at leas kernel version 2.6.99".

I hope someone can finally help me.

Michael

Michael Sch=F6ller schrieb:
> Dominik Kuhlen schrieb:
>> Hmm, this is strange. looks like you are using old drivers or old=20
>> dvb-core module that doesn't support the new ioctls
>> Did you load the modules with
>> insmod ./dvb-core.ko
>> insmod ./dvb-usb.ko
>> insmod ./lnbp22.ko
>> insmod ./stb0899.ko
>> insmod ./stb6100.ko
>> insmod ./dvb-usb-pctv452e.ko
>> to be sure that no old/other modules were used?
>>
>>  =20
>
> Yes, I did as described. I also checked if no old modules are loaded.=20
> Just do be sure I downloaded the newest kernel from the PS3-kernel=20
> tree and compiled it before following the step by step how to.
>
> However the error is still the same.
> Well I try a shoot into the blue and say this is a compatibility=20
> problem of the code with the ppc architecture. Since this is the only=20
> significant difference I can think of.
>
> Michael
> -----------------------------------------------------------------------=
-
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--------------090502050705060306030903
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
  <title></title>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
I did an other test and compiled an new kernel Version 2.6.26-rc5 from
the ps3 kernel tree and disabled all video 4 linux and dvb support in
the kernel. After that I dried that step by step howto again. With the
same result. So I was thinking maybe thats exactly the wrong way and
someone is missing...are there any optins in the "Device
Driver-&gt;multimedia device" tabs that must be enabled so that the
hole stuff works.<br>
<br>
BTW I noticed an really odd message when compiling multiproto drivers.
I don't know remember exactly but It goes something like "VIDEO PLANB:
need at leas kernel version 2.6.99".<br>
<br>
I hope someone can finally help me.<br>
<br>
Michael<br>
<br>
Michael Sch=F6ller schrieb:
<blockquote cite=3D"mid:48519BEB.3030609@schoeller-soft.net" type=3D"cite=
">
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
Dominik Kuhlen schrieb:
  <blockquote cite=3D"mid:200806092248.01786.dkuhlen@gmx.net" type=3D"cit=
e"><!---->Hmm,
this is strange. looks like you are using old drivers or old dvb-core
module that doesn't support the new ioctls<br>
    <pre wrap=3D"">Did you load the modules with
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
  <pre wrap=3D"">
<hr size=3D"4" width=3D"90%">
_______________________________________________
linux-dvb mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:linux-dvb@linuxtv.or=
g">linux-dvb@linuxtv.org</a>
<a class=3D"moz-txt-link-freetext" href=3D"http://www.linuxtv.org/cgi-bin=
/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listi=
nfo/linux-dvb</a></pre>
</blockquote>
<br>
</body>
</html>

--------------090502050705060306030903--


--===============1689714292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1689714292==--
