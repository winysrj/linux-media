Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:55150 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdIZLZK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:25:10 -0400
Received: by mail-oi0-f44.google.com with SMTP id u130so10909118oib.11
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 04:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74764813-ef97-1d00-0154-db978612cff9@gmail.com>
References: <CAAeHK+xrQtsE8vSoxXRidXhXk+Dj-tF0cQ9jEDwH_E+fX0mP0A@mail.gmail.com>
 <74764813-ef97-1d00-0154-db978612cff9@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 26 Sep 2017 13:25:09 +0200
Message-ID: <CAAeHK+zz4pjAWixDci5DCx574SsGpwoRoeaDFBhLfC=WBO5pgw@mail.gmail.com>
Subject: Re: usb/media/lmedm04: GPF in lme2510_int_read/usb_pipe_endpoint
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 25, 2017 at 3:30 PM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
>
>
> On 25/09/17 13:39, Andrey Konovalov wrote:
>>
>> Hi!
>>
>> I've got the following report while fuzzing the kernel with syzkaller.
>>
>> On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).
>>
>> usb 1-1: new full-speed USB device number 2 using dummy_hcd
>> gadgetfs: connected
>> gadgetfs: disconnected
>> gadgetfs: connected
>> usb 1-1: config 63 interface 0 altsetting 32 endpoint 0x7 has invalid
>> maxpacket 476, setting to 64
>> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
>> with address 0x0, skipping
>> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
>> with address 0xE7, skipping
>> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
>> with address 0x7F, skipping
>> usb 1-1: config 63 interface 0 has no altsetting 0
>> usb 1-1: New USB device found, idVendor=3344, idProduct=22f0
>> usb 1-1: New USB device strings: Mfr=255, Product=0, SerialNumber=8
>> usb 1-1: Manufacturer: a
>> usb 1-1: SerialNumber: a
>> gadgetfs: configuration #63
>> gadgetfs: configuration #63
>> usb 1-1: selecting invalid altsetting 1
>> LME2510(C): Firmware Status: 4 (61)
>> usb 1-1: dvb_usb_v2: found a 'DM04_LME2510C_DVB-S RS2000' in warm state
>> usb 1-1: dvb_usb_v2: will use the device's hardware PID filter (table
>> count: 15)
>> dvbdev: DVB: registering new adapter (DM04_LME2510C_DVB-S RS2000)
>> usb 1-1: media controller created
>> dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
>> LME2510(C): FE Found M88RS2000
>> ts2020: probe of 0-0060 failed with error -11
>> usb 1-1: DVB: registering adapter 0 frontend 0 (DM04_LME2510C_DVB-S
>> RS2000 RS2000)...
>> dvbdev: dvb_create_media_entity: media entity 'DM04_LME2510C_DVB-S
>> RS2000 RS2000' registered.
>> LME2510(C): TUN Found RS2000 tuner
>> kasan: CONFIG_KASAN_INLINE enabled
>> kasan: GPF could be caused by NULL-ptr deref or user memory access
>> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>
>
> Neither it it null or user memory and it is always present regardless of
> tuner state when _real_ hardware is connected.

Hi Malcolm,

An attacker may connect a malicious USB device having physical access
to a machine. In this case such device would only cause a kernel
crash, which might not be considered that critical, but other bugs
might be exploitable and allow to execute arbitrary code or leak data.
It would be nice to get this fixed to allow further testing of this
driver.

Thanks!

>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
