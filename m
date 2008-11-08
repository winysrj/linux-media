Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kys7T-0002XW-7T
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 19:01:12 +0100
From: Darron Broad <darron@kewl.org>
To: Michel Verbraak <michel@verbraak.org>
In-reply-to: <4915C608.9000709@verbraak.org> 
References: <4915C608.9000709@verbraak.org>
Date: Sat, 08 Nov 2008 18:01:07 +0000
Message-ID: <18991.1226167267@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to find which command generates error in
	FE_SET_PROPERTY
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <4915C608.9000709@verbraak.org>, Michel Verbraak wrote:

LO

>I'm trying to modify one of my applications to use the new S2API. With 
>this application I control my dvb-t and dvb-s/s2 receivers.
>
>I'm using szap-s2 as an example but I run into a problem that the ioctl 
>FE_SET_PROPERTY always returns -1 and variable errno is set to 14.
>
>My question is. How do I determine which of the commands in the command 
>queue given to FE_SET_PROPERTY is producing this error. I did not try 
>yet to devide my command queue up into one command queue per command.

The only commands as such as CLEAR and TUNE, the rest are tuning
parameters. The way this works is that the TUNE command informs
the kernel to retune using the parameters specified. This occurs
outside of the IOCTL call itself and you don't directly know
if a paramater was wrong, it just doesn't work.

The error you have:
> grep 14 /usr/include/asm-generic/errno-base.h
#define EFAULT          14      /* Bad address */

Suggests a problem in your code...

>Regards,
>
>Michel.
>
>Part of source code for dvb-s/s2:
>
>#ifdef S2API
>int TDVBDevice::SetProperty(struct dtv_property *cmdseq)

This should something like SetProperties(struct dtv_properties cmdseq[])
and then call ioctl(fefd, FE_SET_PROPERTY, cmdseq)
This sends of your args at the same time.

>      if (SetProperty(&p[0]) == 0)

That needs to be more like:
	SetProperties(&cmdseq)

I hope that helps.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
