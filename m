Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36408 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751842AbdDCMMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 08:12:42 -0400
Subject: Re: [Patch v3 07/11] Documentation: v4l: Documentation for HEVC v4l2
 definition
To: Smitha T Murthy <smitha.t@samsung.com>
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090444epcas5p43f44be426728ea22d0b13f64f5cf05bd@epcas5p4.samsung.com>
 <1490951200-32070-8-git-send-email-smitha.t@samsung.com>
 <3bad0b4f-0f0e-c67a-f9f7-135f5b8411c4@xs4all.nl>
 <1491221557.8493.98.camel@smitha-fedora>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a2018ba-7080-4dfc-24a5-c83384bd611d@xs4all.nl>
Date: Mon, 3 Apr 2017 14:12:36 +0200
MIME-Version: 1.0
In-Reply-To: <1491221557.8493.98.camel@smitha-fedora>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2017 02:12 PM, Smitha T Murthy wrote:
> On Mon, 2017-04-03 at 10:10 +0200, Hans Verkuil wrote:
>> On 03/31/2017 11:06 AM, Smitha T Murthy wrote:
>>> Add V4L2 definition for HEVC compressed format
>>>
>>> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
>>> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  Documentation/media/uapi/v4l/pixfmt-013.rst | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
>>> index 728d7ed..ff4cac2 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-013.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
>>> @@ -90,3 +90,8 @@ Compressed Formats
>>>        - ``V4L2_PIX_FMT_VP9``
>>>        - 'VP90'
>>>        - VP9 video elementary stream.
>>> +    * .. _V4L2-PIX-FMT-HEVC:
>>> +
>>> +      - ``V4L2_PIX_FMT_HEVC``
>>> +      - 'HEVC'
>>> +      - HEVC video elementary stream.
>>>
>>
>> You should mention here that HEVC == H.265.
>>
>> Regards,
>>
>> 	Hans
>>
> Do you mean change to "HEVC/H.265 video elementary stream" ?

Yes, that should do it.

Regards,

	Hans

> 
> Thank you for the review.
> Regards,
> Smitha
>>
> 
> 
