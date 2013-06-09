Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34495 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3FITl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 15:41:59 -0400
Received: by mail-bk0-f44.google.com with SMTP id r7so2988368bkg.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 12:41:57 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com, s.nawrocki@samsung.com
Subject: [RFC PATCH v2 0/2] Media entity links handling
Date: Sun,  9 Jun 2013 21:41:37 +0200
Message-Id: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This small patch set adds a function for removing all links at a media
entity. I found out such a function is needed when media entites that
belong to a single media device have drivers in different kernel modules.
This means virtually all camera drivers, since sensors are separate
modules from the host interface drivers.

More details can be found at each patch's description.

The links removal from a media entity is rather strightforward, but when
and where links should be created/removed is not immediately clear to me.

I assumed that links should normally be created/removed when an entity
is registered to its media device, with the graph mutex held.

I'm open to opinions whether it's good or not and possibly suggestions
on how those issues could be handled differently.

The changes since original version are listed in patch 1/2, in patch 2/2
only the commit description has changed slightly.

Thanks,
Sylwester

Sylwester Nawrocki (2):
  media: Add a function removing all links of a media entity
  V4L: Remove all links of a media entity when unregistering subdev

 drivers/media/media-entity.c          |   48 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-device.c |    4 ++-
 include/media/media-entity.h          |    3 ++
 3 files changed, 54 insertions(+), 1 deletions(-)

-- 
1.7.4.1

