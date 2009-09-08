Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Ml0j4-0006IR-FI
	for linux-dvb@linuxtv.org; Tue, 08 Sep 2009 15:27:15 +0200
Received: by ewy10 with SMTP id 10so3693823ewy.13
	for <linux-dvb@linuxtv.org>; Tue, 08 Sep 2009 06:26:40 -0700 (PDT)
Date: Tue, 8 Sep 2009 15:26:36 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Paul Thomas <spongelavapaul@googlemail.com>
In-Reply-To: <8138A3AA-5665-4A05-93F7-7A68D58E3E77@googlemail.com>
Message-ID: <alpine.DEB.2.01.0909081459500.28635@ybpnyubfg.ybpnyqbznva>
References: <8138A3AA-5665-4A05-93F7-7A68D58E3E77@googlemail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Access to raw transport stream
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Tue, 8 Sep 2009, Paul Thomas wrote:

> I'm trying to decide what DVB-T card to get and I can't work out how to tell
> if I'll be able to record entire transport streams (i.e. without any demux).

In the case of USB devices, the available bandwidth will limit
whether your card can deliver this, or only a filtered stream of
one or two programmes.

That is, the available bandwidth of a USB1 device is inadequate
for most full transport streams you are likely to encounter.  If
the specs for the device indicate it's a USB1 device (sometimes
that's hidden when they refer to the backwards compatibility of
USB2.0), such as one particular device I have, then no, that
device will simply be incapable of delivering a full TS over that
limited bandwidth.

If your device is a USB2.0 device, then it's quite possible that
it will deliver a full transport stream, which your computer will
then either handle as such, or trim down to its desired parts.
On the other hand, the device itself may be able to perform the
PID filtering internally, saving a bit of USB bus bandwidth and
taking load off your host, and also allowing you to use it on
legacy USB1-only ports, should you have that.

Probably you'd need to study the code of the driver for a 
particular device to see what it's capable of delivering.  Another
device which I have requires a USB2.0 connection, over which the
entire transport stream is delivered -- as is true for yet another
DVB-S device I have.


> Could someone give me a recommendation please? esp. will the Hauppage HVR-1200
> let me do this?

This not being a USB device, bandwidth is no problem.  In fact,
I was looking for what PCI devices there are today that have the
capability of my existing PCI card of performing PID filtering
internally to allow my machine, which these days would probably
only be found in a skip behind a computer museum, or a tenth
generation hand-me-down, to not be bothered with a full transport
stream.  Seems this isn't common outside of USB1 devices.

I don't see anything in the code for that device that leaps out
to say it is only capable of so many PIDs and internal filtering,
so I'd say you probably will see a full transport stream from it
by default, but don't quote me on it -- I may not be skimming the
right places in the code.


Hope this helps to answer your question, somehow.

barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
