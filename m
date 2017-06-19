Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17944 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdFSJSC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:18:02 -0400
Subject: Re: [RFC PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection
 behavior
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <27dd591b-4ef1-20ed-b93a-a30494cdf94d@samsung.com>
Date: Mon, 19 Jun 2017 11:17:55 +0200
MIME-version: 1.0
In-reply-to: <752af6b7-cbc4-6286-e7dd-45f0377d85b0@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
        <20170508143506.16448-2-hverkuil@xs4all.nl>
        <752af6b7-cbc4-6286-e7dd-45f0377d85b0@xs4all.nl>
        <CGME20170619091759epcas1p267d09b4cb075df4fbb680077b6f4eedf@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 06/19/2017 09:35 AM, Hans Verkuil wrote:

>> diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
>> index f21a69b554e1..d354216846e6 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
>> @@ -39,16 +39,19 @@ structure. Drivers fill the rest of the structure. The results are
>>    constant except when switching the video standard. Remember this switch
>>    can occur implicit when switching the video input or output.
>>    
>> -Do not use the multiplanar buffer types. Use
>> -``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
>> -``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
>> -``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
>> -``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
>> -
>>    This ioctl must be implemented for video capture or output devices that
>>    support cropping and/or scaling and/or have non-square pixels, and for
>>    overlay devices.
>>    
>> +.. note::
>> +   Unfortunately in the case of multiplanar buffer types
>> +   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
>> +   this API was messed up with regards to how the :c:type:`v4l2_cropcap` ``type`` field
>> +   should be filled in. The Samsung Exynos drivers only accepted the
> 
> I propose I change this to "Some drivers only..." here and at the other places I
> refer to Exynos.
> 
> Do you agree?

Yes, perhaps we could move the note paragraphs on the G_CROP,
G_SELECTION pages after v4l2_crop, v4l2_selection tables?

--
Regards,
Sylwester
