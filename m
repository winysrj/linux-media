Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LGf87-0002tN-Lp
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 20:47:24 +0100
From: Andy Walls <awalls@radix.net>
To: Artem Makhutov <artem@makhutov.org>
In-Reply-To: <20081227180001.GS12059@titan.makhutov-it.de>
References: <20081227180001.GS12059@titan.makhutov-it.de>
Date: Sat, 27 Dec 2008 14:49:30 -0500
Message-Id: <1230407370.3121.19.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compile DVB drivers for kernel 2.6.11
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

On Sat, 2008-12-27 at 19:00 +0100, Artem Makhutov wrote:
> Hello,
> 
> I would like to compile current dvb-drivers from hg for kernel 2.6.11.12.
> 
> Is this possible?

The oldest supported kernel version is 2.6.16.


> Has somebody experience with this?

Hans Verkuil did a lot of work and testing in the area of ensuring valid
support of older kernels.   I recall Hans stating that supporting
kernels earlier than 2.6.12 was not feasible.  I can't remember the
reasons why 2.6.12-2.6.15 are not supported.  Check the linux-dvb and
video4linux list archives.


> The first problem I am running into is that 2.6.11 has no linux/mutex.h.

That's probably because the non-spinning mutual exclusion mechanism was
kernel semaphores way back then.

Regards,
Andy

> Thanks, Artem



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
