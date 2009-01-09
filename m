Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:37562 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbZAIVY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 16:24:27 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3526621fgg.17
        for <linux-media@vger.kernel.org>; Fri, 09 Jan 2009 13:24:25 -0800 (PST)
Message-ID: <208cbae30901091324y1f61351bt70351ed339398d35@mail.gmail.com>
Date: Sat, 10 Jan 2009 00:24:24 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Subject: Re: [v4l-dvb-maintainer] [PATCH] si470x: Support for DealExtreme
Cc: "Tobias Lorenz" <tobias.lorenz@gmx.net>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
In-Reply-To: <49679F6B.1070903@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812031929.12660.tobias.lorenz@gmx.net>
	 <208cbae30812301524w8750a60xd3085ebc8134d865@mail.gmail.com>
	 <496784B6.8090104@iki.fi> <49678678.60506@iki.fi>
	 <208cbae30901091043y771b2387p858015513736c109@mail.gmail.com>
	 <49679F6B.1070903@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added linux-media mailing list)

On Fri, Jan 9, 2009 at 10:03 PM, Antti Palosaari <crope@iki.fi> wrote:
> Alexey Klimov wrote:
>>
>> Hello, Antti
>>
>> On Fri, Jan 9, 2009 at 8:16 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> Antti Palosaari wrote:
>>>>
>>>> hello,
>>>> I bought this stick and I did not get it working. This is my very first
>>>> FM
>>>> radio device thus I am not sure if I did something wrong. I did some
>>>> googling and I got understood that analogue radio devices should create
>>>> deivice /dev/radio - but it does not. My distribution is Fedora 9 x86
>>>> and
>>>> v4l-dvb-master is very fresh.
>>
>> Well, i'm confused (may be i understand your English in wrong way).
>> Did you bought DealExtreme Radio ? Looks like your device called RDing
>> PCear FM Radio. But they have same IDs.
>
> yes
> Bus 002 Device 012: ID 10c5:819a Sanei Electric, Inc.
> I ordered that one: http://dealextreme.com/details.dx/sku.1929
> Device is 100% similar except that no external antenna (from comments I
> think it is rolled inside).
>
>> We have two devices with different names ?
>
> Looks like. I will attach lsusb.

Thanks, probably comments (and may be documentation file) should be fixed.

>> Which kernel version do you use ?
>
> Linux localhost.localdomain 2.6.27.9-73.fc9.x86_64 #1 SMP Tue Dec 16
> 14:54:03 EST 2008 x86_64 x86_64 x86_64 GNU/Linux
> I will update Fedora 10 today.

This kernel doesn't have patch(described below) for usbhid.

>> I have small suggestion that usbhid driver binds this device and didnt
>> allow probe-function of si470x driver to be called. We have patch for
>> hid-subsystem that should cover this issue. This patch still not in
>> 2.6.28-git13. I hope in 2.6.28-rc1 we see this patch.
>> If not we should ask Jiri what happened with patch.

Well, after answering first time i checked again and find that patch
for usbhid that forces usbhid not to touch this device already in
upstream kernel.
It is "HID: don't allow DealExtreme usb-radio be handled by usb hid driver".

> Lets see if Fedora 10 have newer Kernel, if not I will try to install it
>  from delvel system (rawhide).

I dont know how fast changes reach Fedora kernel package.

>> So, you can use bind-unbind approach to deal with problem or you can
>> make rmmod usbhid; modprobe radio-si470x and then plug device in. Feel
>> free to ask more if something wrong.
>
> [root@localhost ~]# rmmod usbhid; modprobe radio-si470x
> ERROR: Module usbhid does not exist in /proc/modules

May be i understand you in wrong way ?

Let's check again. You plug device in, make rmmod radio-si470x, then
you unplug radio and plug again ?
Dmesg shows you that radio-si470x is loaded ? But you have no sound, right ?

There is also should be snd-usb-audio module loaded. Please read
Documentation/video4linux/si470x.txt.
Please, tell us problem in more clear way and let's wait Tobias or
others answer.

>> Tobias, what do you think about this issue ?
>>
>
> regards
> Antti
> --
> http://palosaari.fi/
>
>
> Bus 002 Device 014: ID 10c5:819a Sanei Electric, Inc.
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               1.10
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x10c5 Sanei Electric, Inc.
>  idProduct          0x819a
>  bcdDevice            1.00
>  iManufacturer           1 www.rding.cn
>  iProduct                2
>  iSerial                 0
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength          145
>    bNumInterfaces          3
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              100mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           0
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      1 Control Device
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioControl Interface Descriptor:
>        bLength                 9
>        bDescriptorType        36
>        bDescriptorSubtype      1 (HEADER)
>        bcdADC               1.00
>        wTotalLength           43
>        bInCollection           1
>        baInterfaceNr( 0)       1
>      AudioControl Interface Descriptor:
>        bLength                12
>        bDescriptorType        36
>        bDescriptorSubtype      2 (INPUT_TERMINAL)
>        bTerminalID             1
>        wTerminalType      0x0710 Radio Receiver
>        bAssocTerminal          0
>        bNrChannels             2
>        wChannelConfig     0x0003
>          Left Front (L)
>          Right Front (R)
>        iChannelNames           0
>        iTerminal               0
>      AudioControl Interface Descriptor:
>        bLength                13
>        bDescriptorType        36
>        bDescriptorSubtype      6 (FEATURE_UNIT)
>        bUnitID                 2
>        bSourceID               1
>        bControlSize            2
>        bmaControls( 0)      0x01
>        bmaControls( 0)      0x00
>          Mute
>        bmaControls( 1)      0x00
>        bmaControls( 1)      0x00
>        bmaControls( 2)      0x00
>        bmaControls( 2)      0x00
>        iFeature                0
>      AudioControl Interface Descriptor:
>        bLength                 9
>        bDescriptorType        36
>        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>        bTerminalID             3
>        wTerminalType      0x0101 USB Streaming
>        bAssocTerminal          0
>        bSourceID               2
>        iTerminal               0
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        1
>      bAlternateSetting       0
>      bNumEndpoints           0
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        1
>      bAlternateSetting       1
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  0 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]        96000
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            5
>          Transfer Type            Isochronous
>          Synch Type               Asynchronous
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               1
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         2 Decoded PCM samples
>          wLockDelay              0 Decoded PCM samples
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       0
>      bNumEndpoints           2
>      bInterfaceClass         3 Human Interface Device
>      bInterfaceSubClass      0 No Subclass
>      bInterfaceProtocol      0 None
>      iInterface              0
>        HID Device Descriptor:
>          bLength                 9
>          bDescriptorType        33
>          bcdHID               1.11
>          bCountryCode            0 Not supported
>          bNumDescriptors         1
>          bDescriptorType        34 Report
>          wDescriptorLength     203
>         Report Descriptors:
>           ** UNAVAILABLE **
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval              10
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x02  EP 2 OUT
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0040  1x 64 bytes
>        bInterval               1
> Device Status:     0x0000
>  (Bus Powered)

P.S. I think you don't mind I have cc linux-media maillist to share this case.

-- 
Best regards, Klimov Alexey
