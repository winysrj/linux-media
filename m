Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2ADROG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 12:14:06 -0500
Date: Wed, 4 Jan 2012 18:13:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
In-Reply-To: <201201041801.08322.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1201041808260.30506@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr0FxA72dhkjnVHCiWuT-VGYpcdk6WX9ubWoAnLkm7gnBQ@mail.gmail.com>
 <Pine.LNX.4.64.1201041717130.30506@axis700.grange>
 <201201041801.08322.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Jan 2012, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday 04 January 2012 17:35:27 Guennadi Liakhovetski wrote:
> > On Wed, 4 Jan 2012, javier Martin wrote:
> > 
> > [snip]
> > 
> > > For ov7725 it is a natural thing to do since it was originally
> > > developed for soc-camera and it can easily do the following to access
> > > platform data:
> > > 
> > > struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
> > > pdata = icl->priv;
> > > 
> > > However, tvp5150 is not aware about soc_camera. I should be able to
> > > tell whether it's being used with soc-camera or not. If soc camera was
> > > used I would do the previous method to retrieve platform data.
> > > But if soc-camera was not used I would do the classic method:
> > > 
> > > struct tvp5150_platform_data *pdata = client->dev.platform_data;
> > > 
> > > The problem is how to distinguish in tvp5150 whether I am using
> > > soc_camera or not.
> > 
> > Right, that _is_ the problem now. And we've known about it since the very
> > first time we started to think about re-using the subdev drivers. The only
> > solution I see so far is to introduce a standard platform data struct for
> > all subdevices, similar to soc_camera_link. We could use it as a basis, of
> > course, use a generic name, maybe reconsider fields - rename / remove /
> > add, but the principle would be the same: a standard platform data struct
> > with an optional private field.
> 
> Why is that needed ? Why can't a tvp5150-specific platform data structure do ?

Javier has actually explained this already. Ok, again: he wants to use 
tvp5150 with an soc-camera host driver, i.e., with the soc-camera 
subsystem. And the soc-camera core sets board_info->platform_data itself 
to a pointer to the struct soc_camera_link instance.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
