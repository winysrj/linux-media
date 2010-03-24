Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50260 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0CXPf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 11:35:26 -0400
Received: by bwz1 with SMTP id 1so29345bwz.21
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 08:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1080174267.162141269443441472.JavaMail.root@ntc-mailstore1.newtec.eu>
References: <1053716919.162031269443370641.JavaMail.root@ntc-mailstore1.newtec.eu>
	 <1080174267.162141269443441472.JavaMail.root@ntc-mailstore1.newtec.eu>
Date: Wed, 24 Mar 2010 11:35:23 -0400
Message-ID: <829197381003240835s4fd77e5co72880c42e0d6dadf@mail.gmail.com>
Subject: Re: PCTV 73eSE driver not loaded
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: luc.boschmans@newtec.eu
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 24, 2010 at 11:10 AM,  <luc.boschmans@newtec.eu> wrote:
>
> All,
>
> I am a Linux newbie trying to install a PCTV 73eSE DVB-T receiver, but the driver apparently does not get loaded.
>
> These are the 'cookbook' steps I followed:
> -Fresh Ubuntu 9.10 distribution installed.
> -kernel upgraded to 2.6.31-20-generic (using Ubuntu upgrade tool)
> -Mercurial installed
> -V4L-DVB kernel modules downloaded (source)
> -make (screen output attached)
> -make install
> -reboot (with the DVB-T USB dongle attached during boot)
>
> Outcome:
> -There is no /dev/dvb directory
> -/proc/modules does not list any relevant reference to the PCTV 73eSE USB dongle (apparently the correct driver for that should be the DIB0700 driver)
>
> Looking at the mailing list, there is some history on the PCTV 73eSE device: apparently this was originally owned by Pinnacle; the same device can have 2 different manuf ID's. Posts on the list (nov / dec 2009) point out that corrections have been done to support both manuf ID's.
>
> The relevant lsusb -v output is:
>
> Bus 001 Device 003: ID 2013:0245
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x2013
>  idProduct          0x0245
>  bcdDevice            1.00
>  iManufacturer           1 PCTV Systems
>  iProduct                2 PCTV 73e SE
>  iSerial                 3 0000000M99B4P6Q
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           46
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0xa0
>      (Bus Powered)
>      Remote Wakeup
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           4
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol      0
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x01  EP 1 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               1
> Device Qualifier (for other device speed):
>  bLength                10
>  bDescriptorType         6
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  bNumConfigurations      1
> Device Status:     0x0000
>  (Bus Powered)
>
> The vendor ID in my case apparently is 0x2013. I am able to find back this ID in the source files (but I am not a programmer), so it looks as if this is not the reason why the driver doens't get loaded. Nevertheless, the 'automagic' part of udev seems to have abandoned me:)
>
> Any idea's to proceed on this?
>
> Thanks in advance,
> Luc Boschmans.

A couple of quick things:

Your build doesn't look complete.  Did you manually run "make
menuconfig" and pick whatever modules you believed were relevant?  If
so, then don't do that - do a fresh checkout, and only unset the
firedtv module.

Also, please provide the dmesg output after the bootup, so we can see
if the driver loaded at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
