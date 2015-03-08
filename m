Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35393 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:53:57 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6D6022A0090
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 08:53:35 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] Colorspace fixes
Date: Sun,  8 Mar 2015 08:53:29 +0100
Message-Id: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two colorspace fixes:

- fix wrong xv601/709 formulas in the colorspace chapter
- BT.2020 RGB is limited range, not full range. Update where needed.

Regards,

	Hans

Hans Verkuil (4):
  DocBook media: fix xv601/709 formulas
  DocBook media: BT.2020 RGB uses limited quantization range
  videodev2.h: fix comment
  vivid: BT.2020 R'G'B' is limited range

 Documentation/DocBook/media/v4l/pixfmt.xml | 23 ++++++++++++-----------
 drivers/media/platform/vivid/vivid-tpg.c   |  4 ++++
 include/uapi/linux/videodev2.h             |  7 ++++---
 3 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.1.4

