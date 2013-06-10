Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49794 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJOzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 10:55:54 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600I81MT3P7E0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 23:55:53 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v3 0/2] Media entity links handling
Date: Mon, 10 Jun 2013 16:54:28 +0200
Message-id: <1370876070-23699-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
References: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an updated version of the patch set
http://www.spinics.net/lists/linux-media/msg64536.html

Comparing to v2 it includes improvements of the __media_entity_remove_links()
function, thanks to Sakari. 

The cover letter of v2 is included below.

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

 drivers/media/media-entity.c          |   50 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-device.c |    4 ++-
 include/media/media-entity.h          |    3 ++
 3 files changed, 56 insertions(+), 1 deletion(-)

-- 
1.7.9.5

