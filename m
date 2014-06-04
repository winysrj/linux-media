Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaFDLR7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jun 2014 07:17:59 -0400
Message-ID: <538F0064.7000107@linux.intel.com>
Date: Wed, 04 Jun 2014 14:17:56 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Unify argument validation across IOCTLs
References: <1401787516-16545-1-git-send-email-sakari.ailus@linux.intel.com> <1693642.21y0Pscz7q@avalon>
In-Reply-To: <1693642.21y0Pscz7q@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.

Thanks for the review!

> On Tuesday 03 June 2014 12:25:16 Sakari Ailus wrote:
...
>> @@ -202,26 +251,20 @@ static long subdev_do_ioctl(struct file *file,
>> unsigned int cmd, void *arg) #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>>   	case VIDIOC_SUBDEV_G_FMT: {
>>   		struct v4l2_subdev_format *format = arg;
>> +		int rval = check_format(sd, format);
>
> How about declaring the variable once only at the beginning of the function ?

I'll change that and resend.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
