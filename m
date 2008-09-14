Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CC5605.7060505@linuxtv.org>
References: <mailman.757.1221287462.834.linux-dvb@linuxtv.org>
	<200809130945.11500.joe.djemal@btconnect.com>
	<48CC501F.20609@singlespoon.org.au>  <48CC5605.7060505@linuxtv.org>
Date: Sat, 13 Sep 2008 20:47:10 -0400
Message-Id: <1221353230.2777.17.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: Joe Djemal <joe.djemal@btconnect.com>, linux-dvb@linuxtv.org
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

On Sat, 2008-09-13 at 20:08 -0400, Steven Toth wrote:
> Paul Chubb wrote:
> > Hi,
> >      there is a good book on kernel development by Robert Love - Linux 
> > Kernel Development. I read about two thirds of it. Lots of useful 
> > information but I found it difficult to get a wide viewpoint of the 
> > process. It would be great to have beside you as a reference. Looking on 
> > Amazon - I wanted to check the details - there are several other books 
> > including linux device drivers by Rubini.
> > 
> > HTH
> > 
> > Cheers Paul
> > 
> > Joe Djemal wrote:
> >> I concur with the below. I can code in quite a few languages including 
> >> assembly languages and I asked for a pointer on where to get started with 
> >> learning how to make a Linux driver and there was complete silence as there 
> >> was with my previous inquiry.
> >>
> >> Come on guys, I've been Googling but where do I start?
> >>
> >> Joe
> 
> Hey Joe, I didn't see your first request, sorry.
> 
> The Linux Drivers Manual (oreilly) is a good place to start for a 
> generic overview of the kernel driver features. It's also online 
> downloadable for free in PDF form.

I'd also recommend Bovet and Cesati _Understanding_the_Linux_Kernel_.
It's a little dated in that it covers kernel 2.4.x, but it's got an
emphasis of understanding what's going on in critical areas of the
kernel.  It is not a cookbook for writing drivers.

The Linux Device Drivers is quite a good cookbook/reference for how to
write a driver.  But IMO it doesn't have a strong emphasis on the why,
but only the what and how.

Both books are valuable for learning and reference.


> Jumping head first into linuxtv.org is a steep learning curve if you 
> haven't done driver work before. Get comfortable building the source 
> tree (see the wiki). I'd then suggest you look at the small drivers 
> (common/tuners) would be a good place to start.
> 
> Look at the struct_ interfaces that each of the smaller drivers use and 
> you'll start to see the major interfaces between different parts of the 
> kernel (tuners and demodulators) ( files 
> inlinux/drivers/media/dvb/frontends). In the demodulator drivers you'll 
> see dvb_frontend_ops, it contains the callbacks allowing other parts of 
> the kernel (dvb/dvb-core/*.[hc]) to call the demodulators for 
> configuration and tuning purposes. When applications tune then call 
> interfaces in dvb-core, this marshals the data and passes those calls 
> onto the demodulator drivers.
> 
> Tuners and demodulators are a good place to start as the drivers are 
> generally fairly small. Get to grips with this before you look at the 
> physical pci/pcie/usb drivers, they get large quickly and can easily 
> confuse. Limit you learning to a specific field (tuners and demods) and 
> submit a few cleanup patches. This is how most people start.

> No substitute for look at the source code and finding the common 
> structures that all tuners and demodulators use.


I'd also recommend you learn how to use "ctags" to make tag files of the
v4l-dvb source and kernel source, and learn how to use tags files within
your editor to navigate the source.

Tags make life so much easier: structure definitions, defined constants,
and function bodies are a keystoke way from where they are used in the
source you are reading. 

Regards,
Andy



> No good book on linux-dvb exists, apart form the spec (see linuxtv.org) 
> and the actual project source code.
> 
> This is where I'd suggest you begin your journey.
> 
> Welcome, and good luck!
> 
> - Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
