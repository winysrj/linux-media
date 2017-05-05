Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34490 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdEEQdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 12:33:49 -0400
Received: by mail-qk0-f193.google.com with SMTP id u75so1552759qka.1
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 09:33:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505154435.GA18161@googlemail.com>
References: <20170504222115.GA26659@googlemail.com> <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
 <20170505154435.GA18161@googlemail.com>
From: Markus Rechberger <mrechberger@gmail.com>
Date: Sat, 6 May 2017 00:33:47 +0800
Message-ID: <CA+O4pCKDyADH+Bx8Mxd01jCzU3vefRK6JLLYFDMuXdbZxToDtw@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: support for Sundtek MediaTV Digital Home
To: Markus Rechberger <mrechberger@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 5, 2017 at 11:44 PM, Thomas Hollstegge
<thomas.hollstegge@gmail.com> wrote:
> Hi Markus,
>
> Markus Rechberger <mrechberger@gmail.com> schrieb am Fri, 05. May 08:06:
>> On Fri, May 5, 2017 at 6:21 AM, Thomas Hollstegge
>> <thomas.hollstegge@gmail.com> wrote:
>> > Sundtek MediaTV Digital Home is a rebranded MaxMedia UB425-TC with the
>> > following components:
>> >
>> > USB bridge: Empia EM2874B
>> > Demodulator: Micronas DRX 3913KA2
>> > Tuner: NXP TDA18271HDC2
>> >
>>
>> Not that it matters a lot anymore for those units however the USB ID
>> is allocated for multiple different units, this patch will break some
>> of them.
>
> I searched the kernel sources for USB IDs but didn't find any mention.
> So what exactly will break with this commit? Is there a better way to
> detect different devices besides USB IDs?
>

We had different HW designs based on Empia until 2012 using this USB
ID it will not work with many units out there, also with different
standby behaviours, chipsets etc.

If you want to get a device with kernel support I recommend buying a
different one and let that one go back to our community (since our
tuners and support are still quite popular).

>> If you want to use that use the unit with this driver you're on your
>> own and have to assign it via sysfs and usb/bind.
>
> I did, and it works fine. However, it would be nice if the driver
> supported the devices directly.
>
>> It was a joint project many years ago before we also started to design
>> and manufacture our own units.
>
> Interesting, thanks for sharing this insight!
>
> Cheers
> Thomas
