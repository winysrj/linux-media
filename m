Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61149 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1BIFTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 00:19:19 -0500
Received: by qyk12 with SMTP id 12so5434099qyk.19
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 21:19:18 -0800 (PST)
Subject: Re: MCEUSB: falsly claims mass storage device
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4D51EFFB.90201@users.sourceforge.net>
Date: Wed, 9 Feb 2011 00:19:15 -0500
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Content-Transfer-Encoding: 7bit
Message-Id: <9C5EED67-B096-4C8C-8269-CDDCE24F92A7@wilsonet.com>
References: <201101091836.58104.pboettcher@kernellabs.com> <4D51EFFB.90201@users.sourceforge.net>
To: Lucian Muresan <lucianm@users.sourceforge.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 8, 2011, at 8:38 PM, Lucian Muresan wrote:

> On 09.01.2011 18:36, Patrick Boettcher wrote:
>> Hi Jarod,
>> 
>> I'm using an MultiCard-reader which exposes itself like shown below.
>> 
>> It is falsly claimed by the mceusb-driver from (2.6.36 from debian-
>> experimental) .

Bah. First up, apologies, Patrick, it seems I somehow missed your
mail.


> Hi there,
> 
> I also bought a similar Multi-Cardreader, which also comes with a MCE
> remote control. It seems that the Realtek chip inside (RTS5161 I've
> found in other posts on the net) can really do it all: flash card
> reader, CCID compatible smartcard reader and MCE remote, maybe that's
> why on some readers using it, the wrong module claim it, or on some,
> like mine, claim "too much"?

Well, there are some relatively new cx231xx-based usb capture devices
that similarly are claimed by the mceusb driver, but we had to add an
explicit quirk that says only bind to those devices on a specific
interface (usb_host_interface->desc.bInterfaceNumber == 0). I suspect
that we probably just need to do something similar for this device.


> My problem on a 2.6.38-rc2 kernel self-built on Gentoo is that the
> mceusb module registers 2 LIRC devices /dev/lirc0 and /dev/lirc1, as
> well as 2 input devices, and in that situation, the smartcard part of
> the reader is not usale by openct. Once I managed, after manually
> removing the mceusb module, to load it and have it register only one
> such device, and then openct-tool at least found a CCID-compatible
> reader, but somehow it only happened once. So there seem to be problems
> in the mceusb module with this chip... Is there currently someone
> working on this problem? Below, see the output of lsusb for my
> multi-reader/MCE RC...
> 
> Best Regards,
> Lucian
> 
> 
> lsusb -v -d 0bda:0161
> 
> Bus 001 Device 002: ID 0bda:0161 Realtek Semiconductor Corp. Mass
> Storage Device
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x0bda Realtek Semiconductor Corp.
>  idProduct          0x0161 Mass Storage Device
>  bcdDevice           61.10
>  iManufacturer           1 Generic
>  iProduct                2 USB2.0-CRW
>  iSerial                 3 20070818000000000
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength          139
>    bNumInterfaces          3
...
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       0
>      bNumEndpoints           2
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass    255 Vendor Specific Subclass
>      bInterfaceProtocol    255 Vendor Specific Protocol
>      iInterface              7 eHome Infrared Receiver

Looks like bInterfaceNumber == 2 on this device. The patch to handle this
similar to the conexant polaris devices should be pretty trivial. I'll
try to get something together tomorrow.

-- 
Jarod Wilson
jarod@wilsonet.com



