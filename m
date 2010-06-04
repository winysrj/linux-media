Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0FDPwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 11:52:35 -0400
Date: 04 Jun 2010 17:51:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: jarod@redhat.com
Cc: linux-media@vger.kernel.org
Message-ID: <BQCH7Bq3jFB@christoph>
In-Reply-To: <4C087CBE.10202@redhat.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
> Em 03-06-2010 19:06, Jarod Wilson escreveu:
[...]
>> As for the compat bits... I actually pulled them out of the Fedora kernel
>> and userspace for a while, and there were only a few people who really ran
>> into issues with it, but I think if the new userspace and kernel are rolled
>> out at the same time in a new distro release (i.e., Fedora 14, in our
>> particular case), it should be mostly transparent to users.

> For sure this will happen on all distros that follows upstream: they'll
> update lirc to fulfill the minimal requirement at Documentation/Changes.
>
> The issue will appear only to people that manually compile kernel and lirc.
> Those users are likely smart enough to upgrade to a newer lirc version if
> they notice a trouble, and to check at the forums.

>> Christoph
>> wasn't a fan of the change, and actually asked me to revert it, so I'm
>> cc'ing him here for further feedback, but I'm inclined to say that if this
>> is the price we pay to get upstream, so be it.

> I understand Christoph view, but I think that having to deal with compat
> stuff forever is a high price to pay, as the impact of this change is
> transitory and shouldn't be hard to deal with.

I'm not against doing this change, but it has to be coordinated between  
drivers and user-space.
Just changing lirc.h is not enough. You also have to change all user-space  
applications that use the affected ioctls to use the correct types.
That's what Jarod did not address last time so I asked him to revert the  
change. And I'd also like to collect all other change request to the API  
if there are any and do all changes in one go.

Christoph
