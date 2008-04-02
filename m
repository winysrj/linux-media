Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail11.syd.optusnet.com.au ([211.29.132.192])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ausgnome@optusnet.com.au>) id 1JhBRT-0007TS-Sv
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 00:28:29 +0200
Received: from [192.168.0.14] (c211-28-205-57.frank1.vic.optusnet.com.au
	[211.28.205.57]) (authenticated sender ausgnome)
	by mail11.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m32MSE8m021028
	for <linux-dvb@linuxtv.org>; Thu, 3 Apr 2008 09:28:15 +1100
Message-ID: <47F4087D.2050202@optusnet.com.au>
Date: Thu, 03 Apr 2008 09:28:13 +1100
From: ausgnome <ausgnome@optusnet.com.au>
MIME-Version: 1.0
To: dvb <linux-dvb@linuxtv.org>
References: <20080329024154.GA23883@localhost>
	<47EDCE27.4050101@optusnet.com.au> <47EE1056.9050804@iki.fi>
	<47EE3C5E.8080001@optusnet.com.au>
	<20080402023911.GA27360@tull.net>
In-Reply-To: <20080402023911.GA27360@tull.net>
Subject: Re: [linux-dvb] Afatech 9015
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

No code changes needed

lsusb -v
Bus 001 Device 005: ID 15a4:9016 
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
  iProduct                2 DVB-T 2
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

Nick Andrew wrote:
> G'day ausgnome,
>
> On Sat, Mar 29, 2008 at 11:55:58PM +1100, ausgnome wrote:
>   
>> I used this tree
>> http://linuxtv.org/hg/~anttip/af9015/
>>     
>
> Did you need to modify the code at all?
>
> And what's your "lsusb" output?
>
> Nick.
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
