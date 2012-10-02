Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35005 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2JBMmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 08:42:22 -0400
Received: by lbon3 with SMTP id n3so5060994lbo.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 05:42:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506ADE45.6000708@iki.fi>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
	<CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
	<506ABA2B.3070908@iki.fi>
	<20121002080503.76869be7@redhat.com>
	<506ADE45.6000708@iki.fi>
Date: Tue, 2 Oct 2012 08:42:20 -0400
Message-ID: <CAOcJUbxYzdXwe2Njut=KYwKuoyKpXNZDfm-mgtyG2OQ7Kiau1g@mail.gmail.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 2, 2012 at 8:29 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 10/02/2012 02:05 PM, Mauro Carvalho Chehab wrote:
>>
>> Em Tue, 02 Oct 2012 12:55:55 +0300
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> On 10/02/2012 06:17 AM, Michael Krufky wrote:
>>>>
>>>> On Mon, Oct 1, 2012 at 9:58 PM, Devin Heitmueller
>>>> <dheitmueller@kernellabs.com> wrote:
>>>>>
>>>>> On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>>
>>>>>> New drxk firmware download does not work with tda18271. Actual
>>>>>> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
>>>>>> will work as it does not do as much I/O during attach than tda18271.
>>>>>>
>>>>>> Root of cause is tuner I/O during drx-k asynchronous firmware
>>>>>> download. request_firmware_nowait()... :-/
>>>>>
>>>>>
>>>>> This seems like it's just changing the timing of the initialization
>>>>> process, which isn't really any better than the "msleep(2000)".  It's
>>>>> just dumb luck that it happens to work on the developer's system.
>>>>>
>>>>> Don't get me wrong, I agree with Michael that this whole situation is
>>>>> ridiculous, but I don't see why swapping out the entire driver is a
>>>>> reasonable fix.
>>>>
>>>>
>>>> I just send out a patch entitled, "tda18271: prevent register access
>>>> during attach() if delay_cal is set"   Antti, could you set
>>>> tda18271_config.delay_cal = 1 with this patch applied and see if it
>>>> solves your problem?
>>>>
>>>> Again, although this may solve the problem for this particular device,
>>>> the *real* problem is this asynchronous firmware download in the demod
>>>> driver.
>>>>
>>>> Nonetheless, Antti has been asking for this feature, to not allow
>>>> register access during attach, I was against it and I have my reasons,
>>>> but I believe that this patch is a fair compromise.
>>>>
>>>> After somebody can test it, I think we should merge this -- any
>>>> comments?
>>>>
>>>> http://patchwork.linuxtv.org/patch/14799/
>>>
>>>
>>> I tested. It does not help. I also looked it more and it really bails
>>> out with error much earlier, in function where it reads chip ID. That
>>> makes me look the tda18271c2dd driver.
>>
>>
>> I saw Antti's logs: basically, tda18271_get_id() reads all registers at
>> the
>> chip during attach(), returning -EINVAL if tda18271_read_regs(fe) can't
>> read the value for R_ID register.
>>
>> Btw, why do you need to read 16 registers at once, instead of just reading
>> the needed register? read_extended and write operations are even more
>> evil:
>> they read/write the full set of 39 registers on each operation. That seems
>> to be overkill, especially on places like tda18271_get_id(), where
>> all the driver is doing is to check for the ID register.
>>
>> Worse than that, tda18271_get_id() doesn't even check if the read()
>> operation failed: it assumes that it will always work, letting the
>> switch(regs[R_ID]) to print a wrong message (device unknown) when
>> what actually failed where the 16 registers dump.
>>
>>> I found that for some reason
>>> these drivers uses different method for register read. tda18271 uses I2C
>>> transaction with 2 messages, write and read with REPEATED START
>>> condition. tda18271c2dd driver is just simple I2C read. So which one is
>>> correct?
>>
>>
>> That's due to the I2C locking schema: if you do two separate I2C
>> transfers, the I2C core will allow an event to happen between the
>> two operations. That typically causes troubles on read operations.
>> So, it is recommended to use just one i2c_transfer() call for read
>> operations that are mapped via a write and a read.
>
>
> I know rather well how I2C works. As many messages you put to single
> transfer those are aimed to do with REPEATED START condition without a STOP.
> And naturally, when you split to multiple transactions then there is STOP.
> STOP is send after the last I2C message in one transaction.
>
> But what I tried to say there was a different communication schema used
> between the drivers. Other must (quite likely) be wrong. There is no any
> mention about hacks. I don't see how that I2C locking you mention is
> related, as it is *one* I2C transfer in question for both cases.
>
> Here is difference what I mean:
> tda18271: START c0|Ack|00|Ack|START c1|data read|NAck|STOP
> tda18271cc: START c1|data read|NAck|STOP

As per section 9.1 of the NXP TDA18271 datasheet (page 8) (download
from http://www.nxp.com/documents/data_sheet/TDA18271HD.pdf)

9.1 I2C-bus format, Write/Read mode
Remark: The I2C-bus read in the TDA18271HD must read the entire
I2C-bus map, with
required subaddress 00h. The number of bytes read is 16, or 39 in
extended register
mode; see Table 7. Reading write-only bits can return values that are
different from the
programmed values

tda18271 is doing the right thing, tda18271cc is not.

-Mike Krufky
