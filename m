Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:46291 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031950AbeEZRAW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 13:00:22 -0400
Subject: Re: [PATCH 3/6] media: videodev2.h: Add macro
 V4L2_FIELD_IS_SEQUENTIAL
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
 <1527292416-26187-4-git-send-email-steve_longerbeam@mentor.com>
 <a8fb7943417e74fc19f594ae880fea5f306c7be3.camel@ndufresne.ca>
 <f5264a36-f137-d0ae-68b1-f597e3913ba7@gmail.com>
 <dfa1d03adba61699314b823766d7738033b4ab90.camel@ndufresne.ca>
 <25d4c37a058d7b62fd83934898b63c52210aca40.camel@ndufresne.ca>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <d9e3bd54-f2de-da1c-96cc-162c20bdda28@mentor.com>
Date: Sat, 26 May 2018 10:00:15 -0700
MIME-Version: 1.0
In-Reply-To: <25d4c37a058d7b62fd83934898b63c52210aca40.camel@ndufresne.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,


On 05/25/2018 06:21 PM, Nicolas Dufresne wrote:
> Le vendredi 25 mai 2018 à 21:14 -0400, Nicolas Dufresne a écrit :
>> Le vendredi 25 mai 2018 à 17:19 -0700, Steve Longerbeam a écrit :
>>> On 05/25/2018 05:10 PM, Nicolas Dufresne wrote:
>>>> (in text this time, sorry)
>>>>
>>>> Le vendredi 25 mai 2018 à 16:53 -0700, Steve Longerbeam a écrit :
>>>>> Add a macro that returns true if the given field type is
>>>>> 'sequential',
>>>>> that is, the data is transmitted, or exists in memory, as all top
>>>>> field
>>>>> lines followed by all bottom field lines, or vice-versa.
>>>>>
>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>> ---
>>>>>    include/uapi/linux/videodev2.h | 4 ++++
>>>>>    1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/include/uapi/linux/videodev2.h
>>>>> b/include/uapi/linux/videodev2.h
>>>>> index 600877b..408ee96 100644
>>>>> --- a/include/uapi/linux/videodev2.h
>>>>> +++ b/include/uapi/linux/videodev2.h
>>>>> @@ -126,6 +126,10 @@ enum v4l2_field {
>>>>>    	 (field) == V4L2_FIELD_INTERLACED_BT ||\
>>>>>    	 (field) == V4L2_FIELD_SEQ_TB ||\
>>>>>    	 (field) == V4L2_FIELD_SEQ_BT)
>>>>> +#define V4L2_FIELD_IS_SEQUENTIAL(field) \
>>>>> +	((field) == V4L2_FIELD_SEQ_TB ||\
>>>>> +	 (field) == V4L2_FIELD_SEQ_BT ||\
>>>>> +	 (field) == V4L2_FIELD_ALTERNATE)
>>>> No, alternate has no place here, in alternate mode each buffers have
>>>> only one field.
>>> Then I misunderstand what is meant by "alternate". The name implies
>>> to me that a source sends top or bottom field alternately, or top/bottom
>>> fields exist in memory buffers alternately, but with no information about
>>> which field came first. In other words, "alternate" is either seq-tb or
>>> seq-bt,
>>> without any info about field order.
>>>
>>> If it is just one field in a memory buffer, why isn't it called
>>> V4L2_FIELD_TOP_OR_BOTTOM, e.g. we don't know which?
>> I don't see why this could be better then ALTERNATE, were buffers are
>> only top or bottom fields alternatively. And even if there was another
>> possible name, this is public API.
>>
>> V4L2_FIELD_ALTERNATE is a mode, that will only be used with
>> v4l2_pix_format or v4l2_pix_format_mplane. I should never bet set on
>> the v4l2_buffer.field, instead the driver indicates the parity of the
>> field by setting V42_FIELD_TOP/BOTTOM on the v4l2_buffer returned by
>> DQBUF. This is a very different mode of operation compared to
>> sequential, hence why I believe it is wrong to make it part of the new
>> helper. So far, it's the only field value that has this asymmetric
>> usage and meaning.
> I should have put some references. The explanation of the modes, with a
> temporal representation of the fields. Small note, in ALTERNATE mode
> bottom and top fields will likely not share the same timestamp, it is a
> mode used to achieve lower latency.
>
> https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/field-order.html#c.v4l2_field
>
> And in this section, you'll see a paragraph that explain the field
> values when running in ALTERNATE mode.
>
> https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#c.v4l2_buffer

Ok, thanks for clarifying. I suppose it makes sense that this mode 
should not
be seen as sequential, since it represents a mode where each userspace 
buffer
is a single, self-contained field. I'll remove ALTERNATE from the helper 
macro.

Steve
