Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ysangkok@gmail.com>) id 1JNFKG-0002I4-DJ
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 23:34:36 +0100
Received: by nf-out-0910.google.com with SMTP id d21so1115140nfb.11
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 14:34:35 -0800 (PST)
Message-ID: <15a344380802071434k51b59ea3lbe63087f795895e6@mail.gmail.com>
Date: Thu, 7 Feb 2008 23:34:34 +0100
From: Ysangkok <ysangkok@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <15a344380802071428h52e652e8u5e0b1e5fd4bfd56e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_29974_14808864.1202423674811"
References: <15a344380802071428h52e652e8u5e0b1e5fd4bfd56e@mail.gmail.com>
Subject: [linux-dvb] af9015 problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_29974_14808864.1202423674811
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I've just bought an Sandberg DigiTV USB DVB-T receiver.

I found out using lsusb that it contained an Afatech AF9016.

# lsusb -v -s 5:10

Bus 005 Device 010: ID 15a4:9016
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x15a4
  idProduct          0x9016
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T
  iSerial                 3 010101010600001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Devices
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)







When using the default Ubuntu 2.6.22-14-generic kernel however, the
drivers wasn't loaded.

I downloaded the source tree for af9015 from
http://linuxtv.org/hg/~anttip/af9015/ and compiled it.

I use the firmware from http://af.zsolttech.com/Firmware/?C=S;O=A .

However, now when I plug it in at the drivers load these messages
appear in the kernel log:
[128817.914315] usb 5-4: new high speed USB device using ehci_hcd and address 7
[128818.051067] usb 5-4: configuration #1 chosen from 1 choice
[128818.054993] input: Afatech DVB-T as /class/input/input9
[128818.055067] input: USB HID v1.01 Keyboard [Afatech DVB-T] on
usb-0000:00:10.4-4
[128818.230750] af9015_usb_probe:
[128818.231474] af9015_identify_state: reply:01
[128818.231484] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
in cold state, will try to load a firmware
[128818.258657] dvb-usb: did not find the firmware file.
(dvb-usb-af9015.fw) Please see linux/Documentation/dvb/ for more
details on firmware-problems. (-2)
[128818.259170] dvb_usb_af9015: probe of 5-4:1.0 failed with error -2
[128818.259400] usbcore: registered new interface driver dvb_usb_af9015
[129227.449759] usb 5-4: USB disconnect, address 7
[129358.565659] usb 5-4: new high speed USB device using ehci_hcd and address 8
[129358.702243] usb 5-4: configuration #1 chosen from 1 choice
[129358.702669] af9015_usb_probe:
[129358.702971] af9015_identify_state: reply:01
[129358.702977] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
in cold state, will try to load a firmware
[129358.710768] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[129358.710776] af9015_download_firmware:
[129359.784171] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129360.782966] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129361.781639] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129362.780432] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129363.779245] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129364.777901] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129365.776691] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129366.775363] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129367.774157] af9015: af9015_rw_udev: sending failed: -110 (36/0)
[129368.772831] af9015: af9015_rw_udev: sending failed: -110 (8/0)
[129369.771622] af9015: af9015_rw_udev: receiving failed: -110
[129369.771633] af9015: af9015_download_firmware: boot failed: -110
[129369.771740] dvb_usb_af9015: probe of 5-4:1.0 failed with error -110
[129394.740270] af9015_usb_probe:
[129395.738915] af9015: af9015_rw_udev: sending failed: -110 (8/0)
[129396.737703] af9015: af9015_rw_udev: receiving failed: -110
[129396.737714] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick'
in cold state, will try to load a firmware
[129396.741900] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[129396.741909] af9015_download_firmware:
[129397.740371] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129398.739167] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129399.737838] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129400.736640] af9015: af9015_rw_udev: sending failed: -110 (63/0)
[129401.735435] af9015: af9015_rw_udev: sending failed: -110 (63/0)





The full log is dmesg is attached.

Sincerely,
Janus Troelsen

------=_Part_29974_14808864.1202423674811
Content-Type: application/x-gzip; name=dmesg.out.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdvyeqw
Content-Disposition: attachment; filename=dmesg.out.txt.gz

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
8AAA
------=_Part_29974_14808864.1202423674811
Content-Type: application/x-gzip; name=lspci.out.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdvyl6f
Content-Disposition: attachment; filename=lspci.out.txt.gz

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
------=_Part_29974_14808864.1202423674811
Content-Type: application/x-gzip; name=lshw.out.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdvyp8v
Content-Disposition: attachment; filename=lshw.out.txt.gz

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
AA==
------=_Part_29974_14808864.1202423674811
Content-Type: application/x-gzip; name=lsusb.out.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcdvz69c
Content-Disposition: attachment; filename=lsusb.out.txt.gz

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
ROBDI///sOuGXBpSAAA=
------=_Part_29974_14808864.1202423674811
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_29974_14808864.1202423674811--
