Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42200 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbbIMQmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:42:51 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DF4562A009D
	for <linux-media@vger.kernel.org>; Sun, 13 Sep 2015 18:41:33 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] v4l2: add support for the DCI-P3 colorspace
Date: Sun, 13 Sep 2015 18:41:26 +0200
Message-Id: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DCI-P3 colorspace. This colorspace
is used by cinema projectors and is also support by the DisplayPort
standard.

The first patch is a cleanup patch for the vivid driver, the second
improves the colorspace handling of NTSC 1953 (it now compensates for the
different whitepoints between NTSC 1953 and Rec. 709).

The next two add support for DCI-P3 to the header and the documentation and
the last two support the new colorspace in the vivid driver.

Regards,

	Hans

Hans Verkuil (6):
  vivid: use ARRAY_SIZE to calculate max control value
  vivid: use Bradford method when converting Rec. 709 to NTSC 1953
  videodev2.h: add support for the DCI-P3 colorspace
  DocBook media: document the new DCI-P3 colorspace
  vivid-tpg: support the DCI-P3 colorspace
  vivid: add support for the DCI-P3 colorspace

 Documentation/DocBook/media/v4l/biblio.xml      |   9 +
 Documentation/DocBook/media/v4l/pixfmt.xml      |  70 +++++++
 drivers/media/platform/vivid/vivid-core.h       |   1 +
 drivers/media/platform/vivid/vivid-ctrls.c      |  17 +-
 drivers/media/platform/vivid/vivid-tpg-colors.c | 238 +++++++++++++++++++-----
 drivers/media/platform/vivid/vivid-tpg-colors.h |   4 +-
 include/uapi/linux/videodev2.h                  |  18 +-
 7 files changed, 296 insertions(+), 61 deletions(-)

-- 
2.1.4

