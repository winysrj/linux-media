Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35698 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbcA0H5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 02:57:07 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8B382180D43
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 08:57:01 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] v4l2: add support to set the InfoFrame content type
Date: Wed, 27 Jan 2016 08:56:59 +0100
Message-Id: <1453881421-15865-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The HDMI standard defines a Content Type field in the video InfoFrame that
can tell the receiver what sort of video is being transferred. Based on
that information the receiver can choose to optimize for that content type.

A practical example is that if the content type is set to 'Game' then the
TV might configure itself to a low-latency mode.

But this requires that applications can set the content type, and that's
what this patch series does: it adds a new content type control and
implements it in the adv7511 HDMI transmitter.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-ctrls: add V4L2_CID_DV_TX_CONTENT_TYPE
  adv7511: add content type control support

 drivers/media/i2c/adv7511.c          | 12 +++++++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
 include/uapi/linux/v4l2-controls.h   |  8 ++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

-- 
2.7.0.rc3

