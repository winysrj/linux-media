Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44966 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbKIRdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 12:33:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dennis Chen <barracks510@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3 Cameras
Date: Mon, 09 Nov 2015 19:33:29 +0200
Message-ID: <3251528.3ev8VpgUrP@avalon>
In-Reply-To: <1434053610.2501.5.camel@gmail.com>
References: <1433879614.3036.3.camel@gmail.com> <6864236.zlxWyD7sh8@avalon> <1434053610.2501.5.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Denis,

On Thursday 11 June 2015 13:13:30 Dennis Chen wrote:
> > Could you please send me the output of 'lsusb -v -d 045e:07be' and
> > 'lsusb -v -
> > d 045e:07bf' (running as root if possible) ?
> 
> Bus 001 Device 004: ID 045e:07bf Microsoft Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x045e Microsoft Corp.
>   idProduct          0x07bf
>   bcdDevice           21.52
>   iManufacturer           1 QCM
>   iProduct                2 Microsoft LifeCam Rear
>   iSerial                 0
>   bNumConfigurations      1

[snip]

>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      1
>       iInterface              2 Microsoft LifeCam Rear

[snip]

I see where the problem comes from now. I had missed it before, but your 
device sets the bInterfaceProtocol value to 1 as it's UVC 1.5 compliant, as 
opposed to value 0 for UVC 1.1.

The uvcvideo driver doesn't support UVC 1.5 yet. It looks like your camera 
supports the UVC 1.1 protocol as well, but that's not true of all UVC devices 
in general. I expect that enabling detection of UVC 1.5 support in the driver 
will result in issues with UVC 1.5 devices, but on the other hand those 
devices are currently not supported at all. I'll thus submit a patch to enable 
UVC 1.5 device detection, and we'll see how that goes. I'll CC you and would 
appreciate if you could test the patch.

-- 
Regards,

Laurent Pinchart

