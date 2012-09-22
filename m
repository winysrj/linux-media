Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46438 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750948Ab2IVMiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 08:38:11 -0400
Message-ID: <505DB12F.1090600@iki.fi>
Date: Sat, 22 Sep 2012 15:38:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, remi@remlab.net, daniel-gl@gmx.net,
	sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209211133.24174.hverkuil@xs4all.nl>
In-Reply-To: <201209211133.24174.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments.

Hans Verkuil wrote:
> On Thu September 20 2012 22:21:22 Sakari Ailus wrote:
>> Hi all,
>>
>>
>> This RFC intends to summarise and further the recent discussion on
>> linux-media regarding the proposed changes of timestamping V4L2 buffers.
>>
>>
>> The problem
>> ===========
>>
>> The V4L2 has long used realtime timestamps (such as
>> clock_gettime(CLOCK_REALTIME, ...)) to stamp the video buffers before
>> handing them over to the user. This has been found problematic in
>> associating the video buffers with data from other sources: realtime clock
>> may jump around due to daylight saving time, for example, and ALSA
>> (audio-video synchronisation is a common use case) user space API does not
>> provide the user with realtime timestamps, but instead uses monotonic time
>> (i.e. clock_gettime(CLOCK_MONOTONIC, ...)).
>>
>> This is especially an issue in embedded systems where video recording is a
>> common use case. Drivers typically used in such systems have silently
>> switched to use monotonic timestamps. While against the spec, this is
>> necessary for those systems to operate properly.
>>
>> In general, realtime timestamps are seen of little use in other than
>> debugging purposes, but monotonic timestamps are fine for that as well. It's
>> still possible that an application I'm not aware of uses them in a peculiar
>> way that would be adversely affected by changing to monotonic timestamps.
>> Nevertheless, we're not supposed to break the API (or ABI). It'd be also
>> very important for the application to know what kind of timestamps are
>> provided by the device.
>>
>>
>> Requirements, wishes and constraints
>> ====================================
>>
>> Now that it seems to be about the time to fix these issues, it's worth
>> looking a little bit to the future to anticipate the coming changes to be
>> able to accommodate them better later on.
>>
>> - The new default should be monotonic. As the monotonic timestamps are seen
>> to be the most useful, they should be made the default.
>>
>> - timeval vs. timespec. The two structs can be used to store timestamp
>> information. They are not compatible with each other. It's a little bit
>> uncertain what's the case with all the architectures but it looks like the
>> timespec fits into the space of timeval in all cases. If timespec is
>> considered to be used somewhere the compatibility must be ensured. Timespec
>> is better than timeval since timespec has more precision and it's the same
>> struct that's used everywhere else in the V4L2 API: timespec does not need
>> conversion to timespec in the user space.
>>
>> struct timespec {
>>          __kernel_time_t tv_sec;                 /* seconds */
>>          long            tv_nsec;                /* nanoseconds */
>> };
>>
>> struct timeval {
>>          __kernel_time_t         tv_sec;         /* seconds */
>>          __kernel_suseconds_t    tv_usec;        /* microseconds */
>> };
>>
>> To be able to use timespec, the user would have to most likely explicitly
>> choose to do that.
>>
>> - Users should know what kind of timestamps the device produces. This
>> includes existing and future kernels. What should be considered are
>> uninformed porting drivers back and forth across kernel versions and
>> out-of-date kernel header files.
>>
>> - Device-dependent timestamps. Some devices such as the uvcvideo ones
>> produce device-dependent timestamps for synchronising video and audio, both
>> produced by the same physical hardware device. For uvcvideo these timestamps
>> are unsigned 32-bit integers.
>>
>> - There's also another clock, Linux-specific raw monotonic clock (as in
>> clock_gettime(CLOCK_RAW_MONOTONIC, ...)) that could be better in some use
>> cases than the regular monotonic clock. The difference is that the raw
>> monotonic clock is free from the NTP adjustments. It would be nice for the
>> user to be able to choose the clock used for timestamps. This is especially
>> important for device-dependent timestamps: not all applications can be
>> expected to be able to use them.
>>
>> - The field adjacent to timestamp, timecode, is 128 bits wide, and not used
>> by a single driver. This field could be re-used.
>>
>>
>> Possible solutions
>> ==================
>>
>> Not all of the solutions below that have been proposed are mutually
>> exclusive. That's also what's making the choice difficult: the ultimate
>> solution to the issue of timestamping may involve several of these --- or
>> possibly something better that's not on the list.
>>
>>
>> Use of timespec
>> ---------------
>>
>> If we can conclude timespec will always fit into the size of timeval (or
>> timecode) we could use timespec instead. The solution should still make
>> the use of timespec explicit to the user space. This seems to conflict with
>> the idea of making monotonic timestamps the default: the default can't be
>> anything incompatible with timeval, and at the same time it's the most
>> important that the monotonic timestamps are timespec.
>
> We have to keep timeval. Changing this will break the ABI. I see absolutely
> no reason to use timespec for video. At 60 Hz a frame takes 16.67 ms, and that's
> far, far removed from ns precisions. Should we ever have to support high-speed
> cameras running at 60000 Hz, then we'll talk again.
>
> For me this is a non-issue.
>
>> Kernel version as indicator of timestamp
>> ----------------------------------------
>>
>> Conversion of drivers to use monotonic timestamp is trivial, so the
>> conversion could be done once and for all drivers. The kernel version could
>> be used to indicate the type of the timestamp.
>>
>> If this approach is taken care must be taken when new drivers are
>> integrated: developers sometimes use old kernels for development and might
>> also use an old driver for guidance on timestamps, thus using real-time
>> timestamps when monotonic timestamps should be used.
>
> More importantly, this also fails when users use out-of-tree drivers.

