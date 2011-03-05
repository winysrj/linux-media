Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:40592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1CEJYE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2011 04:24:04 -0500
Message-ID: <4D72012F.6030506@iki.fi>
Date: Sat, 05 Mar 2011 11:23:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
CC: adq <adq@lidskialf.net>, linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com> <AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
In-Reply-To: <AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Switching channels for long time seems to hang device (no errors seen 
but it does not lock anymore), I don't know why. It is not very easy to 
reproduce. For me it will take generally few days just tune from channel 
to channel in loop.

Antti

On 03/05/2011 10:56 AM, Juan Jesús García de Soria Lucena wrote:
> Hi, Andrew.
>
> This is what happens to me with both the KWorld dual tuner (when using only
> one tuner) and the Avermedia Volar Black (single tuner), both based on
> AF9015.
>
> I also got corrupted streams with the KWorld when capturing via both tuners
> (the video our the audio would show artifacts in mythtv each several
> seconds).
>
> As far as the loss of tuning ability goes, I think it's a problem related to
> tuning itself, since it wouldn't happen when you just left a channel tuned
> and streaming in a simple client, but would trigger after a random time when
> you left mythtv scanning the channels for EIT data.
>
> I don't think it's a problem with a specific HW implementation, since I got
> it with both AF9015-based cards. It could be either a chipset quirk our a
> bug in the driver.
>
> My informal and quick tests with Windows Media Center and these cards did
> not reproduce the problem, when trying to change channels as quickly as
> possible, admittedly for not so long a time.
>
> Best regards,
>     Juan Jesus.
> El 05/03/2011 02:53, "adq"<adq@lidskialf.net>  escribió:
>> On 5 March 2011 01:43, adq<adq@lidskialf.net>  wrote:
>>> On 4 March 2011 23:11, Andrew de Quincey<adq_dvb@lidskialf.net>  wrote:
>>>> On 4 March 2011 22:59, Antti Palosaari<crope@iki.fi>  wrote:
>>>>> On 03/05/2011 12:44 AM, Andrew de Quincey wrote:
>>>>>>>>
>>>>>>>> Adding a "bus lock" to af9015_i2c_xfer() will not work as
> demod/tuner
>>>>>>>> accesses will take multiple i2c transactions.
>>>>>>>>
>>>>>>>> Therefore, the following patch overrides the dvb_frontend_ops
>>>>>>>> functions to add a per-device lock around them: only one frontend
> can
>>>>>>>> now use the i2c bus at a time. Testing with the scripts above shows
>>>>>>>> this has eliminated the errors.
>>>>>>>
>>>>>>> This have annoyed me too, but since it does not broken functionality
> much
>>>>>>> I
>>>>>>> haven't put much effort for fixing it. I like that fix since it is in
>>>>>>> AF9015
>>>>>>> driver where it logically belongs to. But it looks still rather
> complex.
>>>>>>> I
>>>>>>> see you have also considered "bus lock" to af9015_i2c_xfer() which
> could
>>>>>>> be
>>>>>>> much smaller in code size (that's I have tried to implement long time
>>>>>>> back).
>>>>>>>
>>>>>>> I would like to ask if it possible to check I2C gate open / close
> inside
>>>>>>> af9015_i2c_xfer() and lock according that? Something like:
>>>>>>
>>>>>> Hmm, I did think about that, but I felt overriding the functions was
>>>>>> just cleaner: I felt it was more obvious what it was doing. Doing
>>>>>> exactly this sort of tweaking was one of the main reasons we added
>>>>>> that function overriding feature.
>>>>>>
>>>>>> I don't like the idea of returning "error locked by FE" since that'll
>>>>>> mean the tuning will randomly fail sometimes in a way visible to
>>>>>> userspace (unless we change the core dvb_frontend code), which was one
>>>>>> of the things I was trying to avoid. Unless, of course, I've
>>>>>> misunderstood your proposal.
>>>>>
>>>>> Not returning error, but waiting in lock like that:
>>>>> if (mutex_lock_interruptible(&d->i2c_mutex)<  0)
>>>>>   return -EAGAIN;
>>>>
>>>> Ah k, sorry
>>>>
>>>>>> However, looking at the code again, I realise it is possible to
>>>>>> simplify it. Since its only the demod gates that cause a problem, we
>>>>>> only /actually/ need to lock the get_frontend() and set_frontend()
>>>>>> calls.
>>>>>
>>>>> I don't understand why .get_frontend() causes problem, since it does
> not
>>>>> access tuner at all. It only reads demod registers. The main problem is
>>>>> (like schema in af9015.c shows) that there is two tuners on same I2C
> bus
>>>>> using same address. And demod gate is only way to open access for
> desired
>>>>> tuner only.
>>>>
>>>> AFAIR /some/ tuner code accesses the tuner hardware to read the exact
>>>> tuned frequency back on a get_frontend(); was just being extra
>>>> paranoid :)
>>>>
>>>>> You should block traffic based of tuner not demod. And I think those
>>>>> callbacks which are needed for override are tuner driver callbacks.
> Consider
>>>>> situation device goes it v4l-core calls same time both tuner .sleep()
> ==
>>>>> problem.
>>>>
>>>> Hmm, yeah, you're right, let me have another look tomorrow.
>>>>
>>>
>>> Hi, must admit I misunderstood your diagram originally, I thought it
>>> was the demods AND the tuners that had the same i2c addresses.
>>>
>>> As you say though. its just the tuners, so adding the locking into the
>>> gate ctrl as you suggested makes perfect sense. Attached is v3
>>> implementing this; it seems to be working fine here.
>>>
>>
>> Unfortunately even with this fix, I'm still seeing the problem I was
>> trying to fix to begin with.
>>
>> Although I no longer get any i2c errors (or *any* reported errors),
>> after a bit, one of the frontends just.. stops working. All attempts
>> to tune it fail. I can even unload and reload the driver module, and
>> its stuck in the same state, indicating its a problem with the
>> hardware. :(
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
