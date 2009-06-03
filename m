Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZFCI5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 04:57:42 -0400
Message-ID: <4A263B42.1010006@redhat.com>
Date: Wed, 03 Jun 2009 10:58:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Erik de Castro Lopo <erik@bcode.com>
CC: linux-media@vger.kernel.org
Subject: Re: Creating a V4L driver for a USB camera
References: <20090603141350.04cde59b.erik@bcode.com>
In-Reply-To: <20090603141350.04cde59b.erik@bcode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/03/2009 06:13 AM, Erik de Castro Lopo wrote:
> Hi all,
>
> I'm a senior software engineer [0] with a small startup. Our product
> is Linux based and makes use of a 3M pixel camera. Unfortunately, the
> camera we have been using for the last 3 years is no longer being
> produced.
>
> We have found two candidate replacement cameras, one with a binary
> only driver and user space library and one with a windows driver
> but no Linux driver.
>
> My questions:
>
>   - How difficult is it to create a GPL V4L driver for a USB camera
>     by snooping the USB traffic of the device when connected to
>     a windows machine? The intention is to merge this work into
>     the V4L mainline and ultimately the kernel.
>

That depends mainly on the format of the image data by the cam,
if the cam sends raw bayer data, or raw yuv / rgb then this is doable,
if it uses plain JPEG it is also doable. If it uses some custom
compression then you need a wizzkid to crack the code. I've tried
this myself, and I failed, you really need someone with the right
mindset to reverse engineer a compression algorithm. Merely being
a good programmer is not enough.

>   - How much work is involved in the above for someone experienced
>     in writing V4L drivers?

This can vary wildly, assuming the video data format is a known one,
a wild estimate would be that this takes 2 fulltime weeks (with hands
on hardware access). But it could be that it takes much longer if
somehow the cam is strange (or worse, like buggy).

>   - Are there people involved with the V4L project that would be
>     willing to undertake this project under contract?
>

Your welcome to send me a couple of cams, that is usually all the
payment I expect, I also don't make any promises (I do this on top
of my dayjob). But first things first, what are the usb-id's of
the cams, can you send me (offlist) the windows drivers ? Chances are
the chipset used is already supported.

Regards,

Hans
