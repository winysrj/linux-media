Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57222 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910Ab3FIWfr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jun 2013 18:35:47 -0400
Message-ID: <51B50340.4020509@iki.fi>
Date: Mon, 10 Jun 2013 01:35:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond
 to reality
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi> <21759159.gaVOrBXtYV@avalon> <20130608163142.GI3103@valkosipuli.retiisi.org.uk> <1732074.vUfkmKHbt9@avalon>
In-Reply-To: <1732074.vUfkmKHbt9@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
...
>>>>> @@ -745,13 +718,9 @@ applications when an output stream.</entry>
>>>>>
>>>>>   	    byte was captured, as returned by the
>>>>>   	    <function>clock_gettime()</function> function for the relevant
>>>>>   	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
>>>>>
>>>>> -	    <xref linkend="buffer-flags" />. For output streams the data
>>>>> -	    will not be displayed before this time, secondary to the nominal
>>>>> -	    frame rate determined by the current video standard in enqueued
>>>>> -	    order. Applications can for example zero this field to display
>>>>> -	    frames as soon as possible. The driver stores the time at which
>>>>> -	    the first data byte was actually sent out in the
>>>>> -	    <structfield>timestamp</structfield> field. This permits
>>>>> +	    <xref linkend="buffer-flags" />. For output streams he driver
>>>>
>>>> 'he' -> 'the'
>>>>
>>>>> +	   stores the time at which the first data byte was actually sent
>>>>> out
>>>>> +	   in the  <structfield>timestamp</structfield> field. This permits
>>>>
>>>> Not true: the timestamp is taken after the whole frame was transmitted.
>>>>
>>>> Note that the 'timestamp' field documentation still says that it is the
>>>> timestamp of the first data byte for capture as well, that's also wrong.
>>>
>>> I know we've already discussed this, but what about devices, such as
>>> uvcvideo, that can provide the time stamp at which the image has been
>>> captured ? I don't think it would be worth it making this configurable,
>>> or even reporting the information to userspace, but shouldn't we give
>>> some degree of freedom to drivers here ?
>>
>> Hmm. That's a good question --- if we allow variation then we preferrably
>> should also provide a way for applications to know which case is which.
>>
>> Could the uvcvideo timestamps be meaningfully converted to the frame end
>> time instead? I'd suppose that a frame rate dependent constant would
>> suffice. However, how to calculate this I don't know.
>
> I don't think that's a good idea. The time at which the last byte of the image
> is received is meaningless to applications. What they care about, for
> synchronization purpose, is the time at which the image has been captured.
>
> I'm wondering if we really need to care for now. I would be enclined to leave
> it as-is until an application runs into a real issue related to timestamps.

What do you mean by "image has been captured"? Which part of it?

What I was thinking was the possibility that we could change the 
definition so that it'd be applicable to both cases: the time the whole 
image is fully in the system memory is of secondary importance in both 
cases anyway. As on embedded systems the time between the last pixel of 
the image is fully captured to it being in the host system memory is 
very, very short the two can be considered the same in most situations.

I wonder if this change would have any undesirable consequences.

-- 
Cheers,

Sakari Ailus
sakari.ailus@iki.fi
