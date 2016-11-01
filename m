Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36703 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163165AbcKAGhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 02:37:03 -0400
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
To: Sakari Ailus <sakari.ailus@iki.fi>, Pavel Machek <pavel@ucw.cz>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
Date: Tue, 1 Nov 2016 08:36:57 +0200
MIME-Version: 1.0
In-Reply-To: <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On  1.11.2016 00:54, Sakari Ailus wrote:
> Hi Pavel,
>
> On Sun, Oct 23, 2016 at 10:33:15PM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> Thanks, this answered half of my questions already. ;-)
>>
>> :-).
>>
>> I'll have to go through the patches, et8ek8 driver is probably not
>> enough to get useful video. platform/video-bus-switch.c is needed for
>> camera switching, then some omap3isp patches to bind flash and
>> autofocus into the subdevice.
>>
>> Then, device tree support on n900 can be added.
>
> I briefly discussed with with Sebastian.
>
> Do you think the elusive support for the secondary camera is worth keeping
> out the main camera from the DT in mainline? As long as there's a reasonable
> way to get it working, I'd just merge that. If someone ever gets the
> secondary camera working properly and nicely with the video bus switch,
> that's cool, we'll somehow deal with the problem then. But frankly I don't
> think it's very useful even if we get there: the quality is really bad.
>

Yes, lets merge what we have till now, it will be way easier to improve 
on it once it is part of the mainline.

BTW, I have (had) patched VBS working almost without problems, when it 
comes to it I'll dig it.

>>> Do all the modes work for you currently btw.?
>>
>> I don't think I got 5MP mode to work. Even 2.5MP mode is tricky (needs
>> a lot of continuous memory).
>
> The OMAP 3 ISP has got an MMU, getting some contiguous memory is not really
> a problem when you have a 4 GiB empty space to use.
>
>> Anyway, I have to start somewhere, and I believe this is a good
>> starting place; I'd like to get the code cleaned up and merged, then
>> move to the next parts.
>
> I wonder if something else could be the problem. I think the data rate is
> higher in the 5 MP mode, and that might be the reason. I don't remember how
> similar is the clock tree in the 3430 to the 3630. Could it be that the ISP
> clock is lower than it should be for some reason, for instance?
>

IIRC I checked what Nokia kernel does, and according to my vague 
memories the frequency was the same. Still, it seems the problem is in 
ISP, it has some very fragile calculations. Yet again, having main 
camera merged will ease the problem hunting.

Regards,
Ivo
