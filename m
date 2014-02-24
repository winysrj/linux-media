Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3282 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaBXQCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 11:02:40 -0500
Message-ID: <530B6D0C.1020900@xs4all.nl>
Date: Mon, 24 Feb 2014 17:02:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: Re: [PATCH v5 2/7] v4l: Use full 32 bits for buffer flags
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi> <1392497585-5084-3-git-send-email-sakari.ailus@iki.fi> <5309E05E.4030108@xs4all.nl> <530B668D.6010903@iki.fi>
In-Reply-To: <530B668D.6010903@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2014 04:34 PM, Sakari Ailus wrote:
> Hans Verkuil wrote:
>> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
>>> The buffer flags field is 32 bits but the defined only used 16. This is
>>> fine, but as more than 16 bits will be used in the very near future, define
>>> them as 32-bit numbers for consistency.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>> ---
>>>  Documentation/DocBook/media/v4l/io.xml |   30 ++++++++++++-------------
>>>  include/uapi/linux/videodev2.h         |   38 +++++++++++++++++++-------------
>>>  2 files changed, 38 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
>>> index 8facac4..46d24b3 100644
>>> --- a/Documentation/DocBook/media/v4l/io.xml
>>> +++ b/Documentation/DocBook/media/v4l/io.xml
>>
>> <snip>
>>
>>> @@ -1115,7 +1115,7 @@ in which case caches have not been used.</entry>
>>>  	  </row>
>>>  	  <row>
>>>  	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
>>> -	    <entry>0x4000</entry>
>>> +	    <entry>0x00004000</entry>
>>>  	    <entry>The CAPTURE buffer timestamp has been taken from the
>>>  	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
>>>  	  </row>
>>
>> Should we add here that if TIMESTAMP_COPY is set and the TIMECODE flag is set,
>> then drivers should copy the TIMECODE struct as well? This is happening already
>> in various drivers and I think that is appropriate. Although to be honest nobody
>> is actually using the timecode struct, but we plan to hijack that for hardware
>> timestamps in the future anyway.
> 
> Is there a single driver which uses the timecode field? The fact is that
> many m2m drivers copy it but that's probably mostly copying what one of
> them happened to do by accident. :-)
> 

No, there are no drivers that use this at the moment (other than for copying).
However, it is part of the API and I'd like to close these little holes and define
clearly what should be done. I think given the purpose of the timecode field it
makes sense to copy it. Note that it is the application that might be providing
that data, it doesn't have to come from a driver at all.

I've been doing a lot of testing over the weekend and this is one of those little
things that are not clearly defined.

Regards,

	Hans
