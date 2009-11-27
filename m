Return-path: <linux-media-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:56790 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZK0TDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 14:03:11 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	christoph@bartelmus.de, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	<BDgcsm11qgB@lirc>
	<9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com>
Date: Fri, 27 Nov 2009 20:03:09 +0100
In-Reply-To: <9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com>
	(Jon Smirl's message of "Fri, 27 Nov 2009 12:49:28 -0500")
Message-ID: <874oof6b9u.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

> On Fri, Nov 27, 2009 at 12:29 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>
>>> Maybe we decide to take the existing LIRC system as is and not
>>> integrate it into the input subsystem. But I think there is a window
>>> here to update the LIRC design to use the latest kernel features.
>>
>> If it ain't broke, don't fix it.  [...]
>>
>> We already agreed last year that we can include an interface in
>> lirc_dev that feeds the signal data to an in-kernel decoder if noone
>> from userspace reads it.  [...]
>>
>> I also understand that people want to avoid dependency on external
>> userspace tools. All I can tell you is that the lirc tools already do
>> support everything you need for IR control. And as it includes a lot of
>> drivers that are implemented in userspace already, LIRC will just continue
>> to do it's work even when there is an alternative in-kernel.
>
> Christoph, take what you know from all of the years of working on LIRC
> and design the perfect in-kernel system.

Hi,

I'm reading this thread with great interest.  Thank you (plural) for the
very informative conversation, I think I learnt a lot.  But now I
somehow lost the point, please correct me if the following is wrong.

It looks like having lirc_dev (or a similar raw interface) is a must.
It could be disguised as an input device, or changed in various ways,
but is it worth the effort?  As I understand Christoph, he does not want
to do so, because he finds it wasted work, and also there's already a
*single* user space daemon using it and doing everything users could
want.  Except for plug&play.

On the other hand, a one-liner could make in-kernel decoding possible,
so those who haven't got lircd running could have plug&play easily, if
somebody writes the necessary in-kernel decoders to feed the input
subsystem (which lircd also does, through uinput).

But even if you can't find anybody at the moment to write those, this is
still good stuff (I don't know about the code), which is hurt by being
developed out of kernel.  Is there any reason to keep this so?
Admittedly, I don't know why /dev/mouse is evil, maybe I'd understand if
somebody pointed me to some reading.
-- 
Thanks,
Feri.
