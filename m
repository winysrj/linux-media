Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14192 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2LEJ5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 04:57:07 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEJ00BOIY5XM140@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 09:59:44 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEJ00D0KYB5ZEA0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 09:57:05 +0000 (GMT)
Message-id: <50BF1A70.8070502@samsung.com>
Date: Wed, 05 Dec 2012 10:57:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
 <20121204232208.GP31879@valkosipuli.retiisi.org.uk>
In-reply-to: <20121204232208.GP31879@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the comments.

On 12/05/2012 12:22 AM, Sakari Ailus wrote:
>> diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
>> index 3acbea3..39c4555 100644
>> --- a/drivers/media/platform/s5p-fimc/fimc-capture.c
>> +++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
>> @@ -794,6 +794,21 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
>>  	return 0;
>>  }
>>  
>> +static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
>> +{
>> +	struct media_pad *pad = &me->pads[0];
>> +
>> +	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
>> +		pad = media_entity_remote_source(pad);
>> +		if (!pad)
>> +			break;
> 
> Isn't it an error if a sink pad of the entity isn't connected?
> media_entity_remote_source(pad) returns NULL if the link is disabled. I'm
> just wondering if this is possible.

It is not possible to not have all links connected, from video device to
the sensor subdev entity, at the point when this function is called
(from within VIDIOC_TRY_FMT or VIDIOC_S_FMT ioctls). fimc_pipeline_prepare()
walks the graph in direction from video node to the sensor, also using
media_entity_remote_source(). If it doesn't reach the sensor entity and
save a pointer to it for further reference the video node open() will fail.
And there won't be even a chance to invoke VIDIOC_TRY_FMT/VIDIOC_S_FMT 
ioctls. It's true the above function takes some assumptions that could be
explained with a relevant comment.

It's worth to note that all this in-driver setting of format at the 
pipeline is for static default links created by the driver. If userspace 
reconfigures links it should not rely on it in first place. When we finally 
prepare a libv4l support for this driver it should just go away. Regular 
V4L2 applications must use libv4l2 anyway since the driver supports only 
multi-planar API.

--

Regards,
Sylwester

