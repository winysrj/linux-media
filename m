Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JRayq-00084s-Im
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 23:30:36 +0100
Date: Tue, 19 Feb 2008 23:29:14 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <1203459408.28796.19.camel@youkaida>
Message-ID: <Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203457264.8019.6.camel@anden.nu> <1203459408.28796.19.camel@youkaida>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
 receiver
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

Hi,

On Tue, 19 Feb 2008, Nicolas Will wrote:
>> I would suggest creating a netlink device which lircd (or similar) can
>> read from.
>
> Be ready to discount my opinion, I'm not too good at those things.
>
> Wouldn't going away from an event interface kill a possible direct link
> between the remote and X?
>
> The way I see it, LIRC is an additional layer that may be one too many
> in most cases. From my point of view, it is a relative pain I could do
> without. But I may have tunnel vision by lack of knowledge.

I agree with you. I'm more looking for a solution with existing things. 
LIRC is not in kernel. I don't think we should do something specific, new. 
If there is nothing which can be done with the event system I think we 
should either extend it or just drop this idea.

What about HID?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
