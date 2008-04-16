Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.icp-qv1-irony-out3.iinet.net.au ([203.59.1.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jm4D8-0008N6-IM
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 11:45:51 +0200
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: sonofzev@iinet.net.au, Adam Nielsen <a.nielsen@shikadi.net>
Date: Wed, 16 Apr 2008 17:45:44 +0800
Message-Id: <48792.1208339144@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico Fusion HDTV DVB-T dual express - willing to
Reply-To: sonofzev@iinet.net.au
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0500575267=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0500575267==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<HTML>
Looks like my cats have knocked out my modem, so I can't check till I get h=
ome. However, it identifies the card with a module option for the cx23885 m=
odule, that being card=3D4. <BR>
I have tried using 0 through to 3 but it was looking for tuners that weren'=
t on the chip. <BR>
<BR>
I'll check for the PCI ID's for the card once I get home. <BR>
<BR>
 <BR>
<BR>
<span style=3D"font-weight: bold;">On Tue Apr 15 20:38 , Adam Nielsen <a.ni=
elsen@shikadi.net> sent:<BR>
<BR>
</a.nielsen@shikadi.net></span><blockquote style=3D"border-left: 2px solid =
rgb(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left: 5px;=
 padding-right: 0px;">&gt; I have mistakenly bought a Fusion HDTV DVB-T dua=
l express (cx23885) as a <BR>

&gt; result of misreading some other posts and sites. I was under the <BR>

&gt; impression that it would work either from the current kernel source or=
 <BR>

&gt; using Chris Pascoe's modules.  Unfortunately I didn't realise that the=
 <BR>

&gt; American and Euro/Australian version were different.<BR>

<BR>

What are the PCI IDs for the card?  I'm not sure what criteria the <BR>

driver uses to detect DVB vs ATSC, but I would guess you could tweak the <B=
R>

PCI IDs to make the driver detect your card as one of the others that <BR>

supports DVB and has the same cx23885 chipset.<BR>

<BR>

Cheers,<BR>

Adam.<BR>

)<BR>

</blockquote></HTML>
<BR>=


--===============0500575267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0500575267==--
