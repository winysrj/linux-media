Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45669 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbKWQWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 11:22:23 -0500
Subject: Re: [PATCH v8 17/55] [media] omap3isp: separate links creation from
 entities init
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <c81b0942c0405f447e4736fcda37f63509dc0526.1440902901.git.mchehab@osg.samsung.com>
 <1854108.dJ5m23VzOc@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <56533D39.40404@osg.samsung.com>
Date: Mon, 23 Nov 2015 13:22:17 -0300
MIME-Version: 1.0
In-Reply-To: <1854108.dJ5m23VzOc@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 11/23/2015 12:55 PM, Laurent Pinchart wrote:
> Hi Javier and Mauro,
> 
> Thank you for the patch.
>

Thanks for your feedback.
 
> On Monday 12 October 2015 13:43:05 Mauro Carvalho Chehab wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> The omap3isp driver initializes the entities and creates the pads links
>> before the entities are registered with the media device. This does not
>> work now that object IDs are used to create links so the media_device
>> has to be set.
>>
>> Split out the pads links creation from the entity initialization so are
>> made after the entities registration.
> 
> Is a part of this sentence missing ?
> 

The sentence is not clear indeed, I think it should be something like:

"so the links are created after the entities have been registered with
the media device"

>> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> Series-to: linux-kernel@vger.kernel.org
>> Series-cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Series-cc: linux-media@vger.kernel.org
>> Series-cc: Shuah Khan <shuahkh@osg.samsung.com>
>> Series-cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> Cover-letter:
> 
> I don't think those are known tags. Could you rework the commit message to 
> merge both part into something coherent without copying the cover letter ?
>

Yes, sorry about that. I use patman to manage and post my patches and
forgot to remove the patman tags before handling the patches to Mauro.

I mentioned to him already and he told me that would strip the tags
before pushing to the media tree or posting the patches again.

[remove left over cover letter from a different series]

>>
>> Change-Id: I44abb9b67d6378cbd54ba4e0673a5d6d5721fc77
> 
> No gerrit craziness please.
>

I believe this is something similar, a left over from Mauro since he
uses gerrit to manage this patch series.

>> ---
>>  drivers/media/platform/omap3isp/isp.c        | 152 ++++++++++++++----------
>>  drivers/media/platform/omap3isp/ispccdc.c    |  22 ++--
>>  drivers/media/platform/omap3isp/ispccdc.h    |   1 +
>>  drivers/media/platform/omap3isp/ispccp2.c    |  22 ++--
>>  drivers/media/platform/omap3isp/ispccp2.h    |   1 +
>>  drivers/media/platform/omap3isp/ispcsi2.c    |  22 ++--
>>  drivers/media/platform/omap3isp/ispcsi2.h    |   1 +
>>  drivers/media/platform/omap3isp/isppreview.c |  33 +++---
>>  drivers/media/platform/omap3isp/isppreview.h |   1 +
>>  drivers/media/platform/omap3isp/ispresizer.c |  33 +++---
>>  drivers/media/platform/omap3isp/ispresizer.h |   1 +
>>  11 files changed, 185 insertions(+), 104 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index aa13b17d19a0..b8f6f81d2db2
>> 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -1933,6 +1933,100 @@ done:
>>  	return ret;
>>  }
>>
>> +/*
>> + * isp_create_pads_links - Pads links creation for the subdevices
>> + * @isp : Pointer to ISP device
> 
> Missing blank line here. And missing description of the function for that 
> matter. You can use
> 
> "This function creates all links between ISP internal and external entities."
> 
>> + * return negative error code or zero on success
> 
> In kerneldoc style that should be
> 
> Return: A negative error code on failure or zero on success. Possible error 
> codes are those returned by media_create_pad_link().
> 
> Same for the other functions below, the return line should start with 
> "Return:".
>

You are right, the kerneldoc is not correct. I'll fix it.

>> + */
>> +static int isp_create_pads_links(struct isp_device *isp)
> 
> This should be called isp_create_pad_links() if you want the include the pad 
> prefix, but I'd just name it isp_create_links() as the driver doesn't handle 
> any other kind of links. Same for all the *_create_pads_links() functions 
> below.
>

Ok.

