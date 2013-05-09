Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14386 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3EIMyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 08:54:19 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00D3A7UFRF00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 13:54:17 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 0/3] added managed media/v4l2 initialization
Date: Thu, 09 May 2013 14:52:41 +0200
Message-id: <1368103965-15232-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those three patches adds devm_* functions for initialization of:
- media entity,
- subdevice,
- v4l2 controls handler.

Converting current v4l2 (sub-)devices to use devm API should simplify
device cleanup routines.

Andrzej Hajda (3):
  media: added managed media entity initialization
  media: added managed v4l2 control initialization
  media: added managed v4l2 subdevice initialization

 drivers/media/media-entity.c          |   70 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-common.c |   10 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c  |   48 ++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |   52 ++++++++++++++++++++++++
 include/media/media-entity.h          |    4 ++
 include/media/v4l2-common.h           |    2 +
 include/media/v4l2-ctrls.h            |   30 ++++++++++++++
 include/media/v4l2-subdev.h           |    5 +++
 8 files changed, 221 insertions(+)

-- 
1.7.10.4

