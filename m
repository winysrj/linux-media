Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56234 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732495AbeHCQdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 12:33:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/3] Media Controller Properties
Date: Fri,  3 Aug 2018 16:36:23 +0200
Message-Id: <20180803143626.48191-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This RFC patch series implements properties for the media controller.

This is not finished, but I wanted to post this so people can discuss
this further.

No documentation yet (too early for that).

An updated v4l2-ctl and v4l2-compliance that can report properties
is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props

There is one main missing piece: currently the properties are effectively
laid out in random order. My plan is to change that so they are grouped
by object type and object owner. So first all properties for each entity,
then for each pad, etc. I started to work on that, but it's a bit more
work than expected and I wanted to post this before the weekend.

While it is possible to have nested properties, this is not currently
implemented. Only properties for entities and pads are supported in this
code, but that's easy to extend to interfaces and links.

I'm not sure about the G_TOPOLOGY ioctl handling: I went with the quickest
option by renaming the old ioctl and adding a new one with property support.

I think this needs to change (at the very least the old and new should
share the same ioctl NR), but that's something for the future.

Currently I support u64, s64 and const char * property types. But it
can be anything including binary data if needed. No array support (as we
have for controls), but there are enough reserved fields in media_v2_prop
to add this if needed.

I added properties for entities and pads to vimc, so I could test this.

Regards,

	Hans

Hans Verkuil (3):
  uapi/linux/media.h: add property support
  media: add support for properties
  vimc: add test properties

 drivers/media/media-device.c              |  98 +++++++++++-
 drivers/media/media-entity.c              |  65 ++++++++
 drivers/media/platform/vimc/vimc-common.c |  18 +++
 drivers/media/platform/vimc/vimc-core.c   |   6 +-
 include/media/media-device.h              |   6 +
 include/media/media-entity.h              | 172 ++++++++++++++++++++++
 include/uapi/linux/media.h                |  62 +++++++-
 7 files changed, 420 insertions(+), 7 deletions(-)

-- 
2.18.0
