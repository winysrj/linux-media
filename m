Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58369 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbbEOM3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:25 -0400
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C29072A009F
	for <linux-media@vger.kernel.org>; Fri, 15 May 2015 14:29:11 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] Add COLORSPACE_DEFAULT and COLORSPACE_RAW
Date: Fri, 15 May 2015 14:29:04 +0200
Message-Id: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds a few new colorspace-related things that have been
in my tree for some time now.

- V4L2_COLORSPACE_DEFAULT is added to represent the value 0 that was used until
  now. This really should have a proper define that's in line with
  V4L2_YCBCR_ENC_DEFAULT and V4L2_QUANTIZATION_DEFAULT.
- Add V4L2_COLORSPACE_RAW to signal raw colorspaces such as produced by digital
  cameras. Here no colorspace processing is done at all. This was requested
  during the mini-summit in San Jose.
- Add new V4L2_MAP_*_DEFAULT defines to make the mapping of DEFAULT values to
  actual colorspace/ycbcr_enc/quantization values consistent for both kernel
  and userspace.

Regards,

        Hans

Hans Verkuil (6):
  videodev2.h: add COLORSPACE_DEFAULT
  DocBook/media: document COLORSPACE_DEFAULT
  videodev2.h: add COLORSPACE_RAW
  DocBook/media: document COLORSPACE_RAW.
  videodev2.h: add macros to map colorspace defaults
  vivid: use new V4L2_MAP_*_DEFAULT defines

 Documentation/DocBook/media/v4l/pixfmt.xml | 12 +++++++
 drivers/media/platform/vivid/vivid-tpg.c   | 51 ++++++------------------------
 include/uapi/linux/videodev2.h             | 39 +++++++++++++++++++++++
 3 files changed, 60 insertions(+), 42 deletions(-)

-- 
2.1.4

