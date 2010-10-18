Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3738 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0JRNUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:20:25 -0400
Message-ID: <aa9cebfeb2bfad9ef7f6ee67a188bf98.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTikPugSRT-t=5bKSLjk3eDmeYh5NYUui=uks35vy@mail.gmail.com>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
    <201010171452.17454.hverkuil@xs4all.nl>
    <AANLkTikPugSRT-t=5bKSLjk3eDmeYh5NYUui=uks35vy@mail.gmail.com>
Date: Mon, 18 Oct 2010 15:20:21 +0200
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Sun, Oct 17, 2010 at 8:52 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Sunday, October 17, 2010 14:26:18 Hans Verkuil wrote:
>>> - serialize the suspend and resume functions using the global lock.
>>> - do not call usb_autopm_put_interface after a disconnect.
>>> - fix a race when disconnecting the device.
>>
>> Regarding autosuspend: something seems to work since the
>> power/runtime_status
>> attribute goes from 'suspended' to 'active' whenever the radio handle is
>> open.
>> But the suspend and resume functions are never called. I can't figure
>> out
>> why not. I don't see anything strange.
>>
>> The whole autopm stuff is highly suspect anyway on a device like this
>> since
>> it is perfectly reasonable to just set a frequency and exit. The audio
>> is
>> just going to the line-in anyway. In other words: not having the device
>> node
>> open does not mean that the device is idle and can be suspended.
>>
>> My proposal would be to rip out the whole autosuspend business from this
>> driver. I've no idea why it is here at all.
>>
>> Regards,
>>
>>        Hans
>
> Hans, I highly agree with that analysis. The original author put that
> code in. But like you, I'm not sure if it was ever really valid. Since
> I didn't have anything to test with, I left it untouched.
>
> Regards,
>
> David Ellingsworth
>
>

OK, then I'll make a new patch that just rips out autosuspend support.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

