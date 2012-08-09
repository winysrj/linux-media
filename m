Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45102 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2HIMYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 08:24:20 -0400
Received: by ghrr11 with SMTP id r11so334731ghr.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 05:24:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+WmqJdEprO+ShJDDVfxvE70hWaW1iXAb=9zxOYajRgStw@mail.gmail.com>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
	<501FCFE1.7010802@redhat.com>
	<201208061618.56479.hverkuil@xs4all.nl>
	<CALF0-+U7DYEgRFMaJx4kRpNb4aeeUaTywBVDkmw99azozG_0nQ@mail.gmail.com>
	<CALF0-+UkH7o=mopJJSjRMBF-+60q+-6L=LdfJsWt17oJ0ij0Lw@mail.gmail.com>
	<CALF0-+WmqJdEprO+ShJDDVfxvE70hWaW1iXAb=9zxOYajRgStw@mail.gmail.com>
Date: Thu, 9 Aug 2012 09:24:19 -0300
Message-ID: <CALF0-+UqJUeCCakr73yHFjUvRVm6ZJ371wtTDKPmAXSWUB-57g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v8] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Aug 6, 2012 at 4:13 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>
>> On a second thought, perhaps it makes sense to have a git repo (on linuxtv.org)
>> for me to work on stk1160.
>> That way I could simply send "git pull" requests instead of patches.
>>
>> I'm not sure if this is a better workflow and/or would allow for
>> easier reviewing.
>>
>
> Well, I just got an answer from vger administrator. He told me the
> patch was exceeding
> the allowed limit. Which I later discovered it was documented here:
>
> http://vger.kernel.org/majordomo-info.html
>
> Apparently, there is a 100, 000 characters limit.
>
> So, how do we proceed?
>

Ping! Could you take a look at this?
I'd like to solve the pending issues (see previous mails),
in order to know if the driver will need further work.

... or perhaps we can leave this for after the merge window, when
you (and everyone) are be less busy.

I *really* hope I'm not spamming. In that case, feel free to say so.
Thanks,
Ezequiel.
