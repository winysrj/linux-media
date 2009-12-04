Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1NGQfi-0004Pb-GJ
	for linux-dvb@linuxtv.org; Fri, 04 Dec 2009 06:25:42 +0100
Received: by ey-out-2122.google.com with SMTP id 9so523649eyd.39
	for <linux-dvb@linuxtv.org>; Thu, 03 Dec 2009 21:25:35 -0800 (PST)
Date: Fri, 4 Dec 2009 06:25:31 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Michal Novotny <michal@etc.cz>
In-Reply-To: <4B186D4F.5090208@etc.cz>
Message-ID: <alpine.DEB.2.01.0912040308530.4548@ybpnyubfg.ybpnyqbznva>
References: <4B186D4F.5090208@etc.cz>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] The most stable DVB-T tuner
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

Nazdar!

On Fri, 4 Dec 2009, Michal Novotny wrote:

> I've just bought dual tuner USB stick MyGica T1680 (af9015) and I'm
> unpleasantly surprised with the tuner stability (mxl5005s). I have a good
> signal but the card can't deliver error free streams. Femon shows signal
> 0xf000-0xffff, snr 0xb0-0x110 and ber almost always 0. Some errors (transport
> error bit set or missing TS packet) occur in the stream about every 3 minutes

This is just an idea --

I've experienced problems with certain USB ports on different
hardware, with devices that work fine on other ports.
There's no clear explanation that I can come up with -- it's
a matter of trial-and-error.  It could be a particular hub,
or a particular USB card, or just one port on a PCI USB card
when the other three work fine.

I've never bothered to record and track down the combinations
that result in this corruption -- I've just shuffled until I
get something that works flawlessly.  These have ranged from
a glitch every few minutes, to a glitch every ten seconds or
so.


Another thing was that when I had chained the device that was
throwing up an error every few minutes with another device,
that second DVB-T tuner delivered a flawless stream.  Only
by relocating the common input from the two to a different
USB input port, and possibly juggling PCI cards due to
interrupts on my ancient machine, did things improve to
eliminate errors from the one device.



> on average. It's not a problem of linux driver since the same errors can be
> found in TS recordings taken under windows. And it is also not a problem with
> the signal because I get a much better result with AverTV A800 USB (error
> about every 4 hours) and Nova-T LSI L64781 PCI (error about every 2 hours).

You should get zero errors for many more hours than that with
a clean signal.  The worst I get has been one error every
20 or so hours on one transponder with 5/6 FEC on DVB-S.
However, with DVB-T it can be very dependent on the antenna,
with certain frequencies from one site being flawless when
another from the same site is full of uncorrectable errors.

When you say BER almost zero, I wonder about the times when
it isn't zero.  Here's my tuning for two signals:

Signal=42662, Verror=146, SNR=65389dB, BlockErrors=0, (S|L|C|V|SY)
Signal=42405, Verror=105, SNR=65430dB, BlockErrors=0, (S|L|C|V|SY)

Signal=33153, Verror=0, SNR=65535dB, BlockErrors=0, (S|L|C|V|SY)
Signal=33153, Verror=0, SNR=65535dB, BlockErrors=0, (S|L|C|V|SY)

As you can see, the first signal has correctable errors, while
the second should deliver a perfect stream.  I have line-of-sight
to both, but I don't have the patience to wait for the first to
have an uncorrectable error.



> I assume that those problems are related to the tuner (correct me if I'm
> wrong). The MyGica T1680 USB stick is really bad, Nova-T PCI is quite good

As I note, there are several possibilities.  So, you may be
right, or you may be wrong.  It may be a less sensitive tuner.



> I would like to build a dedicated STB with 2-3 DVB-T tuners. So my question
> is: Is there any well known DVB-T card (preferably USB) that has a sensitive
> and stable tuner that can deliver error free streams?

The USB tuners I have all deliver error-free streams when
connected to a decent USB port, and any errors I do see are
fixed by slightly adjusting the antenna.  But I'm in a strong
signal location for the signals I quoted above, and the first
one that hasn't popped up a block error yet will see a drop
to 0 in the Verror field if I orient the antenna to a different
polarisation.

Note that DVB-T is meant to work with multipath interference
that made analogue signals from the same transmitter sites
unwatchable or with clear errors.  So it wouldn't surprise
me if on occasion there would be an uncorrectable error now
and then in some receiving conditions (moving a small aerial
while observing the analogue signal showed a marked change in
the signal quality), and it is also affected by reflections
that are supposed to be corrected.  I'm not sure if this
could be a factor for you.



> Thanks for any tips,

Hope this gives food for thought.

barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
