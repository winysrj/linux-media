Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALHZKjv013970
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 12:35:20 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALHZ2oE015129
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 12:35:03 -0500
Received: by ey-out-2122.google.com with SMTP id 4so390269eyf.39
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 09:35:02 -0800 (PST)
Message-ID: <9ff7a3bc0811210935k6db41236m46be9f91ca8937fe@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:05:01 +0530
From: "Joel Fernandes" <agnel.joel@gmail.com>
To: "Jonathan Lafontaine" <jlafontaine@ctecworld.com>,
	video4linux-list@redhat.com
In-Reply-To: <09CD2F1A09A6ED498A24D850EB101208165C79D3C4@Colmatec004.COLMATEC.INT>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <9ff7a3bc0811181538w120aa6bm7ae42395b92d3559@mail.gmail.com>
	<9ff7a3bc0811201048x646a3103i4ff9e89c1b065295@mail.gmail.com>
	<09CD2F1A09A6ED498A24D850EB101208165C79D3C4@Colmatec004.COLMATEC.INT>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: RE : v4l-dvb doesn't detect device : PixelView PlayTV USB 415
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

Hi Jonathan,

Yes I have sniffed the device, the isochronous transfer is
interesting, but I am not able to determine the stream of bytes in the
ISOCH transfer from the device.
Is there a standard format that the v4L framework supports, or a
standard set of functions in v4l framework that I can use to
decode/render the bytes that I receive in the ISOCH tranfer?

the packets after usb sniffing for the isochronous transfer are:

