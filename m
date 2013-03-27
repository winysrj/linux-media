Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2426 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3C0KU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 06:20:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 2/6] v4l2: add new VIDIOC_DBG_G_CHIP_NAME ioctl.
Date: Wed, 27 Mar 2013 11:20:40 +0100
Cc: linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl> <201303270941.33211.hverkuil@xs4all.nl> <3447822.JyctDNubxl@avalon>
In-Reply-To: <3447822.JyctDNubxl@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271120.40328.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed March 27 2013 11:11:53 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 27 March 2013 09:41:33 Hans Verkuil wrote:
> > On Wed March 27 2013 02:11:23 Laurent Pinchart wrote:
> > > On Monday 18 March 2013 17:38:16 Hans Verkuil wrote:
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > 
> > > > Simplify the debugging ioctls by creating the VIDIOC_DBG_G_CHIP_NAME
> > > > ioctl. This will eventually replace VIDIOC_DBG_G_CHIP_IDENT. Chip
> > > > matching is done by the name or index of subdevices or an index to a
> > > > bridge chip. Most of this can all be done automatically, so most drivers
> > > > just need to provide get/set register ops.
> > > > 
> > > > In particular, it is now possible to get/set subdev registers without
> > > > requiring assistance of the bridge driver.
> > > 
> > > My biggest question is why don't we use the media controller API to get
> > > the information provided by this new ioctl ?
> > 
> > Because the media controller is implemented by only a handful of drivers,
> > and this debug API is used by many more drivers.
> 
> Shouldn't we then fix that instead of adding a new ioctl ?

Mauro was opposed to making the MC available for all drivers. So besides the
technical issues which would take a lot of time (which I don't have), there is
also a whole discussion about whether or not the MC should be there at all for
'simple' drivers.

My main goal at the moment is to make this API more powerful and simplify the
drivers. It is also my intention to get rid of G_CHIP_IDENT as soon as possible.

Should we get the MC available for all drivers in the future, then it should be
quite easy to adapt the code to the MC once G_CHIP_IDENT has been removed.
Consider this a first step into the right direction.

Regards,

	Hans
