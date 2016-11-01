Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34054 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbcKAWOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 18:14:07 -0400
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
 <20161101201122.GF3217@valkosipuli.retiisi.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <c0370517-076a-feef-a84c-45d01b163c37@gmail.com>
Date: Wed, 2 Nov 2016 00:14:01 +0200
MIME-Version: 1.0
In-Reply-To: <20161101201122.GF3217@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On  1.11.2016 22:11, Sakari Ailus wrote:
> Hi Ivaylo,
>
> On Tue, Nov 01, 2016 at 08:36:57AM +0200, Ivaylo Dimitrov wrote:
>> Hi,
>>
>> On  1.11.2016 00:54, Sakari Ailus wrote:
>>> Hi Pavel,
>>>
>>> On Sun, Oct 23, 2016 at 10:33:15PM +0200, Pavel Machek wrote:
>>>> Hi!
>>>>
>>>>> Thanks, this answered half of my questions already. ;-)
>>>>
>>>> :-).
>>>>
>>>> I'll have to go through the patches, et8ek8 driver is probably not
>>>> enough to get useful video. platform/video-bus-switch.c is needed for
>>>> camera switching, then some omap3isp patches to bind flash and
>>>> autofocus into the subdevice.
>>>>
>>>> Then, device tree support on n900 can be added.
>>>
>>> I briefly discussed with with Sebastian.
>>>
>>> Do you think the elusive support for the secondary camera is worth keeping
>>> out the main camera from the DT in mainline? As long as there's a reasonable
>>> way to get it working, I'd just merge that. If someone ever gets the
>>> secondary camera working properly and nicely with the video bus switch,
>>> that's cool, we'll somehow deal with the problem then. But frankly I don't
>>> think it's very useful even if we get there: the quality is really bad.
>>>
>>
>> Yes, lets merge what we have till now, it will be way easier to improve on
>> it once it is part of the mainline.
>>
>> BTW, I have (had) patched VBS working almost without problems, when it comes
>> to it I'll dig it.
>
> I wonder if I'm the only one who wonders what VBS is here. Don't tell me its
> the old MS thing. :-) ;-)
>

Oh, sorry, I thought that V(ideo) B(us) S(witch) is clear in the context :)
