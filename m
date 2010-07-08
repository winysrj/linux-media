Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48869 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312Ab0GHRoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 13:44:11 -0400
Received: by iwn7 with SMTP id 7so1112458iwn.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 10:44:10 -0700 (PDT)
Message-ID: <4C360E64.3020703@gmail.com>
Date: Thu, 08 Jul 2010 13:44:04 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com> <AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
In-Reply-To: <AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 > KWORLD DVD Maker USB 2.0 (VS-USB2800)

Minor correction, for people who might be searching on the exact model 
number:

KWORLD DVD Maker USB 2.0 (VS-USB2800D)

>> It seemed likely to be supported by the em28xx driver, and I'm pleased to
>> report that, in fact, it is!
>
> Yup, it's supported.

Ok, I just wanted to submit a detailed report because I didn't see my 
exact hardware in any of (what I suppose are) the official lists:

http://www.mjmwired.net/kernel/Documentation/video4linux/CARDLIST.em28xx

http://www.linuxtv.org/wiki/index.php/Em28xx_devices#Validated_boards

It's also kinda nice to see that my previous email is already in the top 
ten google results for *linux kworld dvd maker*.

> No firmware is involved at all for this device.  The Merlin ROM you
> are seeing is for other devices that use the same underlying driver.

Ah, that makes sense.

> If your device actually has a physical button on it then yes it will
> work.  The driver will generate a "KEY_CAMERA" input event via
> inputdev (similar to a keyboard event).  Read up on inputdev to see
> how to write a userland application which can see it.

Thanks for those pointers.

Now, regarding the difference in image quality between the Linux and 
Windows drivers, I took some snapshots. Linux is first, then Windows:

http://www3.picturepush.com/photo/a/3762966/img/3762966.png

http://www4.picturepush.com/photo/a/3762977/img/3762977.png

I would have thought that the digitized video coming from the card would 
be essentially the same in both cases, but the vertical stripes and the 
difference in width don't seem to be merely a matter of postprocessing. 
Does the driver have a greater level of control than I suspected over 
the digitization process in the card? (The difference in sharpness, on 
the other hand, I would guess to be postprocessing.)

So I'm mainly wondering whether the vertical stripes can be eliminated 
by controlling the card differently, or if we have no control over that 
and have to deal with it by postprocessing.

Ivan
