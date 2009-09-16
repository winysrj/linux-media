Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53255 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760035AbZIPUif (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 16:38:35 -0400
Date: Wed, 16 Sep 2009 22:38:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
In-Reply-To: <200909162121.16606.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0909162237250.19291@axis700.grange>
References: <200909100913.09065.hverkuil@xs4all.nl> <200909120039.50343.hverkuil@xs4all.nl>
 <20090916151520.53537714@pedra.chehab.org> <200909162121.16606.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 Sep 2009, Hans Verkuil wrote:

> On Wednesday 16 September 2009 20:15:20 Mauro Carvalho Chehab wrote:
> > 
> > What's a sub-device?
> > ====================
> > 
> > Well, if we strip v4l2-framework.txt and driver/media from "git grep", we have:
> > 
> > For "subdevice", there are several occurences. All of them refers to
> > subvendor/subdevice PCI ID.
> > 
> > For "sub-device": most references also talk about PCI subdevices. On all places
> > (except for V4L), where a subdevice exists, a kernel device is created.
> > 
> > So, basically, only V4L is using sub-device with a different meaning than what's at kernel.
> > On all other places, a subdevice is just another device.
> > 
> > It seems that we have a misconception here: sub-device is just an alias for
> > "device". 
> > 
> > IMO, it is better to avoid using "sub-device", as this cause confusion with the
> > widely used pci subdevice designation.
> 
> We discussed this on the list at the time. I think my original name was
> v4l2-client. If you can come up with a better name, then I'm happy to do a
> search and replace.

FWIW, I'm also mostly using the video -host and -client notation in 
soc-camera.

Thanks
Guennadi
---
Guennadi Liakhovetski
