Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46093 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0JOLfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 07:35:23 -0400
Received: by wyb28 with SMTP id 28so541294wyb.19
        for <linux-media@vger.kernel.org>; Fri, 15 Oct 2010 04:35:22 -0700 (PDT)
From: =?UTF-8?Q?Ali_G=C3=BCller?= <aliguller@gmail.com>
To: "'Patrick Boettcher'" <pboettcher@kernellabs.com>
Cc: "'tvbox'" <tvboxspy@gmail.com>,
	"'Mauro Carvalho Chehab'" <maurochehab@gmail.com>,
	"'Antti Palosaari'" <crope@iki.fi>, <linux-media@vger.kernel.org>
References: <1283459370.3368.23.camel@canaries-desktop> <1287084843.4268.6.camel@canaries-desktop> <00e601cb6c40$78f3c720$6adb5560$@com> <201010151014.46993.pboettcher@kernellabs.com>
In-Reply-To: <201010151014.46993.pboettcher@kernellabs.com>
Subject: RE: Skystar USB 2 Driver
Date: Fri, 15 Oct 2010 14:28:34 +0300
Message-ID: <00ed01cb6c5c$1c64cbf0$552e63d0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: tr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
Thank you for your reply

Here is my device
http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_USB_2

TechniSat SkyStar USB 2
>From LinuxTVWiki
Jump to: navigation, search
Overview
Output of lsusb -v: 

Bus 002 Device 004: ID 13d0:2282 TechniSat DVB-S Skystar USB 2
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x13d0 TechniSat
  idProduct          0x2282 DVB-S Skystar USB 2
  bcdDevice            1.01
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           81
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower              222mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           9
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
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
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
        bEndpointAddress     0x8d  EP 13 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0d  EP 13 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0e  EP 14 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8f  EP 15 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               1
cannot read device status, Broken pipe (32)



-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Patrick Boettcher
Sent: Friday, October 15, 2010 11:15 AM
To: Ali Güller
Cc: 'tvbox'; 'Mauro Carvalho Chehab'; 'Antti Palosaari'; linux-media@vger.kernel.org
Subject: Re: Skystar USB 2 Driver

On Friday 15 October 2010 10:10:44 Ali Güller wrote:
> Hi,
> 
> I have just participated in this mail group. I wonder if there is a driver
> for Technisat Skystar USB 2 . Thank you.

Do you have a link with a picture of  this device or a more precise description? 

There is effectively a driver waiting to be merged for a SkyStar USB  DVB-S2, but 
to find out if it yours, I need more information.

regards,

-- 
Patrick 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

