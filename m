Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1JPIuP-0002MK-Pq
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 15:48:25 +0100
Received: from [192.168.43.91] (rommel.snap.tv [192.168.43.91])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by patton.snap.tv (Postfix) with ESMTP id B295FF1405D
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 15:48:23 +0100 (CET)
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb@linuxtv.org
In-Reply-To: <200707170745.10910@orion.escape-edv.de>
References: <1180167750.15156.4.camel@localhost>
	<4693F7E2.6060709@gmail.com> <200707170440.33627@orion.escape-edv.de>
	<200707170745.10910@orion.escape-edv.de>
Date: Wed, 13 Feb 2008 15:48:21 +0100
Message-Id: <1202914102.28255.270.camel@rommel.snap.tv>
Mime-Version: 1.0
Subject: Re: [linux-dvb] saa7146_i2c_writeout: timed out waiting
	for	end	of	xfer
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

tir, 17.07.2007 kl. 07.45 +0200, skrev Oliver Endriss:
> Oliver Endriss wrote:
> > Imho the interrupt processing was broken:
> > - The first I2C interrupt should be used to wake-up the task.
> >   It does not matter that it takes some time until ERR in IIC_STA
> >   will be updated. We don't need it.
> > - Interrupts must be acknowledged at the end of the ISR.
> > 
> > @all
> > Please test the attached patch.
> > There shouldn't be any unexpected I2C interrupts anymore.
> 
> Attached is an updated patch which does extended status checking.
I've been running 2.6.20 + this patch on several boxes with several
TechnoTrend budget S-1500 cards for quite some time now and it seems
quite stable. However latly I have also tried some Technotrend T-1500
cards and some times I get messages like this:
saa7146_i2c_writeout: unexpected i2c status 0021
Normally I get a single message like that right after the firmware
upload to the frontend is completed, and that seems to cause no
problems, but other times I get it at other times (for insance during
the firmware upload). And some times I get streams of these (mixed with
status 0009 and 0011) coming repeatedly during some operations.

I tried installing latest hg v4l-dvb (without any changes) on one of
these boxes and there are no such messages then, however the same
problems seem to arise just with fewer error messages. And I get this
message:
saa7146 (5) saa7146_i2c_writeout [irq]: timed out waiting for end of
xfer

It seems the problems is not strickly limited to the frontend
communications. Trying for instance to communicate with the CAM can
increase the amount of error messages. 

Regards

Sigmund Augdal

> 
> CU
> Oliver
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
