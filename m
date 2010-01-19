Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0ASLIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 06:08:54 -0500
Message-ID: <4B5592BF.8040201@infradead.org>
Date: Tue, 19 Jan 2010 09:08:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl>
In-Reply-To: <201001190853.11050.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
>> Hi,

>> Due to that, I'm delegating the task of keeping -hg in sync with upstream and backporting
>> patches to run on older kernels to another person: Douglas has offered his help to keep 
>> the tree synchronized with the -git tree, and to add backport support. 
>>
>> He already started doing that, fixing some incompatibility troubles between some drivers
>> and older kernels.
> 
> Mauro, I just wanted to thank you for doing all the hard work in moving to git!

Anytime!

> I do have one proposal: parts of our hg tree are independent of git: v4l2-apps,
> possibly some firmware build code (not 100% sure of that), v4l_experimental,
> perhaps some documentation stuff. My proposal is that we make a separate hg
> or git tree for those. It will make it easier to package by distros and it makes it
> easier to maintain v4l2-apps et al as well. It might even simplify Douglas's work
> by moving non-essential code out of the compat hg tree.

It may make sense, but I have some comments about it:
	1) v4l_experimental - I think we may just drop it. It was meant to be a staging
area in the old days, but never worked. The 3 drivers there never suffered any maintanership.
Even the firewire driver that used to be there were developed independently. So, IMO, we can
just remove it and, if anyone needs those drivers, they can just look inside the -hg history.

	2) firmware - the code there is just what we have in kernel. While this can be broken,
I can't see much sense, as I don't foresee any changes there: new firmwares are going to
linux-firmware tree and have an upstream maintainership in separate;

	3) media docs - the docs are part of upstream tree. So, it doesn't make sense to have
a separate tree for it. IMO, the proper direction is to merge upstream the capability of 
automatic generation of some xml scripts (like videobuf2.h.xml). Yet, there are a few files
present on v4l2-apps that are also converted to xml, as they are usage examples at the API.
I'm not sure what to do with them.

	4) v4l2-apps - I agree that splitting it could be a good idea, provided that we find
a way to handle the few cases where we have "example" applications at the media docs.
> 
> I'll be updating my daily build scripts to start using git soon (I'll keep using
> hg for the older kernels of course).

That's good! I always check if the -git compiles with x86_64, but I generally don't check
all architectures on my checks.

Cheers,
Mauro.
