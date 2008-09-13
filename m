Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kecrv-0001Ry-RI
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 23:41:28 +0200
Received: by nf-out-0910.google.com with SMTP id g13so807864nfb.11
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 14:41:24 -0700 (PDT)
Message-ID: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>
Date: Sat, 13 Sep 2008 17:41:24 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Power management and dvb framework
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

Hello,

I have been doing some debugging of a USB DVB capture device, and I
was hoping someone could answer the following question about the DVB
framework:

What facilities exist to power down a device after a user is done with it?

Let's look at an example:

I have a dib0700 based device.  I specify my own frontend_attach()
function, which twiddles various GPIOs for the demodulator, and I have
a tuner_attach() function which I use to initialize the tuner.  Both
of these are called when I plug in the device.

I had to set various GPIOs to bring components out of reset or
properly set the sleep pin, but I do not see any way to put them back
to sleep after the user is done with them.

So in my case the USB device draws 100ma when plugged in, then goes to
320ma when I start streaming, but when I stop streaming I have no hook
to put the demodulator back to sleep so it *stays* at 320ma until I
unplug the device.

I know I have similar issues with em28xx based devices I am responsible for.

Is there some part of the framework I am simply missing?  Ideally I
would like to be able to power down the tuner and demodulator when the
user is done with them.  I know there are *_sleep functions but it's
not clear how they are used and it doesn't look like they are commonly
used by other devices.  Are the sleep functions called when a user
disconnects from the frontend, or is this purely a power management
call that is used when a user suspends his workstation?

Any advise anyone can give about the basic workflow here would be very useful.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
