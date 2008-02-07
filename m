Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from astana.suomi.net ([82.128.152.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JNFcC-0003z1-66
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 23:53:08 +0100
Received: from taku.suomi.net ([82.128.154.66])
	by astana.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JVW002S949J36A0@astana.suomi.net> for
	linux-dvb@linuxtv.org; Fri, 08 Feb 2008 00:39:19 +0200 (EET)
Received: from spam2.suomi.net (spam2.suomi.net [212.50.131.166])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JVW0037I49JM1T0@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Fri, 08 Feb 2008 00:39:19 +0200 (EET)
Date: Fri, 08 Feb 2008 00:39:02 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <15a344380802071434k51b59ea3lbe63087f795895e6@mail.gmail.com>
To: Ysangkok <ysangkok@gmail.com>
Message-id: <47AB8886.5070404@iki.fi>
MIME-version: 1.0
References: <15a344380802071428h52e652e8u5e0b1e5fd4bfd56e@mail.gmail.com>
	<15a344380802071434k51b59ea3lbe63087f795895e6@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Ysangkok wrote:
> Hello,
> 
> I've just bought an Sandberg DigiTV USB DVB-T receiver.
> 
> I found out using lsusb that it contained an Afatech AF9016.

It is AF9015.

Looks like firmware you have tried is bad. Download correct one from here:
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

regards
Antti Palosaari

> 
> # lsusb -v -s 5:10
> 
> Bus 005 Device 010: ID 15a4:9016
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x15a4
>   idProduct          0x9016
>   bcdDevice            2.00
>   iManufacturer           1 Afatech
>   iProduct                2 DVB-T
>   iSerial                 3 010101010600001
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           71
>     bNumInterfaces          2
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
>       bInterfaceProtocol      0
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
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
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
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Devices
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      1 Keyboard
>       iInterface              0
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.01
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      65
>          Report Descriptors:
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval              16
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
> 
> 
> 
> 
> 
> 
> When using the default Ubuntu 2.6.22-14-generic kernel however, the
> drivers wasn't loaded.
> 
> I downloaded the source tree for af9015 from
> http://linuxtv.org/hg/~anttip/af9015/ and compiled it.
> 
> I use the firmware from http://af.zsolttech.com/Firmware/?C=S;O=A .
> 
> However, now when I plug it in at the drivers load these messages
> appear in the kernel log:
> [128817.914315] usb 5-4: new high speed USB device using ehci_hcd and address 7
> [128818.051067] usb 5-4: configuration #1 chosen from 1 choice
> [128818.054993] input: Afatech DVB-T as /class/input/input9
> [128818.055067] input: USB HID v1.01 Keyboard [Afatech DVB-T] on
> usb-0000:00:10.4-4
> [128818.230750] af9015_usb_probe:
> [128818.231474] af9015_identify_state: reply:01
> [128818.231484] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
> in cold state, will try to load a firmware
> [128818.258657] dvb-usb: did not find the firmware file.
> (dvb-usb-af9015.fw) Please see linux/Documentation/dvb/ for more
> details on firmware-problems. (-2)
> [128818.259170] dvb_usb_af9015: probe of 5-4:1.0 failed with error -2
> [128818.259400] usbcore: registered new interface driver dvb_usb_af9015
> [129227.449759] usb 5-4: USB disconnect, address 7
> [129358.565659] usb 5-4: new high speed USB device using ehci_hcd and address 8
> [129358.702243] usb 5-4: configuration #1 chosen from 1 choice
> [129358.702669] af9015_usb_probe:
> [129358.702971] af9015_identify_state: reply:01
> [129358.702977] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
> in cold state, will try to load a firmware
> [129358.710768] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [129358.710776] af9015_download_firmware:
> [129359.784171] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129360.782966] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129361.781639] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129362.780432] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129363.779245] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129364.777901] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129365.776691] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129366.775363] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129367.774157] af9015: af9015_rw_udev: sending failed: -110 (36/0)
> [129368.772831] af9015: af9015_rw_udev: sending failed: -110 (8/0)
> [129369.771622] af9015: af9015_rw_udev: receiving failed: -110
> [129369.771633] af9015: af9015_download_firmware: boot failed: -110
> [129369.771740] dvb_usb_af9015: probe of 5-4:1.0 failed with error -110
> [129394.740270] af9015_usb_probe:
> [129395.738915] af9015: af9015_rw_udev: sending failed: -110 (8/0)
> [129396.737703] af9015: af9015_rw_udev: receiving failed: -110
> [129396.737714] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
> in cold state, will try to load a firmware
> [129396.741900] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [129396.741909] af9015_download_firmware:
> [129397.740371] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129398.739167] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129399.737838] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129400.736640] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> [129401.735435] af9015: af9015_rw_udev: sending failed: -110 (63/0)
> 
> 
> 
> 
> 
> The full log is dmesg is attached.
> 
> Sincerely,
> Janus Troelsen
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
