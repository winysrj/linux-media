Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39465 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GFPQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 11:16:16 -0400
Received: by yenl2 with SMTP id l2so8684081yen.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 08:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF7005D.6020809@redhat.com>
References: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com>
	<1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
	<4FF5C77C.7030500@redhat.com>
	<CALF0-+XzNOiM+TA3rzY2NGSyXgFL8SuVU_yP0GTpcFMavQmNSg@mail.gmail.com>
	<CALF0-+X3=8kcyz30cqYAH7nunEZyKpvkq0gh70_TB-r-jbutig@mail.gmail.com>
	<CALF0-+UqVy8PzgkNzqH3bdML1QWye+XMTx_-YrmnKGE0s_XepQ@mail.gmail.com>
	<4FF7005D.6020809@redhat.com>
Date: Fri, 6 Jul 2012 12:16:15 -0300
Message-ID: <CALF0-+W7Z48NYXOkX-j9mk5LVTwfRsSQi1BPE1Bt6SfzBfWBTg@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Remove useless runtime->private_data usage
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 6, 2012 at 12:12 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 06-07-2012 11:33, Ezequiel Garcia escreveu:
>> Mauro,
>>
>> On Thu, Jul 5, 2012 at 2:22 PM, Ezequiel Garcia >> Are you sure that
>> this can be removed? I think this is used internally
>>>> by the alsa API, but maybe something has changed and this is not
>>>> required anymore.
>>>
>>> Yes, I'm sure.
>>>
>>
>> This should be: "I'm almost sure" :-)
>> Anyway, probably the patch should have a more verbose commit
>> message, right?
>
> Yeah, that would be good.
>
>> Do you want to do drop it entirely?
>
> No, but, as I'm taking a 2-week vacations starting next week, I'll postpone
> those "compiled-only" cleanup patches to apply after my return, probably
> holding them to be applied on 3.6.
>

Okey.

Have a nice holiday!
Ezequiel.
