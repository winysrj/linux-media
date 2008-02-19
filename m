Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRamW-0006VX-NT
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 23:17:44 +0100
From: Nicolas Will <nico@youplala.net>
To: Jonas Anden <jonas@anden.nu>
In-Reply-To: <1203457264.8019.6.camel@anden.nu>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203457264.8019.6.camel@anden.nu>
Date: Tue, 19 Feb 2008 22:16:48 +0000
Message-Id: <1203459408.28796.19.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with
	dib0700	ir	receiver
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


On Tue, 2008-02-19 at 22:41 +0100, Jonas Anden wrote:
> 
> > In any case, especially to that problem with "unknown key code" I
> think it 
> > is time to change the IR-behavior of the DVB-USB.
> > 
> > My problem is, I don't know how.
> > 
> > My naive idea would be, that the IR-code is reporting each key (as
> raw as 
> > possible) without mapping it to an event to the event interface and
> then 
> > someone, somewhere is interpreting it. Also forward any
> repeat-attribute.
> 
> I would suggest creating a netlink device which lircd (or similar) can
> read from.

Be ready to discount my opinion, I'm not too good at those things.

Wouldn't going away from an event interface kill a possible direct link
between the remote and X?

The way I see it, LIRC is an additional layer that may be one too many
in most cases. From my point of view, it is a relative pain I could do
without. But I may have tunnel vision by lack of knowledge.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
