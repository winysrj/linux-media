Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway09.websitewelcome.com ([64.5.52.12])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1KIQdh-0005ty-Vq
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 18:11:03 +0200
Message-ID: <487B7AE8.30006@kipdola.com>
Date: Mon, 14 Jul 2008 18:12:24 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: manu <eallaud@yahoo.fr>, linux-dvb@linuxtv.org
References: <1215822101l.26120l.0l@manu-laptop>
In-Reply-To: <1215822101l.26120l.0l@manu-laptop>
Subject: Re: [linux-dvb] (Crude) Patch to support latest multiproto drivers
 (as of 2008-07-11
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1295681822=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1295681822==
Content-Type: multipart/alternative;
 boundary="------------000508040803020706040903"

This is a multi-part message in MIME format.
--------------000508040803020706040903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


manu schreef:
> 	Hi all,
> subject says it all. This patch (that applies to trunk, but probably 
> also for 0.21.fixes) allows myth to tune with the latest multiproto 
> drivers.
> No DVB-S2 support here, its a crude patch, but it works for DVB-S.
> Bye
> Manu
>   
As ridiculous as it might seem, I still have difficulties applying 
patches. I know, shoot me! I never seem to get when to use the -p1 or 
-p0 option, or whatever! Here's my output.

patch -p0 < mythtv*.patch
patching file libs/libmythtv/dvbchannel.cpp
Hunk #1 FAILED at 211.
Hunk #2 FAILED at 781.
2 out of 2 hunks FAILED -- saving rejects to file 
libs/libmythtv/dvbchannel.cpp.rej


/Met vriendelijke groeten,/

*Jelle De Loecker*
Kipdola Studios - Tomberg

--------------000508040803020706040903
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
manu schreef:
<blockquote cite="mid:1215822101l.26120l.0l@manu-laptop" type="cite">
  <pre wrap="">	Hi all,
subject says it all. This patch (that applies to trunk, but probably 
also for 0.21.fixes) allows myth to tune with the latest multiproto 
drivers.
No DVB-S2 support here, its a crude patch, but it works for DVB-S.
Bye
Manu
  </pre>
</blockquote>
As ridiculous as it might seem, I still have difficulties applying
patches. I know, shoot me! I never seem to get when to use the -p1 or
-p0 option, or whatever! Here's my output.<br>
<br>
patch -p0 &lt; mythtv*.patch<br>
patching file libs/libmythtv/dvbchannel.cpp<br>
Hunk #1 FAILED at 211.<br>
Hunk #2 FAILED at 781.<br>
2 out of 2 hunks FAILED -- saving rejects to file
libs/libmythtv/dvbchannel.cpp.rej<br>
<br>
<div class="moz-signature"><br>
<em>Met vriendelijke groeten,</em>
<br>
<br>
<strong>Jelle De Loecker</strong>
<br>
Kipdola Studios - Tomberg <br>
</div>
</body>
</html>

--------------000508040803020706040903--


--===============1295681822==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1295681822==--
