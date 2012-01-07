Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:42631 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab2AGXFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 18:05:06 -0500
Message-ID: <4F08CF9C.3040508@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 01:05:00 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 14/17] omap3isp: Use pixelrate from sensor media bus frameformat
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-14-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201061114.05973.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061114.05973.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Tuesday 20 December 2011 21:28:06 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Configure the ISP based on the pixelrate in media bus frame format.
>> Previously the same was configured from the board code.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/isp.c |   24 +++++++++++++++++++++---
>>  drivers/media/video/omap3isp/isp.h |    1 -
>>  2 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/isp.c
>> b/drivers/media/video/omap3isp/isp.c index 6020fd7..92f9716 100644
>> --- a/drivers/media/video/omap3isp/isp.c
>> +++ b/drivers/media/video/omap3isp/isp.c
>> @@ -749,10 +749,14 @@ static int isp_pipeline_enable(struct isp_pipeline
>> *pipe,
>>
>>  	entity = &pipe->output->video.entity;
>>  	while (1) {
>> -		pad = &entity->pads[0];
>> -		if (!(pad->flags & MEDIA_PAD_FL_SINK))
>> +		/*
>> +		 * Is this an external subdev connected to us? If so,
>> +		 * we're done.
>> +		 */
>> +		if (subdev && subdev->host_priv)
>>  			break;
> 
> This doesn't seem to be related to the patch title. Should it be moved to a 
> separate patch ? You could also move the check to the bottom of the while 
> loop, it would allow you to remove the first part of the condition as subdev 
> will always be non-NULL then (or even possible as the while() condition).

The change got removed based on your other suggestions. ;-) The CSI-2
configuration moved to csi2_set_stream, so a lot of cruft got removed
from here.

>> +		pad = &entity->pads[0];
>>  		pad = media_entity_remote_source(pad);
>>  		if (pad == NULL ||
>>  		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
>> @@ -762,6 +766,21 @@ static int isp_pipeline_enable(struct isp_pipeline
>> *pipe, prev_subdev = subdev;
>>  		subdev = media_entity_to_v4l2_subdev(entity);
>>
>> +		/* Configure CCDC pixel clock */
>> +		if (subdev->host_priv) {
>> +			struct v4l2_subdev_format fmt;
>> +
>> +			fmt.pad = pad->index;
>> +			fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>> +			ret = v4l2_subdev_call(subdev, pad, get_fmt,
>> +					       NULL, &fmt);
>> +			if (ret < 0)
>> +				return -EINVAL;
>> +
>> +			isp_set_pixel_clock(isp,
>> +					    fmt.format.pixelrate * 1000);
>> +		}
>> +
>>  		/* Configure CSI-2 receiver based on sensor format. */
>>  		if (prev_subdev == &isp->isp_csi2a.subdev
>>
>>  		    || prev_subdev == &isp->isp_csi2c.subdev) {
>>
>> @@ -2102,7 +2121,6 @@ static int isp_probe(struct platform_device *pdev)
>>
>>  	isp->autoidle = autoidle;
>>  	isp->platform_cb.set_xclk = isp_set_xclk;
>> -	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
>>
>>  	mutex_init(&isp->isp_mutex);
>>  	spin_lock_init(&isp->stat_lock);
>> diff --git a/drivers/media/video/omap3isp/isp.h
>> b/drivers/media/video/omap3isp/isp.h index c5935ae..7d73a39 100644
>> --- a/drivers/media/video/omap3isp/isp.h
>> +++ b/drivers/media/video/omap3isp/isp.h
>> @@ -126,7 +126,6 @@ struct isp_reg {
>>
>>  struct isp_platform_callback {
>>  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
>> -	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
>>  };
>>
>>  /*
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
