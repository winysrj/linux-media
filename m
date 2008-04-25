Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [66.180.172.116] (helo=vps1.tull.net)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1JpFyS-0002c3-CV
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 06:55:53 +0200
Date: Fri, 25 Apr 2008 14:55:20 +1000
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080425045520.GA17371@tull.net>
References: <1209093378.6367.22.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1209093378.6367.22.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org, ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] [PATCH] mxl500x: Add module parameter
	to	enable/disable debug messages
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

On Thu, Apr 24, 2008 at 11:16:18PM -0400, Andy Walls wrote:
> +#define dprintk(level, fmt, arg...)                                       \
> +	do {                                                              \
> +		if (debug >= level)                                       \
> +			printk(KERN_DEBUG "%s: " fmt, "mxl500x", ## arg); \
> +	} while (0)

I think this code will be far more useful in kernel/printk.c rather
than every device driver and subsystem rolling their own (as seems to 
happen at this time).

Also see dev_dbg() and dev_printk() in include/linux/device.h.
What those macros are missing is what you have here - messages
printed or ignored depending on the value of a module variable
and/or parameter.

Nick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
