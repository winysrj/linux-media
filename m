Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZHZVZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 17:25:24 -0400
Date: Wed, 26 Aug 2009 18:25:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Eduardo Valentin via Mercurial <eduardo.valentin@nokia.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] FM TX: si4713: Add files to
 handle si4713 i2c device
Message-ID: <20090826182518.6c879078@pedra.chehab.org>
In-Reply-To: <200908262243.34015.hverkuil@xs4all.nl>
References: <E1MgOf7-0004mc-Pr@mail.linuxtv.org>
	<200908262243.34015.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Aug 2009 22:43:33 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Wednesday 26 August 2009 22:00:05 Patch from Eduardo Valentin wrote:
> > The patch number 12552 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> > 
> > Kernel patches in this development tree may be modified to be backward
> > compatible with older kernels. Compatibility modifications will be
> > removed before inclusion into the mainstream Kernel
> > 
> > If anyone has any objections, please let us know by sending a message to:
> > 	Linux Media Mailing List <linux-media@vger.kernel.org>
> > 
> > ------
> > 
> > From: Eduardo Valentin  <eduardo.valentin@nokia.com>
> > FM TX: si4713: Add files to handle si4713 i2c device
> > 
> > 
> > This patch adds files to control si4713 devices.
> > Internal functions to control device properties
> > and initialization procedures are into these files.
> > Also, a v4l2 subdev interface is also exported.
> > This way other drivers can use this as v4l2 i2c subdevice.
> > 
> > Priority: normal
> > 
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > 
> > ---
> > 
> >  linux/linux/drivers/media/radio/si4713-i2c.c | 2067 +++++++++++++++++++
> >  linux/linux/drivers/media/radio/si4713-i2c.h |  237 ++
> >  linux/linux/include/media/si4713.h           |   49 
> 
> linux/linux/drivers? These files ended up in the wrong place!
> 
> Something went very wrong when merging these files...

Argh! It seems that there's a bug when creating new files with mailimport
script.

Well, I'll move them to the proper place and fix the -git patches.
> 
> Regards,
> 
> 	Hans
> 


-- 

Cheers,
Mauro
