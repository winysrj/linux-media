Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40460 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754663AbaBUJv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 04:51:26 -0500
Message-ID: <530721A1.3060000@iki.fi>
Date: Fri, 21 Feb 2014 11:51:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5.1 3/7] v4l: Add timestamp source flags, mask and document
 them
References: <20140217232931.GW15635@valkosipuli.retiisi.org.uk> <1392925276-20412-1-git-send-email-sakari.ailus@iki.fi> <53066763.3070000@xs4all.nl> <53066F5E.7020202@gmail.com>
In-Reply-To: <53066F5E.7020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments.

Sylwester Nawrocki wrote:
...
> On 02/20/2014 09:36 PM, Hans Verkuil wrote:
>> On 02/20/2014 08:41 PM, Sakari Ailus wrote:
>>> Some devices do not produce timestamps that correspond to the end of the
>>> frame. The user space should be informed on the matter. This patch
>>> achieves
>>> that by adding buffer flags (and a mask) for timestamp sources since
>>> more
>>> possible timestamping points are expected than just two.
>>>
>>> A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two
>>> of the
>>> eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF for
>>> end of
>>> frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of exposure
>>> (next
>>> value).
>>
>> Sorry, but I still have two small notes:
>>
>>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>>> ---
>>> since v5:
>>> - Add a note on software generated timestamp inaccuracy.
>>>
>>>   Documentation/DocBook/media/v4l/io.xml   |   38
>>> +++++++++++++++++++++++++-----
>>>   drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
>>>   include/media/videobuf2-core.h           |    2 ++
>>>   include/uapi/linux/videodev2.h           |    4 ++++
>>>   4 files changed, 41 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/io.xml
>>> b/Documentation/DocBook/media/v4l/io.xml
>>> index 46d24b3..22b87bc 100644
>>> --- a/Documentation/DocBook/media/v4l/io.xml
>>> +++ b/Documentation/DocBook/media/v4l/io.xml
>>> @@ -653,12 +653,6 @@ plane, are stored in
>>> struct<structname>v4l2_plane</structname>  instead.
>>>   In that case, struct<structname>v4l2_buffer</structname>  contains
>>> an array of
>>>   plane structures.</para>
>>>
>>> -<para>For timestamp types that are sampled from the system clock
>>> -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the
>>> timestamp is
>>> -taken after the complete frame has been received (or transmitted in
>>> -case of video output devices). For other kinds of
>>> -timestamps this may vary depending on the driver.</para>
>>> -
>>>       <table frame="none" pgwide="1" id="v4l2-buffer">
>>>         <title>struct<structname>v4l2_buffer</structname></title>
>>>         <tgroup cols="4">
>>> @@ -1119,6 +1113,38 @@ in which case caches have not been used.</entry>
>>>       <entry>The CAPTURE buffer timestamp has been taken from the
>>>           corresponding OUTPUT buffer. This flag applies only to
>>> mem2mem devices.</entry>
>>>       </row>
>>> +    <row>
>>> +    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant></entry>
>>> +    <entry>0x00070000</entry>
>>> +    <entry>Mask for timestamp sources below. The timestamp source
>>> +        defines the point of time the timestamp is taken in relation to
>>> +        the frame. Logical and operation between the
>
> Perhaps s/and/AND ?

Is there a particular reason why? :-)

>>> +    <structfield>flags</structfield>  field and
>>> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant>  produces the
>>> +        value of the timestamp source.</entry>
>>> +    </row>
>>> +    <row>
>>> +    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
>>> +    <entry>0x00000000</entry>
>>> +    <entry>End Of Frame. The buffer timestamp has been taken
>>> +        when the last pixel of the frame has been received or the
>>> +        last pixel of the frame has been transmitted. In practice,
>>> +        software generated timestamps will typically be read from
>>> +        the clock a small amount of time after the last pixel has
>>> +        been received, depending on the system and other activity
>>
>> s/been received/been received or transmitted/
>>
>>> +        in it.</entry>
>>> +    </row>
>>> +    <row>
>>> +    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_SOE</constant></entry>
>
> V4L2_BUF_FLAG_TSTAMP_SRC_SOF (Start Of Frame) wouldn't fit here ?

That's different. Uvc devices provide a special start of exposure 
timestamp which is generated in camera itself. This is start of frame - 
exposure time (which, if AE is enabled, is a per-frame value).

>>> +    <entry>0x00010000</entry>
>>> +    <entry>Start Of Exposure. The buffer timestamp has been
>>> +        taken when the exposure of the frame has begun. In
>>> +        practice, software generated timestamps will typically be
>>> +        read from the clock a small amount of time after the last
>>> +        pixel has been received, depending on the system and other
>>> +        activity in it. This is only valid for buffer type
>>> +    <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>.</entry>
>>
>> I would move the last sentence up to just before "In practice...". The
>> way it is now it looks like an afterthought.
>>
>> I am also not sure whether the whole "In practice" sentence is valid
>> here. Certainly the bit about "the last pixel" isn't since this is the
>> "SOE" case and not the End Of Frame. In the case of the UVC driver
>> (and that's
>> the only one using this timestamp source) the timestamps come from the
>> hardware as I understand it, so the "software generated" bit doesn't
>> apply.
>
> I agree, not it looks like a copy & paste from the "End Of Frame"
> paragraph. I guess for SOE it should have been, e.g.

It is. :-) I shouldn't have written this so late in the evening... I'll 
remove it.

> "...read from the clock a small amount of time after the _first_
>      pixel has been received" ?
>
>> I would actually be inclined to drop it altogether for this particular
>> timestamp source. But it's up to Laurent.
>
> Yup, the "a small amount of time" concept seems a bit vague here.
> It's not clear how long period it could be and the tolerance would like
> very across the hardware.

This is very system and device specific so we can't say it'd be exactly 
within certain limits. What we say instead is that we don't know, which 
is true.

I think Hans's comment was related to this particular timestamp type; 
the same text is still present for the EOF timestamp.

-- 
Kind regards,

Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
