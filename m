Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24691 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3EMIfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 04:35:06 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMQ00M82ABJH680@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 May 2013 09:35:03 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC v2 0/3] added managed media/v4l2 initialization
Date: Mon, 13 May 2013 10:34:43 +0200
Message-id: <1368434086-9027-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the 2nd version of managed initializations for media/v4l2.
There are small changes documented in separate patches.

Additionally to advertise this solution I suggest to look at all *_remove
functions in drivers/media/i2c/ tree. After conversion to devm_* versions
most of the *_remove routines could be removed completely.
Below grep for showing all *_remove functions from drivers/media/i2c:
grep -rPzo "(?s)^(\s*)\N*_remove.*?{.*?^\1}" drivers/media/i2c/ --include='*.c'

Andrzej Hajda (3):
  media: added managed media entity initialization
  media: added managed v4l2 control initialization
  media: added managed v4l2 subdevice initialization

 drivers/media/media-entity.c          |   70 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-common.c |   10 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c  |   48 ++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |   52 ++++++++++++++++++++++++
 include/media/media-entity.h          |    6 +++
 include/media/v4l2-common.h           |    2 +
 include/media/v4l2-ctrls.h            |   31 +++++++++++++++
 include/media/v4l2-subdev.h           |    5 +++
 8 files changed, 224 insertions(+)

-- 
1.7.10.4

