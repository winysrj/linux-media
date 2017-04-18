Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34900 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753539AbdDROAs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 10:00:48 -0400
Received: by mail-pg0-f49.google.com with SMTP id 72so80085167pge.2
        for <linux-media@vger.kernel.org>; Tue, 18 Apr 2017 07:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170416225533.6d83fc6c@vento.lan>
References: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
 <20170416225533.6d83fc6c@vento.lan>
From: Anders Eriksson <aeriksson2@gmail.com>
Date: Tue, 18 Apr 2017 16:00:46 +0200
Message-ID: <CAGncdOa5FOHCqPJBMrkkDNkeL_oAj_SKT4nq2bWwQ80-Za03rQ@mail.gmail.com>
Subject: Re: em28xx i2c writing error
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 17, 2017 at 3:55 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sat, 15 Apr 2017 20:28:20 +0200
> Anders Eriksson <aeriksson2@gmail.com> escreveu:
>
>> Hi Mauro,
>>
>> I've two devices using this driver, and whenever I have them both in
>> use I eventually (between 10K and 100K secs uptime) i2c write errors
>> such as in the log below. If only have one of the devices in use, the
>> machine is stable.
>>
>> The machine never recovers from the error.
>>
>> All help apreciated.
>> -Anders
>>
>>
>>
>> [    0.000000] Booting Linux on physical CPU 0xf00
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Initializing cgroup subsys cpuacct
>> [    0.000000] Linux version 4.4.15-v7+ (dc4@dc4-XPS13-9333) (gcc
>> version 4.9.3 (crosstool-NG crosstool-ng-1.22.0-88-g8460611) ) #897
>> SMP Tue Jul 12 18:42:55 BST 2016
>> [    0.000000] CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d
>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
>> instruction cache
>> [    0.000000] Machine model: Raspberry Pi 2 Model B Rev 1.1
>
> Hmm.. RPi2... that explains a lot ;)
>
> I've seen similar behaviors on some arm devices with just one device.
>
> That's likely due to some problem with isochronous transfers at the
> USB host driver.
>
> The thing is that ISOC transfers are heavily used by USB cameras:
> they require that the USB chip would provide a steady throughput
> that can eat up to 60% of the USB maximum bitrate, with just one
> video stream.
>
> My experience says that several USB drivers can't sustain such
> bit rates for a long time.
>
> The RPi tree uses an out-of-tree driver for the USB host driver
> (otgdwc - I guess). Upstream uses a different driver (dwc2).
> My recent experiences with upstream(dwc2) and USB cameras
> is even worse: it doesn't work, if the camera supports only
> ISOC frames.
>
> I'll eventually try to fix the upstream driver if I find
> spare time for it, but I won't touch at the proprietary
> driver that is shipped with the downstream Kernel.
>

Hi,
I'd appreciate any attempt to fix this. My experience is that it (the
rpi2 with otgdwc) bugs out after 10k-100k of uptime, and can sustain
parallel recordings (using both tv-receivers), so the rest of the
systems seems to be working ok. I'd be happy to try out any patches
you create for the upstream driver.

Br,
Anders
