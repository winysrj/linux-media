Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaAVHPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 02:15:24 -0500
Date: Wed, 22 Jan 2014 08:15:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bryan Wu <cooloney@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: A question about DT support for soc_camera
In-Reply-To: <CAK5ve-KXEFr+bTmC=4Pubo7++R=uSsqRFLgAOvka0L5ikksujw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1401220754490.2996@axis700.grange>
References: <CAK5ve-LbvQACmaZC4gFBf=Ca_nwp7KvvT+dLBhbipxRdLFYonw@mail.gmail.com>
 <Pine.LNX.4.64.1401162337210.11956@axis700.grange>
 <CAK5ve-KXEFr+bTmC=4Pubo7++R=uSsqRFLgAOvka0L5ikksujw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Tue, 21 Jan 2014, Bryan Wu wrote:

> On Thu, Jan 16, 2014 at 3:04 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Bryan,
> >
> > On Wed, 15 Jan 2014, Bryan Wu wrote:
> >
> >> Hi Guennadi,
> >>
> >> I'm working on upstream our Tegra soc_camera host driver. But found
> >> the soc_camera framework is not fully supporting Device Tree probing,
> >> am I wrong about that?
> >
> > Mostly correct, yes, currently soc-camera doesn't support device-tree
> > probing.
> >
> >> While in upstream Tegra kernel, we only support
> >> DT probing and there is no board files.
> >>
> >> Current soc_camera framework needs to put soc_camera_link information
> >> in a board file and build up soc-camera-pdrv platform_device, then
> >> finally register this soc-camera-pdrv platform_device.
> >>
> >> For the host driver, we can do DT probing but for i2c soc_camera
> >> sensor driver I failed to find any DT probing in upstream kernel. So
> >> how to do that without an board file but use DT for this whole thing?
> >>
> >> Can we use DT like this?
> >> DTB file will pass those I2C, clock, regulator, GPIO information to
> >> host driver. During host driver DT probing, we dynamically create
> >> soc-camera-pdrv platform_device and soc_camera_link then register
> >> them. Then the rest of the thing should be the same as None-DT
> >> probing.
> >
> > I've worked on soc-camera DT in the past, this might be the last published
> > version
> >
> > http://marc.info/?l=linux-sh&m=134875489304837&w=1
> >
> > As you see, it's quite old. Since then a few things happened. Device tree
> > support has been added to V4L2 (see
> > Documentation/devicetree/bindings/media/video-interfaces.txt and other
> > files in that directory for examples), it is based on asynchronous
> > probing, which is also supported by the soc-camera core and some its
> > host drivers (e.g.
> >
> > commit 4dbfd040757b8bf22f4ac17e80b39c068061a16c
> > Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Date:   Tue Jul 30 02:59:49 2013 -0300
> >
> >     [media] V4L2: mx3_camera: add support for asynchronous subdevice registration
> >
> > ). So, what you should do, is add asynchronous probing support to your
> > driver, add DT support to the soc-camera core, add it to your drivers.
> > Also see drivers/media/v4l2-core/v4l2-of.c for helper functions, you
> > should be using.
> >
> 
> Great, Guennadi. I will start to help to add DT for soc-camera.
> 
> But one more question is how to add DT support for soc-camera sensor
> driver? For sensor driver, we need pass those regulator/gpio/clock
> information for power on/off operations. If we add I2C device node in
> DTS file to pass those settings to driver, driver will be
> automatically loaded and start to probing. But I think loading
> soc_camera sensor driver should be done by soc_camera core code during
> host driver registering. Any suggestions to solve this problem?

As I mentioned above, DT support in V4L2 is based on asynchronous probing 
patches, which allow exactly this - probing (I2C) sensors and (platform) 
hosts independently and asynchronously. If such a sensor is probed and 
some of its dependencies are missing (e.g. a master clock, normally 
provided by the camera host interface), the driver can return 
-EPROBE_DEFER and will be reprobed later, hopefully when resources are 
already there. After a successful probing such a sensor driver, supporting 
asynchronous probing, calls v4l2_async_register_subdev(). After the 
respective host registers with the async framework, its notifier will be 
called to inform it of your sensor presence. See drivers, listed by

grep -rl v4l2_async_register_subdev drivers/media/i2c/

for examples.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
