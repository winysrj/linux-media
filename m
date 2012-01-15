Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48255 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2AORcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 12:32:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [media-ctl PATCH 1/1] libmediactl: Implement MEDIA_ENT_ID_FLAG_NEXT in media_get_entity_by_id()
Date: Sun, 15 Jan 2012 18:31:54 +0100
Cc: linux-media@vger.kernel.org
References: <1326569616-7048-1-git-send-email-sakari.ailus@iki.fi> <201201151444.08443.laurent.pinchart@ideasonboard.com> <4F12F388.3000508@iki.fi>
In-Reply-To: <4F12F388.3000508@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201151831.54375.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 15 January 2012 16:40:56 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Saturday 14 January 2012 20:33:36 Sakari Ailus wrote:
> >> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> >> ---
> >> 
> >>   src/mediactl.c |    9 +++++++--
> >>   src/mediactl.h |    4 +++-
> >>   2 files changed, 10 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/src/mediactl.c b/src/mediactl.c
> >> index 5b8c587..f62fcdf 100644
> >> --- a/src/mediactl.c
> >> +++ b/src/mediactl.c
> >> @@ -81,8 +81,13 @@ struct media_entity *media_get_entity_by_id(struct
> >> media_device *media, for (i = 0; i<  media->entities_count; ++i) {
> >> 
> >>   		struct media_entity *entity =&media->entities[i];
> >> 
> >> -		if (entity->info.id == id)
> >> -			return entity;
> >> +		if (!(id&  MEDIA_ENT_ID_FLAG_NEXT)) {
> >> +			if (entity->info.id == id)
> >> +				return entity;
> >> +		} else {
> >> +			if (entity->info.id>= (id&  ~MEDIA_ENT_ID_FLAG_NEXT)
> >> +				return entity;
> >> +		}
> > 
> > Just one question that hasn't crossed my mind before, why do you need
> > this ? If you want to enumerate entities in an application you can just
> > iterate over media_device::entities.
> 
> We do have the MEDIA_ENT_ID_FLAG_NEXT flag which is intended to help in
> entity enumeration. Currently the range of entity ids is contiguous in
> all practical implementation but will that always be the case, also in
> the future? A few things might break in the kernel if the range is
> non-contiguous as well, but that's still internal to the kernel.
> 
> However, this is a user space library and if this interface change is
> not made, we essentially are making a promise that the entity ranges
> will always be contiguous.

I definitely don't want to make that promise, but what's the point in calling 
media_get_entity_by_id() for entity enumeration instead of iterating over the 
media_device::entities array ?

> I wouldn't as there's no need to do so.
> 
> I you think about programmable hardware, entities there are logical
> rather than physical and their existence may be dependent on multiple
> factors.

-- 
Regards,

Laurent Pinchart
