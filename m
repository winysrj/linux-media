Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57283 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbbIMTQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:16:38 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 769CA2A009D
	for <linux-media@vger.kernel.org>; Sun, 13 Sep 2015 21:15:22 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] v4l2: add support for the SMPTE 2084 transfer function
Date: Sun, 13 Sep 2015 21:15:17 +0200
Message-Id: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This transfer function is used in High Dynamic Range content. It can be signaled
via the new HDMI Dynamic Range and Mastering InfoFrame (defined in CEA-861.3).

Regards,

	Hans

Hans Verkuil (4):
  videodev2.h: add SMPTE 2084 transfer function define
  vivid-tpg: add support for SMPTE 2084 transfer function
  vivid: add support for SMPTE 2084 transfer function
  DocBook media: Document the SMPTE 2084 transfer function

 Documentation/DocBook/media/v4l/biblio.xml      |  9 +++
 Documentation/DocBook/media/v4l/pixfmt.xml      | 39 ++++++++++
 drivers/media/platform/vivid/vivid-ctrls.c      |  1 +
 drivers/media/platform/vivid/vivid-tpg-colors.c | 96 ++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-tpg-colors.h |  2 +-
 include/uapi/linux/videodev2.h                  |  1 +
 6 files changed, 144 insertions(+), 4 deletions(-)

-- 
2.1.4

