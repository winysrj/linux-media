Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out3.iinet.net.au ([203.59.1.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1LHp9K-0002Vd-2v
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 01:41:26 +0100
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: sonofzev@iinet.net.au, 'Devin Heitmueller' <devin.heitmueller@gmail.com>
Date: Wed, 31 Dec 2008 09:41:19 +0900
Message-Id: <59055.1230684079@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0355661082=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0355661082==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<HTML>
This is a MythTV system (backend and frontend).. I have it setup with the o=
ption to only engage the adaptor when in use (but can't change this at the =
moment, I'm at work and have been accessing via ssh.. obviously one of the =
slowest days of the year). I did get my girlfriend to activate the tv playe=
r as soon as the system came up. <BR>
<BR>
I'm using Gentoo but dont know how to display the timing of the messages. I=
 can't see anything on the dmesg man page. <BR>
<BR>
However, it appears to be almost constantly occurring. If I run dmesg back =
to back it has written at least one new line (so sub 2 seconds at a very ro=
ugh estimate). Right now the entire buffer has filled with this message and=
 appears to be continuously writing it. <BR>
<BR>
At the time of discovery (I noticed the jitter last night, but only checked=
 dmesg today).. <BR>
<BR>
<BR>
<BR>
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Wed Dec 31 11:21 , "Devin Heitmueller=
" <devin.heitmueller@gmail.com> sent:<BR>
<BR>
</devin.heitmueller@gmail.com></span><blockquote style=3D"border-left: 2px =
solid rgb(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left=
: 5px; padding-right: 0px;">On Tue, Dec 30, 2008 at 7:17 PM, <a href=3D"jav=
ascript:top.opencompose('sonofzev@iinet.net.au','','','')">sonofzev@iinet.n=
et.au</a><BR>

&lt;<a href=3D"javascript:top.opencompose('sonofzev@iinet.net.au','','','')=
">sonofzev@iinet.net.au</a>&gt; wrote:<BR>

&gt; Here is the full output from startup  (attached as dmesg.txt) .. the l=
ooping<BR>

&gt; message in the original email starts immediately after (re ran dmesg a=
fter<BR>

&gt; writing this file to check)..<BR>

&gt; I hope this is useful<BR>

&gt;<BR>

<snip><BR>

<BR>

Is this a MythTV system or something that does a scan at startup?<BR>

<BR>

Also, can you provide any timing info as to the frequency of the<BR>

messages (some distributions include the time down to the ms in their<BR>

dmesg output, but I don't know how that is configured)<BR>

<BR>

Devin<BR>

<BR>

-- <BR>

Devin J. Heitmueller<BR>

<a href=3D"parse.pl?redirect=3Dhttp%3A%2F%2Fwww.devinheitmueller.com" targe=
t=3D"_blank"><span style=3D"color: red;">http://www.devinheitmueller.com</s=
pan></a><BR>

AIM: devinheitmueller<BR>

)<BR>

</snip></blockquote></HTML>
<BR>=


--===============0355661082==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0355661082==--
