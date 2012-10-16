Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:17501 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2JPBZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 21:25:39 -0400
Message-ID: <507CB78C.10902@cybermato.com>
Date: Mon, 15 Oct 2012 18:25:32 -0700
From: Chris MacGregor <chris@cybermato.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl, remi@remlab.net,
	daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20121015160549.GE21261@valkosipuli.retiisi.org.uk> <2316067.OFTCziv4Z5@avalon> <507C5BC4.7060700@cybermato.com> <20121015195906.GG21261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121015195906.GG21261@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari.

On 10/15/2012 12:59 PM, Sakari Ailus wrote:
> Hi Chris,
>
> On Mon, Oct 15, 2012 at 11:53:56AM -0700, Chris MacGregor wrote:
>> On 10/15/2012 11:45 AM, Laurent Pinchart wrote:
>>> Hi Sakari,
>>>
>>> On Monday 15 October 2012 19:05:49 Sakari Ailus wrote:
>>>> Hi all,
>>>>
>>>> As a summar from the discussion, I think we have reached the following
>>>> conclusion. Please say if you agree or disagree with what's below. :-)
>>>>
>>>> - The drivers will be moved to use monotonic timestamps for video buffers.
>>>> - The user space will learn about the type of the timestamp through buffer
>>>> flags.
>>>> - The timestamp source may be made selectable in the future, but buffer
>>>> flags won't be the means for this, primarily since they're not available on
>>>> subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.
>>> That's my understanding as well. For the concept,
>>>
>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> I wasn't able to participate in the discussion that led to this, but
>> I'd like to suggest and request now that an explicit requirement (of
>> whatever scheme is selected) be that a userspace app have a
>> reasonable and straightforward way to translate the timestamps to
>> real wall-clock time, ideally with enough precision to allow
>> synchronization of cameras across multiple computers.
>>
>> In the systems I work on, for instance, we are recording real-world
>> biological processes, some of which vary based on the time of day,
>> and it is important to know when a given frame was captured so that
>> information can be stored with the raw frame and the data derived
>> from it. For many such purposes, an accuracy measured in multiple
>> seconds (or even minutes) is fine.
>>
>> However, when we are using multiple cameras on multiple computers
>> (e.g., two or more BeagleBoard xM's, each with a camera connected),
>> we would want to synchronize with an accuracy of less than 1 frame
>> time - e.g. 10 ms or less.
> I think you have two use cases actually: knowing when an image has been
> taken, and synchronisation of images from multiple sources. The first one is
> easy: you just call clock_gettime() for the realtime clock. The precision
> will certainly be enough.

I assume you mean that I would, for instance:

clock_gettime(CLOCK_REALTIME, &realtime);
clock_gettime(CLOCK_MONOTONIC, &monotime);
(compute realtime-monotime and save the result)
...
(later add that result to the timestamp on a frame to recover the 
approximate real-world capture time)

Agreed, for this purpose - getting a reasonable real-world timestamp on 
the frame - the precision is fine...worst case, my process gets 
rescheduled between the two clock_gettime() calls, but even that won't 
matter for this purpose.

> For the latter the realtime clock fits poorly to begin with: it jumps around
> e.g. when the daylight saving time changes.
>
> I think what I'd do is this: figure out the difference between the monotonic
> clocks of your systems and use that as basis for synchronisation. I wonder
> if there are existing solutions for this based e.g. on the NTP.
>
> The pace of the monotonic clocks on different systems is the same as the
> real-time ones; the same NTP adjustments are done to the monotonic clock as
> well. As an added bonus you also won't be affected by daylight saving time
> or someone setting the clock manually.

Yes, I believe that this could work. My concern is that there is some 
unpredictability in the timing of the two clock_gettime() calls, and 
thus some inaccuracy in the conversion, and while I could likely get the 
two systems sufficiently sync'd using NTP or the like at the real-world 
level, the conversion from that (on each system) to the system's 
monotonic time would contain an unpredictable (though bounded) 
inaccuracy. I suppose that as long as I sync the cameras at the hardware 
level (e.g. by tying the strobe line of one to the trigger lines of the 
rest, or tying all the trigger lines to a GPIO), the inaccuracy would be 
less than a frame time, and so I could know reliably enough which frames 
go together.

However, it seems much cleaner to have a more direct way to convert the 
monotonic time to real-world time, or to get real-world time on the 
frames in the first place (for applications that want that). I don't 
know of a way to do the former.

> The conversion of the two clocks requires the knowledge of the values of
> kernel internal variables, so performing the conversion in user space later
> on is not an option.

Sorry, you lost me on this one, unless you're talking about what I refer 
to in my paragraph just above - converting the monotonic timestamp on 
the frame to real-world time...?

> Alternatively you could just call clock_gettime() after every DQBUF call,
> but that's indeed less precise than if the driver would get the timestamp
> for you.

And also less efficient. The platforms I'm working on are already 
hard-pressed to keep up with all the pixels I'm trying to capture and 
process, so I don't really want to waste time trapping into kernel mode 
again if I can avoid it.

> How would this work for you?

Better than nothing, and probably I could live with it. But I think 
perhaps we can do better than that, and now seems like the right time to 
figure it out.

> Best regards,

Cheers,
Chris MacGregor (the Seattle one)
