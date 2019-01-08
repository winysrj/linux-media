Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D25C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6B820850
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfAHN0q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:26:46 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42300 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727980AbfAHN0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 08:26:45 -0500
Received: from [IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231] ([IPv6:2001:420:44c1:2579:e5a0:705e:8afb:6231])
        by smtp-cloud8.xs4all.net with ESMTPA
        id grOwgXMyFNR5ygrP0gzSFx; Tue, 08 Jan 2019 14:26:43 +0100
Subject: Re: [PATCH] media: imx: queue subdev events to reachable video
 devices
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181209195722.26858-1-steve_longerbeam@mentor.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2bd52738-f466-96d8-5877-aab96a129e74@xs4all.nl>
Date:   Tue, 8 Jan 2019 14:26:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181209195722.26858-1-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDwlDzP+GrXe9IXkkz7HS4rwGxtnrCNKUH0e/DFrr3SxrQlnfzCtJMiQM1QgWczTUzfe3Yde432tduJlBj/2J1qU0nLKcn2Mkr+D+xIdc9iS3pARZmxe
 QFQB81D4UJLMRiHp2u9scCvrYTTpuTF8wQNP0lt/9JqHU/Nr8WjANPuyuxJRDKRfcHJ4wGCV52ceMfhnDMuSYRTpbLIKPf1QWuyCnMEnflImjoLBtbu0Enkv
 ofGUh3DV6ShLQgjuG16dKtp8ara/ULn8y2alOdPcNxaXgdRfByg4zBb0bOCt7vgKo7dnWvs/WFlRgnM6yMGikbYSQ9KCg80VbsMb7JBfRd1KHIwqS6cfpC0o
 F5VJ0JXQ8dNwydwfEH7LqrVbrhBVrfROVtJVydrDSdzoe65zY6ZCqQr/OMluBdiFCIfU2LKTp2CbxLNOXBtoD+a+Qd9vC0ro9Ql+ID90e/W+wlINNKwTDCBL
 KhgG/FkvfVjeNfdIzdJb1uPRX3veUgVSLtHYAA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/09/18 20:57, Steve Longerbeam wrote:
> From: Steve Longerbeam <slongerbeam@gmail.com>
> 
> Forward events from a sub-device to its list of reachable video
> devices.
> 
> Note this will queue the event to a video device even if there is
> no actual _enabled_ media path from the sub-device to the video device.
> So a future improvement is to skip the video device if there is no enabled
> path to it from the sub-device. The entity->pipe pointer can't be
> used for this check because in imx-media a sub-device can be a
> member to more than one streaming pipeline at a time.

You explain what you are doing, but I am missing an explanation of *why*
this is needed.

> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/staging/media/imx/imx-media-capture.c | 18 ++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c     | 24 +++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index b37e1186eb2f..4dfbe05d203e 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -335,6 +335,21 @@ static int capture_s_parm(struct file *file, void *fh,
>  	return 0;
>  }
>  
> +static int capture_subscribe_event(struct v4l2_fh *fh,
> +				   const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR:
> +		return v4l2_event_subscribe(fh, sub, 0, NULL);
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subscribe(fh, sub);
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subscribe_event(fh, sub);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>  	.vidioc_querycap	= vidioc_querycap,
>  
> @@ -362,6 +377,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>  	.vidioc_expbuf		= vb2_ioctl_expbuf,
>  	.vidioc_streamon	= vb2_ioctl_streamon,
>  	.vidioc_streamoff	= vb2_ioctl_streamoff,
> +
> +	.vidioc_subscribe_event = capture_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };

This part of the patch adds event support to the capture device, can't this be
split up into a separate patch? It seems to be useful in its own right.

>  
>  /*
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 4b344a4a3706..25e916562c66 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -442,6 +442,29 @@ static const struct media_device_ops imx_media_md_ops = {
>  	.link_notify = imx_media_link_notify,
>  };
>  
> +static void imx_media_notify(struct v4l2_subdev *sd,
> +			     unsigned int notification,
> +			     void *arg)
> +{
> +	struct media_entity *entity = &sd->entity;
> +	int i;
> +
> +	if (notification != V4L2_DEVICE_NOTIFY_EVENT)
> +		return;
> +
> +	for (i = 0; i < entity->num_pads; i++) {
> +		struct media_pad *pad = &entity->pads[i];
> +		struct imx_media_pad_vdev *pad_vdev;
> +		struct list_head *pad_vdev_list;
> +
> +		pad_vdev_list = to_pad_vdev_list(sd, pad->index);
> +		if (!pad_vdev_list)
> +			continue;
> +		list_for_each_entry(pad_vdev, pad_vdev_list, list)
> +			v4l2_event_queue(pad_vdev->vdev->vfd, arg);

Which events do you want to forward? E.g. forwarding control events
doesn't seem right, but other events may be useful. Are those events
also appearing on the v4l-subdevX device? And if so, should they?

> +	}
> +}
> +
>  static int imx_media_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -462,6 +485,7 @@ static int imx_media_probe(struct platform_device *pdev)
>  	mutex_init(&imxmd->mutex);
>  
>  	imxmd->v4l2_dev.mdev = &imxmd->md;
> +	imxmd->v4l2_dev.notify = imx_media_notify;
>  	strscpy(imxmd->v4l2_dev.name, "imx-media",
>  		sizeof(imxmd->v4l2_dev.name));
>  
> 

Regards,

	Hans
