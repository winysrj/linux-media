Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.wa.amnet.net.au ([203.161.124.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@lostcow.com>) id 1KsbCN-0008Ia-5i
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 12:44:21 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp2.wa.amnet.net.au (Postfix) with ESMTP id 09739C3C7D
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 18:44:07 +0800 (WST)
Received: from smtp2.wa.amnet.net.au ([127.0.0.1])
	by localhost (smtp2.wa.amnet.net.au [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id iuzz6OXTx5tt for <linux-dvb@linuxtv.org>;
	Wed, 22 Oct 2008 18:44:05 +0800 (WST)
Received: from callaghan.local (203.161.84.230.static.amnet.net.au
	[203.161.84.230])
	by smtp2.wa.amnet.net.au (Postfix) with SMTP id 82186C47D6
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 18:44:05 +0800 (WST)
Message-ID: <452AD5616A1D4A2EB6BB6329DEF41E58@marklaptop>
From: "Mark Callaghan" <mark@lostcow.com>
To: "Alex Ferrara" <alex@receptiveit.com.au>
References: <00023E2CD2444D05AFE501BA0439DCCF@marklaptop>
	<12A846AD-5D7A-4021-BE5B-063A7AEB70E9@receptiveit.com.au>
In-Reply-To: <12A846AD-5D7A-4021-BE5B-063A7AEB70E9@receptiveit.com.au>
Date: Wed, 22 Oct 2008 18:43:53 +0800
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico Dual Digital 4 rev 2 broken in October?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1991441438=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1991441438==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0024_01C93476.2198D820"

This is a multi-part message in MIME format.

------=_NextPart_000_0024_01C93476.2198D820
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks Alex. I deleted one of the firmware files (Chris's) and my rev2 =
is good now. (I had a few fw files in place.)

But I have been having other problems - only one of the two tuners would =
work, the other reporting "partial lock". Various searches and much =
digging turned up a suggestion to disable EIT scanning. I disabled the =
EIT scan in the backend setup (video sources, I think?). But this had no =
effect. I then went into the database with phpmyadmin, and disabled =
dvb_eitscan in the capturecard table. And now I get both tuners.

So there is something strange happening, but I'm happy.

Cheers,
Mark

------=_NextPart_000_0024_01C93476.2198D820
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.6001.18148" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY=20
style=3D"WORD-WRAP: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space"=20
bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Thanks Alex. I deleted one of the =
firmware files=20
(Chris's) and my rev2 is good now. (I had a few fw files in =
place.)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>But I have been having other problems - =
only one of=20
the two tuners would work, the other reporting "partial lock". Various =
searches=20
and much digging turned up a suggestion to disable EIT scanning. I =
disabled the=20
EIT scan in the backend setup (video sources, I think?). But this had no =
effect.=20
I then went into the database with phpmyadmin, and disabled dvb_eitscan =
in the=20
capturecard table. And now I get both tuners.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>So there is something strange =
happening, but I'm=20
happy.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Cheers,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Mark</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_0024_01C93476.2198D820--



--===============1991441438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1991441438==--
