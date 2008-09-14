Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KefB5-0003eI-8o
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 02:09:25 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K750048WSEDMFK0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 13 Sep 2008 20:08:38 -0400 (EDT)
Date: Sat, 13 Sep 2008 20:08:37 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48CC501F.20609@singlespoon.org.au>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-id: <48CC5605.7060505@linuxtv.org>
MIME-version: 1.0
References: <mailman.757.1221287462.834.linux-dvb@linuxtv.org>
	<200809130945.11500.joe.djemal@btconnect.com>
	<48CC501F.20609@singlespoon.org.au>
Cc: Joe Djemal <joe.djemal@btconnect.com>,
	"linux-dvb >> linux dvb" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 44, Issue 60
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Paul Chubb wrote:
> Hi,
>      there is a good book on kernel development by Robert Love - Linux 
> Kernel Development. I read about two thirds of it. Lots of useful 
> information but I found it difficult to get a wide viewpoint of the 
> process. It would be great to have beside you as a reference. Looking on 
> Amazon - I wanted to check the details - there are several other books 
> including linux device drivers by Rubini.
> 
> HTH
> 
> Cheers Paul
> 
> Joe Djemal wrote:
>> I concur with the below. I can code in quite a few languages including 
>> assembly languages and I asked for a pointer on where to get started with 
>> learning how to make a Linux driver and there was complete silence as there 
>> was with my previous inquiry.
>>
>> Come on guys, I've been Googling but where do I start?
>>
>> Joe

Hey Joe, I didn't see your first request, sorry.

The Linux Drivers Manual (oreilly) is a good place to start for a 
generic overview of the kernel driver features. It's also online 
downloadable for free in PDF form.

Jumping head first into linuxtv.org is a steep learning curve if you 
haven't done driver work before. Get comfortable building the source 
tree (see the wiki). I'd then suggest you look at the small drivers 
(common/tuners) would be a good place to start.

Look at the struct_ interfaces that each of the smaller drivers use and 
you'll start to see the major interfaces between different parts of the 
kernel (tuners and demodulators) ( files 
inlinux/drivers/media/dvb/frontends). In the demodulator drivers you'll 
see dvb_frontend_ops, it contains the callbacks allowing other parts of 
the kernel (dvb/dvb-core/*.[hc]) to call the demodulators for 
configuration and tuning purposes. When applications tune then call 
interfaces in dvb-core, this marshals the data and passes those calls 
onto the demodulator drivers.

Tuners and demodulators are a good place to start as the drivers are 
generally fairly small. Get to grips with this before you look at the 
physical pci/pcie/usb drivers, they get large quickly and can easily 
confuse. Limit you learning to a specific field (tuners and demods) and 
submit a few cleanup patches. This is how most people start.

No substitute for look at the source code and finding the common 
structures that all tuners and demodulators use.

No good book on linux-dvb exists, apart form the spec (see linuxtv.org) 
and the actual project source code.

This is where I'd suggest you begin your journey.

Welcome, and good luck!

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
