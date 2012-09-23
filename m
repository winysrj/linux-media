Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46610 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753607Ab2IWNF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 09:05:58 -0400
Message-ID: <505F098C.9060405@iki.fi>
Date: Sun, 23 Sep 2012 16:07:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, remi@remlab.net, daniel-gl@gmx.net,
	sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209211133.24174.hverkuil@xs4all.nl> <505DB12F.1090600@iki.fi> <201209231118.45904.hverkuil@xs4all.nl>
In-Reply-To: <201209231118.45904.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On Sat September 22 2012 14:38:07 Sakari Ailus wrote:
>> Hi Hans,
>>
>> Thanks for the comments.
>>
>> Hans Verkuil wrote:
>>> On Thu September 20 2012 22:21:22 Sakari Ailus wrote:
...
>>>>
>>>> Capability flag for monotonic timestamps
>>>> ----------------------------------------
>>>>
>>>> A capability flag can be used to tell whether the timestamp is monotonic.
>>>> However, it's not extensible cleanly to provide selectable timestamps. These
>>>> are not features that are needed right now, though.
>>>>
>>>> The upside of this option is ease of implementation and use, but it's not
>>>> extensible. Also we're left with a flag that's set for all drivers: in the
>>>> end it provides no information to the user and is only noise in the spec.
>>>>
>>>>
>>>> Control for timestamp type
>>>> --------------------------
>>>>
>>>> Using a control to tell the type of the timestamp is extensible but not as
>>>> easy to implement than the capability flag: each and every device would get
>>>> an additional control. The value should likely be also file handle specific,
>>>> and we do not have file handle specific controls yet.
>>>
>>> Yes, we do. You can make per-file handle controls. M2M devices need that.
>>
>> Thanks for correcting me.
>>
>>> I'm not sure why this would be filehandle specific, BTW.
>>
>> Good point. I thought that as other properties of the buffers are
>> specific to file handles, including format when using CREATE_BUFS, it'd
>> make sense to make the timestamp source file-handle specific as well.
>>
>> What do you think?
>
> I don't think it makes sense to have different streams from the same device
> use different clocks.
>
>>>> In the meantime the control could be read-only, and later made read-write
>>>> when the timestamp type can be made selectable. Much of he work of
>>>> timestamping can be done by the framework: drivers can use a single helper
>>>> function and need to create one extra standard control.
>>>>
>>>> Should the control also have an effect on the types of the timestamps in
>>>> V4L2 events? Likely yes.
>>>
>>> You are missing one other option:
>>>
>>> Using v4l2_buffer flags to report the clock
>>> -------------------------------------------
>>>
>>> By defining flags like this:
>>>
>>> V4L2_BUF_FLAG_CLOCK_MASK	0x7000
>>> /* Possible Clocks */
>>> V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000  /* system or monotonic, we don't know */
>>> V4L2_BUF_FLAG_CLOCK_MONOTONIC   0x1000
>>>
>>> you could tell the application which clock is used.
>>>
>>> This does allow for more clocks to be added in the future and clock selection
>>> would then be done by a control or possibly an ioctl. For now there are no
>>> plans to do such things, so this flag should be sufficient. And it can be
>>> implemented very efficiently. It works with existing drivers as well, since
>>> they will report CLOCK_UNKNOWN.
>>>
>>> I am very much in favor of this approach.
>>
>> Thanks for adding this. I knew I was forgetting something but didn't
>> remember what --- I swear it was unintentional! :-)
>>
>> If we'd add more clocks without providing an ability to choose the clock
>> from the user space, how would the clock be selected? It certainly isn't
>> the driver's job, nor I think it should be system-specific either
>> (platform data on embedded systems).
>
> IF a driver supports more than one clock (which I really don't see happening
> anytime soon), then we either need a control to select the clock or an ioctl.

The timestamps can be taken from any standard clock using a helper 
function. Right now drivers call do_gettimeofday() or ktime_get_ts(), 
it's the same whether the function was called e.g. v4l2_get_ts(). The 
driver doesn't even need to know which timer is being used to make that 
timestamp. It used to be the realtime clock and soon it's the monotonic 
clock. So I really don't see why the timestamp source should depend on 
the driver. It rather depends on what the user wants.

That said, I also don't see use for other clocks _right now_ than the 
monotonic one.

