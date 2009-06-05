Return-path: <linux-media-owner@vger.kernel.org>
Received: from hora-obscura.de ([213.133.111.163]:45730 "EHLO hora-obscura.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZFEHnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 03:43:43 -0400
Message-ID: <4A28CC9B.6070306@hora-obscura.de>
Date: Fri, 05 Jun 2009 10:43:23 +0300
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
References: <4A238292.6000205@hora-obscura.de> <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net> <4A23CF7F.3070301@redhat.com>
In-Reply-To: <4A23CF7F.3070301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede schrieb:
>
>
> On 06/01/2009 09:58 AM, Trent Piepho wrote:
>> On Mon, 1 Jun 2009, Stefan Kost wrote:
>>> I have implemented support for V4L2_MEMORY_USERPTR buffers in
>>> gstreamers
>>> v4l2src [1]. This allows to request shared memory buffers from xvideo,
>>> capture into those and therefore save a memcpy. This works great with
>>> the v4l2 driver on our embedded device.
>>>
>>> When I was testing this on my desktop, I noticed that almost no driver
>>> seems to support it.
>>> I tested zc0301 and uvcvideo, but also grepped the kernel driver
>>> sources. It seems that gspca might support it, but I ave not confirmed
>>> it. Is there a technical reason for it, or is it simply not
>>> implemented?
>>
>> userptr support is relatively new and so it has less support, especially
>> with driver that pre-date it.  Maybe USB cams use a compressed format
>> and
>> so userptr with xvideo would not work anyway since xv won't support the
>> camera's native format.  It certainly could be done for bt8xx, cx88,
>> saa7134, etc.
>
> Even in the webcam with custom compressed format case, userptr support
> could
> be useful to safe a memcpy, as libv4l currently fakes mmap buffers, so
> what
> happens  is:
>
> cam >direct transfer> mmap buffer >libv4l format conversion> fake mmap
> buffer
> >application-memcpy> dest buffer
>
> So if libv4l would support userptr's (which it currently does not do) we
> could still safe a memcpy here.
Do you mean that if a driver supports userptr and one uses libv4l
instead of the direct ioctl, there is a regression and the app is
getting told only mmap works? For higher pixels counts extra memcpy's
are scary, especially if they are no visible. Sorry for the naive
question, but what is libv4l role regarding buffer allocations?

In ourcase we don't need any extra format conversion from libv4l. I am
fine if it works without extra memcpy in that case and I understand that
it would be tricky to support inplace formats conversions for some
formats and extra memcpy for the rest.
>
> I would be willing to take *clean, non invasive* patches to libv4l to add
> userptr support, but I'm not sure if this can be done in a clean way
> (haven't
> tried).
Where are the libv4l sources hosted. I found your blog and the freshmeat
page only so far.
>
> An alternative could be for the app to just use read() in the above case
> as then the app already provides the dest buffer. And the conversion
> will write
> directly to the application provided buffer.
The driver in question support streaming. Isn't that the better way to
do it.
>
> Regards,
>
> Hans
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

