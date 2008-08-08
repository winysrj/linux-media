Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78C6Rse031602
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 08:06:27 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78C67tI010330
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 08:06:07 -0400
Received: by fg-out-1718.google.com with SMTP id e21so565303fga.7
	for <video4linux-list@redhat.com>; Fri, 08 Aug 2008 05:06:07 -0700 (PDT)
Message-ID: <489C36A3.4060603@gmail.com>
Date: Fri, 08 Aug 2008 13:05:55 +0100
From: zePh7r <zeph7r@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Support for Asus My-Cinema U3000Hybrid?
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

Sometime ago, I bought this usb hybrid tv tuner with FM radio, an Asus 
My-Cinema U3000Hybrid, which considering some Googling I've made on the 
subject seems to be a tuner primarily marketed to eastern and southern 
Europe markets.

Asus is very scarce concerning information related to the device 
specifications. "Official" information is here 
http://www.asus.com/products.aspx?modelmenu=2&model=1639&l1=18&l2=84&l3=254&l4=0

and here  
http://www.asus.com.au/products.aspx?l1=18&l2=84&l3=254&l4=0&model=1639&modelmenu=2

why the second link mentions a so-called "IXCEIVE" tv tuner and the 
first one omits it beats me completely.

The device seems unsupported out-of-the-box in my OpenSUSE 11.0 
(2.6.25.11 kernel) and when I tried googling about linux support I found 
a complete vacuum concerning it. The official support page (forum) has 
some questions related to linux support, all left unanswered. Also, I 
tried inquiring the direct email help support from asus, getting 
non-clear answers (all the operator told me was that "the specification 
of TV Tuner is Philips"). I was also surprised to see that this device 
is not mentioned in the mailing lists.

my lsusb:
Bus 007 Device 002: ID 04f3:0210 Elan Microelectronics Corp. AM-400 Hama 
Optical Mouse
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 003: ID 12d1:1003 Huawei Technologies Co., Ltd. E220 
HSDPA Modem / E270 HSDPA/HSUPA Modem
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 007: ID 0b05:1736 ASUSTek Computer, Inc.
Bus 004 Device 005: ID 064e:a101 Suyin Corp. HP Pavilion dv9640us WebCam
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


and my lsusb -v concerning only to the asus device:

Bus 004 Device 007: ID 0b05:1736 ASUSTek Computer, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0b05 ASUSTek Computer, Inc.
  idProduct          0x1736
  bcdDevice            1.00
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
can't get device qualifier: Operation not permitted
can't get debug descriptor: Operation not permitted
cannot read device status, Operation not permitted (1)

I think there is some confusion in the available information concerning 
the chips used in this device. According to other resource I found: 
http://www.senorg.ro/tv-tunere/asus , a Philips chipset seems to be used 
in older models, some analog only. In the other hand I since xceive 
tuners seem to do the job on both the analog and digital sides, I don't 
see the need to add a a DibCom chipset as well... As so I'm a little 
sceptical about the information available. I was thinking about trying 
the xc3028 or the other members of the xceive family of drivers but I 
was not sure as to em28xx would be an important part to add as well or 
what would be its role in it...

I could think of opening the encased device but I'd preferably rather 
not, as it normally turns out to be irreversible...

Thanks in advance,
--zePh7r

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
