Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sif.is.scarlet.be ([193.74.71.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JZUMh-0006WF-5g
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 18:03:44 +0100
Received: from fry (ip-81-11-185-117.dsl.scarlet.be [81.11.185.117])
	by sif.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m2CH3cph003595
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 18:03:38 +0100
From: "Ben Backx" <ben@bbackx.com>
To: <linux-dvb@linuxtv.org>
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
	<21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
In-Reply-To: <21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
Date: Wed, 12 Mar 2008 18:03:31 +0100
Message-ID: <001201c88463$00432bd0$00c98370$@com>
MIME-Version: 1.0
Content-Language: en-gb
Subject: Re: [linux-dvb] Implementing support for multi-channel
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

> -----Original Message-----
> From: Stephen Rowles [mailto:stephen@rowles.org.uk]
> Sent: 12 March 2008 13:20
> To: Ben Backx
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Implementing support for multi-channel
> 
> > Hello,
> >
> > I was wondering if there's some info to find on how to implement (and
> > test)
> > multi-channel receiving?
> > It's possible, because dvb uses streams and the driver is currently
> > capable
> > to filter one channel, but how can I implement the support of
> > multi-channel
> > filtering?
> > Is there perhaps an open-source driver supporting this that I can
> have a
> > look at?
> 
> Check out the dvbstreamer project:
> 
> http://dvbstreamer.sourceforge.net/
> 
> This allows multi-channel recording / streaming if the DVB device
> supports
> sending the whole transport stream (some usb devices do not support
> this).
> This works by sending the whole transport stream to the dvbstreamer
> program, then this program allows filtering out and recording separate
> channels from that stream as required.
> 
> This isn't a driver level solution, but might provide the function you
> need.

It's (partly) for a research project, so I have to look at all possible
solutions, software being one, so dvbstreamer is part of the solution :-)
The others are at driver and hardware level (the hardware supports this).



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
