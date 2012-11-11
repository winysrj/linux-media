Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56213 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2KKJZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Nov 2012 04:25:08 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so3309188qcr.19
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2012 01:25:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121102104734.04d708de@gaivota.chehab>
References: <CAKQROYViF1PhLNquiPOQAxRs4jnwHXg-kK2PBG3irTtnXpDCwg@mail.gmail.com>
	<000d01cdb886$d08f8ed0$71aeac70$@com>
	<20121102104734.04d708de@gaivota.chehab>
Date: Sun, 11 Nov 2012 09:25:07 +0000
Message-ID: <CAKQROYW6VAppdPFXT1vR0hE+jwZyq9hors2aGkAEW5=dEU0m+A@mail.gmail.com>
Subject: Re: Skeleton LinuxDVB framework
From: Richard <tuxbox.guru@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 November 2012 12:47, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>
> As DVB version 3 or below is outdated, and v4 was never finished/merged.
>
> The DVBv5 (currently, on version 5.8) is the one you should use:
>
>> http://linuxtv.org/downloads/v4l-dvb-apis/dvbapi.html
>
>> -----Original Message-----
>> Subject: Skeleton LinuxDVB framework
>>
>> Hi all,
>>
>> As a newbie to the LinuxDVB Device drivers, I am wondering if there is a
>> framework template to get a quick start in to DVB device drivers. I
>> currently have a SOC chip and an manufacturers API that I would like to make
>> in to a LinuxDVB compliant device. (Tuners/Demods/CA/MPEG output hardware
>> etc)
>
> It is probably easier to get one driver of each type as an example and
> change it to fill your needs.
>
>>
>> Any information is greatly appreciated.
>> Richard

> Cheers,
> Mauro

Hi Mauro (and others),

The documentation shows userspace applications quite clearly, and they
are very easy - its the device driver that I would like to understand
and implement on a SoC. The 'Copy someone elses' idea will get me to
an end, but I have to convince my team of engineers/architects that
the LinuxDVB is the future; and currently I cannot find any
documentation on the .fops, calling conventions, execution order (what
is the dependency order of devices) and such.  I would like to promote
the understanding of the driver, and not blindly hack someone else's
creations. (Hacking code causes maintenance problems later on)
I am currently using a proprietary API that was developed originally
for NeucleusOS that works, and now would like to move to a Linux
standard type system. (Moving from a Working API to an unknown API is
a risk)

Are there any architecture/API documentation on how the driver is
implemented, even pseudo-code would be useful. (Call is 'The Anatomy
of the DVB driver' if you will)

Best Regards,
Richard
