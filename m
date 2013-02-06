Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64388 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3BFR3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 12:29:43 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so899373eek.26
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 09:29:42 -0800 (PST)
Message-ID: <51129334.6040108@googlemail.com>
Date: Wed, 06 Feb 2013 18:30:28 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 2 patches updated
References: <20130205213301.13968.54926@www.linuxtv.org> <51117DA2.4030703@googlemail.com> <20130205200859.3ab68dd3@redhat.com> <5112782A.5000706@googlemail.com> <20130206135855.48b74ffb@redhat.com>
In-Reply-To: <20130206135855.48b74ffb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.02.2013 16:58, schrieb Mauro Carvalho Chehab:
> Em Wed, 06 Feb 2013 16:35:06 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 05.02.2013 23:08, schrieb Mauro Carvalho Chehab:
>>> Em Tue, 05 Feb 2013 22:46:10 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Am 05.02.2013 22:33, schrieb Patchwork:
>>>>> Hello,
>>>>>
>>>>> The following patches (submitted by you) have been updated in patchwork:
>>>> ...
>>>>>  * [RFC] em28xx: fix analog streaming with USB bulk transfers
>>>>>      - http://patchwork.linuxtv.org/patch/16197/
>>>>>     was: New
>>>>>     now: RFC
>>>> What's your plan with this patch ?
>>>> We have this regression in the media-tree since a few weeks now.
>>>> Nobody replied to it or came up with a better solution...
>>> Well, you tagged it as RFC. I just marked as such at patchwork. I don't even
>>> read patches tagged as [RFC] or [REVIEW],
>> Uhm... even patches which are sent to you as the maintainer of the
>> _driver_ ?
>> Isn't commenting / reviewing patches the maintainers job ?
>>
>>
>>>  as those patches will be
>>> resubmitted later by the patch author, if they're ok, or a new version will
>>> be sent instead.
>> That's what I'm asking you. Is this patch ok / ready ?
>> Or can I generally conclude that patches are fine when there is no
>> reaction on them ?
> Frank,
>
> As you may notice, my main "job" with regards to media stuff is to be
> the media core maintainer. My work as a driver maintainer or as a
> developer is forced to go to a second plane, as my time is limited.
> So, I generally trust that driver developers are doing the right
> thing.
>
> ATM, I won't have anytime soon to test patches. So, if those patches 
> require any test from me, they'll need to be postponed to 3.10, as I'm
> finishing the handling of the patches for 3.9 today.
>
> Also, from my side, there are simply too much patches sent to me, either
> on my inbox (where I never read) and/or at linux-media ML. The last ones
> I get from patchwork. Sometimes, even before picking the patches, I tag
> everything with RFC or REVIEW on it as RFC. Then I handle the remaining
> ones. This is to reduce the load to an acceptable work queue.
>
> So, if you think that the USB patches are ok, just send it to the ML
> without tagging it, and I'll analyze and apply if I believe that they're
> ok. I'll eventually test the em28xx driver later, when I found some time.
>
> If otherwise you think they may not be ready yet, the better to wait
> for Devin to test, if it has some time, or send me a separate email asking
> for me to test the patches.
>
> Regards,
> Mauro

Mauro,
I know you are very busy and I agree that maintaining the media-tree has
a higher priority than maintaining a driver.
You are doing a good job and if there's anything I can do to make your
life easier, please tell me !

But this is about regression which exists now for several weeks in the
media-tree and we are getting close to the next merge window.
As you have said yourself before, if you have set a patch to RFC, you
usually never look at it again.
Which means that this regression very likely makes it into mainline in a
few days.

Don't you think this is a valid case for people to bother you ? ;)

Everthing you need to know to decide about this patch is written in the
patch description and the reply I've sent.

Anyway, I will resend the patch without RFC and I will also resend the
ioctl-fixes series marked with REVIEW.
For me, it seems to be unnecessary extra work for you, but if you prefer
it that way - no problem for me.

Regards,
Frank


