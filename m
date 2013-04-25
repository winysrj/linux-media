Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50114 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3DYLgl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:36:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pierre ANTOINE <nunux@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Trying to lower the URB buffers on eMPIA minicam
Date: Thu, 25 Apr 2013 13:36:41 +0200
Message-ID: <2682572.gZg9L6lqOg@avalon>
In-Reply-To: <1366843673.51786119b3ced@imp.free.fr>
References: <1366843673.51786119b3ced@imp.free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre,

On Thursday 25 April 2013 00:47:53 Pierre ANTOINE wrote:
> Hello guys,
> 
> My nickname is Nunux, I'm a geek, and need some help ...
> 
> I just buy ten minicam to do a poker TV table.
> The minicam are eMPIA: eb1a:299f
> 
> I've a PC with 1 internal USB BUS 2.0 and 3 PCI extension cards USB BUS 2.0
> 
> Currently, I can have only one cam eMPIA working per USB BUS but no more
> even if I set the lower resolution of 160x120.
> 
> [ 2768.783291] uvcvideo: Device requested 1024 B/frame bandwidth.
> [ 2768.783295] uvcvideo: Selecting alternate setting 4 (2736 B/frame
> bandwidth). [ 2768.783641] uvcvideo: Allocated 5 URB buffers of 15x2736
> bytes each. [ 2768.783664] uvcvideo: Failed to submit URB 0 (-28).
> 
> So I can have 4 minicam at a time, but need 10.
> 
> I'm running Linux 3.5.0 on Ubuntu.
> 
> pierre@SuperTable:/usr/src/linux-source-3.5.0/linux-source-3.5.0/drivers/med
> ia/video/uvc$ uvcdynctrl -f -d /dev/video0
> Listing available frame formats for device /dev/video0:
> Pixel format: YUYV (YUV 4:2:2 (YUYV); MIME type: video/x-raw-yuv)
>   Frame size: 640x480
>     Frame rates: 30
>   Frame size: 160x120
>     Frame rates: 30
>   Frame size: 176x144
>     Frame rates: 30
>   Frame size: 320x240
>     Frame rates: 30
>   Frame size: 352x288
>     Frame rates: 30
>   Frame size: 640x480
>     Frame rates: 30
> 
> I try to patch uvc_video.c like this:
>                 /* Isochronous endpoint, select the alternate setting. */
>                 //bandwidth = stream->ctrl.dwMaxPayloadTransferSize;
>                 bandwidth = 1024;
> 
> 
> That help me to reduce the USB bandwidth down to 1024 on a Microsoft LifeCam
> Cinema:
> 
> [  944.410066] USB Video Class driver (1.1.1)
> [  948.636665] uvcvideo: Device requested 1024 B/frame bandwidth.
> [  948.636670] uvcvideo: Selecting alternate setting 4 (1024 B/frame
> bandwidth). [  948.912793] uvcvideo: Allocated 5 URB buffers of 32x1024
> bytes each.
> 
> And allow me to run up to 3 Microsoft LifeCam Cinema on the same PCI USB
> Card.
> 
> But it's not working on eMPIA minicam:
> 
> [  982.488896] uvcvideo: Device requested 1024 B/frame bandwidth.
> [  982.488901] uvcvideo: Selecting alternate setting 4 (2736 B/frame
> bandwidth). [  982.489355] uvcvideo: Allocated 5 URB buffers of 32x2736
> bytes each.
> 
> Because even if the request bandwdith is fixed to 1024, there is no endpoint
> with such lower bandwidth.
> 
> --------------
> 
> So my question is, is it possible to lower the bandwidth of the endpoint,
> or use a different bandwidth, or the do anything to run 3 cams per usb ports
> ?

That largely depends on the device. Even when not requiring the full bandwidth 
on average, devices might send data in bursts (memory is expensive), in which 
case you will need to allocate an average bandwidth larger than or equal to 
the peak bandwidth (that's how USB works). However, your device might not need 
the high bandwidth it reports in its endpoint descriptors. There's no way to 
tell short of trying.

As a quick hack it's probably possible to patch the USB core to lower the 
endpoint bandwidth in the endpoint USB descriptors for that device. That's 
pretty dirty, but will at least let you find out whether your device can work 
at lower bandwidth.

> I host a mini poker mtt for my wife birthday this saturday, and hope get
> some thing to work before...
> 
> So any help or comments would be really appreciated,

Just for my records, could you please repost the 'lsusb -v -d eb1a:299f' 
output running as root ? The string descriptors are not displayed otherwise.

-- 
Regards,

Laurent Pinchart

