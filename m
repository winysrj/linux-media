Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1HAAqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 20:46:54 -0400
Message-ID: <4E35F773.3060807@redhat.com>
Date: Sun, 31 Jul 2011 21:46:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
References: <4E2E0788.3010507@iki.fi> <4E3061CF.2080009@redhat.com> <4E306BAE.1020302@iki.fi>
In-Reply-To: <4E306BAE.1020302@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-07-2011 16:49, Antti Palosaari escreveu:
> On 07/27/2011 10:06 PM, Mauro Carvalho Chehab wrote:
> 
>>> +    for (i = 0; i<= x; i++) {
>>> +        ret = adap->props.frontend_attach(adap);
>>> +        if (ret || adap->fe[i] == NULL) {
>>> +            /* only print error when there is no FE at all */
>>> +            if (i == 0)
>>> +                err("no frontend was attached by '%s'",
>>> +                    adap->dev->desc->name);
>>
>> This doesn't seem right. One thing is to accept adap->fe[1] to be
>> NULL. Another thing is to accept an error at the attach. IMO, the
>> logic should be something like:
>>
>>     if (ret<  0)
>>         return ret;
>>
>>     if (!i&&  !adap->fe[0]) {
>>         err("no adapter!");
>>         return -ENODEV;
>>     }
> 
> Heh, I tried to keep it functioning as earlier not to break anything! Only thing it does now differently is that it keeps silent when 2nd FE attach fails since we don't know always before fe attach if there is fe or not.
> 
> So since it *does not change old behaviour* it must be OK. Let fix old problems later. There is millions of DVB USB callbacks failing silently - like tuner_attach etc.
> 
> Surely I want also fix many old issues but it is always too risky.

Added support for DRX-K way at dvb-usb:

http://git.linuxtv.org/mchehab/experimental.git/commitdiff/765b3db218f1e9af6432251c2ebe59bc9660cd42
http://git.linuxtv.org/mchehab/experimental.git/commitdiff/37fa5797c58068cc60cca6829bd662cd4f883cfa

One bad thing I noticed with the API is that it calls adap->props.frontend_attach(adap)
several times, instead of just one, without even passing an argument for the driver to
know that it was called twice.

IMO, there are two ways of doing the attach:

1) call it only once, and, inside the driver, it will loop to add the other FE's;
2) add a parameter, at the call, to say what FE needs to be initialized.

I think (1) is preferred, as it is more flexible, allowing the driver to test for
several types of frontends.

Regards,
Mauro
