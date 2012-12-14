Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51538 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761Ab2LNXD0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 18:03:26 -0500
Message-ID: <50CBB01B.2050700@iki.fi>
Date: Sat, 15 Dec 2012 01:02:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrice Chotard <patrice.chotard@sfr.fr>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Fr=E9d=E9ric?= <frederic.mantegazza@gbiloba.org>
Subject: Re: [PATCH] [media] ngene: fix dvb_pll_attach failure
References: <50B51F7E.2030008@sfr.fr> <50CB61A6.7060308@sfr.fr> <50CB67F4.3090802@iki.fi> <50CBA8BE.8020205@sfr.fr>
In-Reply-To: <50CBA8BE.8020205@sfr.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2012 12:31 AM, Patrice Chotard wrote:
> Le 14/12/2012 18:55, Antti Palosaari a écrit :
>> On 12/14/2012 07:28 PM, Patrice Chotard wrote:
>>> Before dvb_pll_attch call, be sure that drxd demodulator was
>>> initialized, otherwise, dvb_pll_attach() will always failed.
>>>
>>> In dvb_pll_attach(), first thing done is to enable the I2C gate
>>> control in order to probe the pll by performing a read access.
>>> As demodulator was not initialized, every i2c access failed.
>>>
>>> Reported-by: frederic.mantegazza@gbiloba.org
>>> Signed-off-by: Patrice Chotard <patricechotard@free.fr>
>>> ---
>>>    drivers/media/pci/ngene/ngene-cards.c |    2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/media/pci/ngene/ngene-cards.c
>>> b/drivers/media/pci/ngene/ngene-cards.c
>>> index 96a13ed..e2192db 100644
>>> --- a/drivers/media/pci/ngene/ngene-cards.c
>>> +++ b/drivers/media/pci/ngene/ngene-cards.c
>>> @@ -328,6 +328,8 @@ static int demod_attach_drxd(struct ngene_channel
>>> *chan)
>>>            return -ENODEV;
>>>        }
>>>
>>> +    /* initialized the DRXD demodulator */
>>> +    chan->fe->ops.init(chan->fe);
>>>        if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
>>>                &chan->i2c_adapter,
>>>                feconf->pll_type)) {
>>>
>>
>> I don't like that as this causes again more deviation against normal
>> procedures. If gate open is needed (for probe or id check?) then
>> pll/tuner attach should open it. If that is not easily possible then
>> calling gate_control() before pll attach is allowed. init() is very,
>> very, bad as generally starts whole chip => starts eating power etc.
>>
>>
>> Even better would be to let whole gate-control to responsibility of
>> DVB-core, but unfortunately current situation is quite mess. Gate is
>> operated sometimes by DVB-core (like for init/sleep) and for some cases
>> it is left for responsibility of tuner driver. So on real life there is
>> mixed solutions and  for init/sleep gate is even double controlled.
>>
>>
>> regards
>> Antti
>>
>
> Hi Antti,
>
> Unfortunately, opening gate doesn't work with drxd demodulator before
> its initialization (drxd_init() call).
> Also, in dvb_pll_attach(), first thing done is opening the gate control.
>
> I was aware by calling init() directly in demod_attach_drxd() was not
> good at the power consumption point of view, but it was the only
> solution to make it work.
>
> To stop the power consumption, it would be possible to call the frontends :
>
>   	}
>
> +	/* initialized the DRXD demodulator */
> +	chan->fe->ops.init(chan->fe);
>   	if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
>   			&chan->i2c_adapter,
>   			feconf->pll_type)) {
>   		pr_err("No pll(%d) found!\n", feconf->pll_type);
>   		return -ENODEV;
>   	}
> +	chan->fe->ops.sleep(chan->fe);
>   	return 0;
>   }
>
> Thanks for your feedback.

That one is better solution...

but it is clearly DRXD driver bug - it should offer working I2C gate 
control after attach() :-( I looked quickly DRXD driver and there is 
clearly some other places to enhance too. But I suspect there is no 
maintainer, nor interest from anyone to start fix things properly, so 
only reasonable way is to add that hack to get it working...

Honestly, I hate this kind of hacks :/ That makes our live hard on long 
run. It goes slowly more and more hard to make any core changes as 
regressions will happen due to this kind of hacks.

So send new patch which put demod chip sleeping after tuner attach. Or 
even better, find out what is minimal set of commands needed do execute 
during attach in order to offer working I2C gate (I suspect firmware 
load is needed).


regards
Antti

-- 
http://palosaari.fi/
