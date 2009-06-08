Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZFHOxE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 10:53:04 -0400
Message-ID: <4A2D261B.9040104@redhat.com>
Date: Mon, 08 Jun 2009 16:54:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Stefan Kost <ensonic@hora-obscura.de>
CC: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
References: <4A238292.6000205@hora-obscura.de> <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net> <4A23CF7F.3070301@redhat.com> <4A28CC9B.6070306@hora-obscura.de> <4A2BE470.3060005@redhat.com> <4A2CD2C1.40805@hora-obscura.de>
In-Reply-To: <4A2CD2C1.40805@hora-obscura.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 06/08/2009 10:58 AM, Stefan Kost wrote:
> Hans de Goede schrieb:
>>
>> On 06/05/2009 09:43 AM, Stefan Kost wrote:
>>> Hans de Goede schrieb:
>>>> On 06/01/2009 09:58 AM, Trent Piepho wrote:
>>>>> On Mon, 1 Jun 2009, Stefan Kost wrote:
>>>>>> I have implemented support for V4L2_MEMORY_USERPTR buffers in
>>>>>> gstreamers
>>>>>> v4l2src [1]. This allows to request shared memory buffers from
>>>>>> xvideo,
>>>>>> capture into those and therefore save a memcpy. This works great with
>>>>>> the v4l2 driver on our embedded device.
>>>>>>
>>>>>> When I was testing this on my desktop, I noticed that almost no
>>>>>> driver
>>>>>> seems to support it.
>>>>>> I tested zc0301 and uvcvideo, but also grepped the kernel driver
>>>>>> sources. It seems that gspca might support it, but I ave not
>>>>>> confirmed
>>>>>> it. Is there a technical reason for it, or is it simply not
>>>>>> implemented?
>>>>> userptr support is relatively new and so it has less support,
>>>>> especially
>>>>> with driver that pre-date it.  Maybe USB cams use a compressed format
>>>>> and
>>>>> so userptr with xvideo would not work anyway since xv won't support
>>>>> the
>>>>> camera's native format.  It certainly could be done for bt8xx, cx88,
>>>>> saa7134, etc.
>>>> Even in the webcam with custom compressed format case, userptr support
>>>> could
>>>> be useful to safe a memcpy, as libv4l currently fakes mmap buffers, so
>>>> what
>>>> happens  is:
>>>>
>>>> cam>direct transfer>   mmap buffer>libv4l format conversion>   fake mmap
>>>> buffer
>>>>> application-memcpy>   dest buffer
>>>> So if libv4l would support userptr's (which it currently does not
>>>> do) we
>>>> could still safe a memcpy here.
>>> Do you mean that if a driver supports userptr and one uses libv4l
>>> instead of the direct ioctl, there is a regression and the app iuppo
>>> getting told only mmap works?
>> Yes, this was done this way for simplicity's sake (libv4l2 is complex
>> enough at is). At the time this decision was made it was an easy one to
>> make as userptr support mostly was (and I believe still is) a paper
>> excercise. Iow no applications and almost no drivers support it. If
>> more applications start supporting it, support can and should be
>> added to libv4l2. But this will be tricky.
> E.g. omap2 v4l2 drivers (e.g. used in Nokia N800/N810) support it and
> the new drivers fro omap3 will do the same. I probably need to revert
> the libv4l usage in gstreamer than as we can have regressions in
> applications ...

Erm the current (0.10.15) gstreamer libv4l2 plugin does not even use
USERPTR support (which confirms my I didn't implement it because
nothing uses it reasoning), so there can be no regression.

Now not using libv4l will make gstreamer applications not work with
*hundreds* of different webcam models (and that is not an exageration),
see:
http://moinejf.free.fr/webcam.html

For an incomplete list, now some there may work without libv4l, but most
don't.

So given as a choice:
* not having a performance enhancement, which was never present before
   so no regression
* not working with *hundreds* of different webcam models

Which one are you going to choose ? I will most certainly know
where to redirect the bug reports.

Regards,

Hans
