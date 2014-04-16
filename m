Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3751 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161263AbaDPORR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 10:17:17 -0400
Message-ID: <534E90D5.7030809@xs4all.nl>
Date: Wed, 16 Apr 2014 16:16:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/2] v4l: Add resolution change event.
References: <1397653162-10179-1-git-send-email-arun.kk@samsung.com> <4943000.PTOl0cPirQ@avalon>
In-Reply-To: <4943000.PTOl0cPirQ@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2014 04:09 PM, Laurent Pinchart wrote:
> Hi Arun,
> 
> Thank you for the patch.
> On Wednesday 16 April 2014 18:29:21 Arun Kumar K wrote:
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> This event indicates that the decoder has reached a point in the stream,
>> at which the resolution changes. The userspace is expected to provide a new
>> set of CAPTURE buffers for the new format before decoding can continue.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    8 ++++++++
>>  include/uapi/linux/videodev2.h                     |    1 +
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
>> 5c70b61..d848628 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>> @@ -155,6 +155,14 @@
>>  	    </entry>
>>  	  </row>
>>  	  <row>
>> +	    <entry><constant>V4L2_EVENT_RESOLUTION_CHANGE</constant></entry>
>> +	    <entry>5</entry>
>> +	    <entry>This event is triggered when a resolution change is detected
>> +	    during runtime by the video decoder. Application may need to
>> +	    reinitialize buffers before proceeding further.
>> +	    </entry>
>> +	  </row>
> 
> Would it make sense to report the new resolution in the event data ? I suppose 
> it might not be available in all cases though. If we can't report it, would it 
> make sense to document how applications should proceed to retrieve it ?

I wouldn't report that. We played with this in Cisco, and in the end you just
want to know something changed and you can take it from there. Besides, what
constitutes a 'resolution' change? If my HDMI input switches from 720p60 to
720p30 the resolution stays the same, but I most definitely have to get the new
timings. 

So I would call the event something different: EVENT_SOURCE_CHANGE or something
like that.

Getting the new timings is done through QUERYSTD or QUERY_DV_TIMINGS.

> A similar resolution change event might be useful on subdevs, in which case we 
> would need to add a pad number to the event data. We could possibly leave that 
> for later, but it would be worth considering the problem already.

Actually, I would add that right away. That's some thing that the adv7604
driver can implement right away: it has multiple inputs and it can detect
when something is plugged in or unplugged.

Regards,

	Hans

> 
>> +	  <row>
>>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>>  	    <entry>0x08000000</entry>
>>  	    <entry>Base event number for driver-private events.</entry>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 6ae7bbe..58488b7 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
>>  #define V4L2_EVENT_EOS				2
>>  #define V4L2_EVENT_CTRL				3
>>  #define V4L2_EVENT_FRAME_SYNC			4
>> +#define V4L2_EVENT_RESOLUTION_CHANGE		5
>>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>>
>>  /* Payload for V4L2_EVENT_VSYNC */
> 

