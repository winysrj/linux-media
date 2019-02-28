Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C884C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 19:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3AD520C01
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 19:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="UHC5Wm73"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfB1TqG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:46:06 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41974 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfB1TqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 14:46:05 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DFA9749;
        Thu, 28 Feb 2019 20:45:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551383160;
        bh=MSeyrodJ8rb+rc0UFIRRdp6NybuqCMEvUJzAgje/72s=;
        h=Reply-To:Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=UHC5Wm73OcYQjVWkCfb2DWgGWvbbqCP/+A4r7e/+R6+seuYWOCGOh2rnIq0RVZa38
         Vw7DJ1eRogQpo0XD6CXCHAvoIawfJblJLTzpAXhtNQJzcWS8VnxzWk9ZuSs7emC0ZQ
         xKgHk9xWDchiD5lCzwjyxWgOGz+XMXU04KiFFHlg=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [linux-uvc-devel] HD Camera (4e45:5501) support
To:     Amila Manoj <amilamanoj@gmail.com>,
        linux-uvc-devel@lists.sourceforge.net
References: <CAN6+69JTiWpiiOeRn2jAuW__sx2J2p8FWUts1SpLeUoAC=W4vQ@mail.gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <c8534224-e8eb-8b77-a4ac-bcdbfd784a1c@ideasonboard.com>
Date:   Thu, 28 Feb 2019 19:45:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAN6+69JTiWpiiOeRn2jAuW__sx2J2p8FWUts1SpLeUoAC=W4vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Amila,

