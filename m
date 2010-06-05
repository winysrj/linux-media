Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57403 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0FECph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 22:45:37 -0400
Received: by vws5 with SMTP id 5so496725vws.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jun 2010 19:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimFzEEPYnKEsUsd42ny1z1DPnhbPhUIwW_6E5rb@mail.gmail.com>
References: <BQCH7Bq3jFB@christoph>
	<4C09482B.8030404@redhat.com>
	<AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>
	<20100604201733.GJ23375@redhat.com>
	<AANLkTimrV3zUg1yqtWCROtUqY4AfvfXrv81BVmh8HHlk@mail.gmail.com>
	<AANLkTimFzEEPYnKEsUsd42ny1z1DPnhbPhUIwW_6E5rb@mail.gmail.com>
Date: Fri, 4 Jun 2010 22:45:36 -0400
Message-ID: <AANLkTim5pV1nDrDplx-XClAwt4LPHnhr0FeWdfgeKl63@mail.gmail.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Jarod Wilson <jarod@wilsonet.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 4, 2010 at 7:16 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Fri, Jun 4, 2010 at 5:17 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> On Fri, Jun 4, 2010 at 4:17 PM, Jarod Wilson <jarod@redhat.com> wrote:
>>> On Fri, Jun 04, 2010 at 02:57:04PM -0400, Jon Smirl wrote:
>> ...
>>>> > From what I'm seeing, those are the current used ioctls:
>>>> >
>>>> > +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
>>>> > +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)
>>>>
>>>> Has this been set into stone yet? if not a 64b word would be more future proof.
>>>
>>> Nope, not set in stone at all, nothing has been merged. A patch I was
>>> carrying in Fedora changed all unsigned long to u64 and unsigned int to
>>> u32, and my current ir wip tree has all u32, but I don't see a reason why
>>> if we're going to make a change, it couldn't be to all u64, for as much
>>> future-proofing as possible.
>>
>> Hrm, struct file_operations specifies an unsigned long for the ioctl
>> args, so doesn't that mean we're pretty much stuck with only 32-bit
>> for the ioctls?
>
> I haven't written an IOCTL in a while, but how would you pass a 64b
> memory address?

Well, you wouldn't use struct file_operations' ioctl definition if you
wanted to do so on a 32-bit host. :)

Its definitely possible using a different ioctl definition (see
gdth_ioctl_free in drivers/scsi/gdth_proc.c, for example), but we're
currently bound by what's there for file_operations.

-- 
Jarod Wilson
jarod@wilsonet.com
