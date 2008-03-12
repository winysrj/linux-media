Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen@rowles.org.uk>) id 1JZPxZ-0002IF-Ha
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 13:21:35 +0100
Message-ID: <21776.81.144.130.125.1205324398.squirrel@manicminer.homeip.net>
In-Reply-To: <000f01c8842b$a899efe0$f9cdcfa0$@com>
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
Date: Wed, 12 Mar 2008 12:19:58 -0000 (UTC)
From: "Stephen Rowles" <stephen@rowles.org.uk>
To: "Ben Backx" <ben@bbackx.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

> Hello,
>
> I was wondering if there's some info to find on how to implement (and
> test)
> multi-channel receiving?
> It's possible, because dvb uses streams and the driver is currently
> capable
> to filter one channel, but how can I implement the support of
> multi-channel
> filtering?
> Is there perhaps an open-source driver supporting this that I can have a
> look at?

Check out the dvbstreamer project:

http://dvbstreamer.sourceforge.net/

This allows multi-channel recording / streaming if the DVB device supports
sending the whole transport stream (some usb devices do not support this).
This works by sending the whole transport stream to the dvbstreamer
program, then this program allows filtering out and recording separate
channels from that stream as required.

This isn't a driver level solution, but might provide the function you need.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
