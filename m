Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728139AbeJFDDe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 23:03:34 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w95K1pJs111886
        for <linux-media@vger.kernel.org>; Fri, 5 Oct 2018 16:03:17 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mxcy9v2g1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 16:03:17 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 5 Oct 2018 16:03:16 -0400
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
 <ca4757b9-0825-bbbf-b388-0295fd13bad7@linux.vnet.ibm.com>
 <373d2ca3-a6cd-8d87-2bbc-613d65305170@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 5 Oct 2018 15:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <373d2ca3-a6cd-8d87-2bbc-613d65305170@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <8476027d-80d5-2787-944b-eb3f5af717c3@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/04/2018 08:12 AM, Hans Verkuil wrote:
> On 10/03/18 22:43, Eddie James wrote:
>>
>> On 09/28/2018 06:30 AM, Hans Verkuil wrote:
>>> On 09/25/2018 09:27 PM, Eddie James wrote:
>>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>>> can capture and compress video data from digital or analog sources. With
>>>> the Aspeed chip acting a service processor, the Video Engine can capture
>>>> the host processor graphics output.
>>>>
>>>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>>>> Make the video frames available through the V4L2 streaming interface.
>>>>
>>>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>>>> +	}
>>>> +
>>>> +	video->height = (bottom - top) + 1;
>>>> +	video->width = (right - left) + 1;
>>>> +	size = video->height * video->width;
>>> It looks like you can actually determine the blanking width/height and
>>> possibly even more detailed information that would be very useful to
>>> show with the DV_TIMINGS ioctls.
>> Hmm. This information is related to the video signal captured from the
>> host. That information has nothing to do with the buffer that is
>> compressed and grabbed by the driver and ultimately provided to
>> userspace. Isn't the timing information meaningless for JPEG frames?
> It helps in debugging. Basically you are implementing a receiver for a
> video signal. So if for some reason you cannot support the video timings
> that the host sends, then it is very useful to have QUERY_DV_TIMINGS report
> as much information about the signal as possible.
>
> BTW, out of curiosity, how are the host video signals connected to the
> aspeed? Is it still a VGA video signal?
>
> Looking at product briefs it appears that it is VGA. So I guess the aspeed
> 'sniffs' the VGA signals from the host and can capture the video that way.
> Is that correct?

I believe it is a VGA signal from the host, but the Aspeed Video Engine 
somewhat abstracts that away; not all the signal information that the 
engine is receiving is available to the BMC interface. I did add the 
timing information I could access to the latest patch set. As you say, 
it could be useful for debugging if weird things are happening.

Thanks!
Eddie

>
> If so, then this driver is a VGA receiver and should act like that.
> The host can configure its VGA transmitter to invalid timings, or weird
> values, and you need to be able to handle that in your driver.
>
>> Forgot to include this question in my previous reply, sorry for the
>> additional mail.
> No problem! Happy to help.
>
> Regards,
>
> 	Hans
>
