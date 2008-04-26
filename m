Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JpZlS-0003M6-Kk
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 04:03:48 +0200
From: Andy Walls <awalls@radix.net>
To: Nick Andrew <nick-linuxtv@nick-andrew.net>
In-Reply-To: <20080425045520.GA17371@tull.net>
References: <1209093378.6367.22.camel@palomino.walls.org>
	<20080425045520.GA17371@tull.net>
Date: Fri, 25 Apr 2008 21:59:42 -0400
Message-Id: <1209175182.3207.53.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] [PATCH] mxl500x: Add module
	parameter	to	enable/disable debug messages
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

On Fri, 2008-04-25 at 14:55 +1000, Nick Andrew wrote:
> On Thu, Apr 24, 2008 at 11:16:18PM -0400, Andy Walls wrote:
> > +#define dprintk(level, fmt, arg...)                                       \
> > +	do {                                                              \
> > +		if (debug >= level)                                       \
> > +			printk(KERN_DEBUG "%s: " fmt, "mxl500x", ## arg); \
> > +	} while (0)
> 
> I think this code will be far more useful in kernel/printk.c rather
> than every device driver and subsystem rolling their own (as seems to 
> happen at this time).

Probably.  But I certainly don't have the credentials to move that idea
very far forward. :)

> Also see dev_dbg() and dev_printk() in include/linux/device.h.

I looked at those, since Documentation/Codingstyle mentioned them.  They
reduce right back down to almost the same "printk()" statement used in
the macro above.

If it's any real heartburn for anyone, the printk() in the macro quoted
above could be changed to dev_dbg() with a change of arguments.  I'd
need to scrounge up a "struct dev *" every time the module needs to
print out a debug message though.  It's not very pretty (without another
macro!) to dig that out of state->fe->dvb->device all the time, and it
would be more perturbation than necessary just to squelch the spew into
the kernel ring buffer and logs.


> What those macros are missing is what you have here 

To give credit where credit is due, that macro is a work derived from
the macro in linux/drivers/media/dvb/frontends/xc5000.c, (C) Xceive and
Steven Toth.

> - messages
> printed or ignored depending on the value of a module variable
> and/or parameter.

Yes, dev_dbg() and friends are missing that.  My imagination fails me at
the moment, as how to write a generically useful set of functions, with
that characteristic, that a large subset of the drivers could use.


> Nick.

Thanks for the comments.

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
