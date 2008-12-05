Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp06.online.nl ([194.134.42.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1L8U8K-0004Pg-LU
	for linux-dvb@linuxtv.org; Fri, 05 Dec 2008 07:25:49 +0100
Message-ID: <4938C967.2010908@verbraak.org>
Date: Fri, 05 Dec 2008 07:25:43 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: Alessandro Sagratini <ale_sagra@hotmail.com>, linux-dvb@linuxtv.org
References: <BLU147-W3542F4C32E37A483A5750A9E020@phx.gbl>
In-Reply-To: <BLU147-W3542F4C32E37A483A5750A9E020@phx.gbl>
Subject: Re: [linux-dvb] Mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0500249611=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0500249611==
Content-Type: multipart/alternative;
 boundary="------------000607000702030405040605"

This is a multi-part message in MIME format.
--------------000607000702030405040605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Alessandro Sagratini schreef:
> Hello everybody,
> I have Technisat Skystar 2 HD, and I would like to know which are the=20
> merge plans for mantis driver. s2api will be merged in 2.6.28 kernel:=20
> what about mantis?
>
> Thank you,
> Alessandro
> -----------------------------------------------------------------------=
-
> Visita il suo Spaces! Scopri le novit=E0 di Doretta.=20
> <http://doretta82live.spaces.live.com/>
> -----------------------------------------------------------------------=
-
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Alessandro,

For now you will be needing the following driver from:

http://mercurial.intuxication.org/hg/s2-liplianin

To scan and tune you can use
http://mercurial.intuxication.org/hg/scan-s2
http://mercurial.intuxication.org/hg/szap-s2

I do not know how long it will take before this driver makes it into the=20
repository and then in to the main line kernel.

Regards,

Michel.

--------------000607000702030405040605
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Alessandro Sagratini schreef:
<blockquote cite="mid:BLU147-W3542F4C32E37A483A5750A9E020@phx.gbl"
 type="cite">
  <style>
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Verdana
}
  </style>Hello everybody,<br>
I have Technisat Skystar 2 HD, and I would like to
know which are the merge plans for mantis driver. s2api will be
merged in 2.6.28 kernel: what about mantis?<br>
  <br>
Thank you,<br>
Alessandro<br>
  <hr>Visita il suo Spaces! <a moz-do-not-send="true"
 href="http://doretta82live.spaces.live.com/" target="_new">Scopri le
novit&agrave; di Doretta.</a>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
Alessandro,<br>
<br>
For now you will be needing the following driver from:<br>
<br>
<a class="moz-txt-link-freetext" href="http://mercurial.intuxication.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a><br>
<br>
To scan and tune you can use<br>
<a class="moz-txt-link-freetext" href="http://mercurial.intuxication.org/hg/scan-s2">http://mercurial.intuxication.org/hg/scan-s2</a><br>
<a class="moz-txt-link-freetext" href="http://mercurial.intuxication.org/hg/szap-s2">http://mercurial.intuxication.org/hg/szap-s2</a><br>
<br>
I do not know how long it will take before this driver makes it into
the repository and then in to the main line kernel.<br>
<br>
Regards,<br>
<br>
Michel.<br>
</body>
</html>

--------------000607000702030405040605--


--===============0500249611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0500249611==--
