Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41633 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2IVRV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 13:21:57 -0400
Message-ID: <505DF3A0.30806@iki.fi>
Date: Sat, 22 Sep 2012 20:21:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: tda18271 driver power consumption
References: <500C5B9B.8000303@iki.fi> <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com> <500F1DC5.1000608@iki.fi> <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com> <50200AC9.9080203@iki.fi> <CAGoCfixmre37ph46E6U9mJ+tyt+OL7+RbDwg+W6DkL01im2nCg@mail.gmail.com> <CAOcJUbwyNBEoPyE_6QZQ-6tbUsHFzurYBEavegQO1aVYNsQ_kA@mail.gmail.com> <5020175D.3070601@iki.fi> <CAOcJUbw5+wfaZ6Os5gKbPzCf0_d_rh=apatQwA=0k5gKm_FfOQ@mail.gmail.com> <CAOcJUbwCkNZCbNv=JHKhSMiuBre+cqWqhF5ihocRP9jbo1iEkw@mail.gmail.com>
In-Reply-To: <CAOcJUbwCkNZCbNv=JHKhSMiuBre+cqWqhF5ihocRP9jbo1iEkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2012 08:49 PM, Michael Krufky wrote:
> On Thu, Sep 20, 2012 at 1:47 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> On Mon, Aug 6, 2012 at 3:13 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> On 08/06/2012 09:57 PM, Michael Krufky wrote:
>>>>
>>>> On Mon, Aug 6, 2012 at 2:35 PM, Devin Heitmueller
>>>> <dheitmueller@kernellabs.com> wrote:
>>>>>
>>>>> On Mon, Aug 6, 2012 at 2:19 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>>
>>>>>> You should understand from DVB driver model:
>>>>>> * attach() called only once when driver is loaded
>>>>>> * init() called to wake-up device
>>>>>> * sleep() called to sleep device
>>>>>>
>>>>>> What I would like to say is that there is very big risk to shoot own leg
>>>>>> when doing some initialization on attach(). For example resuming from
>>>>>> the
>>>>>> suspend could cause device reset and if you rely some settings that are
>>>>>> done
>>>>>> during attach() you will likely fail as Kernel / USB-host controller has
>>>>>> reset your device.
>>>>>>
>>>>>> See reset_resume from Kernel documentation:
>>>>>> Documentation/usb/power-management.txt
>>>>>
>>>>>
>>>>> Be forewarned:  there is a very high likelihood that this patch will
>>>>> cause regressions on hybrid devices due to known race conditions
>>>>> related to dvb_frontend sleeping the tuner asynchronously on close.
>>>>> This is a hybrid tuner, and unless code is specifically added to the
>>>>> bridge or tuner driver, going from digital to analog mode too quickly
>>>>> will cause the tuner to be shutdown while it's actively in analog
>>>>> mode.
>>>>>
>>>>> (I discovered this the hard way when working on problems MythTV users
>>>>> reported against the HVR-950q).
>>>>>
>>>>> Description of race:
>>>>>
>>>>> 1.  User opens DVB frontend tunes
>>>>> 2.  User closes DVB frontend
>>>>> 3.  User *immediately* opens V4L device using same tuner
>>>>> 4.  User performs tuning request for analog
>>>>> 5.  DVB frontend issues sleep() call to tuner, causing analog tuning to
>>>>> fail.
>>>>>
>>>>> This class of problem isn't seen on DVB only devices or those that
>>>>> have dedicated digital tuners not shared for analog usage.  And in
>>>>> some cases it isn't noticed because a delay between closing the DVB
>>>>> device and opening the analog devices causes the sleep() call to
>>>>> happen before the analog tune (in which case you don't hit the race).
>>>>>
>>>>> I'm certainly not against improved power management, but it will
>>>>> require the race conditions to be fixed first in order to avoid
>>>>> regressions.
>>>>>
>>>>> Devin
>>>>>
>>>>> --
>>>>> Devin J. Heitmueller - Kernel Labs
>>>>> http://www.kernellabs.com
>>>>
>>>>
>>>> Devin's right.  I'm sorry, please *don't* merge the patch, Mauro.
>>>> Antti, you should just call sleep from your driver after attach(), as
>>>> I had previously suggested.  We can revisit this some time in the
>>>> future after we can be sure that these race conditions wont occur.
>>>
>>>
>>> OK, maybe it is safer then. I have no any hybrid hardware to test...
>>>
>>> Anyhow, I wonder how many years it will take to resolve that V4L2/DVB API
>>> hybrid usage pŕoblem. I ran thinking that recently when looked how to
>>> implement DVB SDR for V4L2 API... I could guess problem will not disappear
>>> near future even analog TV disappears, because there is surely coming new
>>> nasty features which spreads over both V4L2 and DVB APIs.
>>
>> Guys,
>>
>> Please take another look at this branch and test if possible -- I
>> pushed an additional patch that takes Devin's concerns into account.
>> After applying these patches, the tda18271 driver will behave as it
>> always has, but it will sleep the tuner after attaching the first
>> instance.  If there is only one instance, then this works exactly as
>> Antti desires.  If there are more instances, then the tuner will only
>> be woken up again during attach if the tda18271_need_cal_on_startup()
>> returns non-zero.  The driver does not attempt to re-sleep the
>> hardware again during successive attach() calls.
>>
>> I have not tested this yet myself, but I believe it resolves the
>> matter -- please comment.
>>
>> Regards,
>>
>> Mike Krufky
>
> ...in case the URL got lost:
>
>
> The following changes since commit 0c7d5a6da75caecc677be1fda207b7578936770d:
>
>    Linux 3.5-rc5 (2012-07-03 22:57:41 +0300)
>
> are available in the git repository at:
>
>    git://linuxtv.org/mkrufky/tuners tda18271
>
> for you to fetch changes up to 4e46c5d1bbb920165fecfe7de18b2c01d9787230:
>
>    tda18271: make 'low-power standby mode after attach' multi-instance
> safe (2012-09-20 13:34:29 -0400)
>
> ----------------------------------------------------------------
> Michael Krufky (2):
>        tda18271: enter low-power standby mode at the end of tda18271_attach()
>        tda18271: make 'low-power standby mode after attach' multi-instance safe
>
>   drivers/media/common/tuners/tda18271-fe.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> Best regards,
>
> Mike
>
Tested-by: Antti Palosaari <crope@iki.fi>

Tested with PCTV 290e, but I cannot test multi-instance. I tried to plug 
PCTV 520e as a second stick, but it crashed as there is now that DRX-K 
firmware download problem....

regards
Antti

-- 
http://palosaari.fi/
