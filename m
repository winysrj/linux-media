Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3ETMAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 08:00:06 -0400
Date: Mon, 20 May 2013 14:00:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] soc_camera/sh_mobile_csi2: Remove redundant
 platform_set_drvdata()
In-Reply-To: <CAK9yfHxOpoNFoTV6LkqTJGAL_K4R7n5e4ke0Cw-WeceWZ6MK_Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1305201359390.25754@axis700.grange>
References: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
 <CAK9yfHxOpoNFoTV6LkqTJGAL_K4R7n5e4ke0Cw-WeceWZ6MK_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 May 2013, Sachin Kamat wrote:

> On 13 May 2013 14:49, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
> > driver is bound) removes the need to set driver data field to
> > NULL.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, both queued for 3.11.

Guennadi

> > ---
> >  drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > index 09cb4fc..13a1f8f 100644
> > --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> > @@ -340,18 +340,13 @@ static int sh_csi2_probe(struct platform_device *pdev)
> >         ret = v4l2_device_register_subdev(pdata->v4l2_dev, &priv->subdev);
> >         dev_dbg(&pdev->dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
> >         if (ret < 0)
> > -               goto esdreg;
> > +               return ret;
> >
> >         pm_runtime_enable(&pdev->dev);
> >
> >         dev_dbg(&pdev->dev, "CSI2 probed.\n");
> >
> >         return 0;
> > -
> > -esdreg:
> > -       platform_set_drvdata(pdev, NULL);
> > -
> > -       return ret;
> >  }
> >
> >  static int sh_csi2_remove(struct platform_device *pdev)
> > @@ -360,7 +355,6 @@ static int sh_csi2_remove(struct platform_device *pdev)
> >
> >         v4l2_device_unregister_subdev(&priv->subdev);
> >         pm_runtime_disable(&pdev->dev);
> > -       platform_set_drvdata(pdev, NULL);
> >
> >         return 0;
> >  }
> > --
> > 1.7.9.5
> >
> 
> Ping...
> 
> -- 
> With warm regards,
> Sachin
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
