Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43978 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1BIXKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 18:10:24 -0500
Received: by eye27 with SMTP id 27so491333eye.19
        for <linux-media@vger.kernel.org>; Wed, 09 Feb 2011 15:10:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102100006.55133.martin@pibbs.de>
References: <201102082305.24897.martin@pibbs.de>
	<201102092336.20812.martin@pibbs.de>
	<AANLkTimST51rWpp9G3a6kds6eqM+dupWu=MyEJtTYZNs@mail.gmail.com>
	<201102100006.55133.martin@pibbs.de>
Date: Wed, 9 Feb 2011 18:10:22 -0500
Message-ID: <AANLkTim5soijcjSrq=n6tQQV-KySuUEgDD_ZT+O-epp7@mail.gmail.com>
Subject: Re: em28xx: board id [eb1a:2863 eMPIA Technology, Inc] Silver Crest
 VG2000 "USB 2.0 Video Grabber"
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Martin Seekatz <martin@pibbs.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 9, 2011 at 6:06 PM, Martin Seekatz <martin@pibbs.de> wrote:
> Am Mittwoch 09 Februar 2011 schrieb Devin Heitmueller:
>> On Wed, Feb 9, 2011 at 5:36 PM, Martin Seekatz <martin@pibbs.de>
> wrote:
>> > Hello Devin,
>> >
>> > I mean that list
>> > http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.em28
>> > xx
>>
>> It actually is there:
>>
>> 29 -> EM2860/TVP5150 Reference Design
>
> Yes, but the list refers to
>  1 -> Unknown EM2750/28xx video grabber        (em2820/em2840)
> [eb1a:2710,eb1a:2820,eb1a:2821,eb1a:2860,eb1a:2861,eb1a:2862,eb1a:2863,eb1a:2870,eb1a:2881,eb1a:2883,eb1a:2868]
>
> because of the usb-id: eb1a:2863
>
>>
>> If the vendor did not build the hardware with its own unique USB ID
>> (because they were lazy), the best we can do is refer to it by the
>> above name (since we would not be able to distinguish between the
>> Silvercrest and all the other clones).
>
> For me it seams that this usb-id is unique.

eb1a:2863 is the chipset vendor's default USB ID.  All reference
designs which use that chip will have that ID.  And because the driver
needs to do additional analysis of the hardware to figure out which
design it is (it probes for other chips in the device), the static
table provided in the text file cannot be specific enough.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
