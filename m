Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36403 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbcCEJib (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 04:38:31 -0500
Date: Sat, 5 Mar 2016 06:38:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] media-device: map new functions into old types
 for legacy API
Message-ID: <20160305063825.0b5aa0bb@recife.lan>
In-Reply-To: <1527901.3Rzc7c6Yxe@avalon>
References: <07c81fda0c8b187be238a8428fd370d156082f8c.1457088214.git.mchehab@osg.samsung.com>
 <1527901.3Rzc7c6Yxe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Mar 2016 22:34:04 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday 04 March 2016 07:43:37 Mauro Carvalho Chehab wrote:
> > The media-ctl tool, on versions <= 1.10 relies on detecting the
> > media_type to identify V4L2 sub-devices and MEDIA_ENT_T_DEVNODE.  
> 
> 1.10 is the latest version, and the problem is still present in the master 
> branch of v4l-utils. 
> Furthermore this issue isn't limited to media-ctl, there 
> are other applications relying on this (I wrote one of them).
> > If the device doesn't match the MEDIA_ENT_T_V4L2_SUBDEV range, it
> > ignores the major/minor and won't be getting the device name on
> > udev or sysfs. It will also ignore the entity when printing the
> > graphviz diagram.
> > 
> > As we're now adding devices outside the old range, the legacy ioctl
> > needs to map the new entity functions into a type at the old range,
> > or otherwise we'll have a regression.  
> 
> How about phrasing it as
> 
> "The legacy media controller userspace API exposes entity types that carry 
> both type and function information. The new API replaces the type with a 
> function. It preserves backward compatibility by defining legacy functions for 
> the existing types and using them in drivers.
> 
> This works fine as long as drivers are not modified to use proper functions. 
> When this happens the legacy API will all of a sudden report new functions 
> instead of legacy types, breaking userspace applications.
> 
> Fix this by deriving the type from the function to emulate the legacy API if 
> the function isn't in the legacy functions range."

When adding workarounds to avoid userspace regressions, it is better to make
it well documented, including the versions where the bug was found (as
newer versions may fix it) and explaining exactly why the patch is needed,
because otherwise another patch in the future might break it again. We
had such problem in the past, with some workarounds added to fix xawtv
and/or tvtime issues that were poorly documented and appeared again after
some change.

We're only experiencing troubles with media-ctl because --print-dot
assumes that anything except for DEVNODE_V4L or SUBDEV types should
be ignored. The same tool does the right thing with --print-topology:
it shows all entities. So, for me, there is an userspace trouble.

This patch was specially crafted to workaroud media-ctl, but we might
need to add more workarounds in the future if some other tool would
require a different behavior.

What about:

The legacy media controller userspace API exposes entity types that carry 
both type and function information. The new API replaces the type with a 
function. It preserves backward compatibility by defining legacy functions
for the existing types and using them in drivers.

This works fine as long as newer entity functions won't be added.

Unfortunately, some tools, like media-ctl relies on the now legacy
MEDIA_ENT_T_V4L2_SUBDEV and MEDIA_ENT_T_DEVNODE numeric range to
identify what entities will be shown when --print-dot option is
used.

Also If the entity doesn't match those ranges, it will ignores the
major/minor and won't be getting the devnode name on udev or sysfs.

As we're now adding devices outside the old range, the legacy ioctl
needs to map the new entity functions into a type at the old range,
or otherwise we'll have a regression.

Detected on all released media-ctl versions (e. g. versions <= 1.10) 

Fix this by deriving the type from the function to emulate the legacy
API if the function isn't in the legacy functions range.

> 
> > Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  drivers/media/media-device.c | 23 +++++++++++++++++++++++
> >  include/uapi/linux/media.h   |  6 +++++-
> >  2 files changed, 28 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 17cd349e485f..1e82c59abb94 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -20,6 +20,9 @@
> >   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> > USA */
> > 
> > +/* We need to access legacy defines from linux/media.h */
> > +#define __MEDIA_DEVICE_C__  
> 
> glibc defines macros named __need_* for the same purpose. How about 
> __need_media_legacy_api instead ?

Works for me.

