Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D63C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70476206B6
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUx8AUVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfAHTOq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:14:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39753 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfAHTOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 14:14:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so5195240wra.6;
        Tue, 08 Jan 2019 11:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FKL4SvOc108O3dQs9D8q8g9z2FQELAS/a7beP3IqgSs=;
        b=BUx8AUVqVwXAXZIOdYxyUCTXu3LakKCYd3WC5HUi0dSReykzleupyF8UiC/86G0H/3
         AMNLxrvWBYF+0wt3bAMcBPAZ9ZqE7vXjNk8aCgWW1Zg/DK7ZAERYNh2GQb050CkqqdGa
         PZgdikHF0YUeutYAUO4lXAZqr/z4fvmYIQ7Rthc/bT8BY0dEAomd0PAM64j0maedqo1h
         pUSmnu4Otr/9et1Us1b1W8542tUrFwYfKoiy4uBbNIeN3q0mVFV0x4tIuZIsIPOWdbGM
         d5P941FcBfTOgMP+1mB8kx8qh/HcHWzb04cs7fAL8Sk2UPkswvodxRg1w+luEfIDx13t
         LAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FKL4SvOc108O3dQs9D8q8g9z2FQELAS/a7beP3IqgSs=;
        b=N0/JASbJvDGJMO6VvqE0RFVSl1HC0M6ceMDUq5DRrRP2zoS13d9EaGjo1cZaxz9IVT
         u6cUlrURLza7qRnPtltPbyD18Ex+g0hno3O3OLKQkFjUJZ/sdQ6dv2/RekHbyu16kplG
         KNtbTTbz7tazASysyjSznh7ptNIeVXmF/2iwF1gil3rVhy2c9rJsgOenbLnHvwYq4Lmw
         ysa/i4vmCaUUmCY2mKOJrj41dyfhGywM3NhdtL8jr4XO9luGbJRTO8n+CFKTmAKllA38
         tTTCtWLrwO/KAKUKNeP8xmO8vWRu9VYRhnsvwj4XiN3ml9GBEi6+YXluR+m9I3SVdwh8
         CXbg==
X-Gm-Message-State: AJcUukeDMy7uF1s1TMlSkLte41ZLrVl4ZZLDQEvTsOvOvG1jh1hE9Wx+
        +W3DdqLG/Z3TToiUA7Eb1LEDtmer
X-Google-Smtp-Source: ALg8bN7+NtlXfzioeMcum7R3ZssumZGb3gNqVU3+DnYmfRCJMX+IGWZU7qpPTcq+pb2c6bvK4j5/HA==
X-Received: by 2002:adf:dec4:: with SMTP id i4mr2258852wrn.307.1546974882139;
        Tue, 08 Jan 2019 11:14:42 -0800 (PST)
Received: from [172.30.90.2] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id a17sm56153811wrs.58.2019.01.08.11.14.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 11:14:41 -0800 (PST)
Subject: Re: [PATCH] media: imx: queue subdev events to reachable video
 devices
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181209195722.26858-1-steve_longerbeam@mentor.com>
 <2bd52738-f466-96d8-5877-aab96a129e74@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <acc89e1c-8115-e585-3040-60fe03799300@gmail.com>
Date:   Tue, 8 Jan 2019 11:14:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <2bd52738-f466-96d8-5877-aab96a129e74@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 1/8/19 5:26 AM, Hans Verkuil wrote:
> On 12/09/18 20:57, Steve Longerbeam wrote:
>> From: Steve Longerbeam <slongerbeam@gmail.com>
>>
>> Forward events from a sub-device to its list of reachable video
>> devices.
>>
>> Note this will queue the event to a video device even if there is
>> no actual _enabled_ media path from the sub-device to the video device.
>> So a future improvement is to skip the video device if there is no enabled
>> path to it from the sub-device. The entity->pipe pointer can't be
>> used for this check because in imx-media a sub-device can be a
>> member to more than one streaming pipeline at a time.
> You explain what you are doing, but I am missing an explanation of *why*
> this is needed.

Ok, I'll add more explanation.

