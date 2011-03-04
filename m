Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:33896 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1CDW7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 17:59:24 -0500
Message-ID: <4D716ECA.4060900@iki.fi>
Date: Sat, 05 Mar 2011 00:59:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew de Quincey <adq_dvb@lidskialf.net>
CC: linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi> <AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
In-Reply-To: <AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/05/2011 12:44 AM, Andrew de Quincey wrote:
>>> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
>>> accesses will take multiple i2c transactions.
>>>
>>> Therefore, the following patch overrides the dvb_frontend_ops
>>> functions to add a per-device lock around them: only one frontend can
>>> now use the i2c bus at a time. Testing with the scripts above shows
>>> this has eliminated the errors.
>>
>> This have annoyed me too, but since it does not broken functionality much I
>> haven't put much effort for fixing it. I like that fix since it is in AF9015
>> driver where it logically belongs to. But it looks still rather complex. I
>> see you have also considered "bus lock" to af9015_i2c_xfer() which could be
>> much smaller in code size (that's I have tried to implement long time back).
>>
>> I would like to ask if it possible to check I2C gate open / close inside
>> af9015_i2c_xfer() and lock according that? Something like:
>
> Hmm, I did think about that, but I felt overriding the functions was
> just cleaner: I felt it was more obvious what it was doing. Doing
> exactly this sort of tweaking was one of the main reasons we added
> that function overriding feature.
>
> I don't like the idea of returning "error locked by FE" since that'll
> mean the tuning will randomly fail sometimes in a way visible to
> userspace (unless we change the core dvb_frontend code), which was one
> of the things I was trying to avoid. Unless, of course, I've
> misunderstood your proposal.

Not returning error, but waiting in lock like that:
if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
   return -EAGAIN;

> However, looking at the code again, I realise it is possible to
> simplify it. Since its only the demod gates that cause a problem, we
> only /actually/ need to lock the get_frontend() and set_frontend()
> calls.

I don't understand why .get_frontend() causes problem, since it does not 
access tuner at all. It only reads demod registers. The main problem is 
(like schema in af9015.c shows) that there is two tuners on same I2C bus 
using same address. And demod gate is only way to open access for 
desired tuner only.

You should block traffic based of tuner not demod. And I think those 
callbacks which are needed for override are tuner driver callbacks. 
Consider situation device goes it v4l-core calls same time both tuner 
.sleep() == problem.

Antti
-- 
http://palosaari.fi/
