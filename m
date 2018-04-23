Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42363 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755198AbeDWNYE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:24:04 -0400
Subject: Re: [RFCv11 PATCH 25/29] media: vim2m: add media device
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-26-hverkuil@xs4all.nl>
 <CAAFQd5C1_rWnQcUUj55UZq83ub=4SMDQW-+WAU6QdarsW9o7OQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <284849df-f061-8f15-ef70-1065c6b39753@xs4all.nl>
Date: Mon, 23 Apr 2018 15:23:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C1_rWnQcUUj55UZq83ub=4SMDQW-+WAU6QdarsW9o7OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 10:54 AM, Tomasz Figa wrote:
> On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Alexandre Courbot <acourbot@chromium.org>
> 
>> Request API requires a media node. Add one to the vim2m driver so we can
>> use requests with it.
> 
>> This probably needs a bit more work to correctly represent m2m
>> hardware in the media topology.
> [snip]
>> @@ -1013,6 +1012,22 @@ static int vim2m_probe(struct platform_device
> *pdev)
>>          vfd->lock = &dev->dev_mutex;
>>          vfd->v4l2_dev = &dev->v4l2_dev;
> 
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +       dev->mdev.dev = &pdev->dev;
>> +       strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>> +       media_device_init(&dev->mdev);
>> +       dev->v4l2_dev.mdev = &dev->mdev;
>> +       dev->pad[0].flags = MEDIA_PAD_FL_SINK;
>> +       dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
>> +       ret = media_entity_pads_init(&vfd->entity, 2, dev->pad);
>> +       if (ret)
>> +               return ret;
> 
> Hmm, what are these pads linked to?

Nothing. It's a quick hack, needs more work.

> 
> [snip]
>> @@ -1050,6 +1076,13 @@ static int vim2m_remove(struct platform_device
> *pdev)
>>          struct vim2m_dev *dev = platform_get_drvdata(pdev);
> 
>>          v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
>> +
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +       if (media_devnode_is_registered(dev->mdev.devnode))
> 
> Do we need to check this? Probe seems to fail if media device fails to
> register.

This was copy-and-paste from somewhere. I agree, this can be dropped.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
