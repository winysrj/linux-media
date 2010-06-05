Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50413 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304Ab0FEMok (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jun 2010 08:44:40 -0400
Received: by vws5 with SMTP id 5so973562vws.19
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 05:44:38 -0700 (PDT)
References: <BQCH7Bq3jFB@christoph> <4C09482B.8030404@redhat.com> <AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com> <20100604201733.GJ23375@redhat.com> <AANLkTimrV3zUg1yqtWCROtUqY4AfvfXrv81BVmh8HHlk@mail.gmail.com> <AANLkTimFzEEPYnKEsUsd42ny1z1DPnhbPhUIwW_6E5rb@mail.gmail.com> <AANLkTim5pV1nDrDplx-XClAwt4LPHnhr0FeWdfgeKl63@mail.gmail.com>
Message-Id: <5601B1AB-20EF-49D3-8EFE-E7F07250E7BC@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <AANLkTim5pV1nDrDplx-XClAwt4LPHnhr0FeWdfgeKl63@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
Date: Sat, 5 Jun 2010 08:43:59 -0400
Cc: Jon Smirl <jonsmirl@gmail.com>, Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	=?utf-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jun 4, 2010, at 10:45 PM, Jarod Wilson <jarod@wilsonet.com> wrote:

> On Fri, Jun 4, 2010 at 7:16 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>> On Fri, Jun 4, 2010 at 5:17 PM, Jarod Wilson <jarod@wilsonet.com>  
>> wrote:
>>> On Fri, Jun 4, 2010 at 4:17 PM, Jarod Wilson <jarod@redhat.com>  
>>> wrote:
>>>> On Fri, Jun 04, 2010 at 02:57:04PM -0400, Jon Smirl wrote:
>>> ...
>>>>>> From what I'm seeing, those are the current used ioctls:
>>>>>>
>>>>>> +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000,  
>>>>>> unsigned long)
>>>>>> +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f,  
>>>>>> unsigned long)
>>>>>
>>>>> Has this been set into stone yet? if not a 64b word would be  
>>>>> more future proof.
>>>>
>>>> Nope, not set in stone at all, nothing has been merged. A patch I  
>>>> was
>>>> carrying in Fedora changed all unsigned long to u64 and unsigned  
>>>> int to
>>>> u32, and my current ir wip tree has all u32, but I don't see a  
>>>> reason why
>>>> if we're going to make a change, it couldn't be to all u64, for  
>>>> as much
>>>> future-proofing as possible.
>>>
>>> Hrm, struct file_operations specifies an unsigned long for the ioctl
>>> args, so doesn't that mean we're pretty much stuck with only 32-bit
>>> for the ioctls?
>>
>> I haven't written an IOCTL in a while, but how would you pass a 64b
>> memory address?
>
> Well, you wouldn't use struct file_operations' ioctl definition if you
> wanted to do so on a 32-bit host. :)
>
> Its definitely possible using a different ioctl definition (see
> gdth_ioctl_free in drivers/scsi/gdth_proc.c, for example), but we're
> currently bound by what's there for file_operations.

There's also the two-pass approach. Just split the address (or feature  
flags) across two slightly different ioctl cmds.

-- 
Jarod Wilson
jarod@wilsonet.com

