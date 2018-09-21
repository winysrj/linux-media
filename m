Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391311AbeIVBaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 21:30:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8LJZ8RL026300
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 15:39:49 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mn5eybt7s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 15:39:49 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 21 Sep 2018 15:39:47 -0400
Subject: Re: [PATCH v2 2/2] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1536866964-71593-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1536866964-71593-3-git-send-email-eajames@linux.vnet.ibm.com>
 <d1d58122-976b-b1dd-e4b4-bcc475219925@xs4all.nl>
 <cf333297-cc02-51c7-14a0-4d35bc1f8f07@linux.vnet.ibm.com>
 <66a5fbcf-2b41-ffd5-ad32-f26af47f3cea@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2018 14:39:42 -0500
MIME-Version: 1.0
In-Reply-To: <66a5fbcf-2b41-ffd5-ad32-f26af47f3cea@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Message-Id: <f1847a48-ca7c-e9e9-c85c-860166cebcbc@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/14/2018 12:31 PM, Hans Verkuil wrote:
> On 09/14/2018 05:22 PM, Eddie James wrote:
>>>> +static int aspeed_video_allocate_cma(struct aspeed_video *video)
>>>>
<snip>
>>>> +	if (rc) {
>>>> +		v4l2_device_unregister(v4l2_dev);
>>>> +		dev_err(video->dev, "Failed to register video device\n");
>>>> +		return rc;
>>>> +	}
>>>> +
>>>> +	video->v4l2_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>>> +	video->v4l2_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
>>>> +	video->v4l2_fmt.fmt.pix.field = V4L2_FIELD_NONE;
>>>> +	video->v4l2_fmt.fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>>> COLORSPACE_JPEG is deprecated. Use V4L2_COLORSPACE_SRGB for pix.colorspace
>>> and set pix.quantization to V4L2_QUANTIZATION_FULL_RANGE.

FYI I'm getting a v4l2-compliance failure using your suggestion:

Format ioctls:
         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
         test VIDIOC_G/S_PARM: OK
         test VIDIOC_G_FBUF: OK (Not Supported)
         fail: 
../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-formats.cpp(331): 
pixelformat == V4L2_PIX_FMT_JPEG && colorspace != V4L2_COLORSPACE_JPEG
         fail: 
../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-formats.cpp(436): 
testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, 
pix.quantization)
         test VIDIOC_G_FMT: FAIL

This is with v4l-utils commit d977e20a45a03543c4bdfeb3aef5211446de7398.

>>>
>>>> +
>>>> +	/* Don't fail the probe if controls init fails */
>>>> +	v4l2_ctrl_handler_init(&video->v4l2_ctrl, 2);
>>>> +
<snip>
>>>> ve,
>>>> +};
>>>> +
>>>> +module_platform_driver(aspeed_video_driver);
>>>> +
>>>> +MODULE_DESCRIPTION("ASPEED Video Engine Driver");
>>>> +MODULE_AUTHOR("Eddie James");
>>>> +MODULE_LICENSE("GPL v2");
>>>>
>>> I don't like the read() API here. It is not a real read() either since it assumes
>>> userspace reads full frames at a time. But if you read e.g. one byte at a time,
>>> then each byte is just the first byte of a different frame.
>> Yea...
>>
>>> I think we need to figure out how to make the stream I/O version just as fast
>>> if not faster as the read() API.

I do have the streaming API working with good performance now. Will get 
another patch set up soon.

Thanks,
Eddie

>> OK, I'll see what I can do.
>>
>> Thanks for the review!
>> Eddie
>>
>>> Regards,
>>>
>>> 	Hans
>>>
> Regards,
>
> 	Hans
>
