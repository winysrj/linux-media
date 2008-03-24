Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sif.is.scarlet.be ([193.74.71.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JdkE4-0005ic-NL
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 11:48:25 +0100
From: "Ben Backx" <ben@bbackx.com>
To: "'Andrea'" <mariofutire@googlemail.com>, <linux-dvb@linuxtv.org>
References: <47D99FE8.80903@googlemail.com>
In-Reply-To: <47D99FE8.80903@googlemail.com>
Date: Mon, 24 Mar 2008 11:48:12 +0100
Message-ID: <001801c88d9c$903339f0$b099add0$@com>
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

Sorry, late reply, been busy with some other stuff.
Back to driver-development.
Perhaps, first some background. I'm a university student in my last year and
am busy with a dissertation (thesis) about DVB (in my case: DVB-s, the
others (c en t) are limited here in Belgium).

The goal is to check and, if possible, optimize the performance of
multi-channel demuxing/decoding. For the moment, I'm looking at 3 possible
scenarios: 
1) Let the end-user software do all the work (meaning: giving the whole TS
to the application), this is possible with eg Kaffeine, flumotion, etc...
2) Let the driver do the work
3) Hardware

The hardware supports multi-PID-filtering, so that's not the problem, the
only problem is: which functions have to be implemented in my driver? In
other words: is there an application that says to the driver: give me the
stream with that PID and which function is called to do that? I'm guessing
DMX_SET_PES_FILTER?


> 
> Have you read my last post?
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024456.html
> 
> When I talk about filter, demux, dvr, this is all in the kernel driver
> for the dvb.
> 

Sorry, must have missed it. You're completely right when you say the driver
must be able to filter more than one PID at the same time, this is also part
of my research: seeing how many PID's I can filter at the same time.

> You can find here an example of how to open the demux to get 1 PID.
> You can run it multiple times and get as many streams as you want
> 
> http://www.audetto.pwp.blueyonder.co.uk/dvb.cpp
> 

Thanks for the example, I think it will come in handy when implementing
DMX_SET_PES_FILTER


Thank you for all the help so far.


Regards,
Ben
 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
