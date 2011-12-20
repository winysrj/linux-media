Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1LTP0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 10:26:48 -0500
Message-ID: <4EF0A92B.6010504@redhat.com>
Date: Tue, 20 Dec 2011 13:26:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
References: <4EE929D5.6010106@iki.fi> <4EF08FFC.2070802@redhat.com> <4EF0A141.7010100@iki.fi>
In-Reply-To: <4EF0A141.7010100@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-12-2011 12:52, Antti Palosaari wrote:
> On 12/20/2011 03:39 PM, Mauro Carvalho Chehab wrote:
>>> +
>>> +    /* ensure modulation validy */
>>> +    /* 0=QAM4_NR, 1=QAM4, 2=QAM16, 3=QAM32, 4=QAM64 */
>>> +    if (modulation>  4) {
>>
>> Please, don't use magic values.
>>
>> Instead, it should be something like:
>>     ARRAY_SIZE(reg_mod_vals_tab[0].val)
> ?

Why "4" and not "8" (or whatever)? You're using 4 to avoid a buffer
overflow on your table. As such, please explicitly code it with
ARRAY_SIZE, instead of using a 4 "magic" number.

> 
>>
>> Still, I don't understand why modulation should be QAM64 when the
>> auto_mode is disabled. Shouldn't it be provided via a DVB property?
> 
> API does not support DMB-TH params. See my earlier comment.

Ok, add support for it then ;)

>>> +        break;
>>> +    case 1: /* QAM4 */
>>> +        str_constellation = "QAM4";
>>> +        c->modulation = QPSK; /* FIXME */
>>
>> QPSK and QAM4 are two names for the same encoding.
> 
> I wasn't 100% sure if those are same or not, thats why added comment.
> 
> Maybe we should add #define QAM4 QPSK to API since QAM4 is much more commonly used.
> I think QPSK is seen mostly when dealing with DVB-T.

I would just add a comment at the frontends.h file. Otherwise, we would need
to replace it on every place.

>>
>>> +        break;
>>> +    case 2:
>>> +        str_constellation = "QAM16";
>>> +        c->modulation = QAM_16;
>>> +        break;
>>> +    case 3:
>>> +        str_constellation = "QAM32";
>>> +        c->modulation = QAM_32;
>>> +        break;
>>> +    case 4:
>>> +        str_constellation = "QAM64";
>>> +        c->modulation = QAM_64;
>>> +        break;
>>
>> Please, avoid magic numbers. Instead, use macros for each
>> value.
> 
> I disagree that. Those numbers are coming from demodulator 
> register value. Same way is used almost every driver that 
> supports reading current transmission params from the demod.

There are drivers that don't code it well, but it is always preferred
to use macros for register values. Good drivers have it.
 
>> Again, don't abuse over the API. Instead, add the proper guard
>> intervals into it.
>>
> API issue again. I did that because DMB-TH was not supported.
> 
> Anyhow, I would like to ask why you even mention those as those are commented clearly to be not correctly?
> 
> That is very commonly used method of our demod drivers. Look all existing DMB-TH drivers and you can see same.

The other DMB drivers are ugly and only support whatever they call "auto".
I won't doubt that they implement only a subset of the existing
modulations, FEC's, etc.

I wouldn't be surprised if they only support whatever someone
discovered from sniffing the i2c traffic.

>>> +    /* reset demod */
>>> +    /* it is recommended to HW reset chip using RST_N pin */
>>> +    if (fe->callback) {
>>> +        ret = fe->callback(fe, 0, 0, 0);
>>
>> This looks weird on my eyes. The fe->callback is tuner-dependent.
>> So, the command you should use there requires a test for the tuner
>> type.
>>
>> In other words, if you're needing to use it, the code should be doing
>> something similar to:
>>
>>          if (fe->callback&&  priv->tuner_type == TUNER_XC2028)
>>         ret = fe->callback(fe, 0, XC2028_TUNER_RESET, 0);
>>
>> (the actual coding will depend on how do you store the tuner type, and
>> what are the commands for the tuner you're using)
>>
>> That's said, it probably makes sense to deprecate fe->callback in favor
>> or a more generic set of callbacks, like fe->tuner_reset().
> 
> Yes it is wrong because there was no DEMOD defined. But, the callback
> itself is correctly. IIRC there was only TUNER defined and no DEMOD. 
> Look callback definition from the API. It is very simply to fix. But at
> the time left it like that, because I wanted to avoid touching one file
> more. I will fix it properly later (2 line change).
> 
> And it was not a bug, it was just my known decision. I just forget to comment it as FIXME or TODO.

Feel free to touch on other files, provided that you fix that. There's
no default behavior for fe->callback, as it were written in order to
provide ways for the tuner to call the bridge driver for some device-specific
reasons. So, the commands are defined with macros, and the callback code
should be device-specific.

> After all as I see there is no big bugs. Those findings are mostly related 
> of missing DMB-TH API support (and was even commented clearly). And 1-2 CodingStyle issues.

One issue is pure CodingStyle. The other no-API related aren't.

> As there is still few other DMB-TH drivers having similar issues already in
> the master I don't see why not to add that too. Anyhow, if you see that must
> be put to staging until DMB-TH is defined to API it is OK for me.

Please fix the non-API related issues. If you ack to provide us the API improvements
for DMB for 3.4, and get rid of "auto_mode = true" for all cases, I'm
ok on merging it after the fixes at drivers/media/dvb.

Regards,
Mauro
