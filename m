Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ked3z-0002he-U5
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 23:53:58 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K75009L6M4XZ5G0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 13 Sep 2008 17:53:22 -0400 (EDT)
Date: Sat, 13 Sep 2008 17:53:21 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <48CC3651.5040502@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Power management and dvb framework
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

Devin Heitmueller wrote:
> Hello,
> 
> I have been doing some debugging of a USB DVB capture device, and I
> was hoping someone could answer the following question about the DVB
> framework:
> 
> What facilities exist to power down a device after a user is done with it?
> 
> Let's look at an example:
> 
> I have a dib0700 based device.  I specify my own frontend_attach()
> function, which twiddles various GPIOs for the demodulator, and I have
> a tuner_attach() function which I use to initialize the tuner.  Both
> of these are called when I plug in the device.
> 
> I had to set various GPIOs to bring components out of reset or
> properly set the sleep pin, but I do not see any way to put them back
> to sleep after the user is done with them.

See below.

> 
> So in my case the USB device draws 100ma when plugged in, then goes to
> 320ma when I start streaming, but when I stop streaming I have no hook
> to put the demodulator back to sleep so it *stays* at 320ma until I
> unplug the device.

A common problem.

> 
> I know I have similar issues with em28xx based devices I am responsible for.
> 
> Is there some part of the framework I am simply missing?  Ideally I
> would like to be able to power down the tuner and demodulator when the
> user is done with them.  I know there are *_sleep functions but it's
> not clear how they are used and it doesn't look like they are commonly
> used by other devices.  Are the sleep functions called when a user
> disconnects from the frontend, or is this purely a power management
> call that is used when a user suspends his workstation?
> 
> Any advise anyone can give about the basic workflow here would be very useful.

I looked at some power stuff for the au0828 recently. I added a couple 
of callbacks in the USB_register struct IIRC, I had those drive the 
gpios. I don't recall the details but if you look at the definition of 
the structure you should see some power related callbacks. Actually, I'm 
not even sure if those patches got merged.

Also, the demod _init() and _sleep()  callbacks get called by dvb-core 
when the demod is required (or not). These might help.

Lastly, depending on how the driver implements DVB, is might use 
videobuf - or it might do it's own buffer handing. In case of the 
latter, look at the feed_start() feed_stop() functions and the struct 
specific feed counter that usually accompanies this... you could 
probably add some useful power related stuff with these indications.

- Steve



- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
