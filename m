Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2JEOcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 10:32:03 -0400
Date: Fri, 5 Oct 2012 16:31:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
In-Reply-To: <20121005151803.248b9480@wker>
Message-ID: <Pine.LNX.4.64.1210051605070.13761@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
 <1348822255-30875-2-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1210030001440.15778@axis700.grange> <20121005151803.248b9480@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anatolij

On Fri, 5 Oct 2012, Anatolij Gustschin wrote:

> Hi Guennadi,
> 
> On Wed, 3 Oct 2012 00:09:29 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Hi Anatolij
> > 
> > > > > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > > > > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> > > > 
> > > > No, we're not adding any preprocessor or run-time hardware dependencies to 
> > > > soc-camera or to any other generic code. I have no idea what those "IFM 
> > > > O2D" cameras are. If it's their common feature, that they cannot take any 
> > > > further I2C commands, while streaming, their drivers have to do that 
> > > > themselves.
> > > 
> > > I'm not sure I understand you. To do what themselves?
> > 
> > They - subdevice drivers of such IFM O2D cameras - should take care to avoid 
> > any I2C commands during a running read-out. Neither the bridge driver nor 
> > the framework core can or should know these details. This is just a generic 
> > call to a subdevice's .s_stream() method. What the driver does in it is 
> > totally its own business. Nobody says, that you have to issue I2C commands 
> > in it.

Unfortunately you still haven't explained what "IFM O2D" cameras are and 
why they have that I2C command restriction. Or - looking at the keyboard - 
is O2D just a typo and it should have been I2C?

> The fact that many I2C commands are permitted during streaming doesn't 
> necessary mean that an application must use them during streaming. Our 
> camera application is aware of I2C bus access limitations during steaming 
> and after streamon it doesn't use configurations resulting in I2C accesses
> to the sensor. But I'm not arguing for the ifdef here.

But that's the only thing, that your patch is doing. So, this patch can be 
dropped?

> We are using mt9v022
> subdevice driver and I'd really avoid creating new custom subdevice driver, 
> duplicating the mt9v022 driver functionality. This custom duplicated driver 
> also won't be accepted in mainline, I think.

Correct.

> I was thinking about a proposal 
> for adding I2C bus access limitation awareness to the mt9v022 subdev driver.

I think I begin to understand. This is exactly why you need the snapshot 
mode in mt9v022, right? And in your camera host driver you issue a 
"stream-off" command on stream-on to switch into the snapshot mode, then 
you have to suppress the stream-on in soc-camera core. If I understand 
correctly, then this is broken. Your host driver will stop streaming on 
all sensor drivers and the ifdef will suppress the streamon from the 
soc-camera core, so, your host driver will only work on this specific 
board, where you have to use the snapshot mode on mt9v022.

The proper solution, as I already suggested before, would be to implement 
a snapshot mode support. In that case the mt9v022 driver will be aware, 
that it has to work in the snapshot mode and will not switch over into the 
streaming mode.

This topic has been raised several times on the mailing list, but until 
now nobody had a real need for a snapshot mode. The easiest way to do this 
would be to add a camera class control, however, I suspect, this is a much 
more complex topic, see, e.g. this recent thread:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/54079

Maybe you could review that thread and reply to it with your requirements?

Thanks
Guennadi

> In our case we enable the snapshot mode by calling subdevice's .s_stream()
> in the .start_streaming() of the capture driver (that means as part of 
> vb2_streamon() in soc_camera_streamon()) and then configure the logic
> for read-out there. Here is the relevant part from soc_camera_streamon():
> 
>         if (ici->ops->init_videobuf)
>                 ret = videobuf_streamon(&icd->vb_vidq);
>         else
>                 ret = vb2_streamon(&icd->vb2_vidq, i);
>  
> After that I2C access is not possible until .stop_streaming() in the capture 
> driver. After enabling streaming in .s_stream() the subdevice driver will have 
> to filter (optionaly) further I2C accesses and return success code for them so 
> that soc_camera_streamon() finaly succeeds. Currently the return code of
> s_stream v4l2_subdev_call() is not checked:
> 
>         if (!ret)
>                 v4l2_subdev_call(sd, video, s_stream, 1);
> 
> But for the case it will be fixed, we have to return success code in s_stream, 
> at least. Otherwise VIDIOC_STREAMON will fail.
> 
> Will you accept adding optional I2C access filtering to the mt9v022 subdev 
> driver?
> 
> Thanks,
> Anatolij
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
