Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1CVJBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:01:09 -0400
Message-ID: <4D886541.60302@redhat.com>
Date: Tue, 22 Mar 2011 06:00:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andrew de Quincey <adq_dvb@lidskialf.net>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi> <AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
In-Reply-To: <AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-03-2011 20:11, Andrew de Quincey escreveu:
> On 4 March 2011 22:59, Antti Palosaari <crope@iki.fi> wrote:
>> On 03/05/2011 12:44 AM, Andrew de Quincey wrote:
>>>>>
>>>>> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
>>>>> accesses will take multiple i2c transactions.
>>>>>
>>>>> Therefore, the following patch overrides the dvb_frontend_ops
>>>>> functions to add a per-device lock around them: only one frontend can
>>>>> now use the i2c bus at a time. Testing with the scripts above shows
>>>>> this has eliminated the errors.
>>>>
>>>> This have annoyed me too, but since it does not broken functionality much
>>>> I
>>>> haven't put much effort for fixing it. I like that fix since it is in
>>>> AF9015
>>>> driver where it logically belongs to. But it looks still rather complex.
>>>> I
>>>> see you have also considered "bus lock" to af9015_i2c_xfer() which could
>>>> be
>>>> much smaller in code size (that's I have tried to implement long time
>>>> back).
>>>>
>>>> I would like to ask if it possible to check I2C gate open / close inside
>>>> af9015_i2c_xfer() and lock according that? Something like:
>>>
>>> Hmm, I did think about that, but I felt overriding the functions was
>>> just cleaner: I felt it was more obvious what it was doing. Doing
>>> exactly this sort of tweaking was one of the main reasons we added
>>> that function overriding feature.
>>>
>>> I don't like the idea of returning "error locked by FE" since that'll
>>> mean the tuning will randomly fail sometimes in a way visible to
>>> userspace (unless we change the core dvb_frontend code), which was one
>>> of the things I was trying to avoid. Unless, of course, I've
>>> misunderstood your proposal.
>>
>> Not returning error, but waiting in lock like that:
>> if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
>>  return -EAGAIN;
> 
> Ah k, sorry
> 
>>> However, looking at the code again, I realise it is possible to
>>> simplify it. Since its only the demod gates that cause a problem, we
>>> only /actually/ need to lock the get_frontend() and set_frontend()
>>> calls.
>>
>> I don't understand why .get_frontend() causes problem, since it does not
>> access tuner at all. It only reads demod registers. The main problem is
>> (like schema in af9015.c shows) that there is two tuners on same I2C bus
>> using same address. And demod gate is only way to open access for desired
>> tuner only.
> 
> AFAIR /some/ tuner code accesses the tuner hardware to read the exact
> tuned frequency back on a get_frontend(); was just being extra
> paranoid :)
> 
>> You should block traffic based of tuner not demod. And I think those
>> callbacks which are needed for override are tuner driver callbacks. Consider
>> situation device goes it v4l-core calls same time both tuner .sleep() ==
>> problem.
> 
> Hmm, yeah, you're right, let me have another look tomorrow.

Andrew, Antti,

I'm understanding that I should wait for another patch on this subject, right?
Please let me know when you have a patch ready for me to apply.

Btw, I think that the long term solution would be, instead, to provide some sort of
resource locking inside DVB (and V4L) core. I have here 3 devices not supported yet that
uses the same tuner (and the same demod - DRX-K) for both DVB-C and DVB-T. It would
be a way better to use some core-provided solution to prevent that both DVB-C and DVB-T
would be used at the same time on such devices, instead of cloning the same code
(or modified versions on it) on each driver that have such issues.

One solution could be to have a callback like:

enum dvb_fe_lock_type {
	ATV_DEMOD_LOCK,
	DTV_DEMOD_T_LOCK,
	DTV_DEMOD_S_LOCK,
	DTV_DEMOD_C_LOCK,
	TUNER_T_LOCK,
	TUNER_S_LOCK,
	TUNER_C_LOCK,
	TUNER_FM_LOCK,
	FM_DEMOD_LOCK,
};

/**
 * dvb_fe_lock - locks a frontend resource
 * @fe:		DVB frontend struct
 * @type:	type of resource to lock
 * @lock:	true indicates to lock the resource, false to unlock
 *
 * Returns true if the resource was locked, false otherwise.
 * routine may wait for a pending transaction to happen before returning.
 */
bool (*dvb_fe_lock)(struct dvb_frontend *fe, enum dvb_fe_lock_type type, bool lock);

What do you think?

Thanks,
Mauro.
