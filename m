Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58309 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0FDS5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 14:57:08 -0400
Received: by vws5 with SMTP id 5so21132vws.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jun 2010 11:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C09482B.8030404@redhat.com>
References: <BQCH7Bq3jFB@christoph>
	<4C09482B.8030404@redhat.com>
Date: Fri, 4 Jun 2010 14:57:04 -0400
Message-ID: <AANLkTikr49GiEcENLb6n1shtCkWrDhMXoYh4VJ4IPtdQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@redhat.com,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 4, 2010 at 2:38 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 04-06-2010 12:51, Christoph Bartelmus escreveu:
>> Hi Mauro,
>>
>> on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
>>> Em 03-06-2010 19:06, Jarod Wilson escreveu:
>> [...]
>>>> As for the compat bits... I actually pulled them out of the Fedora kernel
>>>> and userspace for a while, and there were only a few people who really ran
>>>> into issues with it, but I think if the new userspace and kernel are rolled
>>>> out at the same time in a new distro release (i.e., Fedora 14, in our
>>>> particular case), it should be mostly transparent to users.
>>
>>> For sure this will happen on all distros that follows upstream: they'll
>>> update lirc to fulfill the minimal requirement at Documentation/Changes.
>>>
>>> The issue will appear only to people that manually compile kernel and lirc.
>>> Those users are likely smart enough to upgrade to a newer lirc version if
>>> they notice a trouble, and to check at the forums.
>>
>>>> Christoph
>>>> wasn't a fan of the change, and actually asked me to revert it, so I'm
>>>> cc'ing him here for further feedback, but I'm inclined to say that if this
>>>> is the price we pay to get upstream, so be it.
>>
>>> I understand Christoph view, but I think that having to deal with compat
>>> stuff forever is a high price to pay, as the impact of this change is
>>> transitory and shouldn't be hard to deal with.
>>
>> I'm not against doing this change, but it has to be coordinated between
>> drivers and user-space.
>> Just changing lirc.h is not enough. You also have to change all user-space
>> applications that use the affected ioctls to use the correct types.
>> That's what Jarod did not address last time so I asked him to revert the
>> change.
>
> For sure coordination between kernel and userspace is very important. I'm sure
> that Jarod can help with this sync. Also, after having the changes implemented
> on userspace, I expect one patch from you adding the minimal lirc requirement
> at Documentation/Changes.

Keep the get_version() ioctl stable. The first thing user space would
do it call the get_version() ioctl. If user space doesn't support the
kernel version error out and print a message with the url of the
project web site and tell the user to upgrade.

If you have the ability to upgrade your kernel you should also have
the ability to upgrade user space too. I'm no fan of keeping backwards
compatibility code around. It just becomes piles of clutter that
nobody maintains. A reliable mechanism to determine version mismatch
is all that is needed.

PS - I really don't like having to fix bug reports in compatibility
code. That is an incredible waste of support time that can be easily
fixed by upgrading the user.

>
>> And I'd also like to collect all other change request to the API
>> if there are any and do all changes in one go.
>
> You and Jarod are the most indicated people to point for such needs. Also, Jon
> and David may have some comments.
>
> From my side, as I said before, I'd like to see a documentation of the defined API bits,
> and the removal of the currently unused ioctls (they can be added later, together
> with the patches that will introduce the code that handles them) to give my final ack.
>
> From what I'm seeing, those are the current used ioctls:
>
> +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
>
> +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)

Has this been set into stone yet? if not a 64b word would be more future proof.
Checking the existence of features might be better as sysfs
attributes. You can have as many sysfs attributes as you want.

> +#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, uint32_t)
> +#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, uint32_t)
>
> There is also a defined LIRC_GET_REC_MODE that just returns a mask of GET_FEATURES
> bits, and a LIRC_SET_REC_MODE that do nothing.
>
> I can't comment about the other ioctls, as currently there's no code using them, but
> it seems that some of them would be better implemented as ioctl, like the ones that
> send carrier/burst, etc.

If the ioctls haven't been implemented, leave them as comments in the
h file. Don't implement them with stubs. Stubs will set the parameters
into stone and the parameters may be wrong.

> One discussion that may be pertinent is if we should add ioctls for those controls,
> or if it would be better to just add sysfs nodes for them.
>
> As all those ioctls are related to config stuff, IMO, using sysfs would be better, but
> I haven't a closed opinion about that matter.

In general sysfs is used to set options that are static or only change
infrequently.

If the parameter is set on every request, use an IOCTL.


>
> Btw, a lirc userspace that would work with both the out-of-tree and in-tree lirc-dev
> can easily check for the proper sysfs nodes to know what version of the driver is being
> used. It will need access sysfs anyway, to enable the lirc decoder.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
