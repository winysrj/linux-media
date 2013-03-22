Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:52203 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998Ab3CVQ7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:59:03 -0400
Received: by mail-la0-f51.google.com with SMTP id fo13so7579242lab.24
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 09:59:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303221745.55932.hverkuil@xs4all.nl>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
	<201303221504.06707.hverkuil@xs4all.nl>
	<CAC-25o-Y=0d9=W2L9-_THvK2cR+jwp=gcZ6URSa6byaR3mKpiw@mail.gmail.com>
	<201303221745.55932.hverkuil@xs4all.nl>
Date: Fri, 22 Mar 2013 12:59:00 -0400
Message-ID: <CAC-25o_J1PrTk0gwSV=Fto-NGirZpmDa-otpaQV6X6+1E+xG0A@mail.gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,


On Fri, Mar 22, 2013 at 12:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri March 22 2013 17:26:57 edubezval@gmail.com wrote:
>> Hello Hans,
>>
>> On Fri, Mar 22, 2013 at 10:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> <snip>
>>
>> >>
>> >> # on your branch on the other hand I get a NULL pointer:
>> >
>> > I've fixed that (v4l2_dev was never initialized), and I've also rebased my tree
>> > to the latest code. Can you try again?
>> >
>>
>> This time I get a kernel crash at _power. Unfortunately I cannot fetch
>> the crash log as I am not having access to a serial line (using vga
>> console) and in my setup mtdoops is not working somehow.
>>
>>
>> Sequence is v4l2_ioctl->video_usercopy->__video_do_ioctl->v4l_s_ctrl->v4l2_s_ctrl->set_ctrl_lock->try_or_set_cluster->si4713_s_ctrl->si4713_set_power_state->mutex_lock_nested->lock_acquire.
>>
>>
>> I 'd need to spend some time on it to understand better your patches
>> and help you to get this working. And for that I'd prob need to spend
>> some time to either hack a serial line or get mtdoops to work :-)
>
> You're doing fine: that was all the info I needed. Can you do a git pull and
> try again?
>

Sure. Your patch removes the locks but I believe the set_power is used in other
places as well. And has a misspell: s/clocks/locks.

But now I still get the nested lock issue. But this time around
si4713_setup, that is called from _s_ctrl and which in turns calls
v4l2_ctrl_handler_setup, which call s_ctrl again.

> Regards,
>
>         Hans



-- 
Eduardo Bezerra Valentin
