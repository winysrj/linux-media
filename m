Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33788 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbeJQV2H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 17:28:07 -0400
Subject: Re: [RFCv3 PATCH 0/3] Media Controller Properties
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
References: <20180928100745.4946-1-hverkuil@xs4all.nl>
Message-ID: <3cd1bb44-2f88-5891-2a42-a05b3a11c94b@xs4all.nl>
Date: Wed, 17 Oct 2018 15:32:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180928100745.4946-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2018 12:07 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This RFC patch series implements properties for the media controller.
> 
> The main changes since RFCv2 are:
> 
> - Properties can be nested.
> - G_TOPOLOGY sets flags to indicate if there are pads/links/properties
>   for the objects. And it adds index fields to provide a quick lookup.
>   Effectively the topology arrays now represent a flattened tree.
> 
> An updated v4l2-ctl and v4l2-compliance that can report properties
> is available here:
> 
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
> 
> Currently I support u64, s64 and const char * property types. And also
> a 'group' type that groups sub-properties. But it can be extended to any
> type including binary data if needed. No array support (as we have for
> controls), but there are enough reserved fields in media_v2_prop
> to add this if needed.
> 
> I added properties for entities and pads to vimc, so I could test this.
> 
> Note that the changes to media_device_get_topology() are hard to read
> from the patch. It is easier to just look at the source code:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/media/media-device.c?h=mc-props
> 
> I have some ideas to improve this some more:
> 
> 1) Add the properties directly to media_gobj. This would simplify some
>    of the code, but it would require a media_gobj_init function to
>    initialize the property list. In general I am a bit unhappy about
>    media_gobj_create: it doesn't really create the graph object, instead
>    it just adds it to the media_device. It's confusing and it is something
>    I would like to change.
> 
> 2) The links between pads are stored in media_entity instead of in media_pad.
>    This is a bit unexpected and makes it harder to traverse the data
>    structures since to find the links for a pad you need to walk the entity
>    links and find the links for that pad. Putting all links in the entity
>    also mixes up pad and interface links, and it would be much cleaner if
>    those are separated.

Ignore the last sentence ('Putting...'): it's not true. Interface links are
only added to media_interface and not to media_entity. Neither is there a
backlink. I'm not sure if a backlink is needed at all for this.

> 
> 3) While it is easy to find the pads and links for an entity through the
>    new pad and link index fields, the reverse is not true: i.e. media_v2_pad
>    refers to the entity by entity ID, and that would require walking through
>    all entities to find which one it is. I propose adding an entity_idx field
>    as well (and similar to media_v2_links and media_v2_prop) to make it easy
>    to look up the parent object. It's trivial to add in the kernel and makes
>    life much easier for userspace.

I've implemented this.

> 
> 4) I still think adding support for backlinks to G_TOPOLOGY is a good idea.
>    Since the current data structure represents a flattened tree that is easy
>    to navigate the only thing missing for userspace is backlink support.
>    This is still something that userspace needs to figure out when the kernel
>    has this readily available. I think that with this in place applications
>    can just do all the lookups directly on the topology data structure.

I started looking at adding backlink support, but this requires a separate
'backlinks' list instead of having both forward and backward links in the
same links list. I'm not sure what the impact of this would be on the kernel
code.

Regards,

	Hans
