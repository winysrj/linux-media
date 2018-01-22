Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55877 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751004AbeAVKhW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:37:22 -0500
Subject: Re: [PATCH 9/9] vidioc-g-parm.rst: also allow _MPLANE buffer types
To: Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
 <20180122101857.51401-10-hverkuil@xs4all.nl>
 <20180122102650.xmwnxzq3vwwotduk@paasikivi.fi.intel.com>
Cc: linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <093a53f6-7466-105e-df57-0341281011b2@xs4all.nl>
Date: Mon, 22 Jan 2018 11:37:20 +0100
MIME-Version: 1.0
In-Reply-To: <20180122102650.xmwnxzq3vwwotduk@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/18 11:26, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 22, 2018 at 11:18:57AM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The specification mentions that type can be V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> but the v4l2 core implementation also allows the _MPLANE variant.
>>
>> Document this.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/media/uapi/v4l/vidioc-g-parm.rst | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
>> index 616a5ea3f8fa..a941526cfeb4 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
>> @@ -66,7 +66,7 @@ union holding separate parameters for input and output devices.
>>        -
>>        - The buffer (stream) type, same as struct
>>  	:c:type:`v4l2_format` ``type``, set by the
>> -	application. See :c:type:`v4l2_buf_type`
>> +	application. See :c:type:`v4l2_buf_type`.
>>      * - union
>>        - ``parm``
>>        -
>> @@ -75,12 +75,12 @@ union holding separate parameters for input and output devices.
>>        - struct :c:type:`v4l2_captureparm`
>>        - ``capture``
>>        - Parameters for capture devices, used when ``type`` is
>> -	``V4L2_BUF_TYPE_VIDEO_CAPTURE``.
> 	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``.
> 
> Wrap this one? It's over 80...

OK, done.

	Hans

> 
>>      * -
>>        - struct :c:type:`v4l2_outputparm`
>>        - ``output``
>>        - Parameters for output devices, used when ``type`` is
>> -	``V4L2_BUF_TYPE_VIDEO_OUTPUT``.
>> +	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
>>      * -
>>        - __u8
>>        - ``raw_data``\ [200]
> 
