Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:60118 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab2LNTb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 14:31:29 -0500
Message-ID: <50CB7E88.9050207@iki.fi>
Date: Fri, 14 Dec 2012 21:31:20 +0200
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: balbi@ti.com
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi> <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi> <20121120195755.GM18567@atomide.com> <20121214172809.GT4989@atomide.com> <20121214172616.GC9620@arwen.pp.htv.fi>
In-Reply-To: <20121214172616.GC9620@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/12 19:26, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Dec 14, 2012 at 09:28:09AM -0800, Tony Lindgren wrote:
>> * Tony Lindgren <tony@atomide.com> [121120 12:00]:
>>> Hi,
>>>
>>> * Timo Kokkonen <timo.t.kokkonen@iki.fi> [121118 07:15]:
>>>> --- a/drivers/media/rc/ir-rx51.c
>>>> +++ b/drivers/media/rc/ir-rx51.c
>>>> @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
>>>>  			      OMAP_TIMER_TRIGGER_NONE);
>>>>  }
>>>>  
>>>> +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
>>>> +{
>>>> +	if (lirc_rx51->wbuf_index < 0)
>>>> +		return;
>>>> +
>>>> +	lirc_rx51_off(lirc_rx51);
>>>> +	lirc_rx51->wbuf_index = -1;
>>>> +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
>>>> +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
>>>> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
>>>> +	wake_up(&lirc_rx51->wqueue);
>>>> +}
>>>> +
>>>>  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
>>>>  {
>>>>  	u32 load, match;
>>>
>>> Good fixes in general.. But you won't be able to access the
>>> omap_dm_timer functions after we enable ARM multiplatform support
>>> for omap2+. That's for v3.9 probably right after v3.8-rc1.
>>>
>>> We need to find some Linux generic API to use hardware timers
>>> like this, so I've added Thomas Gleixner and linux-arm-kernel
>>> mailing list to cc.
>>>
>>> If no such API is available, then maybe we can export some of
>>> the omap_dm_timer functions if Thomas is OK with that.
>>
>> Just to update the status on this.. It seems that we'll be moving
>> parts of plat/dmtimer into a minimal include/linux/timer-omap.h
>> unless people have better ideas on what to do with custom
>> hardware timers for PWM etc.
> 
> if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> 

Now that Neil Brown posted the PWM driver for omap, I've been thinking
about whether converting the ir-rx51 into the PWM API would work. Maybe
controlling the PWM itself would be sufficient, but the ir-rx51 uses
also another dmtimer for creating accurate (enough) timing source for
the IR pulse edges.

I haven't tried whether the default 32kHz clock source is enough for
that. Now that I think about it, I don't see why it wouldn't be good
enough. I think it would even be possible to just use the PWM api alone
(plus hr-timers) in order to generate good enough IR pulses.

-Timo

> Meaning that $SUBJECT would just request a PWM device and use it. That
> doesn't solve the whole problem, however, as pwm-omap.c would still need
> access to timer-omap.h.
> 

