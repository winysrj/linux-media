Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59409 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GDN1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 09:27:43 -0400
Received: by yhmm54 with SMTP id m54so7221213yhm.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 06:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com>
References: <CAD4Xxq_s4zbRKBrjcQAfn4v5Dp0sytU=8_=XUViice98aQFysQ@mail.gmail.com>
	<CAD4Xxq9LXGXQKRiNsU_tE8LcyJY64Wk5H4OFzEyhhXtsJJy3dw@mail.gmail.com>
	<CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com>
Date: Wed, 4 Jul 2012 23:27:42 +1000
Message-ID: <CAD4Xxq8CpCMtNP=sPSMhsWs4K1qULXWBtGzbu1ENqs1pgBBs3Q@mail.gmail.com>
Subject: Re: ATI theatre 750 HD tuner USB stick
From: Fisher Grubb <fisher.grubb@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I was in contact with AMD today regarding this tuner haveing no
support on Linux and I was given a link for a feedback form and told
to get specific needs from www.linuxtv.org to help the cause and if
there were enough people, then the AMD developers may help.

Of course I wouldn't be surprised if people will have to reverse
engineer it from the windows drivers but I thought I would mention it.
 I could not find any info on this 750 HD on www.linuxtv.org regarding
where it stands.  What help is needed for it?

Fisher

On Wed, Jul 4, 2012 at 11:21 PM, Fisher Grubb <fisher.grubb@gmail.com> wrote:
> Hi all,
>
> My name is Fisher Grubb, I have an ATI (now AMD) theatre 750 HD based
> TV tuner USB stick.  I don't think this ATI chipset is supported by
> linuxTV and have had no joy search google as others also hit a dead
> end.
>
> I have put USB bus dump for that device and the chip part numbers at the bottom.
>
> Please may I have a quick reply if someone looks at this, thanks.
>
> Model number is U5071, manufacturer site: http://www.geniatech.com/pa/u5071.asp
>
> I think this is a very impressive piece of hardware as it can do:
> Analogue TV, DVB, AV capture and S video capture.  There is an IR
> receiver on board and came with IR remote control.
>
> I'm happy to provide any info on it that you may want such as picture
> of board & chips.  I'm almost finished my electronics degree and so
> can do hardware probing if someone may give me something specific to
> look for.  I'm also happy to run software or commands to dump stuff or
> even help with dumping things from the windows drivers if I've given
> directions etc.
>
> Thank you,
>
> Fisher
>
> lsusb: Bus 002 Device 021: ID 0438:ac14 Advanced Micro Devices, Inc.
>
> sudo lsusb -vd 0438:ac14
>
> Bus 002 Device 021: ID 0438:ac14 Advanced Micro Devices, Inc.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0438 Advanced Micro Devices, Inc.
>   idProduct          0xac14
>   bcdDevice            1.00
>   iManufacturer           1 AMD
>   iProduct                2 Cali TV Card
>   iSerial                 3 1234-5678
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           97
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           5
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               3
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           5
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               3
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
>
> Chips:
> ATI:
> T507
> 0930
> MADE IN TAIWAN
> P0U493.00
> 215-0692014
>
> NXP:
> TDA18271HDC2
> P3KN4 02
> PG09361
