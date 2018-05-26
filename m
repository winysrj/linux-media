Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45583 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030723AbeEZAT6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 20:19:58 -0400
Received: by mail-pg0-f67.google.com with SMTP id w3-v6so2912199pgv.12
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 17:19:57 -0700 (PDT)
Subject: Re: [PATCH 3/6] media: videodev2.h: Add macro
 V4L2_FIELD_IS_SEQUENTIAL
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
 <1527292416-26187-4-git-send-email-steve_longerbeam@mentor.com>
 <a8fb7943417e74fc19f594ae880fea5f306c7be3.camel@ndufresne.ca>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <f5264a36-f137-d0ae-68b1-f597e3913ba7@gmail.com>
Date: Fri, 25 May 2018 17:19:55 -0700
MIME-Version: 1.0
In-Reply-To: <a8fb7943417e74fc19f594ae880fea5f306c7be3.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/25/2018 05:10 PM, Nicolas Dufresne wrote:
> (in text this time, sorry)
>
> Le vendredi 25 mai 2018 à 16:53 -0700, Steve Longerbeam a écrit :
>> Add a macro that returns true if the given field type is
>> 'sequential',
>> that is, the data is transmitted, or exists in memory, as all top
>> field
>> lines followed by all bottom field lines, or vice-versa.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   include/uapi/linux/videodev2.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/include/uapi/linux/videodev2.h
>> b/include/uapi/linux/videodev2.h
>> index 600877b..408ee96 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -126,6 +126,10 @@ enum v4l2_field {
>>   	 (field) == V4L2_FIELD_INTERLACED_BT ||\
>>   	 (field) == V4L2_FIELD_SEQ_TB ||\
>>   	 (field) == V4L2_FIELD_SEQ_BT)
>> +#define V4L2_FIELD_IS_SEQUENTIAL(field) \
>> +	((field) == V4L2_FIELD_SEQ_TB ||\
>> +	 (field) == V4L2_FIELD_SEQ_BT ||\
>> +	 (field) == V4L2_FIELD_ALTERNATE)
> No, alternate has no place here, in alternate mode each buffers have
> only one field.

Then I misunderstand what is meant by "alternate". The name implies
to me that a source sends top or bottom field alternately, or top/bottom
fields exist in memory buffers alternately, but with no information about
which field came first. In other words, "alternate" is either seq-tb or 
seq-bt,
without any info about field order.

If it is just one field in a memory buffer, why isn't it called
V4L2_FIELD_TOP_OR_BOTTOM, e.g. we don't know which?

Steve
