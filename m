Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1KGMVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 07:21:53 -0500
Message-ID: <4EB7CD59.1010303@redhat.com>
Date: Mon, 07 Nov 2011 10:21:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Taylor Ralph <taylor.ralph@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support firmware
 versions > 0.15
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com> <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com> <20111020162340.GC7530@jannau.net> <CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com> <20111020170811.GD7530@jannau.net> <CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com> <CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com> <CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
In-Reply-To: <CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-10-2011 01:33, Taylor Ralph escreveu:
> On Thu, Oct 20, 2011 at 3:26 PM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
>> On Thu, Oct 20, 2011 at 2:14 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>> On Thu, Oct 20, 2011 at 1:08 PM, Janne Grunau <j@jannau.net> wrote:
>>>> I think such scenario is unlikely but I don't know it for sure and
>>>> I don't want to force anyone to test every firmware version.
>>>> Ignoring them for firmware version < 16 should be safe since we assume
>>>> they had no effect. Returning -EINVAL might break API-ignoring
>>>> applications written with the HD PVR in mind but I think it's a better
>>>> approach than silently ignoring those controls.
>>>
>>> At this point, let's just make it so that the old behavior is
>>> unchanged for old firmwares, meaning from both an API standpoint as
>>> well as what the values are.  At some point if somebody cares enough
>>> to go back and fix the support so that the controls actually work with
>>> old firmwares, they can take that up as a separate task.  In reality,
>>> it is likely that nobody will ever do that, as the "easy answer" is
>>> just to upgrade to firmware 16.
>>>
>>> Taylor, could you please tweak your patch to that effect and resubmit?
>>>
>>
>> Sure, I'll try to get to it tonight and have it tested.
>>
> 
> OK, I've updated the patch per your requests. I made this patch
> against the latest kernel source but I'm unable to test since my
> 2.6.32 kernel has symbol issues with the new v4l code.

Please, add your Signed-off-by: to the patch. This is a requirement for
it to be accepted upstream[1].

Thanks,
Mauro

[1] See: http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1

> 
> Regards.
> --
> Taylor

