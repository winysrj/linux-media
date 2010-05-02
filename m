Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab0EBSTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 14:19:44 -0400
Message-ID: <4BDDC239.2000503@redhat.com>
Date: Sun, 02 May 2010 15:19:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx & sliced VBI
References: <201005012312.14082.hverkuil@xs4all.nl> <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com> <y2l829197381005021049ze19f886cyedeeb79da4d87229@mail.gmail.com> <201005022013.03216.hverkuil@xs4all.nl>
In-Reply-To: <201005022013.03216.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 02 May 2010 19:49:33 Devin Heitmueller wrote:
>> On Sun, May 2, 2010 at 1:25 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>> On Sat, May 1, 2010 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Hi all,
>>>>
>>>> I played a bit with my HVR900 and tried the sliced VBI API. Unfortunately I
>>>> discovered that it is completely broken. Part of it is obvious: lots of bugs
>>>> and code that does not follow the spec, but I also wonder whether it ever
>>>> actually worked.
>>>>
>>>> Can anyone shed some light on this? And is anyone interested in fixing this
>>>> driver?
>>>>
>>>> I can give pointers and help with background info, but I do not have the time
>>>> to work on this myself.
>>>>
>>>> Regards,
>>>>
>>>>        Hans
>>> Hi Hans,
>>>
>>> I did the em28xx raw VBI support, and I can confirm that the sliced
>>> support is completely broken.  I just forgot to send the patch
>>> upstream which removes it from the set of v4l2 capabilities advertised
>>> for the device.
>> Sorry, I forgot to answer the second half of the email.
>>
>> We've got no plans to get the sliced VBI support working in em28xx.
>> Everybody who has asked KernelLabs to do the work has been perfectly
>> satisfied with the raw VBI support, so it just doesn't feel like there
>> is a benefit worthy of the effort required.  Also, as far as I can
>> tell, every Windows application I have seen which uses VBI against the
>> em28xx all do it in raw mode, so I don't even have a way of verifying
>> that the sliced VBI even works with the chip.
>>
>> The time is better spent working on other things, although we should
>> definitely do a one line patch so that the driver doesn't claim to
>> support sliced mode.
> 
> Why not just nuke everything related to sliced VBI? Just leave a comment
> saying that you should look at older versions if you want to resurrect sliced
> vbi. That's what version control systems are for.
> 
> I hate code that doesn't do anything. It pollutes the source, it confuses the
> reader and it increases the size for no good reason. And people like me spent
> time flogging a dead horse :-(
> 
> Sliced VBI really only makes sense in combination with compressed video
> streams. Or perhaps on SoCs where you don't want to process the raw VBI.

The current code is incomplete. It were added to allow exporting the decoded
VBI information from tvp5051. However, due to the lack of enough specs on em28xx
side, we never found a way to export those decoded VBI info to userspace.

So, we can just drop this code. I don't think we should keep any comment about that.
If anyone would ever interested on adding sliced VBI support, the code is there
anyway.

-- 

Cheers,
Mauro
