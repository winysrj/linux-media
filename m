Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:64161 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcGBD7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 23:59:47 -0400
Subject: Re: [PATCH 28/38] v4l: Add signal lock status to source change events
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-29-git-send-email-steve_longerbeam@mentor.com>
 <dfa4ca42-f527-f48e-e811-e514c167dc8d@xs4all.nl>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <57773C2F.4040107@mentor.com>
Date: Fri, 1 Jul 2016 20:59:43 -0700
MIME-Version: 1.0
In-Reply-To: <dfa4ca42-f527-f48e-e811-e514c167dc8d@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/01/2016 12:24 AM, Hans Verkuil wrote:
> On 06/15/2016 12:49 AM, Steve Longerbeam wrote:
>> Add a signal lock status change to the source changes bitmask.
>> This indicates there was a signal lock or unlock event detected
>> at the input of a video decoder.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 12 ++++++++++--
>>   include/uapi/linux/videodev2.h                     |  1 +
>>   2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
>> index c9c3c77..7758ad7 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
>> @@ -233,8 +233,9 @@
>>   	    <entry>
>>   	      <para>This event is triggered when a source parameter change is
>>   	       detected during runtime by the video device. It can be a
>> -	       runtime resolution change triggered by a video decoder or the
>> -	       format change happening on an input connector.
>> +	       runtime resolution change or signal lock status change
>> +	       triggered by a video decoder, or the format change happening
>> +	       on an input connector.
>>   	       This event requires that the <structfield>id</structfield>
>>   	       matches the input index (when used with a video device node)
>>   	       or the pad index (when used with a subdevice node) from which
>> @@ -461,6 +462,13 @@
>>   	    from a video decoder.
>>   	    </entry>
>>   	  </row>
>> +	  <row>
>> +	    <entry><constant>V4L2_EVENT_SRC_CH_LOCK_STATUS</constant></entry>
>> +	    <entry>0x0002</entry>
>> +	    <entry>This event gets triggered when there is a signal lock or
>> +	    unlock detected at the input of a video decoder.
>> +	    </entry>
>> +	  </row>
> I'm not entirely sure I like this. Typically losing lock means that this event
> is triggered with the V4L2_EVENT_SRC_CH_RESOLUTION flag set, and userspace has
> to check the new timings etc., which will fail if there is no lock anymore.
>
> This information is also available through ENUMINPUT.
>
> I would need to know more about why you think this is needed, because I don't
> see what this adds.

Hi Hans,

At least on the ADV718x, a source resolution change (from an 
autodetected video
standard change) and a signal lock status change are distinct events. 
For example
there can be a temporary loss of input signal lock without a change in 
detected
input video standard/resolution.

Steve

