Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sif.is.scarlet.be ([193.74.71.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JiEeP-0004Gr-QG
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 22:06:12 +0200
Received: from fry (ip-81-11-181-162.dsl.scarlet.be [81.11.181.162])
	by sif.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m35K64s5025283
	for <linux-dvb@linuxtv.org>; Sat, 5 Apr 2008 22:06:05 +0200
From: "Ben Backx" <ben@bbackx.com>
To: <linux-dvb@linuxtv.org>
References: <47D99FE8.80903@googlemail.com>
	<001801c88d9c$903339f0$b099add0$@com>
	<47E7B2DB.3050009@googlemail.com>
In-Reply-To: <47E7B2DB.3050009@googlemail.com>
Date: Sat, 5 Apr 2008 22:05:50 +0200
Message-ID: <006001c89758$727cb1f0$577615d0$@com>
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

> 
> The way I see it, but I think it might depend on the card as well, is
> that the driver in the kernel
> always receives the whole TS and then does a software filter which you
> can trigger via DMX_SET_PES_FILTER.
> 

Still trying to figure things out...
I just can't seem to find out where exactly things are happening.
I've been looking at some dvb-code, and when it comes to setting
PES-filters, this always is done by using an ioctl-call (eg: ioctl(fd,
DMX_SET_PES_FILTER, &pesFilterParams)), I'm unsure what this means...
Aren't ioctl-calls ment to be handled in hardware? This would mean that the
filtering used by eg. dvbstream is already done in hardware... Or am I
missing something?


Greetz,
Ben


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
