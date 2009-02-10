Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1A0phlx029940
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 19:51:43 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1A0p4Go015694
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 19:51:04 -0500
Received: by yw-out-2324.google.com with SMTP id 9so476618ywe.81
	for <video4linux-list@redhat.com>; Mon, 09 Feb 2009 16:51:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3148792E84E9450D9E2AF67899BF7D00@lynxwebdesign>
References: <3148792E84E9450D9E2AF67899BF7D00@lynxwebdesign>
Date: Mon, 9 Feb 2009 19:51:03 -0500
Message-ID: <b24e53350902091651u48a3d921k574e0fdab21a1f7e@mail.gmail.com>
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: Wayne Bragg <wlbragg@cox.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Fw: compiling and installing driver
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

On Mon, Feb 9, 2009 at 6:51 PM, Wayne Bragg <wlbragg@cox.net> wrote:
> I found this out there on the web
> http://n2.nabble.com/Kworld-315U-help--td2110595.html#a2110682
> and wondered if you were still on this list Douglas Landgraf or Franklin
> Meng? If so did you get this device working and can you help me do the same?
>
> -----Original Message ----- From: "Wayne Bragg" <wlbragg@cox.net>
> To: <video4linux-list@redhat.com>
> Sent: Sunday, February 08, 2009 12:02 AM
> Subject: Re: compiling and installing driver
>
>
> On Fri, Feb 6, 2009 at 2:25 PM, Wayne Bragg <wlbragg@cox.net> wrote:
>>
>> Can someone point me to docs on compiling and installing the v4l drivers
>> in Ubuntu. I
>> am a total dweeb newbe and need a good tutorial.
>
> http://linuxtv.org/repo/
>
> Devin
>
> --------------------------
>
>
> Thank's Devin,
>
> I am trying to get Kworld ATSC USB 315U TV device working in linux (Ubuntu)
> I think I needed the v4l-dvb drivers so I followed the proceedures at
>
> http://linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
>
> but hit a snag right off the bat and don't know what to do next.
> Specifically the line about
>
>> "Provided that the drivers were loaded, you should now have a non-empty
>> /dev/dvb directory"
>
> which I didn't have. So I tried the rest of the instructions and installed
> the v4l-dvb drivers, rebooted and still no /dev/dvb directories.
> Linux is not seeing the usb device at all except with
> lsusb
> I get the same output as
> http://linuxtv.org/wiki/index.php/KWorld_ATSC_315U
> which is
> Bus 001 Device 002: ID eb1a:a313 eMPIA Technology, Inc.
> Device Descriptor:
> bLength                18
> bDescriptorType         1
> bcdUSB               2.00
> bDeviceClass            0 (Defined at Interface level)
> bDeviceSubClass         0
> bDeviceProtocol         0
> bMaxPacketSize0        64
> idVendor           0xeb1a eMPIA Technology, Inc.
> idProduct          0xa313
> bcdDevice            1.10
> iManufacturer           0
> iProduct                1
> iSerial                 0
> bNumConfigurations      1
> Configuration Descriptor:
>  bLength                 9
>  bDescriptorType         2
>  wTotalLength          305
>  bNumInterfaces          1
>  bConfigurationValue     1
>  iConfiguration          0
>  bmAttributes         0x80
>    (Bus Powered)
>  MaxPower              500mA
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       0
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0000  1x 0 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0000  1x 0 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0000  1x 0 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       1
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0000  1x 0 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       2
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0ad4  2x 724 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       3
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0c00  2x 0 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       4
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x1300  3x 768 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       5
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x135c  3x 860 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       6
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x13c4  3x 964 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
>  Interface Descriptor:
>    bLength                 9
>    bDescriptorType         4
>    bInterfaceNumber        0
>    bAlternateSetting       7
>    bNumEndpoints           4
>    bInterfaceClass       255 Vendor Specific Class
>    bInterfaceSubClass      0
>    bInterfaceProtocol    255
>    iInterface              0
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x81  EP 1 IN
>      bmAttributes            3
>        Transfer Type            Interrupt
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x0001  1x 1 bytes
>      bInterval              11
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x82  EP 2 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x1400  3x 0 bytes
>      bInterval               1
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x83  EP 3 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x00c4  1x 196 bytes
>      bInterval               4
>    Endpoint Descriptor:
>      bLength                 7
>      bDescriptorType         5
>      bEndpointAddress     0x84  EP 4 IN
>      bmAttributes            1
>        Transfer Type            Isochronous
>        Synch Type               None
>        Usage Type               Data
>      wMaxPacketSize     0x02f0  1x 752 bytes
>      bInterval               1
> I have no idea where to go from here. Can anyone steer me in the right
> direction?Thanks
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=subscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
> --------------------------------------------------------------------------------
>
>
>
> No virus found in this incoming message.
> Checked by AVG - www.avg.com
> Version: 8.0.233 / Virus Database: 270.10.19/1939 - Release Date: 02/06/09
> 17:28:00
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>

Wayne:

>From the command line do 'lsmod | grep em28xx'.  You should see
several modules with em28xx as the prefix.  You should see one called
em28xx-dvb.  When I build v4l I do 'make clean; make distclean; make;
make unload; make install; make load' from the command line.  I assume
that you followed the same steps.  When you build and install v4l it
is a good idea to remove and re-insert usb devices and better yet
reboot to insure that the device is detected and the proper modules
loaded.  The 'make load' step will force all v4l driver modules to
load but I am not sure if v4l will scan the PCI bid and USB bus to try
to detect v4l devices after a fresh install but before a restart.

Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
