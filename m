Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbeHCRU3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 13:20:29 -0400
Date: Fri, 3 Aug 2018 12:23:39 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Media Controller Properties
Message-ID: <20180803122339.63c148f0@coco.lan>
In-Reply-To: <15936983-465a-2fa1-e14a-6d348cbffc06@xs4all.nl>
References: <20180803143626.48191-1-hverkuil@xs4all.nl>
        <15936983-465a-2fa1-e14a-6d348cbffc06@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Aug 2018 17:03:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/03/2018 04:36 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This RFC patch series implements properties for the media controller.
> > 
> > This is not finished, but I wanted to post this so people can discuss
> > this further.
> > 
> > No documentation yet (too early for that).

That's my first complain :-D

Anyway, just 3 patches should be good enough to review without docs
(famous last words).

> > 
> > An updated v4l2-ctl and v4l2-compliance that can report properties
> > is available here:
> > 
> > https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
> > 
> > There is one main missing piece: currently the properties are effectively
> > laid out in random order. My plan is to change that so they are grouped
> > by object type and object owner. So first all properties for each entity,
> > then for each pad, etc. I started to work on that, but it's a bit more
> > work than expected and I wanted to post this before the weekend.

IMO, the best is to use some tree struct. The Kernel has some types that
could help setting it, although we never used on media. See, for
example Documentation/rbtree.txt for one such type.

> > 
> > While it is possible to have nested properties, this is not currently
> > implemented. Only properties for entities and pads are supported in this
> > code, but that's easy to extend to interfaces and links.

With a tree-based data structure, this would likely come for free.
> > 
> > I'm not sure about the G_TOPOLOGY ioctl handling: I went with the quickest
> > option by renaming the old ioctl and adding a new one with property support.

Why? No need for that at the public header. Just add the needed fields at the
end of the code and check for struct size at the ioctl handler.

It could make sense to have the old struct inside media-device.c, just
to allow using sizeof() there.

> > 
> > I think this needs to change (at the very least the old and new should
> > share the same ioctl NR), but that's something for the future.

You don't need that. Just be sure to mask the size when checking for the
ioctl, and then the code will check for the struct size, comparing if
it matches _v1 and the latest version (with should keep the same name).

> > 
> > Currently I support u64, s64 and const char * property types. But it
> > can be anything including binary data if needed. No array support (as we
> > have for controls), but there are enough reserved fields in media_v2_prop
> > to add this if needed.

That's u64/s64/char* are probably enough for now.

> > 
> > I added properties for entities and pads to vimc, so I could test this.  
> 
> I forgot to mention that there are known issues with the initialization
> of the entity props list (it happens in two places, I need to look into
> that) and that mdev is expected to be valid when adding properties, but
> I don't think that is necessarily the case.
> 
> So just be aware of that.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > Hans Verkuil (3):
> >   uapi/linux/media.h: add property support
> >   media: add support for properties
> >   vimc: add test properties
> > 
> >  drivers/media/media-device.c              |  98 +++++++++++-
> >  drivers/media/media-entity.c              |  65 ++++++++
> >  drivers/media/platform/vimc/vimc-common.c |  18 +++
> >  drivers/media/platform/vimc/vimc-core.c   |   6 +-
> >  include/media/media-device.h              |   6 +
> >  include/media/media-entity.h              | 172 ++++++++++++++++++++++
> >  include/uapi/linux/media.h                |  62 +++++++-
> >  7 files changed, 420 insertions(+), 7 deletions(-)
> >   
> 



Thanks,
Mauro
