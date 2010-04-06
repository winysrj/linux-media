Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3179 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab0DFNym (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 09:54:42 -0400
Message-ID: <45a097098cc45db25ddbd05334b8be3e.squirrel@webmail.xs4all.nl>
In-Reply-To: <4BBB3022.6080406@redhat.com>
References: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net>
    <201004060046.12997.laurent.pinchart@ideasonboard.com>
    <201004060058.54050.hverkuil@xs4all.nl>
    <201004060830.54375.hverkuil@xs4all.nl> <4BBB3022.6080406@redhat.com>
Date: Tue, 6 Apr 2010 15:54:40 +0200
Subject: Re: [RFC] Serialization flag example
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"David Ellingsworth" <david@identd.dyndns.org>,
	hermann-pitton@arcor.de, awalls@md.metrocast.net,
	dheitmueller@kernellabs.com, abraham.manu@gmail.com,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>> On Tuesday 06 April 2010 00:58:54 Hans Verkuil wrote:
>>> On Tuesday 06 April 2010 00:46:11 Laurent Pinchart wrote:
>>>> On Sunday 04 April 2010 05:14:17 David Ellingsworth wrote:
>>>>> After looking at the proposed solution, I personally find the
>>>>> suggestion for a serialization flag to be quite ridiculous. As others
>>>>> have mentioned, the mere presence of the flag means that driver
>>>>> writers will gloss over any concurrency issues that might exist in
>>>>> their driver on the mere assumption that specifying the serialization
>>>>> flag will handle it all for them.
>>>> I happen to agree with this. Proper locking is difficult, but that's
>>>> not a
>>>> reason to introduce such a workaround. I'd much rather see proper
>>>> documentation for driver developers on how to implement locking
>>>> properly.
>>> I've taken a different approach in another tree:
>>>
>>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-ser2/
>>>
>>> It adds two callbacks to ioctl_ops: pre_hook and post_hook. You can use
>>> these
>>> to do things like prio checking and taking your own mutex to serialize
>>> the
>>> ioctl call.
>>>
>>> This might be a good compromise between convenience and not hiding
>>> anything.
>>
>> I realized that something like this is needed anyway if we go ahead with
>> the
>> new control framework. That exposes controls in sysfs, but if you set a
>> control
>> from sysfs, then that bypasses the ioctl completely. So you need a way
>> to hook
>> into whatever serialization scheme you have (if any).
>>
>> It is trivial to get to the video_device struct in the control handler
>> and
>> from there you can access ioctl_ops. So calling the pre/post hooks for
>> the
>> sysfs actions is very simple.
>>
>> The prototype for the hooks needs to change, though, since accesses from
>> sysfs do not provide you with a struct file pointer.
>>
>> Something like this should work:
>>
>> int pre_hook(struct video_device *vdev, enum v4l2_priority prio, int
>> cmd);
>> void post_hook(struct video_device *vdev, int cmd);
>>
>> The prio is there to make priority checking possible. It will be
>> initially
>> unused, but as soon as the events API with the new v4l2_fh struct is
>> merged
>> we can add centralized support for this.
>
> I like this strategy.
>
> My only concern is about performance. Especially in the cases where we
> need to
> handle the command at the hooks, those methods will introduce two extra
> jumps
> to the driver and two extra switches. As the jump will go to a code
> outside
> V4L core, I suspect that they'll likely flush the L1 cache.
>
> If we consider that:
>
> 	- performance is important only for the ioctl's that directly handles
> the streaming (dbuf/dqbuf & friends);

What performance? These calls just block waiting for a frame. How the hell
am I suppose to test performance anyway on something like that?

>
> 	- videobuf has its own lock implementation;
>
> 	- a trivial mutex-based approach won't protect the stream to have
> some parameters modified by a VIDIOC_S_* ioctl (such protection should be
> provided by a resource locking);

Generally once streaming starts drivers should return -EBUSY for such
calls. Nothing to do with locking in general.

> then, maybe the better would be to not call the hooks for those ioctls.
> It may be useful to do some perf tests and measure the real penalty before
> adding
> any extra code to exclude the buffer ioctls from the hook logic.

Yuck. We want something easy to understand. Like: 'the hook is called for
every ioctl'. Not: 'the hook is called for every ioctl except this one and
this one and this one'. Then the driver might have to do different things
for different ioctls just because some behind-the-scene logic dictated
that the hook isn't called in some situations.

I have said it before and I'll say it again: the problem with V4L2 drivers
has never been performance since all the heavy lifting is done with DMA,
the problem is complexity. Remember: premature optimization is the root of
all evil. If a driver really needs the last drop of performance (for what,
I wonder?) then it can choose to just not implement those hooks and do
everything itself.

Regards,

         Hans

>
> --
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

