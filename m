Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:59641 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaIDIBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 04:01:40 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, m.chehab@samsung.com, hverkuil@xs4all.nl,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] fix enum_fmt for s5p-mfc
Date: Thu,  4 Sep 2014 15:52:38 +0800
Message-Id: <1409817159-6237-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch remove the non-multiplanar api for enum_fmt in s5p-mfc.
Now enum_fmt in the driver will only work with multiplanar.
I think it is a bug, hverkuil think it is too. so I made this patch.
Actually gstreamer doesn't care about it, it will merge the result
from non-multiplanar and multiplanar.

ayaka (1):
  media: fix enum_fmt for s5p-mfc

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 24 +++---------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 24 +++---------------------
 2 files changed, 6 insertions(+), 42 deletions(-)

-- 
1.9.3

