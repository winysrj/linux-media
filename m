Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60959 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751161AbeAVOsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 09:48:20 -0500
Subject: Re: [PATCH 2/9] media: convert g/s_parm to g/s_frame_interval in
 subdevs
To: jacopo mondi <jacopo@jmondi.org>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
 <20180122101857.51401-3-hverkuil@xs4all.nl> <20180122144542.GB13087@w540>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <87a68cb7-dd34-93bb-c7e4-e9294f4ce431@xs4all.nl>
Date: Mon, 22 Jan 2018 15:48:17 +0100
MIME-Version: 1.0
In-Reply-To: <20180122144542.GB13087@w540>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/18 15:45, jacopo mondi wrote:
> Hi Hans,
> 
> On Mon, Jan 22, 2018 at 11:18:50AM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>>
> 
> [snip]
> 
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
>> index 34676409ca08..92d695b29fa9 100644
>> --- a/drivers/media/platform/atmel/atmel-isc.c
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -1417,20 +1417,14 @@ static int isc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>>  {
>>  	struct isc_device *isc = video_drvdata(file);
>>
>> -	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> -		return -EINVAL;
>> -
>> -	return v4l2_subdev_call(isc->current_subdev->sd, video, g_parm, a);
>> +	return v4l2_g_parm_cap(video_devdata(file), isc->current_subdev->sd, a);
>>  }
> 
> As I've reported in a comment to the CEU patch series, after having
> re-based my in-review driver on this series, I noticed I need to set
> a->parm.capture.readbuffers to 0, as my driver does not support
> CAP_READWRITE, and v4l2-compliance checks for (readbuffers == 0) if
> that's the case.
> 
> As atmel-isc (and I suspect other drivers modified by this patch) does
> not support CAP_READWRITE, don't you need to set capturebuffers to 0
> as well in order not to v4l2-compliance unhappy?

See the v4l2_g_parm_cap code in the first patch: I test if CAP_READWRITE is
set and if not, then readbuffers is initialized to 0.

Regards,

	Hans
> 
> (I would have tested myself, but I don't have any of these platforms)
> 
> Thanks
>    j
> 
