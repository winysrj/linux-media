Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1KDQIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 12:08:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU500IZJ8UCEO70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 16:08:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU50050Q8UBE5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 16:08:36 +0000 (GMT)
Date: Fri, 04 Nov 2011 17:08:35 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes
In-reply-to: <201111041143.17621.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EB40E03.2040908@samsung.com>
References: <1320250557-20880-1-git-send-email-s.nawrocki@samsung.com>
 <201111041143.17621.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/04/2011 11:43 AM, Laurent Pinchart wrote:
> On Wednesday 02 November 2011 17:15:57 Sylwester Nawrocki wrote:
...
>> diff --git a/drivers/media/video/v4l2-subdev.c
>> b/drivers/media/video/v4l2-subdev.c index 179e20e..4fe1e7a 100644
>> --- a/drivers/media/video/v4l2-subdev.c
>> +++ b/drivers/media/video/v4l2-subdev.c
>> @@ -192,6 +192,9 @@ static long subdev_do_ioctl(struct file *file, unsigned
>> int cmd, void *arg) return v4l2_subdev_call(sd, core, s_register, p);
>>  	}
>>  #endif
> 
> I would have put a blank line here, but that's probably just me :-)

Doesn't sound like a significant improvement, but indeed looks better;)
I'll update this when adding to a pull request.

> 
>> +	case VIDIOC_LOG_STATUS:
>> +		return v4l2_subdev_call(sd, core, log_status);
>> +
>>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>>  	case VIDIOC_SUBDEV_G_FMT: {
>>  		struct v4l2_subdev_format *format = arg;

--
Thanks,
Sylwester