> And something as well to enumerate the available clocks. I'm leaning towards
> ioctls, but I think this should be decided if we ever get an actual use-case
> for this.

I think it should be a control --- I see no reason to add new IOCTLs 
when controls are equally, or even better, fit for the same job. But 
let's decide this only when the functionality is needed.

>> It's up to the application and its needs. That would suggest we should
>> always provide monotonic timestamps to applications (besides a potential
>> driver-specific timestamp), and for that purpose the capability flag ---
>> I admit I disliked the idea at first --- is enough.
>>
>> What comes to buffer flags, the application would also have to receive
>> the first buffer from the device to even know what kind of timestamps
>> the device uses, or at least call QUERYBUF. And in principle the flag
>> should be checked on every buffer, unless we also specify the flag is
>> the same for all buffers. And at certain point this will stop to make
>> any sense...
>
> It should definitely be the same for all buffers. And since apps will
> typically call querybuf anyway I don't see this as a problem. These
> clocks are also specific to the streaming I/O API, so reporting this as
> part of that API makes sense to me as well.
 >
>> A capability flag is cleaner solution from this perspective, and it can
>> be amended by a control (or an ioctl) later on: the flag can be
>> disregarded by applications whenever the control is present.
>
> Yuck.

What's so bad in it then? The user doesn't need to start dealing with 
buffers whenever (s)he needs to know what kind of timestamps the device 
provides.

Timestamps are also used on the event interface (and also on subdevs), 
which currently uses monotonic timestamps (at least it was intended to 
do so, it's missing from the documentation). The timestamps on V4L2 and 
V4L2 subdev must match to be useful for the application, so we should 
not allow using other clock than monotonic before we truly make the 
timestamp source selectable by the application.

A flash subdev, for example, could produce events while the driver 
producing timestamps for the video buffers doesn't know the type of the 
timestamp used by the flash driver. One still must be able to compare 
the two in the user space to make use of them.

I'm ok-ish with using video buffer flags to tell the type of the 
timestamp, but those flags might not be useful (like the capability 
flag) if the timestamp source is made selectable. What I still don't 
like is that you have to start dealing with buffers before you know what 
kind of timestamps you're getting.

I'd like to have Laurent's and Remi's opinion before proceeding to the 
implementation.

...

>>>> Device-dependent timestamp
>>>> --------------------------
>>>>
>>>> Should we agree on selectable timestamps, the existing timestamp field (or a
>>>> union with another field of different type) could be used for the
>>>> device-dependent timestamps.
>>>
>>> No. Device timestamps should get their own field. You want to be able to relate
>>> device timestamps with the monotonic timestamps, so you need both.
>>>
>>>> Alternatively we can choose to re-use the
>>>> existing timecode field.
>>>>
>>>> At the moment there's no known use case for passing device-dependent
>>>> timestamps at the same time with monotonic timestamps.
>>>
>>> Well, the use case is there, but there is no driver support. The device
>>> timestamps should be 64 bits to accomodate things like PTS and DTS from
>>> MPEG streams. Since timecode is 128 bits we might want to use two u64 fields
>>> or perhaps 4 u32 fields.
>>
>> That should be an union for different kinds (or rather types) of
>> device-dependent timestamps. On uvcvideo I think this is u32, not u64.
>> We should be also able to tell what kind device dependent timestamp
>> there is --- should buffer flags be used for that as well?
>
> That's definitely part of the buffer flags. The presence of timecode is already
> signalled using that. And not every buffer may have device timestamps (that
> depends on the hardware), so you have to signal it through the buffer flags.
>
> An anonymous union might be best with the buffer flags signalling the type of
> the union. What I don't know is how to specify the type. Shall we just specify
> the type of the union (e.g. 4 u32 fields or 2 u64 fields) and leave the
> interpretation of those fields up to the application based on the driver name?
> Or shall the type act more like a fourcc in that it also uniquely identifies
> the interpretation of the timestamps?

I think it should uniquely identify it, at least if the MPEG timestamps 
produced by some devices are relevant for video buffers. In this case it 
wouldn't make much sense for the applications having to know what are 
the drivers producing such timestamps. And this might not be the only 
case like that.

> Or should all device timestamps be converted to a timespec by the driver?

Good question.

> Answers on a postcard.

Who are you going to send it? ;-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