I believe this topic might get more attention on the linux-media mailing
list (which I've added to Cc), but I have some comments below too:


On 27/02/2019 16:41, Amila Manoj wrote:
> Hello,
> 
> 
> I'm trying to get this camera working with Ubuntu 18 (4.15.0-20-generic
> x86_64 GNU/Linux):
> 
> http://www.nse-global.com/index.php?ac=article&at=read&did=445
> 
> This camera is not listed under supported devices in
> http://www.ideasonboard.org/uvc/#devices
> 
> Device initialization fails and it doesn't get listed under /dev/video*
> 
> In lsusb, the device is listed with just the vendor and product id's.
> 
> 
> "lsusb" output:
> 
> Bus 002 Device 007: ID 4e45:5501  
> Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 001 Device 005: ID 8087:0a2b Intel Corp. 
> Bus 001 Device 004: ID 1e3d:2093 Chipsbank Microelectronics Co., Ltd CBM209x Flash Drive (OEM)
> Bus 001 Device 003: ID 04f2:0833 Chicony Electronics Co., Ltd 
> Bus 001 Device 009: ID 17ef:6019 Lenovo 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> 
> "dmesg" output (with trace enabled):
> 
> [Feb27 15:37] usb 2-1: new SuperSpeed USB device number 7 using xhci_hcd
> [  +0.024687] usb 2-1: LPM exit latency is zeroed, disabling LPM.
> [  +0.000632] usb 2-1: New USB device found, idVendor=4e45, idProduct=5501
> [  +0.000005] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  +0.000003] usb 2-1: Product: NSE-CAM
> [  +0.000003] usb 2-1: Manufacturer: NSE
> [  +0.001181] uvcvideo: Probing generic UVC device 1
> [  +0.000009] uvcvideo: Found format YUV 4:2:2 (UYVY).
> [  +0.000003] uvcvideo: - 1920x1080 (30.0 fps)
> [  +0.000009] uvcvideo: Found a Status endpoint (addr 82).
> [  +0.000003] uvcvideo: Found UVC 1.10 device NSE-CAM (4e45:5501)
> [  +0.000009] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'Brightness' to control 00000000-0000-0000-0000-000000000101/2.
> [  +0.000005] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'Contrast' to control 00000000-0000-0000-0000-000000000101/3.
> [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'Hue' to control 00000000-0000-0000-0000-000000000101/6.
> [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'Saturation' to control 00000000-0000-0000-0000-000000000101/7.
> [  +0.000004] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'Sharpness' to control 00000000-0000-0000-0000-000000000101/8.
> [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10 to device 1 entity 2
> [  +0.000004] uvcvideo: Adding mapping 'White Balance Temperature' to control 00000000-0000-0000-0000-000000000101/10.
> [  +0.000003] uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11 to device 1 entity 2
> [  +0.000003] uvcvideo: Adding mapping 'White Balance Temperature, Auto' to control 00000000-0000-0000-0000-000000000101/11.
> [  +0.000003] uvcvideo: Scanning UVC chain: OT 4 <- XU 3 <- PU 2 <- IT 1
> [  +0.000010] uvcvideo: Found a valid video chain (1 -> 4).
> [  +0.709208] usb 1-2: new low-speed USB device number 9 using xhci_hcd
> [  +0.151295] usb 1-2: New USB device found, idVendor=17ef, idProduct=6019
> [  +0.000005] usb 1-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [  +0.000003] usb 1-2: Product: Lenovo Optical USB Mouse
> [  +4.165317] input: Lenovo Optical USB Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:17EF:6019.0006/input/input16
> [  +0.059888] hid-generic 0003:17EF:6019.0006: input,hidraw0: USB HID v1.11 Mouse [Lenovo Optical USB Mouse] on usb-0000:00:14.0-2/input0
> [  +5.055435] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
> [  +5.119896] uvcvideo: Failed to query (129) UVC probe control : -110 (exp. 34).

Hrm ... that ^ 'looks' like a bug we fixed a while back I think ...

Have you tried other UVC cameras on this system?
Are you able to try a later kernel version just to be sure?


> [  +0.000007] uvcvideo: Failed to initialize the device (-5).
> [ +25.599651] usbhid 2-1:1.2: can't add hid device: -110
> [  +0.000031] usbhid: probe of 2-1:1.2 failed with error -110
> 
> 
> "lsusb -d 4e45:5501 -v" output:
> 
> Bus 002 Device 006: ID 4e45:5501  
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0         9
>   idVendor           0x4e45 
>   idProduct          0x5501 
>   bcdDevice            1.03
>   iManufacturer           1 (error)
>   iProduct                2 (error)

These (error)s might be a bit of a concern...

>   iSerial                 0 
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          249
>     bNumInterfaces          3
>     bConfigurationValue     1
>     iConfiguration          3 (error)
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              100mA
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         0
>       bInterfaceCount         2
>       bFunctionClass         14 Video
>       bFunctionSubClass       3 Video Interface Collection
>       bFunctionProtocol       0 
>       iFunction               0 
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0 
>       iInterface              0 
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      1 (HEADER)
>         bcdUVC               1.10
>         wTotalLength           81
>         dwClockFrequency       48.000000MHz
>         bInCollection           1
>         baInterfaceNr( 0)       1
>       VideoControl Interface Descriptor:
>         bLength                18
>         bDescriptorType        36
>         bDescriptorSubtype      2 (INPUT_TERMINAL)
>         bTerminalID             1
>         wTerminalType      0x0201 Camera Sensor
>         bAssocTerminal          0
>         iTerminal               0 
>         wObjectiveFocalLengthMin      0
>         wObjectiveFocalLengthMax      0
>         wOcularFocalLength            0
>         bControlSize                  3
>         bmControls           0x00000000
>       VideoControl Interface Descriptor:
>         bLength                13
>         bDescriptorType        36
>         bDescriptorSubtype      5 (PROCESSING_UNIT)
>         bUnitID                 2
>         bSourceID               1
>         wMaxMultiplier      16384
>         bControlSize            3
>         bmControls     0x0000105f
>           Brightness
>           Contrast
>           Hue
>           Saturation
>           Sharpness
>           White Balance Temperature
>           White Balance Temperature, Auto
>         iProcessing             0 
>         bmVideoStandards     0x 0
>       VideoControl Interface Descriptor:
>         bLength                28
>         bDescriptorType        36
>         bDescriptorSubtype      6 (EXTENSION_UNIT)
>         bUnitID                 3
>         guidExtensionCode         {ffffffff-ffff-ffff-ffff-ffffffffffff}


Hrm ... Laurent - is that suspicious? or ok?


>         bNumControl             0
>         bNrPins                 1
>         baSourceID( 0)          2
>         bControlSize            3
>         bmControls( 0)       0x00
>         bmControls( 1)       0x00
>         bmControls( 2)       0x00
>         iExtension              0 
>       VideoControl Interface Descriptor:
>         bLength                 9
>         bDescriptorType        36
>         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>         bTerminalID             4
>         wTerminalType      0x0101 USB Streaming
>         bAssocTerminal          0
>         bSourceID               3
>         iTerminal               0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>         bMaxBurst               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      2 Video Streaming
>       bInterfaceProtocol      0 
>       iInterface              0 
>       VideoStreaming Interface Descriptor:
>         bLength                            14
>         bDescriptorType                    36
>         bDescriptorSubtype                  1 (INPUT_HEADER)
>         bNumFormats                         1
>         wTotalLength                       71
>         bEndPointAddress                  131
>         bmInfo                              0
>         bTerminalLink                       4
>         bStillCaptureMethod                 1
>         bTriggerSupport                     0
>         bTriggerUsage                       0
>         bControlSize                        1
>         bmaControls( 0)                    27
>       VideoStreaming Interface Descriptor:
>         bLength                            27
>         bDescriptorType                    36
>         bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
>         bFormatIndex                        1
>         bNumFrameDescriptors                1
>         guidFormat                            {55595659-0000-1000-8000-00aa00389b71}
>         bBitsPerPixel                      16
>         bDefaultFrameIndex                  1
>         bAspectRatioX                       0
>         bAspectRatioY                       0
>         bmInterlaceFlags                 0x00
>           Interlaced stream or variable: No
>           Fields per frame: 2 fields
>           Field 1 first: No
>           Field pattern: Field 1 only
>           bCopyProtect                      0
>       VideoStreaming Interface Descriptor:
>         bLength                            30
>         bDescriptorType                    36
>         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
>         bFrameIndex                         1
>         bmCapabilities                   0x03
>           Still image supported
>           Fixed frame-rate
>         wWidth                           1920
>         wHeight                          1080
>         dwMinBitRate                995328000
>         dwMaxBitRate                995328000
>         dwMaxVideoFrameBufferSize     4147200
>         dwDefaultFrameInterval         333333
>         bFrameIntervalType                  1
>         dwFrameInterval( 0)            333333
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      0 None
>       iInterface              0 
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.11
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      29
>           Warning: incomplete report descriptor
>           Report Descriptor: (length is 7)
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>             Item(Main  ): (null), data=none
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval              10
>         bMaxBurst               0
> Device Status:     0x77e8
>   (Bus Powered)
>   U2 Enabled
>   Debug Mode
> 
> 
> I would appreciate any pointers to see if I can get this working.
> 
> Thank you!
> 
> 
> Regards,
> 
> Amila
> 
> 
> 
> _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-uvc-devel
> 

-- 
Regards
--
Kieran
