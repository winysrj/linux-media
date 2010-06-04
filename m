Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63006 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0FDVR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 17:17:29 -0400
Received: by gye5 with SMTP id 5so1266982gye.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jun 2010 14:17:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100604201733.GJ23375@redhat.com>
References: <BQCH7Bq3jFB@christoph>
	<4C09482B.8030404@redhat.com>
	<AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>
	<20100604201733.GJ23375@redhat.com>
Date: Fri, 4 Jun 2010 17:17:28 -0400
Message-ID: <AANLkTimrV3zUg1yqtWCROtUqY4AfvfXrv81BVmh8HHlk@mail.gmail.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Jarod Wilson <jarod@wilsonet.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 4, 2010 at 4:17 PM, Jarod Wilson <jarod@redhat.com> wrote:
> On Fri, Jun 04, 2010 at 02:57:04PM -0400, Jon Smirl wrote:
...
>> > From what I'm seeing, those are the current used ioctls:
>> >
>> > +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
>> > +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)
>>
>> Has this been set into stone yet? if not a 64b word would be more future proof.
>
> Nope, not set in stone at all, nothing has been merged. A patch I was
> carrying in Fedora changed all unsigned long to u64 and unsigned int to
> u32, and my current ir wip tree has all u32, but I don't see a reason why
> if we're going to make a change, it couldn't be to all u64, for as much
> future-proofing as possible.

Hrm, struct file_operations specifies an unsigned long for the ioctl
args, so doesn't that mean we're pretty much stuck with only 32-bit
for the ioctls?

Even with "only" 32 feature flags, I think we'd still be just fine,
there appear to be only 15 feature flags at present, and I doubt many
more features need to be added, given how long lirc has been around.

-- 
Jarod Wilson
jarod@wilsonet.com
