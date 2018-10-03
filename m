Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727368AbeJDDdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 23:33:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w93KdGck031233
        for <linux-media@vger.kernel.org>; Wed, 3 Oct 2018 16:43:16 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mw37s4ra5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 16:43:16 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Wed, 3 Oct 2018 14:43:14 -0600
Subject: Re: [PATCH v3 2/2] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com>
 <1537903629-14003-3-git-send-email-eajames@linux.ibm.com>
 <a78d4c7a-ac58-c23d-a683-23dce54be993@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Wed, 3 Oct 2018 15:43:08 -0500
MIME-Version: 1.0
In-Reply-To: <a78d4c7a-ac58-c23d-a683-23dce54be993@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <ca4757b9-0825-bbbf-b388-0295fd13bad7@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/28/2018 06:30 AM, Hans Verkuil wrote:
> On 09/25/2018 09:27 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>> Make the video frames available through the V4L2 streaming interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.ibm.com>

>> +	}
>> +
>> +	video->height = (bottom - top) + 1;
>> +	video->width = (right - left) + 1;
>> +	size = video->height * video->width;
> It looks like you can actually determine the blanking width/height and
> possibly even more detailed information that would be very useful to
> show with the DV_TIMINGS ioctls.

Hmm. This information is related to the video signal captured from the 
host. That information has nothing to do with the buffer that is 
compressed and grabbed by the driver and ultimately provided to 
userspace. Isn't the timing information meaningless for JPEG frames?

Forgot to include this question in my previous reply, sorry for the 
additional mail.

Thanks,
Eddie

>
>> +
>> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
>> +	if (size < DIRECT_FETCH_THRESHOLD) {
>> +		aspeed_video_write(video, VE_TGS_0,
>> +				   FIELD_PREP(VE_TGS_FIRST, left - 1) |
>> +				   FIELD_PREP(VE_TGS_LAST, right));
>> +		aspeed_video_write(video, VE_TGS_1,
>> +				   FIELD_PREP(VE_TGS_FIRST, top) |
>>