> 
> > +
> >  #include <linux/compat.h>
> >  #include <linux/export.h>
> >  #include <linux/idr.h>
> > @@ -121,6 +124,26 @@ static long media_device_enum_entities(struct
> > media_device *mdev, u_ent.group_id = 0;		/* Unused */
> >  	u_ent.pads = ent->num_pads;
> >  	u_ent.links = ent->num_links - ent->num_backlinks;
> > +
> > +	/*
> > +	 * Workaround for a bug at media-ctl <= v1.10 that makes it to  
> 
> I wouldn't call it a bug, as the MC API guarantees that subdevices will have a 
> type within the subdev types range, and media-ctl simply relies on that.

It is a bug, as:

1) media-ctl works fine with --print-topology

2) even if we didn't change the API, newer ranges would
   be ignored by media_ctl on --print-dot. 

Also, this issue should be addressed somehow on newer versions of the
media-ctl, for it to be able to detect the real functions of the new
entities. Unfortunately, after this patch, the only possible fix is
to implement G_TOPOLOGY.

> > +	 * do the wrong thing if the entity function doesn't belong to
> > +	 * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
> > +	 * Ranges.
> > +	 *
> > +	 * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
> > +	 * or, otherwise, will be silently ignored by media-ctl when
> > +	 * printing the graphviz diagram. So, map them into the devnode
> > +	 * old range.  
> 
> To match the commit message, how about just
> 
> "Emulate legacy types for userspace if the entity uses a non-legacy function."

Again, better to be prolific here and clearly describe what's been
done, as we might need to add other workarounds if other tools do
something different.

Also, we'll likely patch this function in some future, when we
remove the entity "major" and "minor" fields. At that time, the
developer will need to carefully look at media-ctl behavior, to
be sure that his patch won't break it.

> 
> > +	 */
> > +	if (ent->function < MEDIA_ENT_F_OLD_BASE ||
> > +	    ent->function > MEDIA_ENT_T_DEVNODE_UNKNOWN) {
> > +		if (is_media_entity_v4l2_subdev(ent))
> > +			u_ent.type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
> > +		else if (ent->function != MEDIA_ENT_F_IO_V4L)  
> 
> This can't happen as MEDIA_ENT_F_IO_V4L is in the 
> MEDIA_ENT_F_OLD_BASE..MEDIA_ENT_T_DEVNODE_UNKNOWN range. We can just leave 
> this out for now, or you can use is_media_entity_v4l2_video_device() if you 
> want to rebase on top of the pull request I've just sent.

Yes, I know that this IF will always be true. GCC will likely detect it
too and optimize it to remove the uneeded IF.

Yet, adding the if here, IMHO, helps humans to better understand the
code.

Replacing it by is_media_entity_v4l2_video_device() would do the wrong
thing here, as other V4L I/O entities, like VBI and SWRADIO should be
detected by it.

The idea here is to catch when function != MEDIA_ENT_F_IO_V4L, e. g.
maping all other device nodes to MEDIA_ENT_T_DEVNODE_UNKNOWN. This 
change makes media-ctl --print-dot to show:

- other V4L devnodes: vbi, radio, swradio;
- ALSA;
- DVB.

See the net result (I hacked au0828 to only show 3 DVB I/O,
as otherwise the graph would be huge):
	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/media-ctl-output.png
	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/media-ctl-output.dot

For you to compare, this is what mc_nextgen_test gets using
G_TOPOLOGY:
	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/mc_nextgen_test-output.png
	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/mc_nextgen_test-output.dot

All entities are there and media-ctl got the name of /dev/vbi0 devnode.

> > +			u_ent.type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
> > +	}
> > +
> >  	memcpy(&u_ent.raw, &ent->info, sizeof(ent->info));
> >  	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
> >  		return -EFAULT;
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 95e126edb1c3..bc27e34ce3a1 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -132,7 +132,7 @@ struct media_device_info {
> > 
> >  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
> > 
> > -#ifndef __KERNEL__
> > +#if !defined(__KERNEL__) || defined(__MEDIA_DEVICE_C__)
> > 
> >  /*
> >   * Legacy symbols used to avoid userspace compilation breakages
> > @@ -145,6 +145,10 @@ struct media_device_info {
> >  #define MEDIA_ENT_TYPE_MASK		0x00ff0000
> >  #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
> > 
> > +/* End of the old subdev reserved numberspace */
> > +#define MEDIA_ENT_T_DEVNODE_UNKNOWN	(MEDIA_ENT_T_DEVNODE | \
> > +					 MEDIA_ENT_SUBTYPE_MASK)  
> 
> Shouldn't we hide it from userpace ? 

I don't think so. Whatever we document it here or not, at the moment
the Kernel reports entities with this number, it becomes part of the
userspace API.

Also, applications may need to handle it properly, for example to
get the right devnode name via udev or sysfs.

> How about moving it to media-device.c as 
> that's the only user ? I don't expect other source files to need this (and 
> certainly hope it won't be the case).

They won't see, as this is under this ifdef:
	#if !defined(__KERNEL__) || defined(__MEDIA_DEVICE_C__)

> 
> I also propose calling the macro MEDIA_ENT_T_DEVNODE_MAX (or possibly 
> MEDIA_ENT_T_DEVNODE_END, up to you). In practice MEDIA_ENT_T_DEVNODE is what 
> currently represents a device node of unknown type, I find 
> MEDIA_ENT_T_DEVNODE_UNKNOWN confusing.

On my first versions, I actually mapped them as MEDIA_ENT_T_DEVNODE_LAST,
to identify that it is the last device.

But this is not what this patch does. What it does is to map all
devnodes that are not /dev/video? to MEDIA_ENT_T_DEVNODE_UNKNOWN.

That's exactly the same thing as mapping all new SUBDEV functions to
MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN: it is not that the Kernel doesn't know
for what purpose the entity is there. It does, because internally it
has the proper type and it will be properly reported via G_TOPOLOGY.

However, after this patch, any app using the legacy ioctl will forever
be doomed to never know for sure the purpose of such entities. So,
for userspace, the purpose of such entities are UNKNOWN.

Ok, userspace can still hint its usage by handling the major/minor, if
available. Yet, I guess we don't fill major/minor, except for the v4l
devnodes, with explains the "(null)" strings at the media-ctl graph.

> 
> >  #define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
> >  #define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
> >  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)  
> 


-- 
Thanks,
Mauro
