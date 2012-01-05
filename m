Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2AEKXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 05:23:41 -0500
Date: Thu, 5 Jan 2012 11:23:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <Pine.LNX.4.64.1201042152130.30506@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201051119320.23644@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <201201041801.08322.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1201041808260.30506@axis700.grange>
 <201201042147.49921.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1201042152130.30506@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Jan 2012, Guennadi Liakhovetski wrote:

> On Wed, 4 Jan 2012, Laurent Pinchart wrote:
> 
> > On Wednesday 04 January 2012 18:13:58 Guennadi Liakhovetski wrote:
> > > On Wed, 4 Jan 2012, Laurent Pinchart wrote:
> > > > On Wednesday 04 January 2012 17:35:27 Guennadi Liakhovetski wrote:
> > > > > On Wed, 4 Jan 2012, javier Martin wrote:
> > > > > 
> > > > > [snip]
> > > > > 
> > > > > > For ov7725 it is a natural thing to do since it was originally
> > > > > > developed for soc-camera and it can easily do the following to access
> > > > > > platform data:
> > > > > > 
> > > > > > struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
> > > > > > pdata = icl->priv;
> > > > > > 
> > > > > > However, tvp5150 is not aware about soc_camera. I should be able to
> > > > > > tell whether it's being used with soc-camera or not. If soc camera
> > > > > > was used I would do the previous method to retrieve platform data.
> > > > > > But if soc-camera was not used I would do the classic method:
> > > > > > 
> > > > > > struct tvp5150_platform_data *pdata = client->dev.platform_data;
> > > > > > 
> > > > > > The problem is how to distinguish in tvp5150 whether I am using
> > > > > > soc_camera or not.
> > > > > 
> > > > > Right, that _is_ the problem now. And we've known about it since the
> > > > > very first time we started to think about re-using the subdev drivers.
> > > > > The only solution I see so far is to introduce a standard platform
> > > > > data struct for all subdevices, similar to soc_camera_link. We could
> > > > > use it as a basis, of course, use a generic name, maybe reconsider
> > > > > fields - rename / remove / add, but the principle would be the same: a
> > > > > standard platform data struct with an optional private field.
> > > > 
> > > > Why is that needed ? Why can't a tvp5150-specific platform data structure
> > > > do ?
> > > 
> > > Javier has actually explained this already.
> > 
> > Sorry for not having followed.
> > 
> > > Ok, again: he wants to use tvp5150 with an soc-camera host driver, i.e.,
> > > with the soc-camera subsystem. And the soc-camera core sets board_info->
> > > platform_data itself to a pointer to the struct soc_camera_link instance.
> > 
> > That looks to me like it's the part to be changed...
> 
> Well, we could do this, but this would require changing a few soc-camera 
> subdev drivers and respective platforms and (slightly) the core itself.
> 
> The soc-camera core needs access to the struct soc_camera_link instance, 
> supplied by the platform. It is passed in .platform_data of the soc-camera 
> client platform device, there's no need to change that. struct 
> soc_camera_link::board_info points to struct i2c_board_info, this is also 
> ok. Basically, that's all the soc-camera core needs - access to these two 
> structs. Next, subdevice drivers also need access to struct 
> soc_camera_link and to their private data. If we let platforms pass 
> subdevice driver private data in i2c_board_info::platform_data, then each 
> driver will need to invent its own way how to also get to struct 
> soc_camera_link. They would either have to point at it from their private 
> data or embed it therein.
> 
> So, yes, it is doable. AFAICS currently these subdevice drivers
> 
> soc_camera_platform
> rj54n1cb0c
> tw9910
> mt9t112
> ov772x
> 
> and these platforms
> 
> sh/ecovec24
> sh/kfr2r09
> sh/migor
> sh/ap325rxa
> 
> arm/mackerel
> 
> are affected and have to be modified. After which the core can be fixed 
> too. I could do that, but not sure when I find the time. Javier, if you 
> like, feel free to give it a try.

Thinking a bit more about this, looks like the drivers don't have to be 
modified in fact. We just would have to make the reference from 
soc_camera_link::board_info to the specific struct i2c_board_info in 
platform data on the above platforms and remove it from soc_camera.c. This 
would look ugly in platform data, because structs i2c_board_info and 
soc_camera_link would then hold pointers to each other, but it would work.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
