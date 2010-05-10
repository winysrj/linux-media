Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab0EJQZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 12:25:07 -0400
Message-ID: <4BE8335C.3050602@redhat.com>
Date: Mon, 10 May 2010 13:25:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@intel.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	LMML <linux-media@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <20100508083127.73a72af7@tele> <4BE5E995.4070003@redhat.com> <20100510134520.GA6213@xanatos>
In-Reply-To: <20100510134520.GA6213@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sarah Sharp wrote:
> On Sat, May 08, 2010 at 03:45:41PM -0700, Mauro Carvalho Chehab wrote:
>> Jean-Francois Moine wrote:
>>> On Fri, 7 May 2010 09:39:16 -0300
>>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>>
>>>> 		== Gspca patches - Waiting Jean-Francois Moine
>>>> <moinejf@free.fr> submission/review == 
>>>>
>>>> Feb,24 2010: gspca pac7302: add USB PID range based on
>>>> heuristics                   http://patchwork.kernel.org/patch/81612
>>>> May, 3 2010: gspca: Try a less bandwidth-intensive alt
>>>> setting.                     http://patchwork.kernel.org/patch/96514
>>> Hello Mauro,
>>>
>>> I don't think the patch about pac7302 should be applied.
>>> The patch about the gspca main is in my last git pull request.
>> (c/c Sarah)
>>
>> I also didn't like this patch strategy. It seems a sort of workaround
>> for xHCI, instead of a proper fix.
>>
>> I'll mark this patch as rejected, and wait for a proper fix.
> 
> This isn't a work around for a bug in the xHCI host.  The bandwidth
> checking is a feature.  It allows the host to reject a new interface if
> other devices are already taking up too much of the bus bandwidth.  I
> expect that all drivers that use interrupt or isochronous will have to
> fall back to a different alternate interface setting if they can.
> 
> Now, Alan Stern and I have been talking about making a different API for
> drivers to request a specific polling rate and frame list length for an
> endpoint.  However, I expect that the call would have to be either
> before or part of the call to usb_set_interface(), because of how the
> xHCI hardware tracks endpoints.  So even if we had the ideal interface,
> the drivers would still need code like this to fall back to
> less-bandwidth intensive alternate settings.
> 
> Is there a different way you think we should handle running out of
> bandwidth?

Sarah,

A loop like the above doesn't work for video streams. The point is that the
hardware got programmed to some resolution and frame rate. For example, a
typical case is to program the hardware to do 640x480x30fps. Assuming a 
device with 16 bits per pixel, this means a bandwidth of 18.432 Mbps.

With V4L API, the resolution is configured before starting stream 
(so, before the place where usb_set_interface is called). After having all
video stream parameters configured via several different ioctls, a call to
VIDIOC_REQBUFS is done, causing the allocation of the streaming buffers and
the corresponding USB interface setup. On that moment, it is too late to
negotiate the bandwidth. So, if xHCI is not capable of supporting at least
18.432 Mbps (assuming my example), the call should simply fail. 

In thesis, all V4L/DVB USB drivers have a code where it plays with USB interface 
alternates, until they found the minimum alternate that is capable of handing 
the bandwidth needed by the stream. As there's no standard way, at USB core,
to set an isoc bandwidth [1], each driver has its own logic for doing that, and
maybe some strategies are better than the others.

I'm not sure if it would be simpler or possible, but an alternative way would
be to have something like usb_request_bandwidth(), where the USB core would
have the logic to set the interface alternates to fulfill the bandwidth needs, or
return -EINVAL if it is not possible. The advantage is that you won't need to
fix all the different logics used by the V4L/DVB drivers.

[1] On some devices, even needing a constant bandwitdh, they only support bulk
transfers, due to hardware limitation, but, from the driver's perspective, the 
seek for the alternate has an identical need.

-- 

Cheers,
Mauro
