Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35ADC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C50C32083E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfCALq4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:46:56 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60436 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbfCALqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 06:46:55 -0500
Received: from [IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48] ([IPv6:2001:983:e9a7:1:e06f:53e3:ca47:5e48])
        by smtp-cloud9.xs4all.net with ESMTPA
        id zgcugZjFLI8AWzgcvgnBCU; Fri, 01 Mar 2019 12:46:53 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH 6/7] v4l2-device: v4l2_device_release_subdev_node can't
 reference sd
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-7-hverkuil-cisco@xs4all.nl>
 <20190222113257.GO3522@pendragon.ideasonboard.com>
Message-ID: <51113ff6-1213-ee6b-93ab-381a55b5e2e5@xs4all.nl>
Date:   Fri, 1 Mar 2019 12:46:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190222113257.GO3522@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO48S/IEq/TjYiJTwsm3Zd0StFR/FdqqUCQX5LOOJSoLIMoOZLpRYOwgzh1dksl58kLcQtktMrD2E2PcVNghXUnLNSlb8+uXXSlh/Bh/QOJyWKSibqoX
 0dD/2yv3DlYOhVLNapDExOTI5OfEUqJWcPM/RRR2Y88LJ6/RrJwJmod1PjwvXxcOXNvs9WL2cbZTOuMlgI/Sp4FwYS2gohhCSpcmI/Oq/9l+YWP8d5+AfrhH
 YAGNs5QWt84Y2oQEMBuE6SkSAD4+7lysTuuJLzegblwTGSdGLIgjqeR3p4WIUlK/fvXB9VFtLDqeSajvcdQuZwfBV1G5Tt88F0N6BcCgrNLkbfrmwuIxP5TB
 qx8CSbkXzYzSEyAZojBzo3BAuTDJ8Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/22/19 12:32 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thu, Feb 21, 2019 at 03:21:47PM +0100, Hans Verkuil wrote:
>> When the v4l-subdev device node is released it calls the
>> v4l2_device_release_subdev_node() function which sets sd->devnode
>> to NULL.
>>
>> However, the v4l2_subdev struct may already be released causing this
>> to write in freed memory.
>>
>> Instead just use the regular video_device_release release function
>> (just calls kfree) and set sd->devnode to NULL right after the
>> video_unregister_device() call.
> 
> This seems a bit of a workaround. The devnode can access the subdev in
> multiple ways, it should really keep a reference to the subdev to ensure
> it doesn't get freed early.

It's not the link from the devnode to the subdev (that's done through
video_get_drvdata()), it's the link from the subdev to the devnode.

As soon as the video device is unregistered sd->devnode should be set
to NULL. It is in fact how sd->devnode is used: as a check if the devnode
was registered.

The only other place where it is used is in v4l2_subdev_notify_event to
send an event to the devnode, and after unregistering the video device
you no longer want to do that, so setting sd->devnode to NULL after it
is unregistered is the right thing to do.

FYI, I'll post a v2 of this series soon.

Regards,

	Hans

> 
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  drivers/media/v4l2-core/v4l2-device.c | 10 ++--------
>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
>> index e0ddb9a52bd1..57a7b220fa4d 100644
>> --- a/drivers/media/v4l2-core/v4l2-device.c
>> +++ b/drivers/media/v4l2-core/v4l2-device.c
>> @@ -216,13 +216,6 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>>  
>> -static void v4l2_device_release_subdev_node(struct video_device *vdev)
>> -{
>> -	struct v4l2_subdev *sd = video_get_drvdata(vdev);
>> -	sd->devnode = NULL;
>> -	kfree(vdev);
>> -}
>> -
>>  int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>>  {
>>  	struct video_device *vdev;
>> @@ -250,7 +243,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>>  		vdev->dev_parent = sd->dev;
>>  		vdev->v4l2_dev = v4l2_dev;
>>  		vdev->fops = &v4l2_subdev_fops;
>> -		vdev->release = v4l2_device_release_subdev_node;
>> +		vdev->release = video_device_release;
>>  		vdev->ctrl_handler = sd->ctrl_handler;
>>  		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
>>  					      sd->owner);
>> @@ -319,6 +312,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>>  	}
>>  #endif
>>  	video_unregister_device(sd->devnode);
>> +	sd->devnode = NULL;
>>  	if (!sd->owner_v4l2_dev)
>>  		module_put(sd->owner);
>>  }
> 

