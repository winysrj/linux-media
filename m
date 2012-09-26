Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48187 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758186Ab2IZTR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 15:17:26 -0400
Message-ID: <506354C2.1030805@iki.fi>
Date: Wed, 26 Sep 2012 22:17:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209251254.34483.hverkuil@xs4all.nl> <50621010.3070703@iki.fi> <84293169.Vi1CrtjK0W@avalon>
In-Reply-To: <84293169.Vi1CrtjK0W@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Laurent Pinchart wrote:
> On Tuesday 25 September 2012 23:12:00 Sakari Ailus wrote:
>> Hans Verkuil wrote:
>>> On Tue 25 September 2012 12:48:01 Laurent Pinchart wrote:
>>>> On Tuesday 25 September 2012 08:47:45 Hans Verkuil wrote:
>>>>> On Tue September 25 2012 02:00:55 Laurent Pinchart wrote:
>>>>> BTW, I think we should also fix the description of the timestamp in the
>>>>> spec. Currently it says:
>>>>>
>>>>> "For input streams this is the system time (as returned by the
>>>>> gettimeofday() function) when the first data byte was captured. For
>>>>> output streams the data will not be displayed before this time,
>>>>> secondary to the nominal frame rate determined by the current video
>>>>> standard in enqueued order. Applications can for example zero this field
>>>>> to display frames as soon as possible. The driver stores the time at
>>>>> which the first data byte was actually sent out in the timestamp field.
>>>>> This permits applications to monitor the drift between the video and
>>>>> system clock."
>>>>>
>>>>> To my knowledge all capture drivers set the timestamp to the time the
>>>>> *last* data byte was captured, not the first.
>>>>
>>>> The uvcvideo driver uses the time the first image packet is received :-)
>>>> Most other drivers use the time the last byte was *received*, not
>>>> captured.
>>>
>>> Unless the hardware buffers more than a few lines there is very little
>>> difference between the time the last byte was received and when it was
>>> captured.
>>>
>>> But you are correct, it is typically the time the last byte was received.
>>>
>>> Should we signal this as well? First vs last byte? Or shall we
>>> standardize?
>>
>> My personal opinion would be to change the spec to say what almost every
>> driver does: it's the timestamp from the moment the last pixel has been
>> received. We have the frame sync event for telling when the frame starts
>> btw. The same event could be used for signalling whenever a given line
>> starts. I don't see frame end fitting to that quite as nicely but I
>> guess it could be possible.
>
> The uvcvideo driver can timestamp the buffers with the system time at which
> the first packet in the frame is received, but has no way to generate a frame
> start event: the frame start event should correspond to the time the frame
> starts, not to the time the first packet in the frame is received. That
> information isn't available to the driver.

Aren't the two about equal, apart from the possible delays caused by the 
USB bus? The spec says about the frame sync event that it's "Triggered 
immediately when the reception of a frame has begun."

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
