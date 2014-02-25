Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4547 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBYMDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 07:03:10 -0500
Message-ID: <530C8657.2050602@xs4all.nl>
Date: Tue, 25 Feb 2014 13:02:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <1392497585-5084-3-git-send-email-sakari.ailus@iki.fi> <5309E05E.4030108@xs4all.nl> <530B668D.6010903@iki.fi> <125b01cf317b$67b61b80$37225280$%debski@samsung.com> <20140225114446.GE15635@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140225114446.GE15635@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/14 12:44, 'Sakari Ailus' wrote:
> Hi Kamil and Hans,
> 
> On Mon, Feb 24, 2014 at 05:13:49PM +0100, Kamil Debski wrote:
>>> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
>>> Sent: Monday, February 24, 2014 4:35 PM
>>>
>>> Hans Verkuil wrote:
>>>> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
>>>>> The buffer flags field is 32 bits but the defined only used 16. This
>>>>> is fine, but as more than 16 bits will be used in the very near
>>>>> future, define them as 32-bit numbers for consistency.
>>>>>
>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>>> ---
>>>>>  Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++---------
>>> ----
>>>>>  include/uapi/linux/videodev2.h         |   38 +++++++++++++++++++--
>>> -----------
>>>>>  2 files changed, 38 insertions(+), 30 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/DocBook/media/v4l/io.xml
>>>>> b/Documentation/DocBook/media/v4l/io.xml
>>>>> index 8facac4..46d24b3 100644
>>>>> --- a/Documentation/DocBook/media/v4l/io.xml
>>>>> +++ b/Documentation/DocBook/media/v4l/io.xml
>>>>
>>>> <snip>
>>>>
>>>>> @@ -1115,7 +1115,7 @@ in which case caches have not been
>>> used.</entry>
>>>>>  	  </row>
>>>>>  	  <row>
>>>>>
>>> <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
>>>>> -	    <entry>0x4000</entry>
>>>>> +	    <entry>0x00004000</entry>
>>>>>  	    <entry>The CAPTURE buffer timestamp has been taken from the
>>>>>  	    corresponding OUTPUT buffer. This flag applies only to
>>> mem2mem devices.</entry>
>>>>>  	  </row>
>>>>
>>>> Should we add here that if TIMESTAMP_COPY is set and the TIMECODE
>>> flag
>>>> is set, then drivers should copy the TIMECODE struct as well? This is
>>>> happening already in various drivers and I think that is appropriate.
>>>> Although to be honest nobody is actually using the timecode struct,
>>>> but we plan to hijack that for hardware timestamps in the future
>>> anyway.
>>>
>>> Is there a single driver which uses the timecode field? The fact is
>>> that many m2m drivers copy it but that's probably mostly copying what
>>> one of them happened to do by accident. :-)
>>
>> Let's focus on not breaking m2m drivers with timestamp patches this time.
>> I'm sure it was a matter of accident with the initial timestamp patches.
> 
> This patch extends the documentation of the buffer flags from 16 bits to 32
> bits. There are no other changes in functionality nor documentation.
> 
> The patchset does indeed change the way timestamp and timestamp flags are
> copied: from source to destination rather than the other way around. I'd
> appreciate if you'd review especially that one (patch 5/7).
> 
> There are no other changes to the way timestamps (or timecode) are handled.
> 
>> I agree with Hans here, not sure about hijacking it in the future, though.
> 
> This patchset does not change the handling of the timecode field, other than
> the fixes in patch 5/7. I would prefer to get this old patchset in and unify
> the timecode field handling once it has been discussed and agreed on.
> 

That's fine by me with respect to timecode handling. That can be handled later.
My comment about patch 7/7 still stands (about having no guarantees when
dealing with TIMESTAMP_COPY). I think this should be mentioned, perhaps with
a note that since it is userspace that provides the source timestamps in this
case, it is also userspace's problem :-) Garbage in, garbage out.

Regards,

	Hans
