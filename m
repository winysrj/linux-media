Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32976 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932380Ab2HFTNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 15:13:47 -0400
Received: by lagy9 with SMTP id y9so936615lag.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 12:13:45 -0700 (PDT)
Message-ID: <5020175D.3070601@iki.fi>
Date: Mon, 06 Aug 2012 22:13:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: tda18271 driver power consumption
References: <500C5B9B.8000303@iki.fi> <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com> <500F1DC5.1000608@iki.fi> <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com> <50200AC9.9080203@iki.fi> <CAGoCfixmre37ph46E6U9mJ+tyt+OL7+RbDwg+W6DkL01im2nCg@mail.gmail.com> <CAOcJUbwyNBEoPyE_6QZQ-6tbUsHFzurYBEavegQO1aVYNsQ_kA@mail.gmail.com>
In-Reply-To: <CAOcJUbwyNBEoPyE_6QZQ-6tbUsHFzurYBEavegQO1aVYNsQ_kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/2012 09:57 PM, Michael Krufky wrote:
> On Mon, Aug 6, 2012 at 2:35 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Mon, Aug 6, 2012 at 2:19 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> You should understand from DVB driver model:
>>> * attach() called only once when driver is loaded
>>> * init() called to wake-up device
>>> * sleep() called to sleep device
>>>
>>> What I would like to say is that there is very big risk to shoot own leg
>>> when doing some initialization on attach(). For example resuming from the
>>> suspend could cause device reset and if you rely some settings that are done
>>> during attach() you will likely fail as Kernel / USB-host controller has
>>> reset your device.
>>>
>>> See reset_resume from Kernel documentation:
>>> Documentation/usb/power-management.txt
>>
>> Be forewarned:  there is a very high likelihood that this patch will
>> cause regressions on hybrid devices due to known race conditions
>> related to dvb_frontend sleeping the tuner asynchronously on close.
>> This is a hybrid tuner, and unless code is specifically added to the
>> bridge or tuner driver, going from digital to analog mode too quickly
>> will cause the tuner to be shutdown while it's actively in analog
>> mode.
>>
>> (I discovered this the hard way when working on problems MythTV users
>> reported against the HVR-950q).
>>
>> Description of race:
>>
>> 1.  User opens DVB frontend tunes
>> 2.  User closes DVB frontend
>> 3.  User *immediately* opens V4L device using same tuner
>> 4.  User performs tuning request for analog
>> 5.  DVB frontend issues sleep() call to tuner, causing analog tuning to fail.
>>
>> This class of problem isn't seen on DVB only devices or those that
>> have dedicated digital tuners not shared for analog usage.  And in
>> some cases it isn't noticed because a delay between closing the DVB
>> device and opening the analog devices causes the sleep() call to
>> happen before the analog tune (in which case you don't hit the race).
>>
>> I'm certainly not against improved power management, but it will
>> require the race conditions to be fixed first in order to avoid
>> regressions.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>
> Devin's right.  I'm sorry, please *don't* merge the patch, Mauro.
> Antti, you should just call sleep from your driver after attach(), as
> I had previously suggested.  We can revisit this some time in the
> future after we can be sure that these race conditions wont occur.

OK, maybe it is safer then. I have no any hybrid hardware to test...

Anyhow, I wonder how many years it will take to resolve that V4L2/DVB 
API hybrid usage pŕoblem. I ran thinking that recently when looked how 
to implement DVB SDR for V4L2 API... I could guess problem will not 
disappear near future even analog TV disappears, because there is surely 
coming new nasty features which spreads over both V4L2 and DVB APIs.

regards
Antti

-- 
http://palosaari.fi/
