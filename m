Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:58025 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3FRFz0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 01:55:26 -0400
Received: by mail-vb0-f50.google.com with SMTP id w16so2581484vbb.37
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 22:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHy-dEx98YXLdJB0rW5yZ_HeKsy5aLSjH0XL07U=5HNgKg@mail.gmail.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-4-git-send-email-arun.kk@samsung.com>
	<002a01ce6b69$512943c0$f37bcb40$%debski@samsung.com>
	<CALt3h7-mNkOJoGbyNsBR0Z2mYKXD58EwqOezeY+7xpx7G0-vHQ@mail.gmail.com>
	<CAK9yfHy-dEx98YXLdJB0rW5yZ_HeKsy5aLSjH0XL07U=5HNgKg@mail.gmail.com>
Date: Tue, 18 Jun 2013 11:25:25 +0530
Message-ID: <CALt3h78MFePzkhqP4iUrBmB8BQkGHeqDKhrWr8-M7ozmxnTZ3w@mail.gmail.com>
Subject: Re: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,


On Tue, Jun 18, 2013 at 10:56 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 18 June 2013 10:21, Arun Kumar K <arunkk.samsung@gmail.com> wrote:
>> Hi Kamil,
>>
>> Thank you for the review.
>>
>>
>>>>  #define IS_MFCV6(dev)                (dev->variant->version >= 0x60 ? 1 :
>>> 0)
>>>> +#define IS_MFCV7(dev)                (dev->variant->version >= 0x70 ? 1 :
>>> 0)
>>>
>>> According to this, MFC v7 is also detected as MFC v6. Was this intended?
>>
>> Yes this was intentional as most of v7 will be reusing the v6 code and
>> only minor
>> changes are there w.r.t firmware interface.
>>
>>
>>> I think that it would be much better to use this in code:
>>>         if (IS_MFCV6(dev) || IS_MFCV7(dev))
>>> And change the define to detect only single MFC revision:
>>>         #define IS_MFCV6(dev)           (dev->variant->version >= 0x60 &&
>>> dev->variant->version < 0x70)
>>>
>>
>> I kept it like that since the macro IS_MFCV6() is used quite frequently
>> in the driver. Also if MFCv8 comes which is again similar to v6 (not
>> sure about this),
>> then it will add another OR condition to this check.
>>
>>> Other possibility I see is to change the name of the check. Although
>>> IS_MFCV6_OR_NEWER(dev) seems too long :)
>>>
>>
>> How about making it IS_MFCV6_PLUS()?
>
> Technically
> #define IS_MFCV6(dev)                (dev->variant->version >= 0x60...)
> means all lower versions are also higher versions.
> This may not cause much of a problem (other than the macro being a
> misnomer) as all current higher versions are supersets of lower
> versions.
> But this is not guaranteed(?).
>

Till now we havent encountered otherwise and we can only hope that
it remains like this :)


> Hence changing the definition of the macro to (dev->variant->version
>>= 0x60 && dev->variant->version < 0x70) as Kamil suggested or
> renaming it to
> IS_MFCV6_PLUS() makes sense.
>
> OTOH, do we really have intermediate version numbers? For e.g. 0x61, 0x72, etc?
>
> If not we can make it just:
> #define IS_MFCV6(dev)                (dev->variant->version == 0x60 ? 1 : 0)
>

The v6 version we use is actually v6.5 and v7 is v7.2.
In mainline we havent used any FW sub-versions yet.

Regards
Arun
