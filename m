Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LPDOZ-0005lm-Gw
	for linux-dvb@linuxtv.org; Tue, 20 Jan 2009 10:59:44 +0100
Received: by ug-out-1314.google.com with SMTP id x30so241817ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 20 Jan 2009 01:59:39 -0800 (PST)
Date: Tue, 20 Jan 2009 10:59:27 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
In-Reply-To: <20090120091952.GB6792@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901201046430.11623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan>
MIME-Version: 1.0
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

On Tue, 20 Jan 2009, Daniel Dalton wrote:

> Could someone please let me know what I have to do to get my msi 5580
> usb digital tv tuner working with linux?

It looks like it may be supported by the following dvb-usb:

config DVB_USB_M920X
        tristate "Uli m920x DVB-T USB2.0 support"
        depends on DVB_USB
        select DVB_MT352 if !DVB_FE_CUSTOMISE
        select MEDIA_TUNER_QT1010 if !DVB_FE_CUSTOMISE
        select MEDIA_TUNER_TDA827X if !DVB_FE_CUSTOMISE
        select DVB_TDA1004X if !DVB_FE_CUSTOMISE
        help
          Say Y here to support the MSI Mega Sky 580 USB2.0 DVB-T receiver.
          Currently, only devices with a product id of
          "DTV USB MINI" (in cold state) are supported.
          Firmware required.

(Not sure if the next-to-last line is accurate; the code lists a 
few devices)

One thing you can do, is to plug your device into the USB port
(if you haven't done so already), and check the output of
`lsusb' for your device vendor and product IDs, to see if
these match those in the source code.


> What drivers do I need? What software, what should I do to test it and
> is it possible to use the remote once it is up and running?

I'm unsure of your level as a beginner, expert, or master of
the known linux kernel (except for that weird DVB code), so
I can't say much -- you'll need at least the module for m920x.

The source code includes remote control keycodes; make of
that what you will.

I'm not so much an end-user (fnar fnar) and instead use my
machines as headless servers, and as such I use basic tools
that are far from user-friendly for everything.


> Finally, I'm vission impared, so are there any programs for controling
> the tv either command line based or gtk? I can't use qt applications.

Similarly for this reason, someone else will have to offer
help on convenient end-user applications.  (I can offer
good commandline suggestions, but `gtk' and `qt' have on
meaning to me)


> Also, does this card allow for reccording?

All supported cards deliver the digital payload to linux,
which can then be recorded by writing it to a file, or
passed to an application for direct processing (listening
and/or viewing), so, yes.

It's up to the application to make this convenient for
the user..


So, my suggestion is, plug it in, and see how far you get :-)

barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
