Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50629 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbeKFJiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 04:38:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id 124-v6so5151063wmw.0
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2018 16:15:55 -0800 (PST)
Subject: Re: [RFC] media: imx: queue subdevice events on the video device in
 the same pipeline
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20181105150349.8882-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ee260dad-0773-bf30-1408-0ec2ebdf0296@gmail.com>
Date: Mon, 5 Nov 2018 16:15:50 -0800
MIME-Version: 1.0
In-Reply-To: <20181105150349.8882-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks, I've been meaning this too. Comments below.


On 11/5/18 7:03 AM, Philipp Zabel wrote:
> While subdevice and video device are in the same pipeline, pass
> subdevice events on to userspace via the video device node.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> This would allow to see source change events from the source subdevice
> on the video device node, for example.
> ---
>   drivers/staging/media/imx/imx-media-dev.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 4b344a4a3706..2fe6fdf2faf1 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -442,6 +442,23 @@ static const struct media_device_ops imx_media_md_ops = {
>   	.link_notify = imx_media_link_notify,
>   };
>   
> +static void imx_media_notify(struct v4l2_subdev *sd, unsigned int notification,
> +			     void *arg)
> +{
> +	struct imx_media_dev *imxmd;
> +	struct imx_media_video_dev *vdev;
> +
> +	imxmd = container_of(sd->v4l2_dev, struct imx_media_dev, v4l2_dev);
> +	list_for_each_entry(vdev, &imxmd->vdev_list, list) {
> +		if (sd->entity.pipe &&
> +		    sd->entity.pipe == vdev->vfd->entity.pipe &&

The problem with this check is that a sensor can be streaming to 
multiple video capture devices simultaneously (to prpenc and prpvf). The 
media framework doesn't support an entity being a member of multiple 
pipelines (there's only one pipe object in 'struct media_entity') so the 
pipe object ends up just pointing to whichever stream was started last 
that included that entity. The result being the event will only get 
queued to whichever video device who's stream was enabled last.

So I think there should be no if statement in the loop. Also it's better 
to loop through the sub-devices vdev_list, because that list contains 
only the video devices reachable from that sub-device. So the function 
should read:

static void imx_media_notify(struct v4l2_subdev *sd,
                  unsigned int notification,
                  void *arg)
{
     struct media_entity *entity = &sd->entity;
     int i;

     if (notification != V4L2_DEVICE_NOTIFY_EVENT)
         return;

     for (i = 0; i < entity->num_pads; i++) {
         struct media_pad *pad = &entity->pads[i];
         struct imx_media_pad_vdev *pad_vdev;
         struct list_head *pad_vdev_list;

         pad_vdev_list = to_pad_vdev_list(sd, pad->index);
         if (!pad_vdev_list)
             continue;
         list_for_each_entry(pad_vdev, pad_vdev_list, list)
             v4l2_event_queue(pad_vdev->vdev->vfd, arg);
     }
}

I posted this to my media-tree fork, see

da05ccab97 ("media: imx: queue subdevice events to the reachable video devices")

and this Note in the commit header:

Note this will queue the event to a video device even if there is
no actual _enabled_ path from the sub-device to the video device.
So a future fix is to skip the video device if there is no enabled
path to it from the sub-device. The entity->pipe pointer can't be
used for this check because in imx-media a sub-device can be a
member to more than one streaming pipeline at a time.


Steve
  

> +		    notification == V4L2_DEVICE_NOTIFY_EVENT) {
> +			v4l2_event_queue(vdev->vfd, arg);
> +			break;
> +		}
> +	}
> +}
> +
>   static int imx_media_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
> @@ -464,6 +481,7 @@ static int imx_media_probe(struct platform_device *pdev)
>   	imxmd->v4l2_dev.mdev = &imxmd->md;
>   	strscpy(imxmd->v4l2_dev.name, "imx-media",
>   		sizeof(imxmd->v4l2_dev.name));
> +	imxmd->v4l2_dev.notify = imx_media_notify;
>   
>   	media_device_init(&imxmd->md);
>   