Could you mention some examples what we could be breaking in particular?

>> This approach has an
>> advantage over the capability flag below: which is that we don't populate
>> the interface with essentially dead definitions.
>
> Using a kernel version to decide whether some feature is available or not is
> IMHO something of a last resort. It's very application unfriendly.

Could be, but that's a passing pain. We're going to live with the flags 
for the foreseeable future, whether we need them or not.

>>
>> Capability flag for monotonic timestamps
>> ----------------------------------------
>>
>> A capability flag can be used to tell whether the timestamp is monotonic.
>> However, it's not extensible cleanly to provide selectable timestamps. These
>> are not features that are needed right now, though.
>>
>> The upside of this option is ease of implementation and use, but it's not
>> extensible. Also we're left with a flag that's set for all drivers: in the
>> end it provides no information to the user and is only noise in the spec.
>>
>>
>> Control for timestamp type
>> --------------------------
>>
>> Using a control to tell the type of the timestamp is extensible but not as
>> easy to implement than the capability flag: each and every device would get
>> an additional control. The value should likely be also file handle specific,
>> and we do not have file handle specific controls yet.
>
> Yes, we do. You can make per-file handle controls. M2M devices need that.

Thanks for correcting me.

> I'm not sure why this would be filehandle specific, BTW.

Good point. I thought that as other properties of the buffers are 
specific to file handles, including format when using CREATE_BUFS, it'd 
make sense to make the timestamp source file-handle specific as well.

What do you think?

>> In the meantime the control could be read-only, and later made read-write
>> when the timestamp type can be made selectable. Much of he work of
>> timestamping can be done by the framework: drivers can use a single helper
>> function and need to create one extra standard control.
>>
>> Should the control also have an effect on the types of the timestamps in
>> V4L2 events? Likely yes.
>
> You are missing one other option:
>
> Using v4l2_buffer flags to report the clock
> -------------------------------------------
>
> By defining flags like this:
>
> V4L2_BUF_FLAG_CLOCK_MASK	0x7000
> /* Possible Clocks */
> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000  /* system or monotonic, we don't know */
> V4L2_BUF_FLAG_CLOCK_MONOTONIC   0x1000
>
> you could tell the application which clock is used.
>
> This does allow for more clocks to be added in the future and clock selection
> would then be done by a control or possibly an ioctl. For now there are no
> plans to do such things, so this flag should be sufficient. And it can be
> implemented very efficiently. It works with existing drivers as well, since
> they will report CLOCK_UNKNOWN.
>
> I am very much in favor of this approach.

Thanks for adding this. I knew I was forgetting something but didn't 
remember what --- I swear it was unintentional! :-)

If we'd add more clocks without providing an ability to choose the clock 
from the user space, how would the clock be selected? It certainly isn't 
the driver's job, nor I think it should be system-specific either 
(platform data on embedded systems).

It's up to the application and its needs. That would suggest we should 
always provide monotonic timestamps to applications (besides a potential 
driver-specific timestamp), and for that purpose the capability flag --- 
I admit I disliked the idea at first --- is enough.

What comes to buffer flags, the application would also have to receive 
the first buffer from the device to even know what kind of timestamps 
the device uses, or at least call QUERYBUF. And in principle the flag 
should be checked on every buffer, unless we also specify the flag is 
the same for all buffers. And at certain point this will stop to make 
any sense...

A capability flag is cleaner solution from this perspective, and it can 
be amended by a control (or an ioctl) later on: the flag can be 
disregarded by applications whenever the control is present. If the 
application doesn't know about the control it can still rely on the 
flag. (I think this would be less clean than to go for the control right 
from the beginning, but better IMO.)

>>
>>
>> Device-dependent timestamp
>> --------------------------
>>
>> Should we agree on selectable timestamps, the existing timestamp field (or a
>> union with another field of different type) could be used for the
>> device-dependent timestamps.
>
> No. Device timestamps should get their own field. You want to be able to relate
> device timestamps with the monotonic timestamps, so you need both.
>
>> Alternatively we can choose to re-use the
>> existing timecode field.
>>
>> At the moment there's no known use case for passing device-dependent
>> timestamps at the same time with monotonic timestamps.
>
> Well, the use case is there, but there is no driver support. The device
> timestamps should be 64 bits to accomodate things like PTS and DTS from
> MPEG streams. Since timecode is 128 bits we might want to use two u64 fields
> or perhaps 4 u32 fields.

That should be an union for different kinds (or rather types) of 
device-dependent timestamps. On uvcvideo I think this is u32, not u64. 
We should be also able to tell what kind device dependent timestamp 
there is --- should buffer flags be used for that as well?

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
