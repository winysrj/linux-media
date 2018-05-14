Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:55209 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbeENLYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:24:09 -0400
Subject: Re: [PATCH 2/5] media: docs: clarify relationship between crop and
 selection APIs
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
 <1522790146-16061-2-git-send-email-luca@lucaceresoli.net>
 <fca47fb0-a299-af1d-4485-268907bb1007@xs4all.nl>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <fefa4941-4465-ccb8-81be-d411c515c710@lucaceresoli.net>
Date: Mon, 14 May 2018 13:24:07 +0200
MIME-Version: 1.0
In-Reply-To: <fca47fb0-a299-af1d-4485-268907bb1007@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thanks for the review.

On 13/05/2018 11:12, Hans Verkuil wrote:
> On 04/03/2018 11:15 PM, Luca Ceresoli wrote:
>> Having two somewhat similar and largely overlapping APIs is confusing,
>> especially since the older one appears in the docs before the newer
>> and most featureful counterpart.
>>
>> Clarify all of this in several ways:
>>  - swap the two sections
>>  - give a name to the two APIs in the section names
>>  - add a note at the beginning of the CROP API section
>>
>> Also remove a note that is incorrect (correct wording is in
>> vidioc-cropcap.rst).
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Based on info from: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> ---
>>  Documentation/media/uapi/v4l/common.rst            |  2 +-
>>  Documentation/media/uapi/v4l/crop.rst              | 21 ++++++++++++---------
>>  Documentation/media/uapi/v4l/selection-api-005.rst |  2 ++
>>  Documentation/media/uapi/v4l/selection-api.rst     |  4 ++--
>>  4 files changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/media/uapi/v4l/common.rst
>> index 13f2ed3fc5a6..5f93e71122ef 100644
>> --- a/Documentation/media/uapi/v4l/common.rst
>> +++ b/Documentation/media/uapi/v4l/common.rst
>> @@ -41,6 +41,6 @@ applicable to all devices.
>>      extended-controls
>>      format
>>      planar-apis
>> -    crop
>>      selection-api
>> +    crop
>>      streaming-par
>> diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
>> index 182565b9ace4..83fa16eb347e 100644
>> --- a/Documentation/media/uapi/v4l/crop.rst
>> +++ b/Documentation/media/uapi/v4l/crop.rst
>> @@ -2,9 +2,18 @@
>>  
>>  .. _crop:
>>  
>> -*************************************
>> -Image Cropping, Insertion and Scaling
>> -*************************************
>> +*****************************************************
>> +Image Cropping, Insertion and Scaling -- the CROP API
>> +*****************************************************
>> +
>> +.. note::
>> +
>> +   The CROP API is mostly superseded by the newer :ref:`SELECTION API
>> +   <selection-api>`. The new API should be preferred in most cases,
>> +   with the exception of pixel aspect ratio detection, which is
>> +   implemented by :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` and has no
>> +   equivalent in the SELECTION API. See :ref:`selection-vs-crop` for a
>> +   comparison of the two APIs.
>>  
>>  Some video capture devices can sample a subsection of the picture and
>>  shrink or enlarge it to an image of arbitrary size. We call these
>> @@ -40,12 +49,6 @@ support scaling or the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
>>  :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls. Their size (and position
>>  where applicable) will be fixed in this case.
>>  
>> -.. note::
>> -
>> -   All capture and output devices must support the
>> -   :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications
>> -   can determine if scaling takes place.
> 
> This note should be rewritten, not deleted:
> 
> 	All capture and output devices that support the CROP or SELECTION API
> 	will also support the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl.

I don't remember exactly the reationale for this removal, perhaps it's
that I added a note above with similar content. But reading that again
now I realize the added not does not clearly state "VIDIOC_CROPCAP is
mandatory".

Thus I added the updated note to v2 as you suggested.

Bye,
-- 
Luca
