Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPOhJ-00038n-H5
	for linux-dvb@linuxtv.org; Tue, 20 Jan 2009 23:03:50 +0100
Date: Wed, 21 Jan 2009 09:03:40 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Message-ID: <20090120220340.GA4150@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan>
	<alpine.DEB.2.00.0901201046430.11623@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901201046430.11623@ybpnyubfg.ybpnyqbznva>
Cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
Reply-To: linux-media@vger.kernel.org
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

On Tue, Jan 20, 2009 at 10:59:27AM +0100, BOUWSMA Barry wrote:
> On Tue, 20 Jan 2009, Daniel Dalton wrote:
> 
> > Could someone please let me know what I have to do to get my msi 5580
> > usb digital tv tuner working with linux?
> 
> It looks like it may be supported by the following dvb-usb:
> 
> config DVB_USB_M920X
>         tristate "Uli m920x DVB-T USB2.0 support"
>         depends on DVB_USB
>         select DVB_MT352 if !DVB_FE_CUSTOMISE
>         select MEDIA_TUNER_QT1010 if !DVB_FE_CUSTOMISE
>         select MEDIA_TUNER_TDA827X if !DVB_FE_CUSTOMISE
>         select DVB_TDA1004X if !DVB_FE_CUSTOMISE
>         help
>           Say Y here to support the MSI Mega Sky 580 USB2.0 DVB-T receiver.
>           Currently, only devices with a product id of
>           "DTV USB MINI" (in cold state) are supported.
>           Firmware required.
> 
> (Not sure if the next-to-last line is accurate; the code lists a 
> few devices)
> 

Hi Barry,

Does this mean I have to build the kernel?
If so, how do I get to this part of the setup what's it under in make
menuconfig for example?

> One thing you can do, is to plug your device into the USB port
> (if you haven't done so already), and check the output of
> `lsusb' for your device vendor and product IDs, to see if
> these match those in the source code.

What source code? The stuff you pasted above?

> 
> 
> > What drivers do I need? What software, what should I do to test it and
> > is it possible to use the remote once it is up and running?
> 
> I'm unsure of your level as a beginner, expert, or master of
> the known linux kernel (except for that weird DVB code), so

I'm not bad in a console, but I'm mostly a home user I just use it for
work music browsing the web etc, and know a bit more. I can compile and
patch stuff, and know a tiny bit of c, so thats basically my level.
(But I'm not a programmer)

> I can't say much -- you'll need at least the module for m920x.

So I just recompile my kernel?

> > Finally, I'm vission impared, so are there any programs for controling
> > the tv either command line based or gtk? I can't use qt applications.
> 
> Similarly for this reason, someone else will have to offer
> help on convenient end-user applications.  (I can offer
> good commandline suggestions, but `gtk' and `qt' have on
> meaning to me)

Can you recommend any command line programs? I love using the cli, and
if possible I would avoid using gnome.
Can mplayer control the tv?

So, I have to build the right module for my card? Then I need to
configure it and get it working with some kind of tv program?
Is that right?

If so, how do I find the part in the kernel config to build the module
for my tv card, and do I build it as modules or build it into the
kernel?

Thanks very much,

Daniel

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
