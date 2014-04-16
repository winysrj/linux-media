Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50844 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161487AbaDPOgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 10:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <534E90D5.7030809@xs4all.nl>
References: <1397653162-10179-1-git-send-email-arun.kk@samsung.com>
	<4943000.PTOl0cPirQ@avalon>
	<534E90D5.7030809@xs4all.nl>
Date: Wed, 16 Apr 2014 20:06:42 +0530
Message-ID: <CALt3h7_=ASEhEtGA1DXbozhbdRrGbBLFxeUdoa=OyvHrezSagA@mail.gmail.com>
Subject: Re: [PATCH 1/2] v4l: Add resolution change event.
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Hans,

Thank you for the review.

On Wed, Apr 16, 2014 at 7:46 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 04/16/2014 04:09 PM, Laurent Pinchart wrote:
>> Hi Arun,
>>
>> Thank you for the patch.
>> On Wednesday 16 April 2014 18:29:21 Arun Kumar K wrote:
>>> From: Pawel Osciak <posciak@chromium.org>
>>>
>>> This event indicates that the decoder has reached a point in the stream,
>>> at which the resolution changes. The userspace is expected to provide a new
>>> set of CAPTURE buffers for the new format before decoding can continue.
>>>
>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>>> ---
>>>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |    8 ++++++++
>>>  include/uapi/linux/videodev2.h                     |    1 +
>>>  2 files changed, 9 insertions(+)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
>>> 5c70b61..d848628 100644
>>> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> @@ -155,6 +155,14 @@
>>>          </entry>
>>>        </row>
>>>        <row>
>>> +        <entry><constant>V4L2_EVENT_RESOLUTION_CHANGE</constant></entry>
>>> +        <entry>5</entry>
>>> +        <entry>This event is triggered when a resolution change is detected
>>> +        during runtime by the video decoder. Application may need to
>>> +        reinitialize buffers before proceeding further.
>>> +        </entry>
>>> +      </row>
>>
>> Would it make sense to report the new resolution in the event data ? I suppose
>> it might not be available in all cases though. If we can't report it, would it
>> make sense to document how applications should proceed to retrieve it ?
>
> I wouldn't report that. We played with this in Cisco, and in the end you just
> want to know something changed and you can take it from there. Besides, what
> constitutes a 'resolution' change? If my HDMI input switches from 720p60 to
> 720p30 the resolution stays the same, but I most definitely have to get the new
> timings.
>
> So I would call the event something different: EVENT_SOURCE_CHANGE or something
> like that.
>
> Getting the new timings is done through QUERYSTD or QUERY_DV_TIMINGS.
>

Ok will use the name V4L2_EVENT_SOURCE_CHANGE and update description
to reflect the generic usecase (not just for video decoders).

>> A similar resolution change event might be useful on subdevs, in which case we
>> would need to add a pad number to the event data. We could possibly leave that
>> for later, but it would be worth considering the problem already.
>
> Actually, I would add that right away. That's some thing that the adv7604
> driver can implement right away: it has multiple inputs and it can detect
> when something is plugged in or unplugged.
>

Ok will add support for mentioning pad number in event data.

Regards
Arun
