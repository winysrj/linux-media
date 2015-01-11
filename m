Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43565 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbAKN6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 08:58:30 -0500
Date: Sun, 11 Jan 2015 11:58:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCHv2 1/9] media: Fix DVB representation at media controller
 API
Message-ID: <20150111115824.0e4acdf0@recife.lan>
In-Reply-To: <2274549.Xm2J2SkQ3y@avalon>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
	<ea1dd8e443b34e2047468866ec423d4334f54eba.1420294938.git.mchehab@osg.samsung.com>
	<2274549.Xm2J2SkQ3y@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 11 Jan 2015 15:50:04 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Saturday 03 January 2015 12:49:03 Mauro Carvalho Chehab wrote:
> > The DVB devices are identified via a (major, minor) tuple,
> > and not by a random id. Fix it, before we start using it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index e00459185d20..de333cc8261b 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -97,7 +97,10 @@ struct media_entity {
> >  			u32 device;
> >  			u32 subdevice;
> >  		} alsa;
> > -		int dvb;
> > +		struct {
> > +			u32 major;
> > +			u32 minor;
> > +		} dvb;
> > 
> >  		/* Sub-device specifications */
> >  		/* Nothing needed yet */
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index d847c760e8f0..7902e800f019 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -27,7 +27,7 @@
> >  #include <linux/types.h>
> >  #include <linux/version.h>
> > 
> > -#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
> > +#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 1)
> > 
> >  struct media_device_info {
> >  	char driver[16];
> > @@ -88,7 +88,10 @@ struct media_entity_desc {
> >  			__u32 device;
> >  			__u32 subdevice;
> >  		} alsa;
> > -		int dvb;
> > +		struct {
> > +			__u32 major;
> > +			__u32 minor;
> > +		} dvb;
> 
> Won't this break compilation of existing userspace code ? As DVB is not 
> properly supported in MC at the moment we could consider that only mediactl 
> will be affected, so it shouldn't be a big issue.

Well, media-ctl uses a local copy of the videodev2.h header, so it won't
break.

I'm not aware of any other application using MC for DVB.

Yet, imagining that such application exists, then, IMHO, it is better
to break compilation for it, as probably such application was written for
some OOT driver that might be using its own version of the media
controller implementation.

Regards,
Mauro
