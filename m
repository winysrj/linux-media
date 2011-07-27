Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33522 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1G0UT7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:19:59 -0400
Message-ID: <4E3072EC.9080502@iki.fi>
Date: Wed, 27 Jul 2011 23:19:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi> <4E3061CF.2080009@redhat.com> <4E306BAE.1020302@iki.fi> <4E306FBB.3030904@redhat.com>
In-Reply-To: <4E306FBB.3030904@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2011 11:06 PM, Mauro Carvalho Chehab wrote:
> Em 27-07-2011 16:49, Antti Palosaari escreveu:
>> On 07/27/2011 10:06 PM, Mauro Carvalho Chehab wrote:
>>
>>>> +    for (i = 0; i<= x; i++) {
>>>> +        ret = adap->props.frontend_attach(adap);
>>>> +        if (ret || adap->fe[i] == NULL) {
>>>> +            /* only print error when there is no FE at all */
>>>> +            if (i == 0)
>>>> +                err("no frontend was attached by '%s'",
>>>> +                    adap->dev->desc->name);
>>>
>>> This doesn't seem right. One thing is to accept adap->fe[1] to be
>>> NULL. Another thing is to accept an error at the attach. IMO, the
>>> logic should be something like:
>>>
>>>      if (ret<   0)
>>>          return ret;
>>>
>>>      if (!i&&   !adap->fe[0]) {
>>>          err("no adapter!");
>>>          return -ENODEV;
>>>      }
>>
>> Heh, I tried to keep it functioning as earlier not to break anything! Only thing it does now differently is that it keeps
>> silent when 2nd FE attach fails since we don't know always before fe attach if there is fe or not.
>>
>> So since it *does not change old behaviour* it must be OK. Let fix old problems later. There is millions of DVB USB
>> callbacks failing silently - like tuner_attach etc.
>>
>> Surely I want also fix many old issues but it is always too risky.
>
> I'm talking about adding another bad behavior: let MFE to have one of the FE's
> failing.

Let the device driver made decision! I can add check that if ret < 0 
then fail as fatal, but if there is ret=0 and fe=NULL is not fatal. But 
since it was discarded earlier I didnt added such check.

There is many devices have like 2 demod places on board. Then it is 
housed as demod#0 + demod#1, #demod0 or #demod1. You will not know that 
before trying to attach demod. Thus it *must* be possible to discard 
missing demod silently. Surely there is soon someone end user making bug 
reports if you print error on that case or even deregister whole device.

>>>> +        if (dvb_register_frontend(&adap->dvb_adap, adap->fe[i])) {
>>>> +            err("Frontend %d registration failed.", i);
>>>> +            dvb_frontend_detach(adap->fe[i]);
>>>
>>> There is a special case here: for DRX-K, we can't call dvb_frontend_detach().
>>> as just one drxk_attach() returns the two pointers. While this is not fixed,
>>> we need to add some logic here to check if the adapter were attached.
>>
>> There is currently no DVB USB driver using DRX-K thus it is not problem. If someone will add such support can fix DRX-K driver.
>
> I agree. I was just rising the question. The glue should be bound together with the first
> dvb-usb DRX-K driver.
>
>> Also take into account it is possible to register only 1 FE using DVB USB and manually register 2nd FE as it have been those days.
>>
>>
>>>> +            adap->fe[i] = NULL;
>>>> +            /* In error case, do not try register more FEs,
>>>> +             * still leaving already registered FEs alive. */
>>>
>>> I think that the proper thing to do is to detach everything, if one of
>>> the attach fails. There isn't much sense on keeping the device partially
>>> initialized.
>
>> It is not attach which fails here, it is dvb_register_frontend registration.
>
> Yes, sure. I've miss-named.
>
>> And I thought that too since it is rather major problem. But as it seems to be very easy to do it like that I did. Not big issue though.
>
> Core functions should be more strict than drivers. So, I think it should really
> enforce an all-or-nothing behavior here.

Lets add it later, like next merge window.

>>>> +        /* use exclusive FE lock if there is multiple shared FEs */
>>>> +        if (adap->fe[1])
>>>> +            adap->dvb_adap.mfe_shared = 1;
>>>
>>> Why? multiple FE doesn't mean that they're mutually exclusive.
>>
>> And again we ran same MFE discussion..... But if you look DVB USB you can see its main idea
>> have been to register multiple adapters in case of not exclusive frontends. That have been
>> most likely implemented like that from day-0 of DVB USB.
>>
>> Another point is that it is not that patch which adds support for MFE. It is old issue and
>> I am not responsible of it. See patch where this decision is made in year 2008:
>>
>> commit 59b1842da1c6f33ad2e8da82d3dfb3445751d964
>> Author: Darron Broad<darron@kewl.org>
>> Date:   Sat Oct 11 11:44:05 2008 -0300
>>
>>      V4L/DVB (9227): MFE: Add multi-frontend mutual exclusion
>>
>>
>> Why to change again old behaviour?
>>
>>
>> Could you now read all with care. As I pointed out almost all your findings are are decisions made *earlier*.
>>
>> Only thing which is not coming from oldies is that you suggest to unregister all frontends if one register fails.
>
> You miss-understood me. I'm not saying that we should drop support for mfe_shared flag.
> I'm just saying that dvb-usb core should not assume that a driver with more than one
> FE have them into a mutually exclusive configuration.
>
> If you look at dvb-core, the default for it is mfe_shared = 0. We should keep the same
> default for dvb-usb.
>
> In other words, it should be up to the drivers to change mfe_shared flag to 1, and not
> to the core.

Peace of cake. Anyhow, we still have 2 adapters for DVB USB for that and 
have been long than I can remember. So I cannot real see point of doing 
that.


regards
Antti


-- 
http://palosaari.fi/
