Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37102 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2JWUCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 16:02:10 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1292526eaa.19
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2012 13:02:08 -0700 (PDT)
Message-ID: <5086E9C0.5060701@googlemail.com>
Date: Tue, 23 Oct 2012 22:02:24 +0300
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: dheitmueller@kernellabs.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com> <CAGoCfiw-nL03s=JSc_MVzR0+hQEfHV5i+FMf41EbEME8jw3wQg@mail.gmail.com>
In-Reply-To: <CAGoCfiw-nL03s=JSc_MVzR0+hQEfHV5i+FMf41EbEME8jw3wQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 21.10.2012 21:13, schrieb Devin Heitmueller:
> Hi Frank,
>
> On Sun, Oct 21, 2012 at 12:52 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> This patch series adds support for USB bulk transfers to the em28xx driver.
> This is a welcome change that some users have been asking about for a while.

Yes, I know...

>
>> Patch 1 is a bugfix for the image data processing with non-interlaced devices (webcams)
>> that should be considered for stable (see commit message).
>>
>> Patches 2-21 extend the driver to support USB bulk transfers.
>> USB endpoint mapping had to be extended and is a bit tricky.
>> It might still not be sufficient to handle ALL isoc/bulk endpoints of ALL existing devices,
>> but it should work with the devices we have seen so far and (most important !)
>> preserves backwards compatibility to the current driver behavior.
>> Isoc endpoints/transfers are preffered by default, patch 21 adds a module parameter to change this behavior.
>>
>> The last two patches are follow-up patches not really related to USB tranfers.
>> Patch 22 reduces the code size in em28xx-video by merging the two URB data processing functions
> This is generally good stuff.  When I originally added the VBI
> support, I kept the URB handlers separate initially to reduce the risk
> of breaking existing devices, and always assumed that at some point
> the two routines would be merged.  You did regression test without VBI
> support enabled though, right?

Yes, but when you take a look at the code, you will see that this patch
nothing really changes for VBI devices.
The problem / regression potential is the non-VBI-devices as they are
now using the VBI-version, too, but they have been tested.
Btw, why didn't you test this function with VBI disabled when you added
it ? ;)

>
>> and patch 23 enables VBI-support for em2840-devices.
> Patch 23 shouldn't be applied unless somebody has an em2840 device to
> test with first.  Nobody has complained about this so far, and it's
> better to not support VBI than to possibly break existing support.

Btw, what about em2874 / em2884 / em28174 ?
We should really sort these kind of things out when adding new devices...

>
>> Please note that I could test the changes with an analog non-interlaced non-VBI device only !
>> So further tests with DVB/interlaced/VBI devices are strongly recommended !
> So here's the problem:  I don't have the cycles to test this, and all
> the refactoring presents a very real risk that breakage of existing
> support could occur.  You've basically got three options if you want
> to see this merged upstream:
>
> 1.  Wait for me to eventually do the testing.
> 2.  Plead for users to do testing, in particular of the VBI support
> for interlaced devices (which is 99% of devices out there)
> 3.  See if Mauro has time to do the testing.

I would say 1 + 2 + 3 ;)
And maybe it's a good chance for the people who were asking for this
feature in the past.

I know there are lots of other people on this list having such a device.

> 4.  Spend $30 and buy one of the dozens of em28xx based analog capture
> devices out there and do the validation yourself (a huge percentage of
> the "Video tape capture devices" are em28xx based.  For example, when
> I did the original VBI work, I used the following:
>
> KWorld DVD Maker USB 2.0 VS- USB2800 USB 2.0 Interface
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815100112
>
> If you're in the United States, I can mail you a device for testing.
> But given how dirt-cheap they are, buying one yourself might be easier
> (and if the money is really the issue, send me your paypal details
> offline and I'll give you the $30.00).

No, thank you. I already have too many devices which I actually don't need.
I'm doing this as a hobby and at the moment, I'm focussed on getting the
devices I already have working properly (which isn't a small task).

I personally don't need this feature uptsream at the moment.
The device I used for testing supports ISOC as well and the em25xx
webcam I'm currently working on will likely use gspca at the end.

> Thanks for you hard work on this, and it will be great to get this
> stuff into the mainline.

I did what I could do. Now its up to others ;)

Regards,
Frank

> Devin
>

