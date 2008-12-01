Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from harpoon.unitedhosting.co.uk ([83.223.124.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert@watkin5.net>) id 1L7FDq-0003wv-TI
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 21:18:24 +0100
From: Robert Watkins <robert@watkin5.net>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228152690.22348.1287628393@webmail.messagingengine.com>
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
Date: Mon, 01 Dec 2008 20:17:53 +0000
Message-Id: <1228162673.6829.14.camel@watkins-desktop>
Mime-Version: 1.0
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700 remote control support fixed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1606721214=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1606721214==
Content-Type: multipart/alternative; boundary="=-IQr7pYiZy+5eYY82p5/w"


--=-IQr7pYiZy+5eYY82p5/w
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-12-01 at 17:31 +0000, petercarm wrote:

> First off I'd like to point out that I had considerable success with fw
> 1.20 and the drivers that I tested on mid-November.  At the time, the
> driver had the issues with the repeating remote control messages.  Since
> the update (I think November 16th) I have not been able to get a stable
> build, suffering from the i2c problem.
> 
> My test environment consists of 2 different VIA Epia boards (SP8000 and
> CN10000).  I have both a PCI Nova-T 500 2040:9950 and a USB stick
> Nova-TD 2040:5200 which are dibcom devices.  I also have a Hauppauge
> Nova-T PCI (cx88xx) and a Kworld 399U dual tuner USB stick 1b80:e399
> (af9015).
> 

I too have a PCI Nova-T 500 2040:9950 that works well with the 1.20
firmware and a 2.6.24 kernel and the latest drivers from
http://linuxtv.org/hg/v4l-dvb.
For me kernels 2.6.25 & 2.6.27 have problems. See here
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/303667. 


> The build is a scripted build of gentoo, built as a livecd (which means
> it is very repeatable).  The snapshot of gentoo portage dates from
> 20081028 which gives me a 2.6.25 kernel.  I'm using gentoo-sources so I
> get 2.6.25-gentoo-r7.

Can you confirm that 2.6.24 was the last good kernel for a PCI Nova-T
500 2040:9950?


> In one of my previous posts I mentioned that I am testing remote control
> functionality using lirc.  This is using devinput and allows me to
> abstract the key bindings for different applications.
> 
> What else can I tell you?
> 

If you start from cold do you see the same firmware load failure that
I'm seeing?

Regards and Best Wishes,
Robert


--=-IQr7pYiZy+5eYY82p5/w
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.18.3">
</HEAD>
<BODY>
On Mon, 2008-12-01 at 17:31 +0000, petercarm wrote:
<BLOCKQUOTE TYPE=CITE>
<PRE>
First off I'd like to point out that I had considerable success with fw
1.20 and the drivers that I tested on mid-November.  At the time, the
driver had the issues with the repeating remote control messages.  Since
the update (I think November 16th) I have not been able to get a stable
build, suffering from the i2c problem.

My test environment consists of 2 different VIA Epia boards (SP8000 and
CN10000).  I have both a PCI Nova-T 500 2040:9950 and a USB stick
Nova-TD 2040:5200 which are dibcom devices.  I also have a Hauppauge
Nova-T PCI (cx88xx) and a Kworld 399U dual tuner USB stick 1b80:e399
(af9015).

</PRE>
</BLOCKQUOTE>
I too have a PCI Nova-T 500 2040:9950 that works well with the 1.20 firmware and a 2.6.24 kernel and the latest drivers from <A HREF="http://linuxtv.org/hg/v4l-dvb.">http://linuxtv.org/hg/v4l-dvb.</A><BR>
For me kernels 2.6.25 &amp; 2.6.27 have problems. See here <A HREF="https://bugs.launchpad.net/ubuntu/+source/linux/+bug/303667.">https://bugs.launchpad.net/ubuntu/+source/linux/+bug/303667.</A> <BR>
<BR>
<BLOCKQUOTE TYPE=CITE>
<PRE>
The build is a scripted build of gentoo, built as a livecd (which means
it is very repeatable).  The snapshot of gentoo portage dates from
20081028 which gives me a 2.6.25 kernel.  I'm using gentoo-sources so I
get 2.6.25-gentoo-r7.
</PRE>
</BLOCKQUOTE>
Can you confirm that 2.6.24 was the last good kernel for a PCI Nova-T 500 2040:9950?<BR>
<BR>
<BLOCKQUOTE TYPE=CITE>
<PRE>
In one of my previous posts I mentioned that I am testing remote control
functionality using lirc.  This is using devinput and allows me to
abstract the key bindings for different applications.

What else can I tell you?

</PRE>
</BLOCKQUOTE>
If you start from cold do you see the same firmware load failure that I'm seeing?<BR>
<BR>
Regards and Best Wishes,<BR>
Robert<BR>
<BR>
</BODY>
</HTML>

--=-IQr7pYiZy+5eYY82p5/w--



--===============1606721214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1606721214==--
