Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38249 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933595AbdIYNa6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 09:30:58 -0400
Subject: Re: usb/media/lmedm04: GPF in lme2510_int_read/usb_pipe_endpoint
To: Andrey Konovalov <andreyknvl@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
References: <CAAeHK+xrQtsE8vSoxXRidXhXk+Dj-tF0cQ9jEDwH_E+fX0mP0A@mail.gmail.com>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <74764813-ef97-1d00-0154-db978612cff9@gmail.com>
Date: Mon, 25 Sep 2017 14:30:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAAeHK+xrQtsE8vSoxXRidXhXk+Dj-tF0cQ9jEDwH_E+fX0mP0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 25/09/17 13:39, Andrey Konovalov wrote:
> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).
> 
> usb 1-1: new full-speed USB device number 2 using dummy_hcd
> gadgetfs: connected
> gadgetfs: disconnected
> gadgetfs: connected
> usb 1-1: config 63 interface 0 altsetting 32 endpoint 0x7 has invalid
> maxpacket 476, setting to 64
> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
> with address 0x0, skipping
> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
> with address 0xE7, skipping
> usb 1-1: config 63 interface 0 altsetting 32 has an invalid endpoint
> with address 0x7F, skipping
> usb 1-1: config 63 interface 0 has no altsetting 0
> usb 1-1: New USB device found, idVendor=3344, idProduct=22f0
> usb 1-1: New USB device strings: Mfr=255, Product=0, SerialNumber=8
> usb 1-1: Manufacturer: a
> usb 1-1: SerialNumber: a
> gadgetfs: configuration #63
> gadgetfs: configuration #63
> usb 1-1: selecting invalid altsetting 1
> LME2510(C): Firmware Status: 4 (61)
> usb 1-1: dvb_usb_v2: found a 'DM04_LME2510C_DVB-S RS2000' in warm state
> usb 1-1: dvb_usb_v2: will use the device's hardware PID filter (table count: 15)
> dvbdev: DVB: registering new adapter (DM04_LME2510C_DVB-S RS2000)
> usb 1-1: media controller created
> dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
> LME2510(C): FE Found M88RS2000
> ts2020: probe of 0-0060 failed with error -11
> usb 1-1: DVB: registering adapter 0 frontend 0 (DM04_LME2510C_DVB-S
> RS2000 RS2000)...
> dvbdev: dvb_create_media_entity: media entity 'DM04_LME2510C_DVB-S
> RS2000 RS2000' registered.
> LME2510(C): TUN Found RS2000 tuner
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN

Neither it it null or user memory and it is always present regardless of 
tuner state when _real_ hardware is connected.