>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/staging/media/imx/imx-media-capture.c | 18 ++++++++++++++
>>   drivers/staging/media/imx/imx-media-dev.c     | 24 +++++++++++++++++++
>>   2 files changed, 42 insertions(+)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
>> index b37e1186eb2f..4dfbe05d203e 100644
>> --- a/drivers/staging/media/imx/imx-media-capture.c
>> +++ b/drivers/staging/media/imx/imx-media-capture.c
>> @@ -335,6 +335,21 @@ static int capture_s_parm(struct file *file, void *fh,
>>   	return 0;
>>   }
>>   
>> +static int capture_subscribe_event(struct v4l2_fh *fh,
>> +				   const struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR:
>> +		return v4l2_event_subscribe(fh, sub, 0, NULL);
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subscribe(fh, sub);
>> +	case V4L2_EVENT_CTRL:
>> +		return v4l2_ctrl_subscribe_event(fh, sub);
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>   static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>>   	.vidioc_querycap	= vidioc_querycap,
>>   
>> @@ -362,6 +377,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>>   	.vidioc_expbuf		= vb2_ioctl_expbuf,
>>   	.vidioc_streamon	= vb2_ioctl_streamon,
>>   	.vidioc_streamoff	= vb2_ioctl_streamoff,
>> +
>> +	.vidioc_subscribe_event = capture_subscribe_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>>   };
> This part of the patch adds event support to the capture device, can't this be
> split up into a separate patch? It seems to be useful in its own right.

Ok, I will split this up. The first patch will add the 
(un)subscribe_event callbacks to the capture device, and the second 
patch will forward subdev events.
>
>>   
>>   /*
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
>> index 4b344a4a3706..25e916562c66 100644
>> --- a/drivers/staging/media/imx/imx-media-dev.c
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>> @@ -442,6 +442,29 @@ static const struct media_device_ops imx_media_md_ops = {
>>   	.link_notify = imx_media_link_notify,
>>   };
>>   
>> +static void imx_media_notify(struct v4l2_subdev *sd,
>> +			     unsigned int notification,
>> +			     void *arg)
>> +{
>> +	struct media_entity *entity = &sd->entity;
>> +	int i;
>> +
>> +	if (notification != V4L2_DEVICE_NOTIFY_EVENT)
>> +		return;
>> +
>> +	for (i = 0; i < entity->num_pads; i++) {
>> +		struct media_pad *pad = &entity->pads[i];
>> +		struct imx_media_pad_vdev *pad_vdev;
>> +		struct list_head *pad_vdev_list;
>> +
>> +		pad_vdev_list = to_pad_vdev_list(sd, pad->index);
>> +		if (!pad_vdev_list)
>> +			continue;
>> +		list_for_each_entry(pad_vdev, pad_vdev_list, list)
>> +			v4l2_event_queue(pad_vdev->vdev->vfd, arg);
> Which events do you want to forward?

Shouldn't any/all subdev events be forwarded?

I would also prefer to allow userland to subscribe to any events that a 
subdevice might generate. In other words, imx-media will allow the user 
to subscribe to, and receive any events that might be generated by 
subdevices.


>   E.g. forwarding control events
> doesn't seem right, but other events may be useful.

The imx capture devices inherit controls from the subdevices. If an 
inherited control is changed via the capture device, will _two_ control 
events be generated (one from the subdevice and one from the capture 
device)? Or will only one event get generated to the capture device? 
Same question goes when changing an inherited control from the subdevice 
nodes.


>   Are those events
> also appearing on the v4l-subdevX device? And if so, should they?

How do we know what subdevices a future imx-based system might attach to 
the media graph? That's why I think it makes sense to forward any/all 
events from subdevices.

Steve

>
>> +	}
>> +}
>> +
>>   static int imx_media_probe(struct platform_device *pdev)
>>   {
>>   	struct device *dev = &pdev->dev;
>> @@ -462,6 +485,7 @@ static int imx_media_probe(struct platform_device *pdev)
>>   	mutex_init(&imxmd->mutex);
>>   
>>   	imxmd->v4l2_dev.mdev = &imxmd->md;
>> +	imxmd->v4l2_dev.notify = imx_media_notify;
>>   	strscpy(imxmd->v4l2_dev.name, "imx-media",
>>   		sizeof(imxmd->v4l2_dev.name));
>>   
>>
> Regards,
>
> 	Hans

