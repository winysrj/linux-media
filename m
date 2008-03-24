Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hel.is.scarlet.be ([193.74.71.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JdrRK-00089E-4O
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 19:30:34 +0100
From: "Ben Backx" <ben@bbackx.com>
To: "'Andrea'" <mariofutire@googlemail.com>
References: <47D99FE8.80903@googlemail.com>
	<001801c88d9c$903339f0$b099add0$@com>
	<47E7B2DB.3050009@googlemail.com>
In-Reply-To: <47E7B2DB.3050009@googlemail.com>
Date: Mon, 24 Mar 2008 19:30:19 +0100
Message-ID: <002e01c88ddd$1d9ff450$58dfdcf0$@com>
MIME-Version: 1.0
Content-Language: en-gb
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


> 
> Ben Backx wrote:
> > Sorry, late reply, been busy with some other stuff.
> > Back to driver-development.
> >
> > The hardware supports multi-PID-filtering, so that's not the problem,
> the
> > only problem is: which functions have to be implemented in my driver?
> In
> > other words: is there an application that says to the driver: give me
> the
> > stream with that PID and which function is called to do that? I'm
> guessing
> > DMX_SET_PES_FILTER?
> 
> I see.
> To be honest with you I don't know the difference between kernel level
> filter and hardware filter.
> 
> The way I see it, but I think it might depend on the card as well, is
> that the driver in the kernel
> always receives the whole TS and then does a software filter which you
> can trigger via
> DMX_SET_PES_FILTER.
> 
> I don't know anything about hardware filter.
> Someone else should maybe answer this question.
> 

The hardware can handle it (up to a certain number of PID-filters). The main
difference: cpu-load. When the hardware handles the filtering, the cpu can
be busy with other stuff... (at least, that's what I think).
The (performance) difference between driver and software will be little, I
expect.


Regards,
Ben


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
