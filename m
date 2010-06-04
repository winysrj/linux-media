Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0FDSir (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 14:38:47 -0400
Message-ID: <4C09482B.8030404@redhat.com>
Date: Fri, 04 Jun 2010 15:38:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: jarod@redhat.com, linux-media@vger.kernel.org,
	Jon Smirl <jonsmirl@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
References: <BQCH7Bq3jFB@christoph>
In-Reply-To: <BQCH7Bq3jFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-06-2010 12:51, Christoph Bartelmus escreveu:
> Hi Mauro,
> 
> on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
>> Em 03-06-2010 19:06, Jarod Wilson escreveu:
> [...]
>>> As for the compat bits... I actually pulled them out of the Fedora kernel
>>> and userspace for a while, and there were only a few people who really ran
>>> into issues with it, but I think if the new userspace and kernel are rolled
>>> out at the same time in a new distro release (i.e., Fedora 14, in our
>>> particular case), it should be mostly transparent to users.
> 
>> For sure this will happen on all distros that follows upstream: they'll
>> update lirc to fulfill the minimal requirement at Documentation/Changes.
>>
>> The issue will appear only to people that manually compile kernel and lirc.
>> Those users are likely smart enough to upgrade to a newer lirc version if
>> they notice a trouble, and to check at the forums.
> 
>>> Christoph
>>> wasn't a fan of the change, and actually asked me to revert it, so I'm
>>> cc'ing him here for further feedback, but I'm inclined to say that if this
>>> is the price we pay to get upstream, so be it.
> 
>> I understand Christoph view, but I think that having to deal with compat
>> stuff forever is a high price to pay, as the impact of this change is
>> transitory and shouldn't be hard to deal with.
> 
> I'm not against doing this change, but it has to be coordinated between  
> drivers and user-space.
> Just changing lirc.h is not enough. You also have to change all user-space  
> applications that use the affected ioctls to use the correct types.
> That's what Jarod did not address last time so I asked him to revert the  
> change.

For sure coordination between kernel and userspace is very important. I'm sure
that Jarod can help with this sync. Also, after having the changes implemented
on userspace, I expect one patch from you adding the minimal lirc requirement 
at Documentation/Changes.

> And I'd also like to collect all other change request to the API  
> if there are any and do all changes in one go.

You and Jarod are the most indicated people to point for such needs. Also, Jon
and David may have some comments.

>From my side, as I said before, I'd like to see a documentation of the defined API bits,
and the removal of the currently unused ioctls (they can be added later, together
with the patches that will introduce the code that handles them) to give my final ack.

>From what I'm seeing, those are the current used ioctls:

+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)

+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)

+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, uint32_t)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, uint32_t)

There is also a defined LIRC_GET_REC_MODE that just returns a mask of GET_FEATURES
bits, and a LIRC_SET_REC_MODE that do nothing.

I can't comment about the other ioctls, as currently there's no code using them, but
it seems that some of them would be better implemented as ioctl, like the ones that
send carrier/burst, etc.

One discussion that may be pertinent is if we should add ioctls for those controls,
or if it would be better to just add sysfs nodes for them.

As all those ioctls are related to config stuff, IMO, using sysfs would be better, but
I haven't a closed opinion about that matter.

Btw, a lirc userspace that would work with both the out-of-tree and in-tree lirc-dev
can easily check for the proper sysfs nodes to know what version of the driver is being
used. It will need access sysfs anyway, to enable the lirc decoder.

Cheers,
Mauro.