[11642 ms]  >>>  URB 704 going down  >>>
-- URB_FUNCTION_ISOCH_TRANSFER:
  PipeHandle           = 856843f4 [endpoint 0x00000081]
  TransferFlags        = 00000007 (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK, USBD_START_ISO_TRANSFER_ASAP
  TransferBufferLength = 00060000
  TransferBuffer       = 853070b4
  TransferBufferMDL    = 00000000
  StartFrame           = 00000000
  NumberOfPackets      = 00000080
  IsoPacket[0].Offset = 0
  IsoPacket[0].Length = 0
  IsoPacket[1].Offset = 3072
  IsoPacket[1].Length = 0
  IsoPacket[2].Offset = 6144
  IsoPacket[2].Length = 0
  .... till isoPacket[129]

and the same comes back after a few URBs as follows:
[11664 ms]  <<<  URB 704 coming back  <<<
-- URB_FUNCTION_ISOCH_TRANSFER:
  PipeHandle           = 856843f4 [endpoint 0x00000081]
  TransferFlags        = 00000007 (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK, USBD_START_ISO_TRANSFER_ASAP
  TransferBufferLength = 00001800
  TransferBuffer       = 853070b4
  TransferBufferMDL    = 8563b908
  StartFrame           = 0000bbbb
  NumberOfPackets      = 00000080
  ErrorCount           = 0000007e
  IsoPacket[0].Offset = 0
  IsoPacket[0].Length = 0
  IsoPacket[0].Status = c0000011
  IsoPacket[1].Offset = 3072
  IsoPacket[1].Length = 0
  IsoPacket[1].Status = c0000011
  IsoPacket[2].Offset = 6144
  IsoPacket[2].Length = 0
  IsoPacket[2].Status = c0000011
  IsoPacket[3].Offset = 9216
  IsoPacket[3].Length = 2048
  IsoPacket[3].Status = 00000000
    00000000: 80 11 80 12 80 13 80 13 80 13 80 13 80 11 80 11
    00000010: 80 10 80 12 80 12 80 14 7f 13 80 12 7f 12 80 12
    00000020: 7f 12 80 12 7f 11 80 10 7f 12 80 14 7f 13 80 13
    00000030: 7f 14 80 12 7f 11 7f 11 7f 11 7f 12 7f 12 7f 14
    00000040: 7f 13 7f 13 80 12 7f 11 80 12 7f 11 80 10 7f 11
    00000050: 5c 1a 20 47 80 11 80 14 80 13 80 14 80 13 80 12
    00000060: 7f 11 80 10 7f 11 80 11 7f 13 80 14 7f 13 80 13
... data ..

Can you give me a hint on how I could interpret the above data and
write a driver for the same,

Thanks,
Joel

On Fri, Nov 21, 2008 at 1:38 AM, Jonathan Lafontaine
<jlafontaine@ctecworld.com> wrote:
> START SNIFFING DEVICE WITH windows driversin WXP if possible.
>
> if any information u need more th start this reply me.
>
> I'm sure we can get datasheet just need pain in the as research, hustle to companie's costumer support.
>
>
> ________________________________________
> De : video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] de la part de Joel Fernandes [agnel.joel@gmail.com]
> Date d'envoi : 20 novembre 2008 13:48
> À : video4linux-list@redhat.com
> Objet : Re: v4l-dvb doesn't detect device : PixelView PlayTV USB 415
>
>> I bought a pixelview PlayTV USB a couple of months back.
>>
>> Device Details:
>> PV-A5600U1(RN)-F
>> PixelView PlayTV USB 415
>> Device URL: http://www.prolink.com.tw/style/content/CN-08-2cp2/product_detail.asp?lang=2&customer_id=1470&name_id=36165&rid=17007&id=135713
>
> I just opened up the device, and found that it uses a TM5600 usb chip,
> with an XC2028 tuner. I would like to write a little driver for it in
> the V4L framework but I can't figure out where to start. Unfortunately
> the chip doesn't have datasheets availabe, and all that's available is
> a chinese translation of theproduct page.
>
> I would like to use my usb tuner for Composite video, and not really
> for DVB tuning.
>
> My main intention is to start an isochronous transfer from the device,
> I have usb-snooped the URB packets that initiate isochronous transfer,
> I would like to write a v4L driver for the same. Can anyone list the
> areas of v4L that I should study and understand. My first question is,
> what are the v4l modules that mount /dev/video and which interfaces in
> the API should I use to make this happen, along with the video
> transfer? Also as all I want to use the tuner for is composite video,
> can I ignore configuration of the XC2028 chip or do I need to initiate
> it and configure it to have composite video to work.
>
> Looking forward to contributing to v4l with the driver if I have any success.
>
> Thanks,
> Joel
>
> On Wed, Nov 19, 2008 at 5:08 AM, Joel Fernandes <agnel.joel@gmail.com> wrote:
>> Hi,
>> I bought a pixelview PlayTV USB a couple of months back.
>>
>> Device Details:
>> PV-A5600U1(RN)-F
>> PixelView PlayTV USB 415
>> Device URL: http://www.prolink.com.tw/style/content/CN-08-2cp2/product_detail.asp?lang=2&customer_id=1470&name_id=36165&rid=17007&id=135713
>>
>> The device is like a thumb drive. Unfortunately, it doesn't get
>> detected on usb connection. I have been reading quite some source code
>> and thinking off ways to get it to work. After fighting the device
>> alot, and even opening it up, I was thinking if anyone has already got
>> it to work?
>>
>> Things I tried:
>> Inorder to see if drivers for similar devices supported would work, I
>> tried adding my device into the em28xx usb device table, though the
>> driver would detect, it would result in several errors. I soon figured
>> out that the chip/board must be different, (as the vendor/product id
>> was so different) so I somehow took the courage to open up the little
>> device, and found that the board was named 'U6010'.
>> I also found that the vendor ID of the device is present in
>> connexant's v4l drivers (cx88xx) card list. and product ID numbers for
>> my vendor in that list are very close to mine. This led me to think
>> that my device's board is very similar in behavior to the connexant
>> boards except that cx88xx is only for PCI, and mine is a USB.
>> To add to the confusion, the driver on windows seems to be from
>> Trident, who is also apparently the manufacturer of my device.
>> So we have a device that is owned by Prolink, manufactured by Trident,
>> and the drivers on linux are similar to Connexant's. :-) voila! a
>> device driver developers night mare :-)
>>
>> dmesg on connect gives only the following:
>> [  800.907706] usb 5-3: new high speed USB device using ehci_hcd and address 4
>> [  801.337477] usb 5-3: configuration #1 chosen from 1 choice
>>
>> lsusb -v gives the following for my usb device:
>> --------------------------------------------------------------------------------------------
>> Bus 005 Device 003: ID 1554:4966 Prolink Microsystems Corp.
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            0 (Defined at Interface level)
>>  bDeviceSubClass         0
>>  bDeviceProtocol         0
>>  bMaxPacketSize0        64
>>  idVendor           0x1554 Prolink Microsystems Corp.
>>  idProduct          0x4966
>>  bcdDevice            0.01
>>  iManufacturer          16 Trident
>>  iProduct               32 USB2.0 TV BOX
>>  iSerial                64 2004090820040908
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>   bLength                 9
>>   bDescriptorType         2
>>   wTotalLength           78
>>   bNumInterfaces          1
>>   bConfigurationValue     1
>>   iConfiguration         48 2.0
>>   bmAttributes         0x80
>>     (Bus Powered)
>>   MaxPower              500mA
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       0
>>     bNumEndpoints           2
>>     bInterfaceClass       255 Vendor Specific Class
>>     bInterfaceSubClass      0
>>     bInterfaceProtocol    255
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            1
>>         Transfer Type            Isochronous
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0000  1x 0 bytes
>>       bInterval               1
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x82  EP 2 IN
>>       bmAttributes            2
>>         Transfer Type            Bulk
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0200  1x 512 bytes
>>       bInterval               0
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       1
>>     bNumEndpoints           2
>>     bInterfaceClass       255 Vendor Specific Class
>>     bInterfaceSubClass      0
>>     bInterfaceProtocol    255
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            1
>>         Transfer Type            Isochronous
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x1400  3x 1024 bytes
>>       bInterval               1
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x82  EP 2 IN
>>       bmAttributes            2
>>         Transfer Type            Bulk
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0200  1x 512 bytes
>>       bInterval               0
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       2
>>     bNumEndpoints           2
>>     bInterfaceClass       255 Vendor Specific Class
>>     bInterfaceSubClass      0
>>     bInterfaceProtocol    255
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            1
>>         Transfer Type            Isochronous
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x1400  3x 1024 bytes
>>       bInterval               1
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x82  EP 2 IN
>>       bmAttributes            2
>>         Transfer Type            Bulk
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0200  1x 512 bytes
>>       bInterval               0
>> Device Qualifier (for other device speed):
>>  bLength                10
>>  bDescriptorType         6
>>  bcdUSB               2.00
>>  bDeviceClass            0 (Defined at Interface level)
>>  bDeviceSubClass         0
>>  bDeviceProtocol         0
>>  bMaxPacketSize0        64
>>  bNumConfigurations      1
>> Device Status:     0x0002
>>  (Bus Powered)
>>  Remote Wakeup Enabled
>>
>> Bus 005 Device 001: ID 0000:0000
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         1 Single TT
>>  bMaxPacketSize0        64
>>  idVendor           0x0000
>>  idProduct          0x0000
>>  bcdDevice            2.06
>>  iManufacturer           3 Linux 2.6.24-16-generic ehci_hcd
>>  iProduct                2 EHCI Host Controller
>>  iSerial                 1 0000:00:1d.7
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>   bLength                 9
>>   bDescriptorType         2
>>   wTotalLength           25
>>   bNumInterfaces          1
>>   bConfigurationValue     1
>>   iConfiguration          0
>>   bmAttributes         0xe0
>>     Self Powered
>>     Remote Wakeup
>>   MaxPower                0mA
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       0
>>     bNumEndpoints           1
>>     bInterfaceClass         9 Hub
>>     bInterfaceSubClass      0 Unused
>>     bInterfaceProtocol      0 Full speed (or root) hub
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            3
>>         Transfer Type            Interrupt
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0004  1x 4 bytes
>>       bInterval              12
>> Hub Descriptor:
>>  bLength              11
>>  bDescriptorType      41
>>  nNbrPorts             8
>>  wHubCharacteristic 0x000a
>>   No power switching (usb 1.0)
>>   Per-port overcurrent protection
>>   TT think time 8 FS bits
>>  bPwrOn2PwrGood       10 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00 0x00
>>  PortPwrCtrlMask    0xff 0xff
>> Hub Port Status:
>>  Port 1: 0000.0100 power
>>  Port 2: 0000.0100 power
>>  Port 3: 0000.0503 highspeed power enable connect
>>  Port 4: 0000.0100 power
>>  Port 5: 0000.0100 power
>>  Port 6: 0000.0100 power
>>  Port 7: 0000.0100 power
>>  Port 8: 0000.0100 power
>> Device Status:     0x0003
>>  Self Powered
>>  Remote Wakeup Enabled
>>
>> Bus 004 Device 001: ID 0000:0000
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               1.10
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x0000
>>  idProduct          0x0000
>>  bcdDevice            2.06
>>  iManufacturer           3 Linux 2.6.24-16-generic uhci_hcd
>>  iProduct                2 UHCI Host Controller
>>  iSerial                 1 0000:00:1d.3
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>   bLength                 9
>>   bDescriptorType         2
>>   wTotalLength           25
>>   bNumInterfaces          1
>>   bConfigurationValue     1
>>   iConfiguration          0
>>   bmAttributes         0xe0
>>     Self Powered
>>     Remote Wakeup
>>   MaxPower                0mA
>>   Interface Descriptor:
>>     bLength                 9
>>     bDescriptorType         4
>>     bInterfaceNumber        0
>>     bAlternateSetting       0
>>     bNumEndpoints           1
>>     bInterfaceClass         9 Hub
>>     bInterfaceSubClass      0 Unused
>>     bInterfaceProtocol      0 Full speed (or root) hub
>>     iInterface              0
>>     Endpoint Descriptor:
>>       bLength                 7
>>       bDescriptorType         5
>>       bEndpointAddress     0x81  EP 1 IN
>>       bmAttributes            3
>>         Transfer Type            Interrupt
>>         Synch Type               None
>>         Usage Type               Data
>>       wMaxPacketSize     0x0002  1x 2 bytes
>>       bInterval             255
>> Hub Descriptor:
>>  bLength               9
>>  bDescriptorType      41
>>  nNbrPorts             2
>>  wHubCharacteristic 0x000a
>>   No power switching (usb 1.0)
>>   Per-port overcurrent protection
>>  bPwrOn2PwrGood        1 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00
>>  PortPwrCtrlMask    0xff
>> Hub Port Status:
>>  Port 1: 0000.0100 power
>>  Port 2: 0000.0100 power
>> Device Status:     0x0003
>>  Self Powered
>>  Remote Wakeup Enabled
>>
>> Bus 003 Device 001: ID 0000:0000
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               1.10
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x0000
>>  idProduct          0x0000
>>  bcdDevice            2.06
>>  iManufacturer           3 Linux 2.6.24-16-generic uhci_hcd
>>  iProduct                2 UHCI Host Controller
>>  iSerial                 1 0000:00:1d.2
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>   bLength                 9
>>   bDescriptorType         2
>>   wTotalLength           25
>>   bNumInterfaces          1
>>   bConfigurationValue     1
>>   iConfiguration          0
>>   bmAttributes         0xe0
>>     Self Powered
>>     Remote Wakeup
>>   MaxPower                0mA

..

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
