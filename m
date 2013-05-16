Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45979 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3EPIPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 04:15:02 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMV005MPTILO420@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 May 2013 09:15:00 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v3 0/3] added managed media/v4l2 initialization
Date: Thu, 16 May 2013 10:14:31 +0200
Message-id: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the 3rd version of managed initializations for media/v4l2.
Patches are adjusted according to Hans and Laurent suggestions.
Details of changes documented in individual patches.

*** BLURB HERE ***

Andrzej Hajda (3):
  media: added managed media entity initialization
  media: added managed v4l2 control initialization
  media: added managed v4l2/i2c subdevice initialization

 drivers/media/media-entity.c          |   44 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-common.c |   10 ++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c  |   32 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |   25 +++++++++++++++++++
 include/media/media-entity.h          |    5 ++++
 include/media/v4l2-common.h           |    2 ++
 include/media/v4l2-ctrls.h            |   16 ++++++++++++
 include/media/v4l2-subdev.h           |    2 ++
 8 files changed, 136 insertions(+)

-- 
1.7.10.4

