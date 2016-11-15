Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:17807 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934871AbcKOBhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 20:37:40 -0500
Message-ID: <1479173856.932.1.camel@mtksdaap41>
Subject: Re: [PATCH] [media] mtk-mdp: allocate video_device dynamically
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Tue, 15 Nov 2016 09:37:36 +0800
In-Reply-To: <d21cd419-e1fc-4d2e-a2a9-74c535865762@xs4all.nl>
References: <1478522529-57129-1-git-send-email-minghsiu.tsai@mediatek.com>
         <1478522529-57129-2-git-send-email-minghsiu.tsai@mediatek.com>
         <d21cd419-e1fc-4d2e-a2a9-74c535865762@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-11-11 at 11:51 +0100, Hans Verkuil wrote:
> Almost correct:
> 
> On 11/07/2016 01:42 PM, Minghsiu Tsai wrote:
> > It can fix known problems with embedded video_device structs.
> > 
> > Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> > ---
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  2 +-
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 33 ++++++++++++++++-----------
> >  2 files changed, 21 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> > index 848569d..ad1cff3 100644
> > --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> > @@ -167,7 +167,7 @@ struct mtk_mdp_dev {
> >  	struct mtk_mdp_comp		*comp[MTK_MDP_COMP_ID_MAX];
> >  	struct v4l2_m2m_dev		*m2m_dev;
> >  	struct list_head		ctx_list;
> > -	struct video_device		vdev;
> > +	struct video_device		*vdev;
> >  	struct v4l2_device		v4l2_dev;
> >  	struct workqueue_struct		*job_wq;
> >  	struct platform_device		*vpu_dev;
> > diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > index 9a747e7..b8dee1c 100644
> > --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> > @@ -1236,16 +1236,22 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
> >  	int ret;
> >  
> >  	mdp->variant = &mtk_mdp_default_variant;
> > -	mdp->vdev.device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > -	mdp->vdev.fops = &mtk_mdp_m2m_fops;
> > -	mdp->vdev.ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
> > -	mdp->vdev.release = video_device_release_empty;
> > -	mdp->vdev.lock = &mdp->lock;
> > -	mdp->vdev.vfl_dir = VFL_DIR_M2M;
> > -	mdp->vdev.v4l2_dev = &mdp->v4l2_dev;
> > -	snprintf(mdp->vdev.name, sizeof(mdp->vdev.name), "%s:m2m",
> > +	mdp->vdev = video_device_alloc();
> > +	if (!mdp->vdev) {
> > +		dev_err(dev, "failed to allocate video device\n");
> > +		ret = -ENOMEM;
> > +		goto err_video_alloc;
> > +	}
> > +	mdp->vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > +	mdp->vdev->fops = &mtk_mdp_m2m_fops;
> > +	mdp->vdev->ioctl_ops = &mtk_mdp_m2m_ioctl_ops;
> > +	mdp->vdev->release = video_device_release;
> > +	mdp->vdev->lock = &mdp->lock;
> > +	mdp->vdev->vfl_dir = VFL_DIR_M2M;
> > +	mdp->vdev->v4l2_dev = &mdp->v4l2_dev;
> > +	snprintf(mdp->vdev->name, sizeof(mdp->vdev->name), "%s:m2m",
> >  		 MTK_MDP_MODULE_NAME);
> > -	video_set_drvdata(&mdp->vdev, mdp);
> > +	video_set_drvdata(mdp->vdev, mdp);
> >  
> >  	mdp->m2m_dev = v4l2_m2m_init(&mtk_mdp_m2m_ops);
> >  	if (IS_ERR(mdp->m2m_dev)) {
> > @@ -1254,26 +1260,27 @@ int mtk_mdp_register_m2m_device(struct mtk_mdp_dev *mdp)
> >  		goto err_m2m_init;
> >  	}
> >  
> > -	ret = video_register_device(&mdp->vdev, VFL_TYPE_GRABBER, 2);
> > +	ret = video_register_device(mdp->vdev, VFL_TYPE_GRABBER, 2);
> >  	if (ret) {
> >  		dev_err(dev, "failed to register video device\n");
> >  		goto err_vdev_register;
> >  	}
> >  
> >  	v4l2_info(&mdp->v4l2_dev, "driver registered as /dev/video%d",
> > -		  mdp->vdev.num);
> > +		  mdp->vdev->num);
> >  	return 0;
> >  
> >  err_vdev_register:
> >  	v4l2_m2m_release(mdp->m2m_dev);
> >  err_m2m_init:
> > -	video_device_release(&mdp->vdev);
> > +	video_unregister_device(mdp->vdev);
> 
> This should remain video_device_release: the video_register_device call failed, so
> the device hasn't been registered. In that case just release the device (i.e.
> free the allocated memory).
> 
Hi Hans,

I have uploaded patch v2 for this. Thanks for your review.


Best regards,
Ming Hsiu

> > +err_video_alloc:
> >  
> >  	return ret;
> >  }
> >  
> >  void mtk_mdp_unregister_m2m_device(struct mtk_mdp_dev *mdp)
> >  {
> > -	video_device_release(&mdp->vdev);
> > +	video_unregister_device(mdp->vdev);
> >  	v4l2_m2m_release(mdp->m2m_dev);
> >  }
> > 
> 
> Regards,
> 
> 	Hans


