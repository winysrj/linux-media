Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59818 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2JBJ4U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 05:56:20 -0400
Message-ID: <506ABA2B.3070908@iki.fi>
Date: Tue, 02 Oct 2012 12:55:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
References: <1349139145-22113-1-git-send-email-crope@iki.fi> <CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com> <CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
In-Reply-To: <CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2012 06:17 AM, Michael Krufky wrote:
> On Mon, Oct 1, 2012 at 9:58 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> New drxk firmware download does not work with tda18271. Actual
>>> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
>>> will work as it does not do as much I/O during attach than tda18271.
>>>
>>> Root of cause is tuner I/O during drx-k asynchronous firmware
>>> download. request_firmware_nowait()... :-/
>>
>> This seems like it's just changing the timing of the initialization
>> process, which isn't really any better than the "msleep(2000)".  It's
>> just dumb luck that it happens to work on the developer's system.
>>
>> Don't get me wrong, I agree with Michael that this whole situation is
>> ridiculous, but I don't see why swapping out the entire driver is a
>> reasonable fix.
>
> I just send out a patch entitled, "tda18271: prevent register access
> during attach() if delay_cal is set"   Antti, could you set
> tda18271_config.delay_cal = 1 with this patch applied and see if it
> solves your problem?
>
> Again, although this may solve the problem for this particular device,
> the *real* problem is this asynchronous firmware download in the demod
> driver.
>
> Nonetheless, Antti has been asking for this feature, to not allow
> register access during attach, I was against it and I have my reasons,
> but I believe that this patch is a fair compromise.
>
> After somebody can test it, I think we should merge this -- any comments?
>
> http://patchwork.linuxtv.org/patch/14799/

I tested. It does not help. I also looked it more and it really bails 
out with error much earlier, in function where it reads chip ID. That 
makes me look the tda18271c2dd driver. I found that for some reason 
these drivers uses different method for register read. tda18271 uses I2C 
transaction with 2 messages, write and read with REPEATED START 
condition. tda18271c2dd driver is just simple I2C read. So which one is 
correct?

Also other note. tda18271c2dd does not have almost any error logging. 
Only error log is failed I2C write. So it could be even possible 
tda18271c2dd fails too, but as it keeps silence and discards all the 
error I don't see it and it even works :S

And 3rd issue. It crashes. Very often. I didn't take picture anymore as 
I have taken earlier. I am so f***ing pissed off all the long time 
problems with that em28xx driver! It has crashed more than any other 
driver I have ever seen. It is really, really, problematic. The amount 
of time what I have loosen em28xx driver problems when hacking with 
relatively small amount of devices is huge. It is surely more time that 
it will take me to write whole driver from the scratch using DVB USB. As 
I cannot trust em28xx correctness it is very hard to debug these 
crashes. That one seems to come from drxk, but is it really?

http://palosaari.fi/linux/v4l-dvb/em28xx_drxk_crash/

regards
Antti

-- 
http://palosaari.fi/
