Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33198 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752180AbeBEVsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 16:48:41 -0500
Date: Mon, 5 Feb 2018 23:48:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media_device.c question: can this workaround be removed?
Message-ID: <20180205214838.uu6n4if5bnl6ch4k@valkosipuli.retiisi.org.uk>
References: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
 <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
 <2291cc25-50fd-90cc-8948-6def4acc73a3@xs4all.nl>
 <20180205143039.uhlxala2vc4diysp@valkosipuli.retiisi.org.uk>
 <10d299e0-4edf-75dc-56f1-3acfb6ed719b@xs4all.nl>
 <20180205143228.728d0e73@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180205143228.728d0e73@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Mon, Feb 05, 2018 at 02:32:28PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 5 Feb 2018 16:19:28 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 02/05/2018 03:30 PM, Sakari Ailus wrote:
> > > Hi Hans,
> > > 
> > > On Mon, Feb 05, 2018 at 01:30:04PM +0100, Hans Verkuil wrote:  
> > >> On 02/05/2018 12:59 PM, Sakari Ailus wrote:  
> > >>> Hi Hans,
> > >>>
> > >>> On Mon, Feb 05, 2018 at 11:26:47AM +0100, Hans Verkuil wrote:  
> > >>>> The function media_device_enum_entities() has this workaround:
> > >>>>
> > >>>>         /*
> > >>>>          * Workaround for a bug at media-ctl <= v1.10 that makes it to
> > >>>>          * do the wrong thing if the entity function doesn't belong to
> > >>>>          * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
> > >>>>          * Ranges.
> > >>>>          *
> > >>>>          * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
> > >>>>          * or, otherwise, will be silently ignored by media-ctl when
> > >>>>          * printing the graphviz diagram. So, map them into the devnode
> > >>>>          * old range.
> > >>>>          */
> > >>>>         if (ent->function < MEDIA_ENT_F_OLD_BASE ||
> > >>>>             ent->function > MEDIA_ENT_F_TUNER) {
> > >>>>                 if (is_media_entity_v4l2_subdev(ent))
> > >>>>                         entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
> > >>>>                 else if (ent->function != MEDIA_ENT_F_IO_V4L)
> > >>>>                         entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
> > >>>>         }
> > >>>>
> > >>>> But this means that the entity type returned by ENUM_ENTITIES just overwrites
> > >>>> perfectly fine types by bogus values and thus the returned value differs
> > >>>> from that returned by G_TOPOLOGY.
> > >>>>
> > >>>> Can we please, please remove this workaround? I have no idea why a workaround
> > >>>> for media-ctl of all things ever made it in the kernel.  
> > >>>
> > >>> The entity types were replaced by entity functions back in 2015 with the
> > >>> big Media controller reshuffle. While I agree functions are better for
> > >>> describing entities than types (and those types had Linux specific
> > >>> interfaces in them), the new function-based API still may support a single
> > >>> value, i.e. a single function per device.
> > >>>
> > >>> This also created two different name spaces for describing entities: the
> > >>> old types used by the MC API and the new functions used by MC v2 API.
> > >>>
> > >>> This doesn't go well with the fact that, as you noticed, the pad
> > >>> information is not available through MC v2 API. The pad information is
> > >>> required by the user space so software continues to use the original MC
> > >>> API.
> > >>>
> > >>> I don't think there's a way to avoid maintaining two name spaces (types and
> > >>> functions) without breaking at least one of the APIs.  
> > >>
> > >> The comment specifically claims that this workaround is for media-ctl and
> > >> it suggests that it is fixed after v1.10. Is that comment bogus? I can't
> > >> really tell which commit fixed media-ctl. Does anyone know?
> > >>
> > >> As far as I can tell the function defines have been chosen in such a way that
> > >> they will equally well work with the old name space. There should be no
> > >> problem there whatsoever and media-ctl should switch to use the new defines.  
> > > 
> > > The old interface (type) was centered around the uAPI for the entity.
> > > That's no longer the case for functions. The entity type
> > > (MEDIA_ENT_TYPE_MASK) tells the uAPI which affects the interpretation of
> > > the dev union in struct media_entity_struct as well as the interface that
> > > device node implements. With the new function field that's no longer the
> > > case.
> > > 
> > > Also, the new MC v2 API makes a separation between the entity function and
> > > the uAPI (interface) which was lacking in the old API.
> > >   
> > >>
> > >> We now have a broken ENUM_ENTITIES ioctl (it rudely overwrites VBI/DVB/etc types)
> > >> and a broken G_TOPOLOGY ioctl (no pad index).
> > >>
> > >> This sucks. Let's fix both so that they at least report consistent information.  
> > > 
> > > The existing user space may assume that the type field of the entity
> > > conveys that the entity does provide a V4L2 sub-device interface if that's
> > > the case actually.
> > > 
> > > This is what media-ctl does and I presume if existing user space checks for
> > > the type field, it may well have similar checks: it was how the API was
> > > defined. Therefore it's not entirely accurate to say that only media-ctl
> > > has this "bug", I'd generally assume programs that use MC (v1) API do this.
> > > 
> > > You could argue about the merits (or lack of them) of the old API, no
> > > disagrement there.  
> > 
> > The old API is already broken. E.g. using MEDIA_ENT_F_PROC_VIDEO_SCALER in
> > vimc/vimc-scaler.c (instead of the current - and bogus - MEDIA_ENT_F_ATV_DECODER)
> > gives me this with media-ctl:
> > 
> > - entity 21: Scaler (2 pads, 4 links)
> >              type V4L2 subdev subtype Unknown flags 0
> >              device node name /dev/v4l-subdev5
> >         pad0: Sink
> >                 [fmt:RGB888_1X24/640x480 field:none]
> >                 <- "Debayer A":1 [ENABLED]
> >                 <- "Debayer B":1 []
> >                 <- "RGB/YUV Input":0 []
> >         pad1: Source
> >                 [fmt:RGB888_1X24/1920x1440 field:none]
> >                 -> "RGB/YUV Capture":0 [ENABLED,IMMUTABLE]  
> > 
> > Useless. We now have an old API that gives us pad indices but not the
> > function, and a new API that gives us the function but not the pad index.
> 
> Adding pad index to new API is trivial, as your RFC patch pointed.
> 
> Changing media-ctl to fully use the new ioctl is not trivial, as it
> was written on a non-portable way, very dependent on the kernel API
> specifics[1]. I suspect that it is a lot more easier to add support
> for MEDIA_IOC_SETUP_LINK to mc_nextgen_test and rename it to
> media-ctl[2].

