Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:43891 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab0EBRte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 13:49:34 -0400
Received: by gxk9 with SMTP id 9so1026135gxk.8
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 10:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com>
References: <201005012312.14082.hverkuil@xs4all.nl>
	 <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com>
Date: Sun, 2 May 2010 13:49:33 -0400
Message-ID: <y2l829197381005021049ze19f886cyedeeb79da4d87229@mail.gmail.com>
Subject: Re: em28xx & sliced VBI
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 2, 2010 at 1:25 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sat, May 1, 2010 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi all,
>>
>> I played a bit with my HVR900 and tried the sliced VBI API. Unfortunately I
>> discovered that it is completely broken. Part of it is obvious: lots of bugs
>> and code that does not follow the spec, but I also wonder whether it ever
>> actually worked.
>>
>> Can anyone shed some light on this? And is anyone interested in fixing this
>> driver?
>>
>> I can give pointers and help with background info, but I do not have the time
>> to work on this myself.
>>
>> Regards,
>>
>>        Hans
>
> Hi Hans,
>
> I did the em28xx raw VBI support, and I can confirm that the sliced
> support is completely broken.  I just forgot to send the patch
> upstream which removes it from the set of v4l2 capabilities advertised
> for the device.

Sorry, I forgot to answer the second half of the email.

We've got no plans to get the sliced VBI support working in em28xx.
Everybody who has asked KernelLabs to do the work has been perfectly
satisfied with the raw VBI support, so it just doesn't feel like there
is a benefit worthy of the effort required.  Also, as far as I can
tell, every Windows application I have seen which uses VBI against the
em28xx all do it in raw mode, so I don't even have a way of verifying
that the sliced VBI even works with the chip.

The time is better spent working on other things, although we should
definitely do a one line patch so that the driver doesn't claim to
support sliced mode.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
