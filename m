Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39840
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753995AbcLOWzi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:55:38 -0500
Subject: Re: [PATCH 1/2] media: omap3isp fix media_entity_cleanup() after
 media device unregister
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1481829721.git.shuahkh@osg.samsung.com>
 <adae92a88cf8f25e022fdf46b8be7cb23e07465b.1481829722.git.shuahkh@osg.samsung.com>
 <8332445.l6HF2EFQsf@avalon>
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <227ddd9c-b7a0-e24e-0e1d-b83d5a60e075@osg.samsung.com>
Date: Thu, 15 Dec 2016 15:53:59 -0700
MIME-Version: 1.0
In-Reply-To: <8332445.l6HF2EFQsf@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2016 03:32 PM, Laurent Pinchart wrote:
> Hello Shuah,
> 
> Thank you for the patch.
> 
> On Thursday 15 Dec 2016 12:40:07 Shuah Khan wrote:
>> During unbind isp_remove() media_entity_cleanup() after it unregisters the
> 
> I assume you meant "During unbind isp_remove() calls media_entity_cleanup()"
> 
>> media_device. Cleanup routine calls media_entity_cleanup() accessing subdev
>> entities that have been removed. This will cause problems during unbind.
> 
> What problems ? media_entity_cleanup() is a no-op. And regardless of that, you 
> shouldn't remove the function call (unless the function is considered 
> deprecated, in which case it should be removed completely, and that should be 
> discussed beforehand) but move it to the appropriate place.

It is in the wrong place for one thing, It accesses entity after it
is removed. It could be moved to the right place or like you said,
remove media_entity_cleanup() interface as it does nothing and we
don't seem to have any concrete future plan for what it do.

> 
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/platform/omap3isp/ispccdc.c    | 1 -
>>  drivers/media/platform/omap3isp/ispccp2.c    | 1 -
>>  drivers/media/platform/omap3isp/ispcsi2.c    | 1 -
>>  drivers/media/platform/omap3isp/isppreview.c | 1 -
>>  drivers/media/platform/omap3isp/ispresizer.c | 1 -
>>  drivers/media/platform/omap3isp/ispstat.c    | 1 -
>>  drivers/media/platform/omap3isp/ispvideo.c   | 1 -
>>  7 files changed, 7 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
>> b/drivers/media/platform/omap3isp/ispccdc.c index 882310e..6d27e48 100644
>> --- a/drivers/media/platform/omap3isp/ispccdc.c
>> +++ b/drivers/media/platform/omap3isp/ispccdc.c
>> @@ -2726,7 +2726,6 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
>>  	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
>>
>>  	omap3isp_video_cleanup(&ccdc->video_out);
>> -	media_entity_cleanup(&ccdc->subdev.entity);
>>
>>  	/* Free LSC requests. As the CCDC is stopped there's no active 
> request,
>>  	 * so only the pending request and the free queue need to be handled.
>> diff --git a/drivers/media/platform/omap3isp/ispccp2.c
>> b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..4c1e7f0 100644
>> --- a/drivers/media/platform/omap3isp/ispccp2.c
>> +++ b/drivers/media/platform/omap3isp/ispccp2.c
>> @@ -1162,5 +1162,4 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp)
>>  	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
>>
>>  	omap3isp_video_cleanup(&ccp2->video_in);
>> -	media_entity_cleanup(&ccp2->subdev.entity);
>>  }
>> diff --git a/drivers/media/platform/omap3isp/ispcsi2.c
>> b/drivers/media/platform/omap3isp/ispcsi2.c index f75a1be..840756e 100644
>> --- a/drivers/media/platform/omap3isp/ispcsi2.c
>> +++ b/drivers/media/platform/omap3isp/ispcsi2.c
>> @@ -1318,5 +1318,4 @@ void omap3isp_csi2_cleanup(struct isp_device *isp)
>>  	struct isp_csi2_device *csi2a = &isp->isp_csi2a;
>>
>>  	omap3isp_video_cleanup(&csi2a->video_out);
>> -	media_entity_cleanup(&csi2a->subdev.entity);
>>  }
>> diff --git a/drivers/media/platform/omap3isp/isppreview.c
>> b/drivers/media/platform/omap3isp/isppreview.c index ac30a0f..a179dac
>> 100644
>> --- a/drivers/media/platform/omap3isp/isppreview.c
>> +++ b/drivers/media/platform/omap3isp/isppreview.c
>> @@ -2348,5 +2348,4 @@ void omap3isp_preview_cleanup(struct isp_device *isp)
>>  	v4l2_ctrl_handler_free(&prev->ctrls);
>>  	omap3isp_video_cleanup(&prev->video_in);
>>  	omap3isp_video_cleanup(&prev->video_out);
>> -	media_entity_cleanup(&prev->subdev.entity);
>>  }
>> diff --git a/drivers/media/platform/omap3isp/ispresizer.c
>> b/drivers/media/platform/omap3isp/ispresizer.c index 0b6a875..d22a54a
>> 100644
>> --- a/drivers/media/platform/omap3isp/ispresizer.c
>> +++ b/drivers/media/platform/omap3isp/ispresizer.c
>> @@ -1791,5 +1791,4 @@ void omap3isp_resizer_cleanup(struct isp_device *isp)
>>
>>  	omap3isp_video_cleanup(&res->video_in);
>>  	omap3isp_video_cleanup(&res->video_out);
>> -	media_entity_cleanup(&res->subdev.entity);
>>  }
>> diff --git a/drivers/media/platform/omap3isp/ispstat.c
>> b/drivers/media/platform/omap3isp/ispstat.c index 1b9217d..47b8e43 100644
>> --- a/drivers/media/platform/omap3isp/ispstat.c
>> +++ b/drivers/media/platform/omap3isp/ispstat.c
>> @@ -1055,7 +1055,6 @@ int omap3isp_stat_init(struct ispstat *stat, const
>> char *name,
>>
>>  void omap3isp_stat_cleanup(struct ispstat *stat)
>>  {
>> -	media_entity_cleanup(&stat->subdev.entity);
>>  	mutex_destroy(&stat->ioctl_lock);
>>  	isp_stat_bufs_free(stat);
>>  	kfree(stat->buf);
>> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
>> b/drivers/media/platform/omap3isp/ispvideo.c index 7354469..6914035 100644
>> --- a/drivers/media/platform/omap3isp/ispvideo.c
>> +++ b/drivers/media/platform/omap3isp/ispvideo.c
>> @@ -1470,7 +1470,6 @@ int omap3isp_video_init(struct isp_video *video, const
>> char *name)
>>
>>  void omap3isp_video_cleanup(struct isp_video *video)
>>  {
>> -	media_entity_cleanup(&video->video.entity);
>>  	mutex_destroy(&video->queue_lock);
>>  	mutex_destroy(&video->stream_lock);
>>  	mutex_destroy(&video->mutex);
> 

