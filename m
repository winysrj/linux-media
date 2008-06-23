Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KAlWL-0007Sn-UD
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 14:51:46 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K2X007F12DAV7Y0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 23 Jun 2008 08:51:10 -0400 (EDT)
Date: Mon, 23 Jun 2008 08:51:10 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080622121058.122F7BE4078@ws1-9.us4.outblaze.com>
To: stev391@email.com
Message-id: <485F9C3E.50309@linuxtv.org>
MIME-version: 1.0
References: <20080622121058.122F7BE4078@ws1-9.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
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

stev391@email.com wrote:
> Steven,
> 
> The card works perfectly using Chris Pascoe's branch, I can use both 
> tuners at the same time. It only stuffs up when I try and merge the 
> relevant sections into tip, as per the patch I attached in the previous 
> email.  So this eliminates bios/hardware faults. I can also try in 
> windows for you, but I'm sure this is not the fault.
> 
> I would like to run a more modern version of the hg code as I have other 
> cards sitting around that could go in the same system and also I fear 
> that if somebody doesn't do the work to get it into tip, support will 
> disappear for newer kernels.
> 
> Thanks for help, any further advice?
> (Also you lost me a bit with sram and risc, is this for the 
> microprocessor on the tv card or is it on my motherboard/cpu? And do you 
> have any documentation about them so I can learn more about it?)
> 
> Stephen.
> 
>     ----- Original Message -----
>     From: "Steven Toth"
>     To: stev391@email.com
>     Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
>     Date: Sat, 21 Jun 2008 08:54:39 -0400
> 
> 
> 
>      > As soon as I try to access both cards at the same time it breaks
>      > and only a full computer restart will fix it, i have tried
>      > unloading all the modules that I can find that this card uses and
>      > loading them again. I get the syslog attached below (cx23885 with
>      > debug =1). It doesn't matter what progam i use to access them
>      > (tried gxine, totem, mythtv) it all works the same, only one at a
>      > time or it breaks.
> 
>     If the vidb and vidc (ts1 / ts2) bridge streams each single channel
>     correctly, but not both together then this is either a sram
>     configuration issue (the risc engine's workspace is being corrupted
>     by another risc channel), or your system has a pcie compatibility
>     issue.
> 
>     I've seen both of these issues in the past.
> 
>     I don't have a hardware product with demodulators on vidb and c, so
>     that's not something I can repro.
> 
>     Can you dual boot the same system under windows and remove any pcie
>     compatibility doubts?
> 
>     - Steve

No need to try windows, if you have the driver already running (pascoe's 
patches) then your chipset and hardware are fine.

Sounds like you have a simple merge issue.

Try to figure out which parts of the merge actually create the problem 
then bring that issue back to this list for discussion.

Regards,

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
