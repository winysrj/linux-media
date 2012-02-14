Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33177 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2BNUnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 15:43:52 -0500
Received: by pbcun15 with SMTP id un15so769021pbc.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 12:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOTqeXoavdYLkfp+FRLj3v24z2m+xZHiKhnOOiHJhZ+Y858y9w@mail.gmail.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
	<CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
	<20111020170811.GD7530@jannau.net>
	<CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
	<CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com>
	<CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
	<4EB7CD59.1010303@redhat.com>
	<CAOTqeXoavdYLkfp+FRLj3v24z2m+xZHiKhnOOiHJhZ+Y858y9w@mail.gmail.com>
Date: Tue, 14 Feb 2012 15:43:51 -0500
Message-ID: <CANOx78GENFQXfuX0OeYPa=YCHREk3H2OKmKQhkEsQx9qFieksg@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Jarod Wilson <jarod@wilsonet.com>
To: Taylor Ralph <taylor.ralph@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 7, 2011 at 7:54 PM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
> On Mon, Nov 7, 2011 at 7:21 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 21-10-2011 01:33, Taylor Ralph escreveu:
>>> On Thu, Oct 20, 2011 at 3:26 PM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
>>>> On Thu, Oct 20, 2011 at 2:14 PM, Devin Heitmueller
>>>> <dheitmueller@kernellabs.com> wrote:
>>>>> On Thu, Oct 20, 2011 at 1:08 PM, Janne Grunau <j@jannau.net> wrote:
>>>>>> I think such scenario is unlikely but I don't know it for sure and
>>>>>> I don't want to force anyone to test every firmware version.
>>>>>> Ignoring them for firmware version < 16 should be safe since we assume
>>>>>> they had no effect. Returning -EINVAL might break API-ignoring
>>>>>> applications written with the HD PVR in mind but I think it's a better
>>>>>> approach than silently ignoring those controls.
>>>>>
>>>>> At this point, let's just make it so that the old behavior is
>>>>> unchanged for old firmwares, meaning from both an API standpoint as
>>>>> well as what the values are.  At some point if somebody cares enough
>>>>> to go back and fix the support so that the controls actually work with
>>>>> old firmwares, they can take that up as a separate task.  In reality,
>>>>> it is likely that nobody will ever do that, as the "easy answer" is
>>>>> just to upgrade to firmware 16.
>>>>>
>>>>> Taylor, could you please tweak your patch to that effect and resubmit?
>>>>>
>>>>
>>>> Sure, I'll try to get to it tonight and have it tested.

Looks sane to me, and really needs to get in ASAP. I'd even suggest we
get it sent to stable, as these newer firmware HDPVR are pretty wonky
with any current kernel.

Acked-by: Jarod Wilson <jarod@redhat.com>
Reviewed-by: Jarod Wilson <jarod@redhat.com>
CC: stable@vger.kernel.org

-- 
Jarod Wilson
jarod@wilsonet.com
