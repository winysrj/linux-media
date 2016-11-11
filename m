Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47411 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751606AbcKKKwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 05:52:08 -0500
Subject: Re: [PATCH] [media] mtk-mdp: allocate video_device dynamically
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
References: <1478522529-57129-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1478522529-57129-2-git-send-email-minghsiu.tsai@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d21cd419-e1fc-4d2e-a2a9-74c535865762@xs4all.nl>
Date: Fri, 11 Nov 2016 11:51:57 +0100
MIME-Version: 1.0
In-Reply-To: <1478522529-57129-2-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Almost correct:

On 11/07/2016 01:42 PM, Minghsiu Tsai wrote:
> It can fix known problems with embedded video_device structs.
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  2 +-
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 33 ++++++++++++++++-----------
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> index 848569d..ad1cff3 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> @@ -167,7 +167,7 @@ struct mtk_mdp_dev {
>  	struct mtk_mdp_comp		*comp[MTK_MDP_COMP_ID_MAX];
>  	struct v4l2_m2m_dev		*m2m_dev;
>  	struct list_head		ctx_list;
> -	struct video_device		vdev;
> +	struct video_device		*vdev;
>  	struct v4l2_device		v4l2_dev;
>  	struct workqueue_struct		*job_wq;
>  	struct platform_device		*vpu_dev;
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> index 9a747e7..b8dee1c 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> @@ -1236,16 +1236,22 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
>  	int ret;
>  
>  	mdp->variant = &mtk_mdp_default_variant;
> -	mdp->vdev.device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> -	mdp->vdev.fops = &mtk_mdp_m2m_fops;
> -	mdp->vdev.ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
> -	mdp->vdev.release = video_device_release_empty;
> -	mdp->vdev.lock = &mdp->lock;
> -	mdp->vdev.vfl_dir = VFL_DIR_M2M;
> -	mdp->vdev.v4l2_dev = &mdp->v4l2_dev;
> -	snprintf(mdp->vdev.name, sizeof(mdp->vdev.name), "%s:m2m",
> +	mdp->vdev = video_device_alloc();
> +	if (!mdp->vdev) {
> +		dev_err(dev, "failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto err_video_alloc;
> +	}
> +	mdp->vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +	mdp->vdev->fops = &mtk_mdp_m2m_fops;
> +	mdp->vdev->ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
> +	mdp->vdev->release = video_device_release;
> +	mdp->vdev->lock = &mdp->lock;
> +	mdp->vdev->vfl_dir = VFL_DIR_M2M;
> +	mdp->vdev->v4l2_dev = &mdp->v4l2_dev;
> +	snprintf(mdp->vdev->name, sizeof(mdp->vdev->name), "%s:m2m",
>  		 MTK_MDP_MODULE_NAME);
> -	video_set_drvdata(&mdp->vdev, mdp);
> +	video_set_drvdata(mdp->vdev, mdp);
>  
>  	mdp->m2m_dev = v4l2_m2m_init(&mtk_mdp_m2m_ops);
>  	if (IS_ERR(mdp->m2m_dev)) {
> @@ -1254,26 +1260,27 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
>  		goto err_m2m_init;
>  	}
>  
> -	ret = video_register_device(&mdp->vdev, VFL_TYPE_GRABBER, 2);
> +	ret = video_register_device(mdp->vdev, VFL_TYPE_GRABBER, 2);
>  	if (ret) {
>  		dev_err(dev, "failed to register video device\n");
>  		goto err_vdev_register;
>  	}
>  
>  	v4l2_info(&mdp->v4l2_dev, "driver registered as /dev/video%d",
> -		  mdp->vdev.num);
> +		  mdp->vdev->num);
>  	return 0;
>  
>  err_vdev_register:
>  	v4l2_m2m_release(mdp->m2m_dev);
>  err_m2m_init:
> -	video_device_release(&mdp->vdev);
> +	video_unregister_device(mdp->vdev);

This should remain video_device_release: the video_register_device call failed, so
the device hasn't been registered. In that case just release the device (i.e.
free the allocated memory).

> +err_video_alloc:
>  
>  	return ret;
>  }
>  
>  void mtk_mdp_unregister_m2m_device(struct mtk_mdp_dev *mdp)
>  {
> -	video_device_release(&mdp->vdev);
> +	video_unregister_device(mdp->vdev);
>  	v4l2_m2m_release(mdp->m2m_dev);
>  }
> 

Regards,

	Hans
