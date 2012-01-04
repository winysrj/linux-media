Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46200 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab2ADRAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 12:00:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
Date: Wed, 4 Jan 2012 18:01:07 +0100
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com> <CACKLOr0FxA72dhkjnVHCiWuT-VGYpcdk6WX9ubWoAnLkm7gnBQ@mail.gmail.com> <Pine.LNX.4.64.1201041717130.30506@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201041717130.30506@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201041801.08322.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 04 January 2012 17:35:27 Guennadi Liakhovetski wrote:
> On Wed, 4 Jan 2012, javier Martin wrote:
> 
> [snip]
> 
> > For ov7725 it is a natural thing to do since it was originally
> > developed for soc-camera and it can easily do the following to access
> > platform data:
> > 
> > struct soc_camera_link	*icl = soc_camera_i2c_to_link(client);
> > pdata = icl->priv;
> > 
> > However, tvp5150 is not aware about soc_camera. I should be able to
> > tell whether it's being used with soc-camera or not. If soc camera was
> > used I would do the previous method to retrieve platform data.
> > But if soc-camera was not used I would do the classic method:
> > 
> > struct tvp5150_platform_data *pdata = client->dev.platform_data;
> > 
> > The problem is how to distinguish in tvp5150 whether I am using
> > soc_camera or not.
> 
> Right, that _is_ the problem now. And we've known about it since the very
> first time we started to think about re-using the subdev drivers. The only
> solution I see so far is to introduce a standard platform data struct for
> all subdevices, similar to soc_camera_link. We could use it as a basis, of
> course, use a generic name, maybe reconsider fields - rename / remove /
> add, but the principle would be the same: a standard platform data struct
> with an optional private field.

Why is that needed ? Why can't a tvp5150-specific platform data structure do ?

> Alternatively - would it be possible to find all tvp5150 users and port
> them to use struct soc_camera_link too?

-- 
Regards,

Laurent Pinchart
