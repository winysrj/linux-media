Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaG3X1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 19:27:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Durkin <kc7noa@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Fresco Logic FL2000
Date: Thu, 31 Jul 2014 01:27:20 +0200
Message-ID: <5475683.lx59QSOxgD@avalon>
In-Reply-To: <CAC8M0Esy+sRt0OGychoTBfgEBznTnwiCpaC0UzZgd9ga-QSWNg@mail.gmail.com>
References: <CAC8M0Evra8ipDo9Tgasd2AtWWLZQ8M2Ty37i6R3nc7H0-C3_wg@mail.gmail.com> <3072133.WlkirvIpIB@avalon> <CAC8M0Esy+sRt0OGychoTBfgEBznTnwiCpaC0UzZgd9ga-QSWNg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Sorry for the late reply.

On Tuesday 22 July 2014 11:03:35 Michael Durkin wrote:
> as sudo su
> 
> root@SDR-client:/home/mike# lsusb -v -d 1d5c:2000
> 
> Bus 002 Device 003: ID 1d5c:2000
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.10
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x1d5c
>   idProduct          0x2000
>   bcdDevice            1.00
>   iManufacturer           0
>   iProduct                0
>   iSerial                 0
>   bNumConfigurations      1

[snip]

>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass        16
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0

That's, as suspected, a USB Audio/Video class device. There's currently no 
Linux driver for that, and I'm not aware any active project to develop one 
(there were prototypes developed behind closed doors though, but nothing 
published as far as I know). Frankly, given how brain-dead the A/V class 
specification is, I wouldn't hold any hope of getting support for that device 
any time soon (or ever).

-- 
Regards,

Laurent Pinchart

