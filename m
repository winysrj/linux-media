Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49961 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2JENSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 09:18:18 -0400
Date: Fri, 5 Oct 2012 15:18:03 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
Message-ID: <20121005151803.248b9480@wker>
In-Reply-To: <Pine.LNX.4.64.1210030001440.15778@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
	<1348822255-30875-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1210030001440.15778@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, 3 Oct 2012 00:09:29 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Anatolij
> 
> > > > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > > > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> > > 
> > > No, we're not adding any preprocessor or run-time hardware dependencies to 
> > > soc-camera or to any other generic code. I have no idea what those "IFM 
> > > O2D" cameras are. If it's their common feature, that they cannot take any 
> > > further I2C commands, while streaming, their drivers have to do that 
> > > themselves.
> > 
> > I'm not sure I understand you. To do what themselves?
> 
> They - subdevice drivers of such IFM O2D cameras - should take care to avoid 
> any I2C commands during a running read-out. Neither the bridge driver nor 
> the framework core can or should know these details. This is just a generic 
> call to a subdevice's .s_stream() method. What the driver does in it is 
> totally its own business. Nobody says, that you have to issue I2C commands 
> in it.

The fact that many I2C commands are permitted during streaming doesn't 
necessary mean that an application must use them during streaming. Our 
camera application is aware of I2C bus access limitations during steaming 
and after streamon it doesn't use configurations resulting in I2C accesses
to the sensor. But I'm not arguing for the ifdef here. We are using mt9v022
subdevice driver and I'd really avoid creating new custom subdevice driver, 
duplicating the mt9v022 driver functionality. This custom duplicated driver 
also won't be accepted in mainline, I think. I was thinking about a proposal 
for adding I2C bus access limitation awareness to the mt9v022 subdev driver.

In our case we enable the snapshot mode by calling subdevice's .s_stream()
in the .start_streaming() of the capture driver (that means as part of 
vb2_streamon() in soc_camera_streamon()) and then configure the logic
for read-out there. Here is the relevant part from soc_camera_streamon():

        if (ici->ops->init_videobuf)
                ret = videobuf_streamon(&icd->vb_vidq);
        else
                ret = vb2_streamon(&icd->vb2_vidq, i);
 
After that I2C access is not possible until .stop_streaming() in the capture 
driver. After enabling streaming in .s_stream() the subdevice driver will have 
to filter (optionaly) further I2C accesses and return success code for them so 
that soc_camera_streamon() finaly succeeds. Currently the return code of
s_stream v4l2_subdev_call() is not checked:

        if (!ret)
                v4l2_subdev_call(sd, video, s_stream, 1);

But for the case it will be fixed, we have to return success code in s_stream, 
at least. Otherwise VIDIOC_STREAMON will fail.

Will you accept adding optional I2C access filtering to the mt9v022 subdev 
driver?

Thanks,
Anatolij
