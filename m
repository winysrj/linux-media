Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xyzzy@speakeasy.org>) id 1JUSja-00073e-9q
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 21:18:34 +0100
Date: Wed, 27 Feb 2008 12:17:59 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andreas Oberritter <obi@linuxtv.org>
In-Reply-To: <47C4E2B6.40900@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0802271210270.14140@shell4.speakeasy.net>
References: <1204046724.994.21.camel@amd64.pyotr.org>
	<47C4E2B6.40900@linuxtv.org>
MIME-Version: 1.0
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams
 from same mux
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

On Wed, 27 Feb 2008, Andreas Oberritter wrote:
> Peter Hartley wrote:
> > The attached patch adds a new value for dmx_output_t:
> > DMX_OUT_TSDEMUX_TAP, which sends TS to the demux0 device. The main
> > question I have, is, seeing as this was such a simple change, why didn't
> > it already work like that? Does everyone else who wants to capture
> > multiple video streams, take the whole multiplex into userspace and
> > demux it themselves? Or do they take PES from each demux0 device and

Yes, they all demux in userspace themselves.  If you search the archives,
I've pointed out this same problem.

One thing you do lose with the kernel demuxing system is the relationship
between the different streams.  For instance, a PMT change takes effect for
all packets that follow it, but with the demuxed streams, you don't know
where that is.

Of course if you want to work with existing systems, you have to demux in
userspace since no one will have this new feature yet.  And if you're doing
that anyway, it's more work to add additional support for demuxed TS
streams to your software.  That probably why no one has bothered to add
this feature.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
