Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34068 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752062AbdHHOof (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 10:44:35 -0400
Date: Tue, 8 Aug 2017 17:44:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4 09/21] media: camss: Add files which handle the video
 device nodes
Message-ID: <20170808144430.d3ljza6bq5r4vpj5@valkosipuli.retiisi.org.uk>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-10-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502199018-28250-10-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Tue, Aug 08, 2017 at 04:30:06PM +0300, Todor Tomov wrote:
...
> +static int video_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct camss_video *video = vb2_get_drv_priv(q);
> +	struct video_device *vdev = &video->vdev;
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	ret = media_pipeline_start(&vdev->entity, &video->pipe);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = video_check_format(video);
> +	if (ret < 0)
> +		goto error;
> +
> +	entity = &vdev->entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;

Could you align starting and stopping the streaming with this patch:

<URL:http://www.spinics.net/lists/linux-media/msg117737.html>

I'll send a pull request on it shortly.

Feel free to postpone for now, this isn't urgent.

> +
> +		pad = media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
> +		if (ret < 0 && ret != -ENOIOCTLCMD)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	media_pipeline_stop(&vdev->entity);
> +
> +	video->ops->flush_buffers(video, VB2_BUF_STATE_QUEUED);
> +
> +	return ret;
> +}
> +
> +static void video_stop_streaming(struct vb2_queue *q)
> +{
> +	struct camss_video *video = vb2_get_drv_priv(q);
> +	struct video_device *vdev = &video->vdev;
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	struct v4l2_subdev *subdev_vfe = NULL;
> +
> +	entity = &vdev->entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		if (strstr(subdev->name, "vfe")) {
> +			subdev_vfe = subdev;
> +		} else if (strstr(subdev->name, "ispif")) {
> +			v4l2_subdev_call(subdev, video, s_stream, 0);
> +			v4l2_subdev_call(subdev_vfe, video, s_stream, 0);
> +		} else {
> +			v4l2_subdev_call(subdev, video, s_stream, 0);
> +		}
> +	}
> +
> +	media_pipeline_stop(&vdev->entity);
> +
> +	video->ops->flush_buffers(video, VB2_BUF_STATE_ERROR);
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
