Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56229 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbbLFBgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 20:36:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	media-workshop@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [media-workshop] [PATCH v8.4 43/83] [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
Date: Sun, 06 Dec 2015 03:36:43 +0200
Message-ID: <3698212.DSFTXWn1Di@avalon>
In-Reply-To: <20151107220255.GT17128@valkosipuli.retiisi.org.uk>
References: <1444668252-2303-1-git-send-email-mchehab@osg.samsung.com> <20151014183548.7180618e@concha.lan> <20151107220255.GT17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

CC'ing the linux-media mailing list, for real this time.

On Sunday 08 November 2015 00:02:55 Sakari Ailus wrote:
> On Wed, Oct 14, 2015 at 06:35:48PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 14 Oct 2015 13:15:40 +0300 Sakari Ailus escreveu:
> >> On Mon, Oct 12, 2015 at 09:26:04PM -0300, Mauro Carvalho Chehab wrote:
> >>> Em Tue, 13 Oct 2015 01:25:35 +0300 Sakari Ailus escreveu:
> >>>> On Mon, Oct 12, 2015 at 01:43:32PM -0300, Mauro Carvalho Chehab wrote:
> >>>>> Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
> >>>>> new subdev entities as MEDIA_ENT_T_UNKNOWN.
> >>>>> 
> >>>>> Change-Id: I294ee20f49b6c40dd95339d6730d90fa85b0dea9
> >>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>> ---
> >>>>> 
> >>>>>  drivers/media/media-device.c          |  6 ++++++
> >>>>>  drivers/media/v4l2-core/v4l2-subdev.c |  2 +-
> >>>>>  include/uapi/linux/media.h            | 17 +++++++++++++++++
> >>>>>  3 files changed, 24 insertions(+), 1 deletion(-)
> >>>>> 
> >>>>> diff --git a/drivers/media/media-device.c
> >>>>> b/drivers/media/media-device.c
> >>>>> index 659507bce63f..134fe7510195 100644
> >>>>> --- a/drivers/media/media-device.c
> >>>>> +++ b/drivers/media/media-device.c
> >>>>> @@ -435,6 +435,12 @@ int __must_check
> >>>>> media_device_register_entity(struct media_device *mdev,
> >>>>>  {
> >>>>>  	int i;
> >>>>> 
> >>>>> +	if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ||
> >>>>> +	    entity->type == MEDIA_ENT_T_UNKNOWN)
> >>>>> +		dev_warn(mdev->dev,
> >>>>> +			 "Entity type for entity %s was not initialized!\n",
> >>>>> +			 entity->name);

First of all the subject of the patch is very misleading as you initialize the 
entity type for new subdevs to MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN, not 
MEDIA_ENT_T_UNKNOWN.

> >>>> I don't think I'd warn about MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ---
> >>>> there are entities that do not fall into any category of existing
> >>>> functions. For instance image signal processors have such; they are
> >>>> hardware specific and often their functionality is somewhat so as
> >>>> well. Some of them perform a variety of functions (image processing
> >>>> algorithms) but I doubt it'd make sense to start e.g. listing those
> >>>> until we have any standardised interface for them.

Most of the subdevs we have today are of the "unknown" type, which isn't very 
user-friendly. Part of the reason is that there has never been a big incentive 
for driver writes to add proper subdev types, as the type is ignored in 
userspace in most cases. This should hopefully change with functions, and 
we'll need to push for new subdevs to have at least one function defined, even 
if it's a generic function such as image processing for lack of a better 
alternative. Warning on MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN has the advantage that 
it will push driver authors to think about the issue instead of just ignoring 
it and setting the type/function to unknown. That might be a wrong solution 
though, as if we introduce a generic image processing function (which we'll 
need for lack of a better or more precise alternative in some cases) driver 
authors might just use that one instead of MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN, 
and it would become the equivalent of the unknown type for all practical 
purpose. We would only have pushed the problem one step further without 
solving it. I wonder how we could improve that.

> >>>> The two entities in smiapp don't have a specific function either.
> >>>> Adding a new one (scaler) might make sense for the two, but I think
> >>>> I'd leave that out from this set.
> >>> 
> >>> IMHO, if the entity function is really unknown, it shouldn't even be
> >>> at the graph in the first place, as an unknown entity can't be
> >>> controlled.
> >> 
> >> These used to be just "sub-devices" without a type that 1) did not fall
> >> into any existing category
> > 
> > No problem. You can create a new function
> > 
> >> and 2) was not generic enough to warrant adding a
> >> specific type for them. I don't think that has really changed with
> >> functions.
> >
> > Well, you could add a device-specific function name. We have already
> > other device specific things (like device-only FOURCCs, device-specific
> > controls). I don't see why not having device-specific functions when
> > we want/need to map such entities.
> 
> What would be the benefit of having device specific functions?
> 
> The user who would need to access such a device would probably use the name
> instead, probably combined with the bus information in the future (or serial
> number etc.).
> 
> >>> So, I think we should either add a new function for those entities,
> >>> for them to be used on userspace, or simply remove them, if they won't
> >>> be used on userspace, because they aren't documented.
> >> 
> >> What kind of "function" could you use for e.g. OMAP3ISP CCDC or preview
> >> blocks?
> > 
> > ENT_F_OMAP3ISP_CCDC
> > 
> > if the preview is generic enough, it could be ENT_F_PREVIEW. If not,
> > ENT_F_OMAP3ISP_PREVIEW.
> > 
> >> The issue is that for the user to meaningfully use the devices, one has
> >> to know exactly what they are. The fact they do "image processing" for
> >> instance is not really useful alone.
> >> 
> >> Flash devices, for instance, have a well defined control interface.
> > 
> > Yes, but a ENT_F_OMAP3_CCDC would also have a well defined control
> > interface.
> 
> ..and its private IOCTLs as well.
> 
> I'd like to have Laurent's and Hans's opinion on this.

I don't think it makes sense to create a device-specific function for those 
subdevs. Functions should be defined generically, not in a hardware-specific 
fashion. Otherwise we would mix two very different usages, the identification 
of what an entity does and the identification of what an entity is. Locating 
an entity precisely in the graph ("where is the OMAP3 ISP CCDC entity?") is 
the purpose of the entity name. Using ENT_F_OMAP3_CCDC would mean "the OMAP3 
ISP CCDC entity does ENT_F_OMAP3_CCDC, defined as whatever the OMAP3 ISP CCDC 
entity does". That sounds tautological to me. I'd rather know that "the OMAP3 
ISP CCDC entity does image processing", or possibly "the OMAP3 ISP CCDC entity 
does black level compensation, fault pixel correction and lens shading 
correction".

> We'll also start needing multiple functions per entity in this case, since
> existing device specific functions would need to be amended with
> standardised functions. Supposing functions can be device specific, I think
> functions such as "scaler" should be standardised as well.

I agree with both statements, we'll need multiple functions per entity, and 
the scaler function should be standardized.

-- 
Regards,

Laurent Pinchart

