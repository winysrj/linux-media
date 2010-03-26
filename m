Return-path: <linux-media-owner@vger.kernel.org>
Received: from ntc-mta1.newtec.eu ([62.58.98.207]:57407 "EHLO
	ntc-mta1.newtec.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0CZHuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 03:50:08 -0400
Date: Fri, 26 Mar 2010 08:50:01 +0100 (CET)
From: Luc Boschmans <luc.boschmans@newtec.eu>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Message-ID: <235898576.241711269589801844.JavaMail.root@ntc-mailstore1.newtec.eu>
In-Reply-To: <829197381003240835s4fd77e5co72880c42e0d6dadf@mail.gmail.com>
Subject: Re: PCTV 73eSE driver not loaded
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin,

The build process was not complete indeed. Dropping FiredTV made it successful - the rest of the story is positive; everything running smooth.

Many thanks!

Luc.


----- Oorspronkelijk bericht -----
Van: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Aan: "luc boschmans" <luc.boschmans@newtec.eu>
Cc: linux-media@vger.kernel.org
Verzonden: Woensdag 24 maart 2010 16:35:23 GMT +01:00 Amsterdam / Berlijn / Bern / Rome / Stockholm / Wenen
Onderwerp: Re: PCTV 73eSE driver not loaded

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
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


Newtec’s MENOS system awarded IBC Innovation Award for Content Delivery & the IBC Judges’ Award  Newtec’s FlexACM awarded 2009 Teleport Technology of the Year by WTA  *** e-mail confidentiality footer *** This message and any attachments thereto are confidential. They may also be privileged or otherwise protected by work product immunity or other legal rules. If you have received it by mistake, please let us know by e-mail reply and delete it from your system; you may not copy this message or disclose its contents to anyone. E-mail transmission cannot be guaranteed to be secure or error free as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete, or contain viruses. The sender therefore is in no way liable for any errors or omissions in the content of this message, which may arise as a result of e-mail transmission. If verification is required, please request a hard copy.
