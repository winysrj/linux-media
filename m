Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33980 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139AbcA0NFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:05:09 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E8ECE180D43
	for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 14:05:03 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/5] v4l2: add support to set the InfoFrame content type
Date: Wed, 27 Jan 2016 14:04:58 +0100
Message-Id: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The HDMI standard defines a Content Type field in the AVI InfoFrame that
can tell the receiver what sort of video is being transferred. Based on
that information the receiver can choose to optimize for that content type.

A practical example is that if the content type is set to 'Game' then the
TV might configure itself to a low-latency mode.

But this requires that applications can get/set the content type, and that's
what this patch series does: it adds new content type controls and
implements it in the adv7511 HDMI transmitter and adv7604/adv7842 receivers.

Regards,

	Hans

Changes since v1:

- Add the _IT_ prefix since this is about IT Content, not content in general.
- Add documentation
- Add V4L2_CID_DV_TX_IT_CONTENT_TYPE
- Add V4L2_DV_IT_CONTENT_TYPE_NO_ITC
- Support this in the adv receivers.


Hans Verkuil (5):
  v4l2-ctrls: add V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
  DocBook media: document the new V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE
    controls
  adv7604: add support to for the content type control.
  adv7842: add support to for the content type control.
  adv7511: add support to for the content type control.

 Documentation/DocBook/media/v4l/controls.xml | 50 ++++++++++++++++++++++++++++
 drivers/media/i2c/adv7511.c                  | 22 ++++++++++--
 drivers/media/i2c/adv7604.c                  | 21 ++++++++++++
 drivers/media/i2c/adv7842.c                  | 20 +++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         | 16 +++++++++
 include/uapi/linux/v4l2-controls.h           | 10 ++++++
 6 files changed, 137 insertions(+), 2 deletions(-)

-- 
2.7.0.rc3

