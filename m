Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0IJE1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 00:27:12 -0400
Message-ID: <4C89B3AD.1010404@redhat.com>
Date: Fri, 10 Sep 2010 01:27:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com> <4C891F0D.2060103@redhat.com> <4C89A3EE.8040503@samsung.com>
In-Reply-To: <4C89A3EE.8040503@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 10-09-2010 00:20, Pawel Osciak escreveu:
> Hello Mauro,
> 
> On 09/10/2010 02:53 AM, Mauro Carvalho Chehab wrote:
>> Em 09-09-2010 06:19, Pawel Osciak escreveu:
>> > Hello,
>> >
>> > These patches add a new driver framework for Video for Linux 2 driver
>> > - Videobuf2.
>>
>> I didn't test the patches, but, from a source code review, they seem
>> on a good shape. I did a few comments on some patches. There are a few
>> missing features for them to be used with real drivers:
>>
> 
> Thank you for review. I will address your in-code comments in a bit, now
> for general comments.
> 
>> 1) it lacks implementation of read() method. This means that vivi driver
>> has a regression, as it currently supports it.
> 
> Yes, read() is not yet implemented. I guess it is not a feature that would
> be deprecated, right? 

Yes, there are no plans to deprecate it. Also, some devices like cx88 and bttv
allows receiving simultaneous streams, one via mmap, and another via read().
This is used by some applications to allow recording video via ffmpeg/mencoder
using read(), while the main application is displaying video using mmap.

> There are some problems with read that are problematic:
> - not every device / memory type will be able to use it, as we need a way
> to allocate kernel memory for an operation and not every memory type may
> support it
> - there is no way to use it with multi-planar API, as it is not possible
> to read from multiple memory buffers (having multiple pointers) with read...
> 
> But I guess it it could be added to work as before with single-planar buffers
> only, for compatibility.

Yeah, a multi-planar read() doesn't seem to make sense.

> Also I am thinking about where read() should be implemented. It is something
> that will have to be emulated on top of normal streaming, as it is now done
> in videobuf1. So maybe a more generic read implementation would be a good
> idea? A separate layer that would be implementing read on top of streaming?
> It would not have to be limited to videobuf only then, drivers that support
> streaming but not using videobuf would be able to use it too.

I don't think we should try to cover drivers that don't use videobuf.

>> 2) it lacks OVERLAY mode. We can probably mark this feature as deprecated,
>> avoiding the need of implementing it on videobuf2, but we need a patch
>> for Documentation/feature-removal-schedule.txt,  in order to allow the
>> migration of the existing drivers like bttv and saa7134, where this feature
>> is implemented, of course if people agree that this is the better way;
> 
> If you think this feature can be deprecated, it might be a good idea. If not,
> I guess I will be able to take a stab at it when working with saa7134 and
> bttv, right? Should not require too much work to add. I just did not have
> a device to test it on, so I did not add it.
> 
> It would be great if you could make the decision about what to do with this.
> I will try to follow your opinion and suggestions.

>From Helsinki's comments, it seems that most people believe that we can deprecate it,
as a feature similar to OVERLAY can be done by using USERPTR. Also, there's currently
a problem with userspace applications and OVERLAY, and none is working to fix it.

So, if nobody objects (and fixes the userspace applications), then I think that the
better is to deprecate it.

>> 3) it lacks the implementation of videobuf-dvb;
> 
> Yes... I have no experience with DVB, but I guess I can just get a DVB card
> and start hacking. Could you recommend a card? Technisat SkyStar 2?

You should get one that uses videobuf-dvb. I would seek for one using bttv, saa7134, cx88
or em28xx. It is hard to me to point you to an specific device, especially since I am
at ISDB-T area. There are lots of supported devices, so the better is to just take a look
at *-cards.c and seek for one DVB device that you could find near you. I'm sure you'll
find lots of saa7134 cards and em28xx-based sticks with DVB support.

>> 4) it lacks an implementation for DMA S/G.
> 
> Yes, I am planning to work on this next, I will be testing on saa7134 and maybe
> something else as well, probably a bttv. Please let me know if you have any
> suggestions or recommendations on which drivers I should be focusing.
> 
> I am also hoping for Laurent's comments on this, since he was working on SG
> much more than I did.

bttv and saa7134 are the more complete/complex implementations. If you can make
them work, porting videobuf2 to the other drivers will be trivial.

>> We need to address all the above issues, in order to use it, otherwise the
>> migration of existing drivers would cause regressions, as features will be
>> missing.
> 
> Right, of course. Videobuf2 is a long time effort and I hope it will be evolving
> gradually. What I would like to assure you about is that I will not abandon it
> and will not limit myself to working only on embedded or Samsung device support.
> 
> Videobuf2 is not only my in-Samsung project and I intend to be working on it
> "outside my work responsibilities" as well, supporting desktop and other
> platforms, as my time permits.

Ok, good to know.

> I would like to address whatever you and others think is necessary and make
> videobuf2 useful for as many devices as possible. This is also why I am posting
> it earlier rather than later. I hope for people to point out features they would
> require and give their opinions early. I think that working together on this we
> will be able to gradually come up with a solution that would be useful and
> satisfying for most people.
> 

After having all features implemented, I can test and help to port it to other hardware
that uses videobuf1. While the strategy of "forking" videobuf is the proper way, we
need to make sure that we'll have a clean way to deprecate the legacy videobuf, as
maintaining both makes support harder, as time goes by.

> I would like to ask about your idea for the strategy of its development and
> inclusion. We will be posting a few drivers based on videobuf2 soon. Do you think
> it could be merged gradually, as features are added?
> 
> It would be great if we could work on it and merge it gradually. Some people could
> already start using it in new drivers, others could start adding features to it,
> the API would be stabilizing and we would be having a solid base to work on. This is
> a long-term effort for many months or maybe years. It goes without saying that it
> will be harder to add everything in one go.
> 
> Others might not be eager to adopt it if it is not an official effort either.
> And I cannot deny it, it would also make my job easier. As I said, I do not intend
> to leave it as it is now nor work on embedded support only.

In order for me to accept vivi patches, you need to implement read(), to avoid a
regression. IMHO, merging vivi earlier helps other developers to better understand
what's needed.

The next needed feature, IMHO, is the videobuf-dvb. With both read() and videobuf-dvb,
we can port an existing real case driver like em28xx and tm6000. This will allow checking
its usage, and advantages/disadvantages when compared to videobuf1. For example, it is
expected a performance increase with videobuf2, as the code is now simpler, but only
doing a perf against the same driver using vb1 and vb2 will actually show if performance
is equivalent or better, or if is there any drawback at vb2 implementation.

Implementing videobuf DMA S/G won't help if you don't have read() and dvb supported, as
no real driver could be migrated to vb2 without causing regressions.

So, for me, you should address those technical questions, on this order:
	- read()
	- dvb
	- dma s/g

With respect to OVERLAY, just send me a RFC patch deprecating it. Let's wait for one or two
weeks for people to complain. If nobody complains, let's remove it for 2.6.37 or 2.6.38.

> Also, we do not have to migrate all old drivers in one go, but that also goes without
> saying. As we discussed, videobuf1 will not go away anytime soon.

Agreed.

> I think we should consider new drivers as well here. It is troublesome when they
> provide their custom code instead of using a framework, as is the case with some
> drivers that have been posted in the previous months and some ongoing ones, but this
> is also obvious.

New drivers are easier, as they can be conceived using vb2.

> Please let me know your opinion. It would be good if we could come up with a list
> of features that have to be added before merging and others that could be added
> gradually and a general plan for development of videbuf2.

Cheers,
Mauro
