Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2JHHXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 03:23:08 -0400
Date: Mon, 8 Oct 2012 09:23:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>
Subject: Re: [PATCH 2/2] V4L: soc_camera: disable I2C subdev streamon for
 mpc52xx_csi
In-Reply-To: <20121005174231.32119433@wker>
Message-ID: <Pine.LNX.4.64.1210051759080.13761@axis700.grange>
References: <1348822255-30875-1-git-send-email-agust@denx.de>
 <1348822255-30875-2-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1210030001440.15778@axis700.grange> <20121005151803.248b9480@wker>
 <Pine.LNX.4.64.1210051605070.13761@axis700.grange> <20121005174231.32119433@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Oct 2012, Anatolij Gustschin wrote:

> On Fri, 5 Oct 2012 16:31:58 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Hi Anatolij
> > 
> > On Fri, 5 Oct 2012, Anatolij Gustschin wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > On Wed, 3 Oct 2012 00:09:29 +0200 (CEST)
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > 
> > > > Hi Anatolij
> > > > 
> > > > > > > +#if !defined(CONFIG_VIDEO_MPC52xx_CSI) && \
> > > > > > > +    !defined(CONFIG_VIDEO_MPC52xx_CSI_MODULE)
> > > > > > 
> > > > > > No, we're not adding any preprocessor or run-time hardware dependencies to 
> > > > > > soc-camera or to any other generic code. I have no idea what those "IFM 
> > > > > > O2D" cameras are. If it's their common feature, that they cannot take any 
> > > > > > further I2C commands, while streaming, their drivers have to do that 
> > > > > > themselves.
> > > > > 
> > > > > I'm not sure I understand you. To do what themselves?
> > > > 
> > > > They - subdevice drivers of such IFM O2D cameras - should take care to avoid 
> > > > any I2C commands during a running read-out. Neither the bridge driver nor 
> > > > the framework core can or should know these details. This is just a generic 
> > > > call to a subdevice's .s_stream() method. What the driver does in it is 
> > > > totally its own business. Nobody says, that you have to issue I2C commands 
> > > > in it.
> > 
> > Unfortunately you still haven't explained what "IFM O2D" cameras are and 
> > why they have that I2C command restriction.
> 
> This is not true. I did. And I did it even _before_ anyone has asked me to
> explain it. Please read the commit log of this patch again.

I did. It tells about the specific implementation, that you worked with, 
but I have no idea, whether that's a definition of an "O2D camera" or just 
your specific case. So, is an O2D camera a sensor, like mt9v022 + "special 
glue logic" to connect it to the LocalPlus bus?

> > > The fact that many I2C commands are permitted during streaming doesn't 
> > > necessary mean that an application must use them during streaming. Our 
> > > camera application is aware of I2C bus access limitations during steaming 
> > > and after streamon it doesn't use configurations resulting in I2C accesses
> > > to the sensor. But I'm not arguing for the ifdef here.
> > 
> > But that's the only thing, that your patch is doing. So, this patch can be 
> > dropped?
> 
> Only if there will be another possibility to isolate I2C access after
> streamon. Otherwise the capturing won't work.
> 
> > > We are using mt9v022
> > > subdevice driver and I'd really avoid creating new custom subdevice driver, 
> > > duplicating the mt9v022 driver functionality. This custom duplicated driver 
> > > also won't be accepted in mainline, I think.
> > 
> > Correct.
> > 
> > > I was thinking about a proposal 
> > > for adding I2C bus access limitation awareness to the mt9v022 subdev driver.
> > 
> > I think I begin to understand. This is exactly why you need the snapshot 
> > mode in mt9v022, right?
> 
> No! Not only. There are many different requirements for industrial camera
> applications. I.e. one requirement is to trigger a single frame on some
> external event and to capture exactly this triggered frame. Streaming mode
> is not suitable here.

I understand this, but your specific case is this your LocalPlus bus + 
glue, which can only operate the attached sensor in the snapshot mode, 
triggering each signle frame, using a chip-select pin.

But it doesn't matter indeed in this case. Important is, that we have a 
valid use case and we have to make it work.

Let's think how this snapshot mode is different from the "normal" 
streaming mode. The obvious difference is the sensor (mt9v022) 
configuration. So, our "switch to snapshot mode" command must have a 
subdevice operation or it has to be a control. Are there any more 
differences? Does the host have to know, that the snapshot mode has been 
activated? In master mode the regularity, at which frames will be arriving 
can change, but do hosts care? Most anyway work asynchronously, listening 
to sync signals. However, in slave mode the host will have to be 
synchronised with the trigger signal. I don't know, whether we have any 
active slave-mode set ups, i.e. whether we should care about those.

In either case, this should be a proper configuration option, so far I 
don't see why a control should not suffice.

> > And in your camera host driver you issue a 
> > "stream-off" command on stream-on to switch into the snapshot mode, then 
> > you have to suppress the stream-on in soc-camera core. If I understand 
> > correctly, then this is broken. Your host driver will stop streaming on 
> > all sensor drivers and the ifdef will suppress the streamon from the 
> > soc-camera core, so, your host driver will only work on this specific 
> > board, where you have to use the snapshot mode on mt9v022.
> 
> What is wrong with this? Nothing is broken at all. This host driver is
> written for this specific board family and is not used on other boards.
> It cannot be used on other boards at all since these do not provide
> needed sensor glue logic. Even if other sensor drivers should ever be
> used on this board (most probably it will never be the case), they have
> to be used in snapshot mode anyway.

Hm, ok, if you're willing to maintain a driver in the mainline, that is 
only used on 1 family of boards - no problem with me. Still, I don't want 
it to look like a hack, e.g. calling streamoff in place of a streamon. So, 
we still need to extend the mt9v022 driver to explicitly support the 
snapshot mode, in which it will not switch to the streaming mode on 
streamon. And I think this should be a run-time operation, because 
eventually it can be used to switch between preview and taking single 
externally-triggered snapshots.

Thanks
Guennadi

> > The proper solution, as I already suggested before, would be to implement 
> > a snapshot mode support. In that case the mt9v022 driver will be aware, 
> > that it has to work in the snapshot mode and will not switch over into the 
> > streaming mode.
> > 
> > This topic has been raised several times on the mailing list, but until 
> > now nobody had a real need for a snapshot mode. The easiest way to do this 
> > would be to add a camera class control, however, I suspect, this is a much 
> > more complex topic, see, e.g. this recent thread:
> > 
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/54079
> > 
> > Maybe you could review that thread and reply to it with your requirements?
> 
> I did already read this thread partially. Unfortunately I do not have time
> for it now, maybe later.
> 
> Thanks,
> Anatolij

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