>> +{
>> +	int ret;
>> +
>> +	ret = omap3isp_csi2_create_pads_links(isp);
>> +	if (ret < 0) {
>> +		dev_err(isp->dev, "CSI2 pads links creation failed\n");
> 
> That's lots of error strings. You would save memory by turning the messages 
> into "%s pads links creation failed\n", "CSI2" as the compiler will then avoid 
> multiple copies of the first string.
> 
> I would actually remove the messages as the only source of error is a memory 
> allocation failure, which will already print a message. You could add a single 
> dev_err() in the location where isp_create_pads_links() is called if you want 
> to.
>

Agreed, I'll just remove the messages.

>> +		return ret;
>> +	}
>> +
>> +	ret = omap3isp_ccp2_create_pads_links(isp);
>> +	if (ret < 0) {
>> +		dev_err(isp->dev, "CCP2 pads links creation failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = omap3isp_ccdc_create_pads_links(isp);
>> +	if (ret < 0) {
>> +		dev_err(isp->dev, "CCDC pads links creation failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = omap3isp_preview_create_pads_links(isp);
>> +	if (ret < 0) {
>> +		dev_err(isp->dev, "Preview pads links creation failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = omap3isp_resizer_create_pads_links(isp);
>> +	if (ret < 0) {
>> +		dev_err(isp->dev, "Resizer pads links creation failed\n");
>> +		return ret;
>> +	}
>> +
>> +	/* Connect the submodules. */
> 
> I'd write "Create links between entities." and add a comment at the beginning 
> of the function that states "Create links between entities and video nodes.".
>

Ok.

>> +	ret = media_create_pad_link(
>> +			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>> +			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
>> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
>> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>> +			&isp->isp_aewb.subdev.entity, 0,
>> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>> +			&isp->isp_af.subdev.entity, 0,
>> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = media_create_pad_link(
>> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>> +			&isp->isp_hist.subdev.entity, 0,
>> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>> @@ -2468,6 +2508,10 @@ static int isp_probe(struct platform_device *pdev)
>>  	if (ret < 0)
>>  		goto error_modules;
>>
>> +	ret = isp_create_pads_links(isp);
>> +	if (ret < 0)
>> +		goto error_register_entities;
>> +
>>  	isp->notifier.bound = isp_subdev_notifier_bound;
>>  	isp->notifier.complete = isp_subdev_notifier_complete;
>>
>> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
>> b/drivers/media/platform/omap3isp/ispccdc.c index
>> 27555e4f4aa8..9a811f5741fa 100644
>> --- a/drivers/media/platform/omap3isp/ispccdc.c
>> +++ b/drivers/media/platform/omap3isp/ispccdc.c
>> @@ -2666,16 +2666,8 @@ static int ccdc_init_entities(struct isp_ccdc_device
>> *ccdc) if (ret < 0)
>>  		goto error_video;
>>
>> -	/* Connect the CCDC subdev to the video node. */
>> -	ret = media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
>> -			&ccdc->video_out.video.entity, 0, 0);
>> -	if (ret < 0)
>> -		goto error_link;
>> -
>>  	return 0;
>>
>> -error_link:
>> -	omap3isp_video_cleanup(&ccdc->video_out);
>>  error_video:
> 
> As there's now a single error label I'd rename it to just "error:". Same 
> comment for the other ISP modules.
>

Ok.

>>  	media_entity_cleanup(me);
>>  	return ret;
>> @@ -2721,6 +2713,20 @@ int omap3isp_ccdc_init(struct isp_device *isp)
>>  }
>>
>>  /*
>> + * omap3isp_ccdc_create_pads_links - CCDC pads links creation
>> + * @isp : Pointer to ISP device
>> + * return negative error code or zero on success
>> + */
>> +int omap3isp_ccdc_create_pads_links(struct isp_device *isp)
>> +{
>> +	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
>> +
>> +	/* Connect the CCDC subdev to the video node. */
>> +	return media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
>> +				     &ccdc->video_out.video.entity, 0, 0);
>> +}
> 
> Given that this function and the other similar functions for other modules 
> just link entities and video devices, it could make sense to inline them 
> directly in the caller in order to group all the link create calls together. 
> No strong opinion though, I'll leave it up to you and on whether you want to 
> fix the kerneldoc or remove it ;-)
>

Right, would make sense to remove them indeed and just inline in the caller.

>> +
>> +/*
>>   * omap3isp_ccdc_cleanup - CCDC module cleanup.
>>   * @isp: Device pointer specific to the OMAP3 ISP.
>>   */
> 
> [snip]
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
