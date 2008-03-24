Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jdn9V-00050D-5n
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:55:56 +0100
Received: by el-out-1112.google.com with SMTP id o28so1139168ele.2
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 06:55:42 -0700 (PDT)
Message-ID: <47E7B2DB.3050009@googlemail.com>
Date: Mon, 24 Mar 2008 13:55:39 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: Ben Backx <ben@bbackx.com>
References: <47D99FE8.80903@googlemail.com>
	<001801c88d9c$903339f0$b099add0$@com>
In-Reply-To: <001801c88d9c$903339f0$b099add0$@com>
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

Ben Backx wrote:
> Sorry, late reply, been busy with some other stuff.
> Back to driver-development.
> 
> The hardware supports multi-PID-filtering, so that's not the problem, the
> only problem is: which functions have to be implemented in my driver? In
> other words: is there an application that says to the driver: give me the
> stream with that PID and which function is called to do that? I'm guessing
> DMX_SET_PES_FILTER?

I see.
To be honest with you I don't know the difference between kernel level filter and hardware filter.

The way I see it, but I think it might depend on the card as well, is that the driver in the kernel 
always receives the whole TS and then does a software filter which you can trigger via 
DMX_SET_PES_FILTER.

I don't know anything about hardware filter.
Someone else should maybe answer this question.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
