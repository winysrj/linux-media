Return-path: <linux-media-owner@vger.kernel.org>
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:52897 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZCaTU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 15:20:56 -0400
Date: Tue, 31 Mar 2009 21:20:52 +0200
From: Gabriele Dini Ciacci <dark.schneider@iol.it>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
Message-ID: <20090331212052.152d2ffc@gdc1>
In-Reply-To: <20090331075610.53620db8@pedra.chehab.org>
References: <20090329155608.396d2257@gdc1>
 <20090331075610.53620db8@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009 07:56:10 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Gabriele,
> 
> On Sun, 29 Mar 2009 15:56:08 +0200
> Gabriele Dini Ciacci <dark.schneider@iol.it> wrote:
> 
> > Hello,
> > 
> > This is a stub patch to make the subjects card work.
> > 
> > I am using the driver on a pctv60e and it is very stable, I use it
> > daily. It should work for pctv200e but not owning the device I
> > cannot test it.
> > 
> > The code need to be cleaned, as I am not an experienced kernel
> > coder. The code in mt352.c contains an hard-coded address for the
> > device, while Pinnalce devices with that tuner uses a different
> > address. Currently the address is "hijacked" to be the correct one.
> > This is a hack, and i think that mt352.c should be changed to
> > support multiple addresses, selected via params, duplicate code or
> > something.
> > 
> > Remote support is missing, cause it was not working out of the box.
> > I do not use it and so developing it for myself only was not very
> > useful, if someone wants it or is interested I can have a look.
> > 
> > The patch is generally messy, I need help there. I do not know if I
> > have to change all the functions to take as parameter an adapter_nr
> > or change the caller to continue to pass them a struct
> > dvb_usb_device obtained with i2c_get_adapdata(adapter_nr).
> > 
> > Here is the patch, as an attachment, thanks meanwhile.
> 
> Well, let's go by parts. 
> 
> It seems that you wrote your driver based on some USB sniffing. Do
> you know what are the chipsets present on your driver? Maybe there's
> another driver already developed or under development for the same
> chipset.

I actually did not any sniffing at all. I was ready to go for it (so I
asked a windows guy to send me the sniff).
Obtained that, I started to look at it, then I
realized that v4l already had support for all the chipsets the thing
was using. I just made the code that connects the parts and such,
indeed the patch is only the main file, no low level chip file, or
anything else touched. So there is no actual code for the chipsets.
I'm using mt353 and mt2060, that are already in the main tree.

As I explained above, mt353.c makes a wrong assumption about the address
the chip has, at it also states that in a comment, explaining that on
pinnacle hardware (like in this case) the address is different. I just
had to hijack that and hack this. I was suggesting above to fix
mt353.c else, no pinnacle card with mt353 can be implemented with a
clean code.

> In the case of your patch, you should first run checkpatch.pl for it
> to show you the non-compliances of your driver and Linux Kernel
> CodingStyle. checkpatch.pl is avaliable at kernel tree,
> under /scripts dir. You'll also find it at v4l-dvb development tree,
> at v4l/script/checkpatch.pl.
> It is also a good idea to read README.patches at v4l-dvb development
> tree.
> 

I have checked coding style manually, I'll use the script.
I read README.patches the first time i coded the driver, reread it on
January when I updated the driver to the new interface and decided to
send it the first time to the ml on 01/06/2009. In January it was
outdated in regards to the new patch system adopted, wiki was also
outdated. I'll reread it to see if I am missing something and to check
if it needs to be updated to explain the new system for patch.

To sum up I will run checkpatch.pl and when it run fine I will resend
the patch.

But note that the problem with mt353.c stays, I do not have the
necessary confidence to change a low level chipset driver interface to
make it not assume an hardcoded adderss.

> Cheers,
> Mauro

Thanks, see you :)
Best Regards,
Gabriele

----------- 
http://linux-wildo.sf.net
http://www.diniciacci.org
