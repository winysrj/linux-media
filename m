Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbbHDLlT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 07:41:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH_RFC_v1 0/4] MC initial changes due to MC workshop
Date: Tue,  4 Aug 2015 08:41:05 -0300
Message-Id: <cover.1438687440.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an initial set of patches showing the approach I'm taking
in order to fulfill all the MC needs that was discussed on the 3
day MC summit in Helsinki.

As suggested, I'll be sending incremental patches and avoiding to
do a large set of changes into one changeset series.

So, this is the first 4 patches of the changes.

Along this patch series, I'll be calling "object" as anything "symbol"
is part of the media graph. Currently: entity, link and pads.

New object types will be needed to represent interfaces. I suspect
we'll also need another type to represent group of objects, but this
will be covered on future patches.

No userspace API changes here, just changes at the internal structs
that contains the media graph objects and some new helper functions.

The goal of this patchset is:

1) to create a common struct that will be embedded on all internal
   structs that represents the comon data that will be used by
   all kinds of objects;

2) to have an unique object ID for each object in the graph. The
   object ID will be needed by the userspace API in the future, as
   discussed during the MC workshop;

3) to be sure that no data used by an entity will be freed too
   early. Latter patches will do similar changes to links and pads.

With regards to (3), this patchset is not complete yet; it currently
changes only the DVB core, as the changes are simpler there.
I'll be working on a similar change for the V4L2 core. Yet, it would
be nice to have a feedback earlier in order to avoid rework.

Mauro Carvalho Chehab (4):
  media: Add some fields to store graph objects
  media: Add a common embeed struct for all media graph objects
  media: add functions to create/remove entities
  dvbdev: Use functions to create/remove media_entity struct

 drivers/media/dvb-core/dvbdev.c | 13 +++---
 drivers/media/media-device.c    |  4 ++
 drivers/media/media-entity.c    | 99 +++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h    |  4 ++
 include/media/media-entity.h    | 58 ++++++++++++++++++++++++
 5 files changed, 172 insertions(+), 6 deletions(-)

-- 
2.4.3

