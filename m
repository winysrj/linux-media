Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZFAMxZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 08:53:25 -0400
Message-ID: <4A23CF7F.3070301@redhat.com>
Date: Mon, 01 Jun 2009 14:54:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Stefan Kost <ensonic@hora-obscura.de>, linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
References: <4A238292.6000205@hora-obscura.de> <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2009 09:58 AM, Trent Piepho wrote:
> On Mon, 1 Jun 2009, Stefan Kost wrote:
>> I have implemented support for V4L2_MEMORY_USERPTR buffers in gstreamers
>> v4l2src [1]. This allows to request shared memory buffers from xvideo,
>> capture into those and therefore save a memcpy. This works great with
>> the v4l2 driver on our embedded device.
>>
>> When I was testing this on my desktop, I noticed that almost no driver
>> seems to support it.
>> I tested zc0301 and uvcvideo, but also grepped the kernel driver
>> sources. It seems that gspca might support it, but I ave not confirmed
>> it. Is there a technical reason for it, or is it simply not implemented?
>
> userptr support is relatively new and so it has less support, especially
> with driver that pre-date it.  Maybe USB cams use a compressed format and
> so userptr with xvideo would not work anyway since xv won't support the
> camera's native format.  It certainly could be done for bt8xx, cx88,
> saa7134, etc.

Even in the webcam with custom compressed format case, userptr support could
be useful to safe a memcpy, as libv4l currently fakes mmap buffers, so what
happens  is:

cam >direct transfer> mmap buffer >libv4l format conversion> fake mmap buffer
 >application-memcpy> dest buffer

So if libv4l would support userptr's (which it currently does not do) we
could still safe a memcpy here.

I would be willing to take *clean, non invasive* patches to libv4l to add
userptr support, but I'm not sure if this can be done in a clean way (haven't
tried).

An alternative could be for the app to just use read() in the above case
as then the app already provides the dest buffer. And the conversion will write
directly to the application provided buffer.

Regards,

Hans
