Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52585 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbeHGMmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 08:42:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 0/3] Media Controller Properties
Date: Tue,  7 Aug 2018 12:28:44 +0200
Message-Id: <20180807102847.13200-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This RFC patch series implements properties for the media controller.

The main changes since RFCv1 are:

- it is now possible to add properties even if mdev is not yet known.
  It's fixed up in media_device_register_entity().

- Dropped struct media_v2_topology_1 and instead just added a G_TOPOLOGY_OLD
  ioctl define.

- The properties are now laid out in order: first the properties for
  all entities, then the properties for all pads. The properties
  belonging to the same object are always consecutive in the property
  list.

This is not finished, but I wanted to post this so people can discuss
this further. I especially would like to get feedback on the two
proposals at the end.

No documentation yet (too early for that).

An updated v4l2-ctl and v4l2-compliance that can report properties
is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props

Currently I support u64, s64 and const char * property types. But it
can be anything including binary data if needed. No array support (as we
have for controls), but there are enough reserved fields in media_v2_prop
to add this if needed.

I added properties for entities and pads to vimc, so I could test this.

We had a discussion whether we should only export properties for objects
that we query for. E.g. if set ptr_pad to 0, then don't include pad
properties in the property list.

I decided not to do that after all. It became messy and the behavior was
weird. The typical use-case is that you call G_TOPOLOGY once with all
pointers set to 0, then again after allocating the required memory.

So in the first call it will report that there are e.g. 100 properties,
but if you call it again with for example ptr_pad set to 0, then it
might only fill the first 50 properties since it is skipping the pads.
But you still need to allocate space for 100 properties since the first
call has no way of knowing that you only want to get the entity
properties.

It's just weird and I really see no reason to not always return all
properties.

I also have two proposals (not implemented yet):

1) Since the properties are now laid out in a consistent way we can do this:

struct media_v2_entity {
        __u32 id;
        char name[64];
        __u32 function;         /* Main function of the entity */
        __u32 flags;
        __u16 pad_idx;
        __u16 prop_idx;
        __u32 reserved[4];
} __attribute__ ((packed));

struct media_v2_pad {
        __u32 id;
        __u32 entity_id;
        __u32 flags;
        __u32 index;
        __u16 link_idx;
        __u16 prop_idx;
        __u32 reserved[3];
} __attribute__ ((packed));

I.e. the entity and pad structs can be extended with two fields:

pad_idx is the index of the first pad belonging to this entity in the
ptr_pad array and prop_idx is the index of the first property belonging
to this entity in the ptr_prop array.

The same for link_idx and prop_idx in the pad struct.

You can loop over e.g. all the properties of an entity by doing:

        for (i = ent->prop_idx;
             i < topo->num_props && props[i].owner_id == ent->id; i++) {
                // use property
        }

Note 1: since index can be 0 we will need flags to signal which index
fields are valid.

Note 2: the pad/link_idx fields require that we also lay out the pad
structs per entity and the link struct per pad.

2) Since we are adding properties to the topology struct, should we
   perhaps also add support for backlinks? Currently we leave it to
   userspace to deduce the backlinks, but it would not be hard to
   add a ptr_backlinks section to the topology struct. We have all
   the information and it simplifies userspace code. The pad struct
   can then also have a backlink_idx field.

Regards,

        Hans

Hans Verkuil (3):
  uapi/linux/media.h: add property support
  media: add support for properties
  vimc: add test properties

 drivers/media/media-device.c              | 162 +++++++++++++++++--
 drivers/media/media-entity.c              |  79 ++++++++-
 drivers/media/platform/vimc/vimc-common.c |  18 +++
 include/media/media-device.h              |   6 +
 include/media/media-entity.h              | 186 ++++++++++++++++++++++
 include/uapi/linux/media.h                |  40 +++++
 6 files changed, 477 insertions(+), 14 deletions(-)

-- 
2.18.0
