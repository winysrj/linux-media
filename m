Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab0CLWwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 17:52:23 -0500
Message-ID: <4B9AC590.3020408@redhat.com>
Date: Fri, 12 Mar 2010 19:52:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Remaining drivers that aren't V4L2?
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com> <201003122242.06508.hverkuil@xs4all.nl>
In-Reply-To: <201003122242.06508.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Friday 12 March 2010 21:11:49 Devin Heitmueller wrote:
>> Hello,
>>
>> I know some months ago, there was some discussion about a few drivers
>> which were stragglers and had not been converted from V4L to V4L2.
>>
>> Do we have a current list of driver which still haven't been converted?
> 
> These drivers are still v4l1:
> 
> arv
> bw-qcam
> c-qcam
> cpia_pp
> cpia_usb
> ov511
> se401
> stradis
> stv680
> usbvideo
> w9966

All the above are webcam drivers. I doubt that those drivers would work
with tvtime: this software were meant to test the Vector's deinterlacing
algorithms, so it requires some specific video formats/resolutions found on TV
and require 25 or 30 fps, as far as I remember. For example, It doesn't support
QCIF/QVGA cameras.

If you want to extend tvtime to use webcams, some work is needed. Probably the easiest
way would be to use libv4l, that also does the V4L1 conversion, if needed. This may
actually make sense even for a few TV cards like em28xx, where you could use a bayer
format with a lower color depth and/or lower resolution, in order to allow viewing two 
simultaneous streams.

So, I suggest you to just drop V4L1 from tvtime and convert it to use libv4l (the conversion
is trivial: just replace open/close/ioctl from the V4L2 driver to the libv4l ones). This will
allow you to drop the old V4L1 driver from it, and, if you decide later to accept other
resolutions and make it more webcam friendly, you'll just need to allow tvtime to accept
other video resolutions and disable the de-interlacing setup if a webcam is detected.

-- 

Cheers,
Mauro
