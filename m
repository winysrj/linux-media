Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43571 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbbAKOJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 09:09:27 -0500
Date: Sun, 11 Jan 2015 12:09:22 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCHv3 01/20] media: add new types for DVB devnodes
Message-ID: <20150111120922.02d26c67@recife.lan>
In-Reply-To: <5047178.zZItJZYJNH@avalon>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
	<39466944.7lEGPfqsct@avalon>
	<20150108154450.654d04d6@concha.lan>
	<5047178.zZItJZYJNH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 11 Jan 2015 15:54:14 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday 08 January 2015 15:44:50 Mauro Carvalho Chehab wrote:
> > Em Thu, 08 Jan 2015 18:10:13 +0200 Laurent Pinchart escreveu:
> > > On Wednesday 07 January 2015 12:22:39 Mauro Carvalho Chehab wrote:
> > >> Em Wed, 07 Jan 2015 16:09:04 +0200 Sakari Ailus escreveu:
> > >>> Mauro Carvalho Chehab wrote:
> > >>>> Most of the DVB subdevs have already their own devnode.
> > >>>> 
> > >>>> Add support for them at the media controller API.
> > >>>> 
> > >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >>>> 
> > >>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > >>>> index 7902e800f019..707db275f92b 100644
> > >>>> --- a/include/uapi/linux/media.h
> > >>>> +++ b/include/uapi/linux/media.h
> > >>>> @@ -50,7 +50,14 @@ struct media_device_info {
> > >>>> 
> > >>>>   #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> > >>>>   #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> > >>>>   #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> > >>>> 
> > >>>> -#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> > >>>> +#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
> > >>>> +#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
> > >>>> +#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
> > >>>> +#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
> > >>>> +#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
> > >>> 
> > >>> I'd create another type for the DVB sub-type devices, as there is for
> > >>> V4L2 sub-devices. I wonder what Laurent thinks.
> > >> 
> > >> I discussed this quickly with Laurent on IRC.
> > >> 
> > >> There are some concept differences between V4L2 and DVB.
> > >> 
> > >> At v4l2:
> > >> - the spec is one monolitic header (videodev2.h);
> > >> - one devnode is used to control everyhing (/dev/video?)
> > >> - there is one v4l core for all types of devices
> > >> 
> > >> At DVB:
> > >> - each different DVB API has its own header;
> > >> - each DVB device type has its own core (ok, they're
> > >>   linked into one module, but internally they're almost independent);
> > >> - each different DVB API has its own devnode.
> > >> 
> > >> So, using "SUBDEV" for DVB (or at least for the devnodes) don't
> > >> make much sense.
> > >> 
> > >> Ok, there are still some things at DVB side that could be mapped as
> > >> subdev. The clear example is the tuner. However, in this case, the
> > >> same tuner can be either V4L, DVB or both. So, we need to define just
> > >> one subdev type for the tuner.
> > >> 
> > >> Also, each DVB device can be identified via major/minor pairs.
> > >> 
> > >> I wrote already (and submitted upstream) the patches for media-ctl to
> > >> 
> > >> recognize them. They're also on my experimental v4l-utils tree:
> > >> 	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-> >> 	utils.git/log/?h=dvb-media-ctl> 
> > >
> > > As I've mentioned in a previous discussion, the media_entity type field is
> > > too restrictive. Not only does this use case show that we need a type,
> > > sub-type and sub-sub-type, there are also entities that implement several
> > > distinct types. I thus believe we need a new ioctl is needed to expose
> > > detailed information about entities. This topic has been discussed
> > > numerous times in the past, it "just" requires someone to implement it.
> > > 
> > > I'm not opposed to a short-term solution like the one proposed here, but
> > > maybe we should instead decide it's time to implement the new ioctl
> > > instead.
> >
> > Ok, so let's stick with it for DVB. At DVB side, I don't see a need for
> > sub-sub-type, especially since DVB has no subdevs (except for the shared
> > tuner between DVB and V4L). Everything there are devnodes, with their
> > functionality strictly following the documentation, as the API is fully
> > handled inside the DVB core[1].
> 
> At the moment the MC API has a devnode type with a DVB devnode subtype. 
> Splitting DVB devnodes into different categories effectively create sub-
> subtypes. That's what bothers mode, the type field is becoming a ragbag.

As I explained before, and more detailed at:
	http://www.spinics.net/lists/linux-media/msg85229.html

DVB is actually 3 different APIs (demux, frontend and CA). Those APIs
are independent, and each have an independent devnode. The dvr is a
special case: it is a devnode that doesn't accept ioctl's. It is just
an output devnode, controlled vis the demux API.

The only thing in common to those 3 APIs is that they belong to the same
device type. But some may argue that, on an hybrid device, the input,
remote controller and even V4L2 are also sub-types.

In any case, they're all devnodes, so MEDIA_ENT_T_DEVNODE_foo fits well.

> 
> > Also, I don't want to mix adding DVB media controller support with the
> > addition of a new ioctl.
> 
> *If* we conclude that a new ioctl is needed to support DVB in a clean way, I 
> don't see why that new ioctl shouldn't be considered as a prerequisite.

I don't see the need of a new ioctl for DVB. DVB is even simpler than V4L2,
as it doesn't have subdevs (except for tuner).

> 
> > [1] For the non-deprecated DVB devnodes. DVB have 3 devnode types that
> > are deprecated because they implement functionality found elsewhere
> > (video, audio and OSD dvb APIs). Only one legacy driver implements it,
> > and there's no plan to ever add media controller or expand/accept
> > new drivers using those legacy APIs.
> 
