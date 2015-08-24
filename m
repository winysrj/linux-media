Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59510 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbbHXSeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 14:34:36 -0400
Subject: Re: [PATCH v7 03/44] [media] omap3isp: get entity ID using
 media_entity_id()
To: Shuah Khan <shuahkhan@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
 <0c7d9114cb585da8f24c6ac9861bed9cd7f5a794.1440359643.git.mchehab@osg.samsung.com>
 <CAKocOOO37DPG520cpYrTFgXWyCrTRjRDCvdk13n1EC0PWPrpzQ@mail.gmail.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	shuahkh@osg.samsung.com
Message-ID: <55DB63B8.4010105@osg.samsung.com>
Date: Mon, 24 Aug 2015 20:34:32 +0200
MIME-Version: 1.0
In-Reply-To: <CAKocOOO37DPG520cpYrTFgXWyCrTRjRDCvdk13n1EC0PWPrpzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

Thanks for your feedback.

On 08/24/2015 08:14 PM, Shuah Khan wrote:
> On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> X-Patchwork-Delegate: laurent.pinchart@ideasonboard.com
>> The struct media_entity does not have an .id field anymore since
>> now the entity ID is stored in the embedded struct media_gobj.
>>
>> This caused the omap3isp driver fail to build. Fix by using the
>> media_entity_id() macro to obtain the entity ID.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
>> index 56e683b19a73..e08183f9d0f7 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -975,6 +975,7 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>>         struct v4l2_subdev *subdev;
>>         int failure = 0;
>>         int ret;
>> +       u32 id;
>>
>>         /*
>>          * We need to stop all the modules after CCDC first or they'll
>> @@ -1027,8 +1028,10 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>>                 if (ret) {
>>                         dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
>>                         isp->stop_failure = true;
>> -                       if (subdev == &isp->isp_prev.subdev)
>> -                               isp->crashed |= 1U << subdev->entity.id;
>> +                       if (subdev == &isp->isp_prev.subdev) {
>> +                               id = media_entity_id(&subdev->entity);
>> +                               isp->crashed |= 1U << id;
> 
> Is there a reason why you need id defined here, unlike the cases
> below. Can you do
> 
> isp->crashed |= 1U << media_entity_id(&subdev->entity);
> 
>

Yes I could but due the indentation levels, that line length would be
way over the 80 columns convention. An alternative would had been to
break down in two lines but that would make it even less readable IMHO.

So I added that variable for readability and to make checkpatch.pl happy.

> 
> thanks,
> -- Shuah
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
