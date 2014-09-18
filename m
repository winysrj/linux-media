Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39752 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaIRTlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 15:41:35 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, arun.m@samsung.com, arun.kk@samsung.com,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] fix enum_fmt for s5p-mfc
Date: Fri, 19 Sep 2014 03:41:11 +0800
Message-Id: <1411069272-16896-1-git-send-email-ayaka@soulik.info>
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

