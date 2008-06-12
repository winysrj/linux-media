Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sneakemail.com ([38.113.6.61] helo=sneak1.sneakemail.com)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <2hteq3r02@sneakemail.com>) id 1K6ddG-0004dl-8E
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 05:39:50 +0200
From: "Sneake" <2hteq3r02@sneakemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <412bdbff0806111939l6beabec1l5da450565817765a@mail.gmail.com>
References: <5455-11240@sneakemail.com>
	<412bdbff0806111939l6beabec1l5da450565817765a@mail.gmail.com>
Date: Wed, 11 Jun 2008 22:37:37 -0500
Message-ID: <29463-69064@sneakemail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Regression in cx88_dvb relative 2.6.25?
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

On Wed, 2008-06-11 at 22:39 -0400, Devin Heitmueller
devin.heitmueller-at-......... |linux-dvb| wrote:
> Hello there,
> 
> Not that I have reason to believe the problem is with the em28xx
> driver, but could you please reboot the PC without the USB devices
> connected (so we know for sure the driver did not load), and make sure
> you still have the issue?
> 
> I just want to be sure it's the V4L code in general and not some
> interaction between your PCI device and the USB devices.

GOOD GUESS: I did exactly that (removed the two USB devices) and now the
PCI card works.

Now, how the heck can a USB device that isn't even active at the time
screw up the PCI device?

Note: when I went back to the stock 2.6.25 drivers the devices were
still plugged in, they just did not have drivers active. That would tend
to exclude weird stuff like ground loops (which would have still been
present).

Are you thinking an electrical level interaction (noise) or some
software level interaction?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
