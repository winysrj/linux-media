Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55649 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIMaN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:30:13 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00CLV6Q1A870@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 21:30:11 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 0/2] Media entity links handling
Date: Thu, 09 May 2013 14:29:31 +0200
Message-id: <1368102573-16183-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This small patch set add a function for removing all links at a media
entity. I found out such a function is needed when media entites that
belong to single media device have drivers in different kernel modules.
This means virtually all camera drivers, since sensors are separate
modules from the host interface drivers.

More details can be found in the commits' description.

The links removal from a media entity is rather strightforward, but when
and where links should be created/removed is not immediately clear to me.

I assumed that links should be created/removed only when an entity is
registered to its media device, and with the graph mutex held.

I'm open to opinions whether it's good or not and possibly suggestions
on how those issues could be handled differently.

Thanks,
Sylwester

Sylwester Nawrocki (2):
  media: Add function removing all media entity links
  V4L: Remove all links of a media entity when unregistering subdev

 drivers/media/media-entity.c          |   51 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-device.c |    4 ++-
 include/media/media-entity.h          |    3 ++
 3 files changed, 57 insertions(+), 1 deletion(-)

--
1.7.9.5

