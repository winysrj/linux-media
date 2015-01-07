Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42976 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbbAGOXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jan 2015 09:23:55 -0500
Date: Wed, 7 Jan 2015 12:22:39 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCHv3 01/20] media: add new types for DVB devnodes
Message-ID: <20150107122239.232d1f56@concha.lan>
In-Reply-To: <54AD3E00.5070208@linux.intel.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
	<7f1ea82b1055aa490726f3af2ad22bca25e49a28.1420578087.git.mchehab@osg.samsung.com>
	<54AD3E00.5070208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 07 Jan 2015 16:09:04 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Mauro Carvalho Chehab wrote:
> > Most of the DVB subdevs have already their own devnode.
> >
> > Add support for them at the media controller API.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 7902e800f019..707db275f92b 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -50,7 +50,14 @@ struct media_device_info {
> >   #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> >   #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> >   #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> > -#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> > +#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
> > +#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
> > +#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
> > +#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
> > +#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
> 
> I'd create another type for the DVB sub-type devices, as there is for 
> V4L2 sub-devices. I wonder what Laurent thinks.

I discussed this quickly with Laurent on IRC.

There are some concept differences between V4L2 and DVB.

At v4l2:
- the spec is one monolitic header (videodev2.h);
- one devnode is used to control everyhing (/dev/video?)
- there is one v4l core for all types of devices

At DVB:
- each different DVB API has its own header;
- each DVB device type has its own core (ok, they're
  linked into one module, but internally they're almost independent);
- each different DVB API has its own devnode.

So, using "SUBDEV" for DVB (or at least for the devnodes) don't
make much sense.

Ok, there are still some things at DVB side that could be mapped as
subdev. The clear example is the tuner. However, in this case, the
same tuner can be either V4L, DVB or both. So, we need to define just
one subdev type for the tuner.

Also, each DVB device can be identified via major/minor pairs.

I wrote already (and submitted upstream) the patches for media-ctl to
recognize them. They're also on my experimental v4l-utils tree:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=dvb-media-ctl

Regards,
Mauro
