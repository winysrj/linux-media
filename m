Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1Jux1k-00051X-9t
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 23:54:49 +0200
Received: from [192.168.1.2] (01-138.155.popsite.net [66.217.131.138])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id m4ALsaw1022056
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 17:54:37 -0400 (EDT)
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <200805101727.55810@orion.escape-edv.de>
References: <482560EB.2000306@gmail.com>
	<200805101717.23199@orion.escape-edv.de>
	<200805101727.55810@orion.escape-edv.de>
Date: Sat, 10 May 2008 17:53:41 -0400
Message-Id: <1210456421.7632.29.camel@palomino.walls.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021
	and	stv0297
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

On Sat, 2008-05-10 at 17:27 +0200, Oliver Endriss wrote:
> Oliver Endriss wrote:
> > e9hack wrote:
> > > the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
> > > makes the UNC value of the femon plugin useless.
> > 
> > Why? It does not make sense to accumulate the errors forever, i.e.
> > nobody wants to know what happened last year...
> > 
> > Afaics it is ok to reset the counter after reading it.
> > All drivers should behave this way.
> > 
> > If the femon plugin requires something else it might store the values
> > and process them as desired.
> > 
> > Afaics the femon command line tool has no problems with that.
> 
> Argh, I just checked the API 1.0.0. spec:
> | FE READ UNCORRECTED BLOCKS
> | This ioctl call returns the number of uncorrected blocks detected by the device
> | driver during its lifetime. For meaningful measurements, the increment
> | in block count during a speci c time interval should be calculated. For this
> | command, read-only access to the device is suf cient.
> | Note that the counter will wrap to zero after its maximum count has been
> | reached
> 
> So it seens you are right and the drivers should accumulate the errors
> forever. Any opinions?

For communications systems, whether its is two-way or one-way broadcast,
most people are concerned with the error *rate* (errors per unit time)
rather than absolute error counts.  Communications engineers have a good
understanding of what it means to have a 10^-2 BER vs 10^-12 BER, and
adjust their expectations accordingly.  Absolute counts have less
meaning to engineers, and I'm not sure what a layman would make of them.

I'd suggest whatever error counts you store have a start time and
starting value (i.e. 0) associated with them, so when you look at the
accumulated value at present you can determine the average error rate.

When should the error counter and start time be reset?  On channel
(frequency) change is a convenient and make sense to me.  When the
counter overflows is obviously another time.  When the time reaches a
certain number of seconds?  Maybe implement a moving average (sliding
window) to better report the current instantaneous error rate.


Regards,
Andy



> CU
> Oliver
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
