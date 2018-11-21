Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37967 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728289AbeKVCPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 21:15:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv4 PATCH 0/3] This RFC patch series implements properties for the media controller.
Date: Wed, 21 Nov 2018 16:40:21 +0100
Message-Id: <20181121154024.13906-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The main changes since RFCv3 are:

- Add entity index to media_v2_pad
- Add source/sink pad index to media_v2_link
- Add owner_idx and owner type flags to media_v2_prop

An updated v4l2-ctl and v4l2-compliance that can report properties
is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props

Currently I support u64, s64 and const char * property types. And also
a 'group' type that groups sub-properties. But it can be extended to any
type including binary data if needed. No array support (as we have for
controls), but there are enough reserved fields in media_v2_prop
to add this if needed.

I added properties for entities and pads to vimc, so I could test this.

Note that the changes to media_device_get_topology() are hard to read
from the patch. It is easier to just look at the source code:

https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/media/media-device.c?h=mc-props

I have some ideas to improve this some more:

1) Add the properties directly to media_gobj. This would simplify some
   of the code, but it would require a media_gobj_init function to
   initialize the property list. In general I am a bit unhappy about
   media_gobj_create: it doesn't really create the graph object, instead
   it just adds it to the media_device. It's confusing and it is something
   I would like to change.

2) The links between pads are stored in media_entity instead of in media_pad.
   This is a bit unexpected and makes it harder to traverse the data
   structures since to find the links for a pad you need to walk the entity
   links and find the links for that pad. Putting all links in the entity
   also mixes up pad and interface links, and it would be much cleaner if
   those are separated.

3) I still think adding support for backlinks to G_TOPOLOGY is a good idea.
   Since the current data structure represents a flattened tree that is easy
   to navigate the only thing missing for userspace is backlink support.
   This is still something that userspace needs to figure out when the kernel
   has this readily available. I think that with this in place applications
   can just do all the lookups directly on the topology data structure.

1+2 are internal cleanups that can be done later.

3 is a low-priority future enhancement. This might become easier to implement
once 1+2 are done.

This is pretty much the last RFC. If everyone agree with this approach, then
I can make a final patch series, adding documentation etc.

Regards,

        Hans


Hans Verkuil (3):
  uapi/linux/media.h: add property support
  media controller: add properties support
  vimc: add property test code

 drivers/media/media-device.c              | 335 +++++++++++++++++-----
 drivers/media/media-entity.c              | 107 ++++++-
 drivers/media/platform/vimc/vimc-common.c |  50 ++++
 include/media/media-device.h              |   6 +
 include/media/media-entity.h              | 318 ++++++++++++++++++++
 include/uapi/linux/media.h                |  88 +++++-
 6 files changed, 819 insertions(+), 85 deletions(-)

-- 
2.19.1
