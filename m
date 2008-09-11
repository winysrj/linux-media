Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n70.bullet.mail.sp1.yahoo.com ([98.136.44.38])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KdmT4-0006U7-TL
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 15:44:20 +0200
Date: Thu, 11 Sep 2008 06:43:41 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48C89D12.4060207@linuxtv.org>
MIME-Version: 1.0
Message-ID: <570512.55545.qm@web46113.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Reply-To: free_beer_for_all@yahoo.com
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

--- On Thu, 9/11/08, Andreas Oberritter <obi@linuxtv.org> wrote:

> How about dropping demux1 and dvr1 for this adapter, since they don't
> create any benefit? IMHO the number of demux devices should always equal
> the number of simultaneously usable transport stream inputs.

I like this `solution', but I'm not sure it is optimal...

Sure, it works for 2x devices, where only one at a time can be
used, but if one has a hypothetical DVB-S(2) + DVB-C/T device,
with two RF inputs, so that one could simultaneously use sat
and one of cable/terrestrial, you'd get two demux devices, and
three frontends, and you'd need to map the exclusivity of the
cable/terrestrial frontend somehow.

The `problem' I see with the separate adapters, is that, should
my dream PCI card with 2xSat, 2xDVB-T(2), and 2xDVB-C ever
materialise (and obsolete analogue), I'd need 6 /dev/dvb/adapter
entries, coming close to the current #define of 8.

My `production' machine has reached its limit of 4, and I'm
cautiously considering upgrading parts of it, not yet sure if
that limit is thanks to device minor numbers or what, but then,
its hardware capacity is almost reached with three USB DVB
devices.  (A quick test on my current kernel revealed that minor
numbers isn't a problem nowadays)


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