libmediactl (which media-ctl uses) was intended to be the user space
library for MC. Perhaps analogous to libv4l on V4L2.

It builds an internal state from what it queries from the kernel, it
shouldn't be *that* difficult to change it. The API can be changed, too,
it's not exported as a library from v4l-utils.

> 
> [1] I tried it before working at contrib/test/mc_nextgen_test.c. The
> internal data model used by media-ctl library was just a clone of the
> model returned by the ioctls. Even a minimal change on the way ioctls 
> return things (even adding new entity types) is enough to break it.

The entity type is only used for informational purposes AFAIK. Otherwise
it'll just say "unknown".

Don't forget that media-ctl also supports most of V4L2 sub-device API.

> 
> [2] It would be possible, however, to make media-ctl to use 
> G_TOPOLOGY, ignoring new features that can't be represented using
> the old ioctls and providing fallback to entity functions in order
> to represent media types. It won't be too much elegant though.
> 
> > How about adding a 'function' field to struct media_entity_desc
> > and fill that? Keep the type for backwards compatibility.
> 
> Nah, Let's not touch the old ioctls. Instead, we should stick
> with the new API and convert (or replace) existing applications to
> use it, as the old ioctl set can't even represent the interfaces.

MC v2 would need better support for pad information, as well as flags. At
least. I haven't decided yet what to think of this.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
