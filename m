Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33143 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752965Ab0BHTdM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 14:33:12 -0500
Date: Mon, 8 Feb 2010 20:33:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] MT9T031: write xskip and yskip at each set_params call
In-Reply-To: <4B705B5E.8060605@epfl.ch>
Message-ID: <Pine.LNX.4.64.1002082014170.4936@axis700.grange>
References: <1264013696-11315-1-git-send-email-valentin.longchamp@epfl.ch>
 <Pine.LNX.4.64.1001202010190.4151@axis700.grange> <4B580FE8.8080203@epfl.ch>
 <Pine.LNX.4.64.1002041514490.19438@axis700.grange> <4B705B5E.8060605@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Val

On Mon, 8 Feb 2010, Valentin Longchamp wrote:

> > /*
> >  * Power Management:
> >  * This function does nothing for now but must be present for pm to work
> >  */
> > static int mt9t031_runtime_suspend(struct device *dev)
> > {
> > 	return 0;
> > }
> 
> First, can you confirm me that this function is needed even if it does nothing
> ? I have read in the code that if the function is not present,
> __pm_runtime_suspend is going to return -ENOSYS and will set runtime_status to
> RPM_ACTIVE, which is not what we want. That's why I left it.

Yes, I think, you're right - if neither bus, nor type, nor class suspend 
is debined, -ENOSYS is returned (see __pm_runtime_suspend()).

> > /*
> >  * Power Management:
> >  * COLUMN_ADDRESS_MODE and ROW_ADDRESS_MODE are not rewritten if unchanged
> >  * they are however changed at reset if the platform hook is present
> >  * thus we rewrite them with the values stored by the driver
> >  */
> > static int mt9t031_runtime_resume(struct device *dev)
> > {
> > 	struct video_device *vdev = to_video_device(dev);
> > 	struct soc_camera_device *icd = container_of(vdev->parent,
> > 		struct soc_camera_device, dev);
> > 	struct device *i2c_dev = container_of(icd, struct device,
> > platform_data);
> > 	struct i2c_client *client = to_i2c_client(i2c_dev);
> > 	struct mt9t031 *mt9t031 = to_mt9t031(client);
> 
> Here I have a problem ... I am pretty sure that the third assignation has a
> problem, because platform_data is a pointer and not a normal member of struct
> device, and I thus cannot use container_of with it. What would then be the way
> to go from the soc_camera_device to the i2c_client (I'm a little bit confused
> with all the different structs and layers involved with i2c, soc-camera,
> v4l2_device and v4l2_subdevice) ?

	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
	struct i2c_client *client = sd->priv;

> Just as a remark, this is the exact reverse
> path of this that is present in your patch to add runtime pm support to
> soc-camera:
> 
> /* This is only temporary here - until v4l2-subdev begins to link to
> video_device */
> #include <linux/i2c.h>
> static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client
> *client)
> {
> 	struct soc_camera_device *icd = client->dev.platform_data;
> 	return icd->vdev;
> }
> 
> > 
> > 	int ret;
> > 	u16 xbin, ybin;
> > 
> > 	xbin = min(mt9t031->xskip, (u16)3);
> > 	ybin = min(mt9t031->yskip, (u16)3);
> > 
> > 	ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
> > 		((xbin-1)<<4) | (mt9t031->xskip-1));
> > 	if (ret < 0)
> > 		return ret;
> > 
> > 	ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
> > 		((ybin-1)<<4) | (mt9t031->yskip-1));
> > 	if (ret < 0)
> > 		return ret;
> > 
> > 	return 0;
> > }
> > 
> > static struct dev_pm_ops mt9t031_dev_pm_ops = {
> > 	.runtime_suspend	= mt9t031_runtime_suspend,
> > 	.runtime_resume		= mt9t031_runtime_resume,
> > };
> > 
> > static struct device_type mt9t031_dev_type = {
> > 	.name	= "MT9T031",
> > 	.pm	= &mt9t031_dev_pm_ops,
> > };
> 
> Thank you in advance for your help.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
