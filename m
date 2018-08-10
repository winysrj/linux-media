Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:62962 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbeHJNSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 09:18:17 -0400
Subject: Re: [PATCHv16 01/34] Documentation: v4l: document request API
To: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
 <20180705160337.54379-2-hverkuil@xs4all.nl> <20180810104623.GA6350@amd>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <edbd181b-f7a4-cfa5-0460-7e6348ceb4bd@cisco.com>
Date: Fri, 10 Aug 2018 12:48:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180810104623.GA6350@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/18 12:46, Pavel Machek wrote:
> Hi!
>> From: Alexandre Courbot <acourbot@chromium.org>
>>
>> Document the request API for V4L2 devices, and amend the documentation
>> of system calls influenced by it.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> --- a/Documentation/media/uapi/v4l/buffer.rst
>> +++ b/Documentation/media/uapi/v4l/buffer.rst
>> @@ -306,10 +306,15 @@ struct v4l2_buffer
>>        - A place holder for future extensions. Drivers and applications
>>  	must set this to 0.
>>      * - __u32
>> -      - ``reserved``
>> +      - ``request_fd``
>>        -
>> -      - A place holder for future extensions. Drivers and applications
>> -	must set this to 0.
>> +      - The file descriptor of the request to queue the buffer to. If specified
>> +        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer will be
> 
> Delete "specified and" -- 0 is valid fd?

Good catch!

> 
>> +	queued to that request. This is set by the user when calling
>> +	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
>> +	If the device does not support requests, then ``EPERM`` will be returned.
>> +	If requests are supported but an invalid request FD is given, then
>> +	``ENOENT`` will be returned.
> 
> Should this still specify that this should be 0 if
> V4L2_BUF_FLAG_REQUEST_FD is not set?

I don't think so. But I can mentioned with request_fd that it is ignored if
V4L2_BUF_FLAG_REQUEST_FD is not set.

Regards,

	Hans

> 
> 									Pavel
> 
