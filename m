Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44259 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2I0V60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 17:58:26 -0400
Received: by bkcjk13 with SMTP id jk13so2598285bkc.19
        for <linux-media@vger.kernel.org>; Thu, 27 Sep 2012 14:58:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5064C741.1060306@iki.fi>
References: <500C5B9B.8000303@iki.fi>
	<CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
	<500F1DC5.1000608@iki.fi>
	<CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
	<CAOcJUbzJjBBMcLmeaOCsJRz44KVPqZ_sGctG8+ai=n1W+9P9xA@mail.gmail.com>
	<500F4140.1000202@iki.fi>
	<CAOcJUbzF8onCqoxv-xkZY3YUiUjgjokkstB5eSX8YKELYDrjag@mail.gmail.com>
	<CAOcJUbw4O_rHCN6PgXc7=XU5ZToTB3QqAWLPUPhW-TZZVZ9X5w@mail.gmail.com>
	<20120927161940.0f673e2e@redhat.com>
	<5064B01E.4070802@iki.fi>
	<CAOcJUbxhgwhMJuAF0sfbC-ddDFOawGBFekwdhQbcJ5z2-eaxYg@mail.gmail.com>
	<5064C741.1060306@iki.fi>
Date: Thu, 27 Sep 2012 17:58:24 -0400
Message-ID: <CAOcJUbxRP-7P-qrRsfP4RV4JHTi2Sc_5HuVtkWwhnBGW3K5OXw@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 27, 2012 at 5:38 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 09/28/2012 12:20 AM, Michael Krufky wrote:
>>
>> On Thu, Sep 27, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> On 09/27/2012 10:19 PM, Mauro Carvalho Chehab wrote:
>>>>
>>>>
>>>> Em Thu, 26 Jul 2012 08:48:58 -0400
>>>> Michael Krufky <mkrufky@linuxtv.org> escreveu:
>>>>
>>>>> Antti,
>>>>>
>>>>> This small patch should do the trick -- can you test it?
>>>>>
>>>>>
>>>>> The following changes since commit
>>>>> 0c7d5a6da75caecc677be1fda207b7578936770d:
>>>>>
>>>>>     Linux 3.5-rc5 (2012-07-03 22:57:41 +0300)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>     git://git.linuxtv.org/mkrufky/tuners tda18271
>>>>>
>>>>> for you to fetch changes up to
>>>>> 782b28e20d3b253d317cc71879639bf3c108b200:
>>>>>
>>>>>     tda18271: enter low-power standby mode at the end of
>>>>> tda18271_attach() (2012-07-26 08:34:37 -0400)
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Michael Krufky (1):
>>>>>         tda18271: enter low-power standby mode at the end of
>>>>> tda18271_attach()
>>>>>
>>>>>    drivers/media/common/tuners/tda18271-fe.c |    3 +++
>>>>>    1 file changed, 3 insertions(+)
>>>>
>>>>
>>>>
>>>>
>>>> Mike,
>>>>
>>>> Despite patchwork's way of handling, thinking that this is a pull
>>>> request,
>>>> I suspect that your intention here were simply offer some patches for
>>>> Antti
>>>> to test.
>>>>
>>>> In any case, please always send the patches via email to the ML before
>>>> sending a pull request. This was always a rule, but some developers are
>>>> lazy with this duty, and, as I didn't use to have a tool to double
>>>> check,
>>>> bad things happen.
>>>>
>>>> I'm now finally able to check with a simple script if weather a patch
>>>> went to the ML or not. My script checks both reply-to/references email
>>>> tags and it looks for the same patch subject at the ML Inbox.
>>>> So, I'll be now be more grumpy with that ;) [1]
>>>>
>>>> So, please be sure to post those patches at the ML, with Antti's
>>>> tested-by:
>>>> tag, before sending a pull request.
>>>>
>>>> Thanks!
>>>> Mauro
>>>>
>>>> [1] Side note: it is not actually a matter of being grumpy; posted
>>>> patches
>>>> receive a lot more attention/review than simple pull requests. From time
>>>> to time, patches that went via the wrong way (e. g. without a previous
>>>> post)
>>>> caused troubles for other developers. So, enforcing it is actually a
>>>> matter
>>>> of improving Kernel quality and avoiding regressions.
>>>>
>>>> -
>>>>
>>>> $ test_patch
>>>> testing if
>>>> patches/0001-tda18271-enter-low-power-standby-mode-at-the-end-of-.patch
>>>> applies
>>>> patch -p1 -i
>>>> patches/0001-tda18271-enter-low-power-standby-mode-at-the-end-of-.patch
>>>> --dry-run -t -N
>>>> patching file drivers/media/tuners/tda18271-fe.c
>>>>    drivers/media/tuners/tda18271-fe.c |    3 +++
>>>>    1 file changed, 3 insertions(+)
>>>> Subject: tda18271: enter low-power standby mode at the end of
>>>> tda18271_attach()
>>>> From: Michael Krufky <mkrufky@linuxtv.org>
>>>> Date: Thu, 26 Jul 2012 08:34:37 -0400
>>>> Patch applies OK
>>>> total: 0 errors, 0 warnings, 9 lines checked
>>>>
>>>> patches/0001-tda18271-enter-low-power-standby-mode-at-the-end-of-.patch
>>>> has no obvious style problems and is ready for submission.
>>>> Didn't find any message with subject equal to 'tda18271: enter low-power
>>>> standby mode at the end of tda18271_attach()'
>>>> Duplicated md5sum patches
>>>> Likely duplicated patches (need manual check)
>>>
>>>
>>>
>>> If that tda18271 patch is not applied then these two should be:
>>>
>>> https://patchwork.kernel.org/patch/1481901/
>>> https://patchwork.kernel.org/patch/1481911/
>>>
>>>
>>> regards
>>> Antti
>>>
>>> --
>>> http://palosaari.fi/
>>
>>
>> The tda18271 patch should indeed be applied -- I will send it to the
>> ML later on today and follow up with a pull request.  Thanks to all
>> who have commented :-)
>
>
> Mike, There is other problem too. PCTV 520e, which is Em28xx + DRX-K +
> TDA18271, fails to attach tuner now. Tuner is wired behind DRX-K I2C bus.
> TDA18271 driver does very much I/O during attach and I2C error is raised
> during attach now. Earlier it worked as DRX-K firmware was downloaded before
> tuner was attached, but now both DRX-K fw download and tuner attach happens
> same time leading that error.

Why is the DRX-K firmware downloading at the same time as tuner
attach?  Shouldn't the demod attach be finished before the tuner
attach begins?

-Mike
