Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:58671 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3LVSum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 13:50:42 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so1704634eek.27
        for <linux-media@vger.kernel.org>; Sun, 22 Dec 2013 10:50:41 -0800 (PST)
Message-ID: <52B734C0.6010409@googlemail.com>
Date: Sun, 22 Dec 2013 19:51:44 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DEADLOCK reported by lock debug
References: <52B1C79C.1070408@iki.fi> <52B5C718.7030605@googlemail.com> <52B5F229.6020301@iki.fi> <52B6EE79.9070105@googlemail.com> <52B6F883.8060103@iki.fi> <52B7293C.5010206@googlemail.com> <52B72BEB.4010902@iki.fi>
In-Reply-To: <52B72BEB.4010902@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.12.2013 19:14, schrieb Antti Palosaari:
> On 22.12.2013 20:02, Frank Schäfer wrote:
>> Am 22.12.2013 15:34, schrieb Antti Palosaari:
>>> On 22.12.2013 15:51, Frank Schäfer wrote:
>>>> Am 21.12.2013 20:55, schrieb Antti Palosaari:
>>>>> On 21.12.2013 18:51, Frank Schäfer wrote:
>>>>>> Hi Antti,
>>>>>>
>>>>>> thank you for reporting this issue.
>>>>>>
>>>>>> Am 18.12.2013 17:04, schrieb Antti Palosaari:
>>>>>>> That same lock debug deadlock is still there (maybe ~4 times I
>>>>>>> report
>>>>>>> it during 2 years). Is that possible to fix easily at all?
>>>>>>
>>>>>> Patches are always welcome. ;)
>>>>>
>>>>> haha, I cannot simply learn every driver I meet some problems...
>>>> Hint:
>>>>
>>>> If you report a bug ~4 times in 2 years but never get a reply, it
>>>> usually means
>>>> a) nobody cares
>>>> b) nobody has the resources (time, knowledge) to fix it.
>>>>
>>>> So you either have to live with this issue or to fix it yourself.
>>>
>>> OK, as you request me to fix it, I will fix that by making DVB USB v2
>>> driver for these em28xx devices I have added.
>>>
>>> It should not be very much work as em28xx protocol is still relatively
>>> easy.
>> How would that help to get those lockdep false warnings fixed ?
>> Btw: these warnings should appear for _all_ em28xx extensions (dvb,
>> input, audio).
>
> I am already looking to silence that v4l2 lockdep report. It is hard
> to say how much it is work as I simply don't know even reasons.
>
> I suspect that if I start learning and fixing em28xx driver it will
> take week or two as a workload. Writing new dvb-usb driver is only max
> 2 days of work and as a bonus you will get some missing features for
> free:
> 1) power-management
> 2) suspend/resume
> 3) PID filters
Sure, but we already have a driver for these devices.
I agree with you that em28xx is a big mess, but at least in this case it
doesn't do anything wrong.
Does this false warning really make you so nervous that you're willing
to spent 2 days for it ?
I appreciate that, but I suggest to spend these 2 days for fixing the
issue instead of just avoiding it.

Regards,
Frank

>
> regards
> Antti
>

