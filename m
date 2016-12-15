Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53313 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757439AbcLOQHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 11:07:20 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <20161215123207.3198d1d2@vento.lan>
 <8eaf38da-0dc1-493f-c41d-56b23509bb2d@xs4all.nl>
 <20161215134552.1b47f008@vento.lan>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d59e175f-bcf3-3980-39f9-0112567aebd3@xs4all.nl>
Date: Thu, 15 Dec 2016 17:07:16 +0100
MIME-Version: 1.0
In-Reply-To: <20161215134552.1b47f008@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/12/16 16:45, Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 15:45:22 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> On 15/12/16 15:32, Mauro Carvalho Chehab wrote:
>>> Em Thu, 15 Dec 2016 15:03:36 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 15/12/16 13:56, Laurent Pinchart wrote:
>>>>> Hi Sakari,
>>>>>
>>>>> On Thursday 15 Dec 2016 13:30:41 Sakari Ailus wrote:
>>>>>> On Tue, Dec 13, 2016 at 10:24:47AM -0200, Mauro Carvalho Chehab wrote:
>>>>>>> Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
>>>>>>>> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
>>>>>>>>> Hi Sakari,
>>>>>>>>>
>>>
>>>
>>>>> There's plenty of way to try and work around the problem in drivers, some more
>>>>> racy than others, but if we require changes to all platform drivers to fix
>>>>> this we need to ensure that we get it right, not as half-baked hacks spread
>>>>> around the whole subsystem.
>>>>
>>>> Why on earth do we want this for the omap3 driver? It is not a hot-pluggable
>>>> device and I see no reason whatsoever to start modifying platform drivers just
>>>> because you can do an unbind. I know there are real hot-pluggable devices, and
>>>> getting this right for those is of course important.
>>>
>>> That's indeed a very good point. If unbind is not needed by any usecase,
>>> the better fix for OMAP3 would be to just prevent it to happen in the first
>>> place.
>>>
>>>>>>> The USB subsystem has a a .disconnect() callback that notifies
>>>>>>> the drivers that a device was unbound (likely physically removed).
>>>>>>> The way USB media drivers handle it is by returning -ENODEV to any
>>>>>>> V4L2 call that would try to touch at the hardware after unbound.
>>>>>
>>>>
>>>> In my view the main problem is that the media core is bound to a struct
>>>> device set by the driver that creates the MC. But since the MC gives an
>>>> overview of lots of other (sub)devices the refcount of the media device
>>>> should be increased for any (sub)device that adds itself to the MC and
>>>> decreased for any (sub)device that is removed. Only when the very last
>>>> user goes away can the MC memory be released.
>>>>
>>>> The memory/refcounting associated with device nodes is unrelated to this:
>>>> once a devnode is unregistered it will be removed in /dev, and once the
>>>> last open fh closes any memory associated with the devnode can be released.
>>>> That will also decrease the refcount to its parent device.
>>>>
>>>> This also means that it is a bad idea to embed devnodes in a larger struct.
>>>> They should be allocated and freed when the devnode is unregistered and
>>>> the last open filehandle is closed.
>>>>
>>>> Then the parent's device refcount is decreased, and that may now call its
>>>> release callback if the refcount reaches 0.
>>>>
>>>> For the media controller's device: any other device driver that needs access
>>>> to it needs to increase that device's refcount, and only when those devices
>>>> are released will they decrease the MC device's refcount.
>>>>
>>>> And when that refcount goes to 0 can we finally free everything.
>>>>
>>>> With regards to the opposition to reverting those initial patches, I'm
>>>> siding with Greg KH. Just revert the bloody patches. It worked most of the
>>>> time before those patches, so reverting really won't cause bisect problems.
>>>
>>> You're contradicting yourself here ;)
>>>
>>> The patches that this patch series is reverting are the ones that
>>> de-embeeds devnode struct and fixes its lifecycle.
>>>
>>> Reverting those patches will cause regressions on hot-pluggable drivers,
>>> preventing them to be unplugged. So, if we're willing to revert, then we
>>> should also revert MC support on them.
>>
>> Two options:
>>
>> 1) Revert, then build up a proper solution.
>
> Reverting is a regression, as we'll strip off the MC support from the
> existing devices. We would also need to revert a lot more than just those
> 3 patches.
>
>> 2) Do a big-bang patch switching directly over to the new solution, but that's
>> very hard to review.
>> 2a) Post the patch series in small chunks on the mailinglist (starting with the
>> reverts), but once we're all happy merge that patch series into a single big-bang
>> patch and apply that.
>
> We could do that, but so far, what has been submitted are incomplete,
> as they only touch on a single driver (with doesn't require hot-plugging),
> breaking all the other ones.

Step 1 is to find a solution that works and isn't a hack or workaround.

The next step is to roll it out for all drivers (ideally with an absolute minimum of
required changes), and the final step is to figure out how to organize the patch
series to ensure bisect, etc.

But the first step is the most important, and one that should be reviewed
even if the way the patch series is organized might/will cause problems when
it is merged.

This whole discussion about those revert patches is simply not relevant at the
moment.

Regards,

	Hans

>
>> As far as I am concerned the whole hotplugging code is broken and has been for
>> a very long time. We (or at least I :-) ) understand the underlying concepts
>> a lot better, so we can do a better job. But the transition may well be
>> painful.
>
> It is not broken currently on the devices that require hotplugging.
>
> Thanks,
> Mauro
>

