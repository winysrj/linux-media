Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36702 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HIN5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 09:57:43 -0400
Received: by ghrr11 with SMTP id r11so445562ghr.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 06:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5023AE05.1040604@redhat.com>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
	<501FCFE1.7010802@redhat.com>
	<201208061618.56479.hverkuil@xs4all.nl>
	<CALF0-+U7DYEgRFMaJx4kRpNb4aeeUaTywBVDkmw99azozG_0nQ@mail.gmail.com>
	<CALF0-+UkH7o=mopJJSjRMBF-+60q+-6L=LdfJsWt17oJ0ij0Lw@mail.gmail.com>
	<CALF0-+WmqJdEprO+ShJDDVfxvE70hWaW1iXAb=9zxOYajRgStw@mail.gmail.com>
	<CALF0-+UqJUeCCakr73yHFjUvRVm6ZJ371wtTDKPmAXSWUB-57g@mail.gmail.com>
	<5023AE05.1040604@redhat.com>
Date: Thu, 9 Aug 2012 10:57:42 -0300
Message-ID: <CALF0-+Ve-+sY48-86=+sPZDBUeXFmoKqoLU8tiDniZopjv6B_Q@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v8] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2012 at 9:33 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 09-08-2012 09:24, Ezequiel Garcia escreveu:
>> Hi Mauro,
>>
>> On Mon, Aug 6, 2012 at 4:13 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>>>
>>>> On a second thought, perhaps it makes sense to have a git repo (on linuxtv.org)
>>>> for me to work on stk1160.
>>>> That way I could simply send "git pull" requests instead of patches.
>>>>
>>>> I'm not sure if this is a better workflow and/or would allow for
>>>> easier reviewing.
>>>>
>>>
>>> Well, I just got an answer from vger administrator. He told me the
>>> patch was exceeding
>>> the allowed limit. Which I later discovered it was documented here:
>>>
>>> http://vger.kernel.org/majordomo-info.html
>>>
>>> Apparently, there is a 100, 000 characters limit.
>>>
>>> So, how do we proceed?
>>>
>>
>> Ping! Could you take a look at this?
>> I'd like to solve the pending issues (see previous mails),
>> in order to know if the driver will need further work.
>>
>> ... or perhaps we can leave this for after the merge window, when
>> you (and everyone) are be less busy.
>>
>> I *really* hope I'm not spamming. In that case, feel free to say so.
>
> The merge window was closed already.

Yes, you're right. I'm still unsure about the work flow.

> I pushed this patch directly into patchwork,
> so I should be handling it sooner or later.
>

Yes, I noticed it after sending the mail.

> Unfortunately, I had a crash on my home volume group, and I'm busy those
> days recovering data from it. It seems I'll be able to recover everything,
> but I'll need to move about 800GB of data between two disks (one of them is
> a slow one), plus my backup machine. I'll likely break it into several smaller
> logical volumes, in order to help me to keep the backup updated. So,
> that'll keep me busy for a while. In the meantime, I'm working on a slow
> notebook. So, I might still be able to review and add some patches upstream,
> especially the more trivial ones.
>

Ouch! I'm sorry to hear that. I hope you can recover soon.

I'll stay tuned for your comments (and I'll stop bothering).

Thanks for your reply!
Ezequiel.
