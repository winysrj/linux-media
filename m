Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58836 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CDXL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 18:11:57 -0500
Received: by wwb22 with SMTP id 22so3306463wwb.1
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2011 15:11:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D716ECA.4060900@iki.fi>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
	<4D716ECA.4060900@iki.fi>
Date: Fri, 4 Mar 2011 23:11:55 +0000
Message-ID: <AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: Andrew de Quincey <adq_dvb@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 4 March 2011 22:59, Antti Palosaari <crope@iki.fi> wrote:
> On 03/05/2011 12:44 AM, Andrew de Quincey wrote:
>>>>
>>>> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
>>>> accesses will take multiple i2c transactions.
>>>>
>>>> Therefore, the following patch overrides the dvb_frontend_ops
>>>> functions to add a per-device lock around them: only one frontend can
>>>> now use the i2c bus at a time. Testing with the scripts above shows
>>>> this has eliminated the errors.
>>>
>>> This have annoyed me too, but since it does not broken functionality much
>>> I
>>> haven't put much effort for fixing it. I like that fix since it is in
>>> AF9015
>>> driver where it logically belongs to. But it looks still rather complex.
>>> I
>>> see you have also considered "bus lock" to af9015_i2c_xfer() which could
>>> be
>>> much smaller in code size (that's I have tried to implement long time
>>> back).
>>>
>>> I would like to ask if it possible to check I2C gate open / close inside
>>> af9015_i2c_xfer() and lock according that? Something like:
>>
>> Hmm, I did think about that, but I felt overriding the functions was
>> just cleaner: I felt it was more obvious what it was doing. Doing
>> exactly this sort of tweaking was one of the main reasons we added
>> that function overriding feature.
>>
>> I don't like the idea of returning "error locked by FE" since that'll
>> mean the tuning will randomly fail sometimes in a way visible to
>> userspace (unless we change the core dvb_frontend code), which was one
>> of the things I was trying to avoid. Unless, of course, I've
>> misunderstood your proposal.
>
> Not returning error, but waiting in lock like that:
> if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
>  return -EAGAIN;

Ah k, sorry

>> However, looking at the code again, I realise it is possible to
>> simplify it. Since its only the demod gates that cause a problem, we
>> only /actually/ need to lock the get_frontend() and set_frontend()
>> calls.
>
> I don't understand why .get_frontend() causes problem, since it does not
> access tuner at all. It only reads demod registers. The main problem is
> (like schema in af9015.c shows) that there is two tuners on same I2C bus
> using same address. And demod gate is only way to open access for desired
> tuner only.

AFAIR /some/ tuner code accesses the tuner hardware to read the exact
tuned frequency back on a get_frontend(); was just being extra
paranoid :)

> You should block traffic based of tuner not demod. And I think those
> callbacks which are needed for override are tuner driver callbacks. Consider
> situation device goes it v4l-core calls same time both tuner .sleep() ==
> problem.

Hmm, yeah, you're right, let me have another look tomorrow.
