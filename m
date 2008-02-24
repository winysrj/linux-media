Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1O7dAOe031398
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 02:39:10 -0500
Received: from po-out-1718.google.com (po-out-1718.google.com [72.14.252.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1O7cXmF023082
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 02:38:33 -0500
Received: by po-out-1718.google.com with SMTP id b23so1858054poe.1
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 23:38:33 -0800 (PST)
Message-ID: <d9def9db0802232338o478ff9c4x722108fac1320603@mail.gmail.com>
Date: Sun, 24 Feb 2008 08:38:32 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?WINDOWS-1252?Q?Andra=9E_'ruskie'_Levstik?=" <ruskie@mages.ath.cx>
In-Reply-To: <3f2211ae69f189d94ad7030090f46d08@hastymail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
References: <3f2211ae69f189d94ad7030090f46d08@hastymail.org>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: LifeView DVB-T/Analog USB Hybrid - LV5H
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Andraž,


On Sun, Feb 24, 2008 at 8:14 AM, "Andraž 'ruskie' Levstik"
<ruskie@mages.ath.cx> wrote:
> Hi,
>
>  I recently bought the above mentioned device but it seems it's not yet
>  supported. Here's the data that I can provide:
>
>  It uses the em2882(visualy inspected)
>  The model name on the box is: LV5H Hybrid USB (LV5H_LV009O)
>

I ordered that device for adding full support for it too... for more
information please subscribe to the em28xx mailinglist on mcentral.de
If everything goes well I should have it within a week.

Markus

>  Hopefully the provided information will be enough to get it supported. If
>  need be I can provide ssh access to a box with the device attached.
>
>  Bus 001 Device 011: ID eb1a:2883 eMPIA Technology, Inc.
>
>  lsusb -v
>  >>>>
>  Bus 001 Device 011: ID eb1a:2883 eMPIA Technology, Inc.
>  Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0xeb1a eMPIA Technology, Inc.
>   idProduct          0x2883
>   bcdDevice            1.10
>   iManufacturer           0
>   iProduct                1 USB 2883 Device
>   iSerial                 2 200710
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          305
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
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       2
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0ad4  2x 724 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       3
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0c00  2x 1024 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       4
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x1300  3x 768 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       5
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x135c  3x 860 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       6
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x13c4  3x 964 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       7
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol    255
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0001  1x 1 bytes
>         bInterval              11
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x00c4  1x 196 bytes
>         bInterval               4
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0234  1x 564 bytes
>         bInterval               1
>  Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
>  Device Status:     0x0000
>   (Bus Powered)
>  <<<<
>
>  --
>  Andraž "ruskie" Levstik
>  Source Mage GNU/Linux Games grimoire guru
>  Geek/Hacker/Tinker
>
>  Be sure brain is in gear before engaging mouth.
>
>  Key id = F4C1F89C
>  Key fingerprint = 6FF2 8F20 4C9D DB36 B5B6  F134 884D 72CC F4C1 F89C
>
>  --
>  video4linux-list mailing list
>  Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>  https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
