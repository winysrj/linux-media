Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57440 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab1FVUVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 16:21:30 -0400
Received: by iwn6 with SMTP id 6so997697iwn.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 13:21:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0233DE.6030802@redhat.com>
References: <BANLkTimRt5m_+LBGqF25YY9jU=OLUtXFeg@mail.gmail.com> <4E0233DE.6030802@redhat.com>
From: nogueira13 <nogueira13@gmail.com>
Date: Wed, 22 Jun 2011 17:21:10 -0300
Message-ID: <BANLkTim=LYhUeNG7kQrgpCe=iCEpUX+j+Q@mail.gmail.com>
Subject: Re: KAIOMY ISDB-T Hybrid USB Dongle Receiver
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ok Mauro, Do you think I would capable to add the USB ID at cx231xx
driver in order to make it work? Where from can I gownload the cx231xx
in order I can try to introduce the line (I guess...) in the file of
ths e cx231xx driver and after that to compile it with "make" and them
do "make install" to incorporate it in my kernel (2.6.38-8-generic).
Is it correct this proceeding I said?  I am not sure how to do this
things... I think that I must have the kernel source of
2.6.38-8-generic version in the /usr/src/linux-2.6.38-8-generic
directory, is it correct? Can you indi cate a site or tutorial that I
could do the insersion of the USB ID (1554:5019) in the cx231xx driver
and compile it and to add it in the module in Ubuntu 11.04?
By the way Mauro, couldn't I write in Portuguese to you? Ok, just in
case I send the message only for you, not to linux-media list.

Thanks in advance

Antonio Carlos


>> I bought a KAIOMY ISDB-T Hybrid USB Dongle Receiver to use with my
>> Dell Inspiron 15 Laptop under Ubuntu 11.04 Linux. But I connect it in
>> the USB port and it doesn't recognises it. The kernel version I am
>> using is the 2.6.38-8-generic. I opened the menuconfig of the kernel
>> and I could saw that all modules in the especific section "Device
>> Drivers --> Multimedia support --> DVB/ATSC Adapters" are all set to
>> <M>. I was thinking that the driver v2l already was buit in this
>> modules. But when I connected the device in the USB port I got the
>> following autputs to the lsusb and dmesg commands in the console:
>>
>> Without the device connected
>>
>> nogueira@nogueira-Inspiron-1545:~$ lsusb
>> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
>> Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
>> Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
>> Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub
>> (part of BCM2046 Bluetooth)
>> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 001 Device 004: ID 0c45:63ee Microdia
>> Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0
>> multicard reader
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> nogueira@nogueira-Inspiron-1545:~$
>>
>>
>> With the device connected
>>
>> nogueira@nogueira-Inspiron-1545:~$ lsusb
>> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 003 Device 005: ID 413c:8160 Dell Computer Corp.
>> Bus 003 Device 004: ID 413c:8162 Dell Computer Corp.
>> Bus 003 Device 003: ID 413c:8161 Dell Computer Corp.
>> Bus 003 Device 002: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub
>> (part of BCM2046 Bluetooth)
>> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 002 Device 014: ID 1554:5019 Prolink Microsystems Corp.
>> Bus 002 Device 002: ID 04e8:1f05 Samsung Electronics Co., Ltd
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 001 Device 004: ID 0c45:63ee Microdia
>> Bus 001 Device 003: ID 0bda:0158 Realtek Semiconductor Corp. USB 2.0
>> multicard reader
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> nogueira@nogueira-Inspiron-1545:~$
>>
>> I guess that the device pointed is Device 014, Prolink Microsystems Corp.
>
> Hmm... This device seems to be, in reality, a Prolink device. It is probably
> close to the current Prolink/Pixelview ISDB-T devices already supported.
>
> The first devices from this manufacturer were using dib0700/dib8000. Newer
> devices were using cx231xx chipsets.
>
> I have a few Prolink devices here, but I don't think that any of them have
> this USB ID (1554:5019). I'll need to double-check though. I'm seeking for some
> spare time to add support for a mew more devices.
>
> Anyway, I'm not sure what's the chipset used inside your device. If the device
> is hybrid, it probably has a cx231xx chipset. If so, probably, all that it is
> needed is to add the USB ID at cx231xx driver in order to make it work, of
> course assuming that they didn't make any other hange like using a different
> tuner on it.
>
> Abraços,
> Mauro
>
>
>
>
>
>
