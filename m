Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42298 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbbGBN3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2015 09:29:07 -0400
Received: from cobaltpc1.cisco.com (unknown [173.38.220.51])
	by tschai.lan (Postfix) with ESMTPSA id 993AA2A00AF
	for <linux-media@vger.kernel.org>; Thu,  2 Jul 2015 15:28:25 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/2] Add VIDIOC_SUBDEV_QUERYCAP
Date: Thu,  2 Jul 2015 15:27:48 +0200
Message-Id: <cover.1435842920.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev devices
as discussed during the ELC in San Jose and as discussed here:

http://www.spinics.net/lists/linux-media/msg88009.html

This patch series returns to the v1 patch series, but it drops the pads field
and the VIDIOC_QUERYCAP changes.

This should hopefully make this a minimal uncontroversial implementation that
I can finally start using in the v4l2-compliance utility.

Ideally I'd like to have a link back to the media controller, which is what
the v2 patch series was all about, but not everyone agrees so I will probably
require that when v4l2-compliance is called for a v4l-subdev node you also
have to provide the MC device node.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
  DocBook/media: document VIDIOC_SUBDEV_QUERYCAP

 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 133 +++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c              |  17 +++
 include/uapi/linux/v4l2-subdev.h                   |  18 +++
 4 files changed, 169 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml

-- 
2.1.4

