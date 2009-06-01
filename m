Return-path: <linux-media-owner@vger.kernel.org>
Received: from hora-obscura.de ([213.133.111.163]:35253 "EHLO hora-obscura.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFAIHw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 04:07:52 -0400
Message-ID: <4A238C48.7090405@hora-obscura.de>
Date: Mon, 01 Jun 2009 11:07:36 +0300
From: Stefan Kost <ensonic@hora-obscura.de>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
References: <4A238292.6000205@hora-obscura.de> <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho schrieb:
> On Mon, 1 Jun 2009, Stefan Kost wrote:
>   
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
>>     
>
> userptr support is relatively new and so it has less support, especially
> with driver that pre-date it.  Maybe USB cams use a compressed format and
> so userptr with xvideo would not work anyway since xv won't support the
> camera's native format.  It certainly could be done for bt8xx, cx88,
> saa7134, etc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Yes, I am aware of the format issue. On the gstreamer side formats are
negotiated. Plugins export e.g. wat colorpsaces they support and the
zerocopy path can only be taken if e.g. both support UVYV. Luckily this
is quite common.

But thanks for the info. I have nver touched kernel code sofar, but if I
find some free time, I can try to add support for it in one driver.

Stefan
