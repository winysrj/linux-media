Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34622 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1LUG4g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 01:56:36 -0500
Message-ID: <4EF1831E.1090006@iki.fi>
Date: Wed, 21 Dec 2011 08:56:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
References: <4EE929D5.6010106@iki.fi>	<4EF08FFC.2070802@redhat.com>	<4EF0A141.7010100@iki.fi>	<4EF0A92B.6010504@redhat.com> <CAOcJUbygkw-UJ4=V3vsRT8VtdrjhNwng9KQr_FFe=CdsybUBXQ@mail.gmail.com>
In-Reply-To: <CAOcJUbygkw-UJ4=V3vsRT8VtdrjhNwng9KQr_FFe=CdsybUBXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/21/2011 12:35 AM, Michael Krufky wrote:
> On Tue, Dec 20, 2011 at 10:26 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> On 20-12-2011 12:52, Antti Palosaari wrote:
>>>>> +    /* reset demod */
>>>>> +    /* it is recommended to HW reset chip using RST_N pin */
>>>>> +    if (fe->callback) {
>>>>> +        ret = fe->callback(fe, 0, 0, 0);
>>>>
>>>> This looks weird on my eyes. The fe->callback is tuner-dependent.
>>>> So, the command you should use there requires a test for the tuner
>>>> type.
>>>>
>>>> In other words, if you're needing to use it, the code should be doing
>>>> something similar to:
>>>>
>>>>           if (fe->callback&&    priv->tuner_type == TUNER_XC2028)
>>>>          ret = fe->callback(fe, 0, XC2028_TUNER_RESET, 0);
>>>>
>>>> (the actual coding will depend on how do you store the tuner type, and
>>>> what are the commands for the tuner you're using)
>>>>
>>>> That's said, it probably makes sense to deprecate fe->callback in favor
>>>> or a more generic set of callbacks, like fe->tuner_reset().
>>>
>>> Yes it is wrong because there was no DEMOD defined. But, the callback
>>> itself is correctly. IIRC there was only TUNER defined and no DEMOD.
>>> Look callback definition from the API. It is very simply to fix. But at
>>> the time left it like that, because I wanted to avoid touching one file
>>> more. I will fix it properly later (2 line change).
>>>
>>> And it was not a bug, it was just my known decision. I just forget to comment it as FIXME or TODO.
>>
>> Feel free to touch on other files, provided that you fix that. There's
>> no default behavior for fe->callback, as it were written in order to
>> provide ways for the tuner to call the bridge driver for some device-specific
>> reasons. So, the commands are defined with macros, and the callback code
>> should be device-specific.
>
> This generic callback was written for the BRIDGE driver to be called
> by any frontend COMPONENT, not specifically the tuner, perhaps a demod
> or LNB, but at the time of writing, we only needed it from the tuner
> so the DVB_FRONTEND_COMPONENT_TUNER(0) was the only #define created at
> the time.  This was written with forward-compatibility in mind, so
> lets please not deprecate it unless we actually have to -- I see
> additional uses for this coming in the future.
>
> In order to use fe callback properly, please add "#define
> DVB_FRONTEND_COMPONENT_DEMOD 1" to dvb-core/dvb_frontend.h , and
> simply call your callback as fe->callback(adap_state,
> DVB_FRONTEND_COMPONENT_DEMOD, CMD, ARG) ... This way, the callback
> knows that it is being called by the demod and not the tuner, it is
> receiving command CMD with argument ARG.
>
> I can imagine a need one day to perhaps convert the "int arg" into a
> "void* arg", but such a need doesn't exist today.  I don't think it
> gets any more generic than this.
>
>          int (*callback)(void *adapter_priv, int component, int cmd, int arg);
>
> Cheers,
>
> Mike

+1 for that. It was just what I also was thinking :) I will add that 
demod component define to the internal API and it is fixed properly.

regards
Antti


-- 
http://palosaari.fi/
