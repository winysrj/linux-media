Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:47892 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2JEPmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:42:47 -0400
Date: Fri, 5 Oct 2012 17:42:31 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
Message-ID: <20121005174231.32119433@wker>
In-Reply-To: <Pine.LNX.4.64.1210051605070.13761@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
	<1348822255-30875-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1210030001440.15778@axis700.grange>
	<20121005151803.248b9480@wker>
	<Pine.LNX.4.64.1210051605070.13761@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Oct 2012 16:31:58 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Anatolij
> 
> On Fri, 5 Oct 2012, Anatolij Gustschin wrote:
> 
> > Hi Guennadi,
> > 
> > On Wed, 3 Oct 2012 00:09:29 +0200 (CEST)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > > Hi Anatolij
> > > 
> > > > > > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > > > > > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> > > > > 
> > > > > No, we're not adding any preprocessor or run-time hardware dependencies to 
> > > > > soc-camera or to any other generic code. I have no idea what those "IFM 
> > > > > O2D" cameras are. If it's their common feature, that they cannot take any 
> > > > > further I2C commands, while streaming, their drivers have to do that 
> > > > > themselves.
> > > > 
> > > > I'm not sure I understand you. To do what themselves?
> > > 
> > > They - subdevice drivers of such IFM O2D cameras - should take care to avoid 
> > > any I2C commands during a running read-out. Neither the bridge driver nor 
> > > the framework core can or should know these details. This is just a generic 
> > > call to a subdevice's .s_stream() method. What the driver does in it is 
> > > totally its own business. Nobody says, that you have to issue I2C commands 
> > > in it.
> 
> Unfortunately you still haven't explained what "IFM O2D" cameras are and 
> why they have that I2C command restriction.

This is not true. I did. And I did it even _before_ anyone has asked me to
explain it. Please read the commit log of this patch again.

> > The fact that many I2C commands are permitted during streaming doesn't 
> > necessary mean that an application must use them during streaming. Our 
> > camera application is aware of I2C bus access limitations during steaming 
> > and after streamon it doesn't use configurations resulting in I2C accesses
> > to the sensor. But I'm not arguing for the ifdef here.
> 
> But that's the only thing, that your patch is doing. So, this patch can be 
> dropped?

Only if there will be another possibility to isolate I2C access after
streamon. Otherwise the capturing won't work.

> > We are using mt9v022
> > subdevice driver and I'd really avoid creating new custom subdevice driver, 
> > duplicating the mt9v022 driver functionality. This custom duplicated driver 
> > also won't be accepted in mainline, I think.
> 
> Correct.
> 
> > I was thinking about a proposal 
> > for adding I2C bus access limitation awareness to the mt9v022 subdev driver.
> 
> I think I begin to understand. This is exactly why you need the snapshot 
> mode in mt9v022, right?

No! Not only. There are many different requirements for industrial camera
applications. I.e. one requirement is to trigger a single frame on some
external event and to capture exactly this triggered frame. Streaming mode
is not suitable here.

> And in your camera host driver you issue a 
> "stream-off" command on stream-on to switch into the snapshot mode, then 
> you have to suppress the stream-on in soc-camera core. If I understand 
> correctly, then this is broken. Your host driver will stop streaming on 
> all sensor drivers and the ifdef will suppress the streamon from the 
> soc-camera core, so, your host driver will only work on this specific 
> board, where you have to use the snapshot mode on mt9v022.

What is wrong with this? Nothing is broken at all. This host driver is
written for this specific board family and is not used on other boards.
It cannot be used on other boards at all since these do not provide
needed sensor glue logic. Even if other sensor drivers should ever be
used on this board (most probably it will never be the case), they have
to be used in snapshot mode anyway.

> The proper solution, as I already suggested before, would be to implement 
> a snapshot mode support. In that case the mt9v022 driver will be aware, 
> that it has to work in the snapshot mode and will not switch over into the 
> streaming mode.
> 
> This topic has been raised several times on the mailing list, but until 
> now nobody had a real need for a snapshot mode. The easiest way to do this 
> would be to add a camera class control, however, I suspect, this is a much 
> more complex topic, see, e.g. this recent thread:
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/54079
> 
> Maybe you could review that thread and reply to it with your requirements?

I did already read this thread partially. Unfortunately I do not have time
for it now, maybe later.

Thanks,
Anatolij
