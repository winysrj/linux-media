Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44444 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbcBZNVr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:21:47 -0500
Date: Fri, 26 Feb 2016 10:21:41 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add type field to struct media_entity
Message-ID: <20160226102141.01afcda6@recife.lan>
In-Reply-To: <18438705.DF1fHKHHvm@avalon>
References: <1456105996-20845-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20160222064601.6fc22c30@recife.lan>
	<20160222212058.GX32612@valkosipuli.retiisi.org.uk>
	<18438705.DF1fHKHHvm@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Feb 2016 13:18:30 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> On Monday 22 February 2016 23:20:58 Sakari Ailus wrote:
> > On Mon, Feb 22, 2016 at 06:46:01AM -0300, Mauro Carvalho Chehab wrote:  
> > > Em Mon, 22 Feb 2016 03:53:16 +0200 Laurent Pinchart escreveu:  
> > >> Code that processes media entities can require knowledge of the
> > >> structure type that embeds a particular media entity instance in order
> > >> to use the API provided by that structure. This needs is shown by the
> > >> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
> > >> functions.
> > >> 
> > >> The implementation of those two functions relies on the entity function
> > >> field, which is both a wrong and an inefficient design, without even  
> > 
> > I wouldn't necessarily say "wrong", but it is risky. A device's function not
> > only defines the interface it offers but also which struct is considered to
> > contain the media entity. Having a wrong value in the function field may
> > thus lead memory corruption and / or system crash.
> >   
> > >> mentioning the maintenance issue involved in updating the functions
> > >> every time a new entity function is added. Fix this by adding add a type
> > >> field to the media entity structure to carry the information.
> > >> 
> > >> Signed-off-by: Laurent Pinchart
> > >> <laurent.pinchart+renesas@ideasonboard.com>
> > >> ---
> > >> 
> > >>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
> > >>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
> > >>  include/media/media-entity.h          | 65 +++++++++++------------------
> > >>  3 files changed, 30 insertions(+), 37 deletions(-)  
> 
> [snip]
> 
> > >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > >> index fe485d367985..2be38483f3a4 100644
> > >> --- a/include/media/media-entity.h
> > >> +++ b/include/media/media-entity.h
> > >> @@ -187,10 +187,27 @@ struct media_entity_operations {
> > >>  };
> > >>  
> > >>  /**
> > >> + * enum MEDIA_ENTITY_TYPE_NONE - Media entity type
> > >> + *  
> > > 
> > > s/MEDIA_ENTITY_TYPE_NONE/media_entity_type/
> > > 
> > > (it seems you didn't test producing the docbook, otherwise you would
> > > have seen this error - Please always generate the docbook when the
> > > patch contains kernel-doc markups)  
> 
> Oops, sorry. I'll fix that.
> 
> > > I don't like the idea of calling it as "type", as this is confusing,
> > > specially since we used to call entity.type for what we now call function.  
> > 
> > What that field essentially defines is which struct embeds the media entity.
> > (Well, there's some cleanups to be done there, as we have extra entity for
> > V4L2 subdevices, but that's another story.)
> > 
> > The old type field had that information, plus the "function" of the entity.
> > 
> > I think "type" isn't a bad name for this field, as what we would really need
> > is inheritance. It refers to the object type. What would you think of
> > "class"?  
> 
> I'd prefer type as class has other meanings in the kernel, but I can live with 
> it. Mauro, I agree with Sakari here, what the field contains is really the 
> object type in an object-oriented programming context.

Well, as we could have entities not embedded on some other object, this
is actually not an object type, even on OO programming. What we're actually
representing here is a graph object class.

The problem is that "type" is a very generic term, and, as we used it before
with some other meaning, so I prefer to call it as something else.

I'm ok with any other name, although I agree that Kernel uses "class" for
other things. Maybe gr_class or obj_class?

> 
> > > What we're actually wanting to represent is the Linux kABI group where
> > > the entity belongs. So, maybe we could call it as
> > > media_entity_kabi_type, instead.
> > >   
> > > > + * @MEDIA_ENTITY_TYPE_NONE:
> > > > + *	The entity isn't embedded in a standard structure.  
> > > 
> > > I also don't like having a NONE here. All objects belong to some
> > > kABI type, but not all subsystems need to use this field
> > > (so far, DVB doesn't need nor ALSA).
> > > 
> > > So, I would either call it as DEFAULT or UNDEFINED.  
> > 
> > I prefer UNDEFINED from the two. There really is no interface in that case,
> > and we don't have a "default" interface either.  
> 
> I prefer UNDEFINED too, I'll fix that.

OK.

> 
> > >> + * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
> > >> + *	The media entity is embedded in a struct video_device.
> > >> + * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
> > >> + *	The media entity is embedded in a struct v4l2_subdev.
> > >> + */
> > >> +enum media_entity_type {
> > >> +	MEDIA_ENTITY_TYPE_NONE,
> > >> +	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
> > >> +	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
> > >> +};  
> 
> [snip]
> 
> > >> @@ -328,56 +346,29 @@ static inline u32 media_gobj_gen_id(enum
> > >> media_gobj_type type, u64 local_id)
> > >>  }
> > >>  
> > >>  /**
> > >> - * is_media_entity_v4l2_io() - identify if the entity main function
> > >> - *			       is a V4L2 I/O
> > >> - *
> > >> + * is_media_entity_v4l2_io() - Check if the entity implements the
> > >> video_device
> > >> + *			       API
> > >>   * @entity:	pointer to entity
> > >>   *
> > >> - * Return: true if the entity main function is one of the V4L2 I/O
> > >> types
> > >> - *	(video, VBI or SDR radio); false otherwise.
> > >> + * Return: true if the entity implement the video_device API (is
> > >> directly
> > >> + * embedded in a struct video_device instance) or false otherwise.  
> > > 
> > > s/implement/implements/  
> 
> Will fix.
> 
> > > Yet, I don't think the above comment is ok. First of all, video_device is
> > > a kABI. We're nowadays calling the kernel APIs as kABI, and the userspace
> > > ones as uAPI.  
> > 
> > Are the exact definitions of the two available somewhere? ABI doesn't matter
> > much in the kernel itself but towards user space both ABI and API are
> > important...  
> 
> the Kernel ABI is defined as the binary interface exported by the kernel to 
> modules. I don't think that's relevant here.

Maybe we could then call it as kAPI, do distinguish from uAPI.

> 
> > > Also, it doesn't make clear that it would be used also for radio, and
> > > it is repeating the same thing twice.
> > > 
> > > So, I would either keep the original comment or change it to:
> > >
> > > "Return: true if the entity implements the video_device kABI for video,
> > >  VBI or SDR radio (e. g. if the entity is embeddded at a struct
> > >  video_device instance) or false otherwise."  
> 
> The original comment isn't correct, as the is_media_entity_v4l2_io() doesn't 
> care about the entity main function. I don't think we need to mention video, 
> VBI or radio, this is really about whether the entity is embedded in a 
> video_device structure. How about
> 
> "Return: true if the entity is embedded in a struct video_device instance or 
> false otherwise."

Works for me.

> 
> > >>   */
> > >>  static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
> > >>  {
> > >> -	if (!entity)
> > >> -		return false;
> > >> -
> > >> -	switch (entity->function) {
> > >> -	case MEDIA_ENT_F_IO_V4L:
> > >> -	case MEDIA_ENT_F_IO_VBI:
> > >> -	case MEDIA_ENT_F_IO_SWRADIO:
> > >> -		return true;
> > >> -	default:
> > >> -		return false;
> > >> -	}
> > >> +	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
> > >>  }  
> 
> [snip]
> 
> I'm happy to see that the comments are mostly about details and that the 
> overall idea doesn't raise any strong opposition :-) Let's try to sort the 
> last issues out and get this merged.
> 
> By the way, this patch is a prerequisite to fix the warnings printed by the MC 
> core for the vsp1 driver since v4.5-rc1. Should it thus be merged as a fix for 
> v4.5 ?

This patch itself won't remove the warnings, but the followup ones that
you're likely writing adding the proper entity functions to each
subdev used by vsp1. The very same thing is also needed for omap3 and
some other drivers.

I guess there's no hurry to merge such warnings removal on v4.5. The entity 
types on vsp1 driver are not properly reported even before 4.5. The only
thing is that, before 4.5, those undefined entities were silently ignored by 
the MC core. So, I don't see any urgency.

Regards,
Mauro
