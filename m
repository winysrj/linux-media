Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:58447 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcEGFOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 01:14:50 -0400
From: ayaka <ayaka@soulik.info>
To: linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, nicolas.dufresne@collabora.com,
	shuahkh@osg.samsung.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	ayaka <ayaka@soulik.info>
Subject: [RESEND PATCH] [PATCH 0/3] A few patches make s5p-mfc work with Gstreamer
Date: Sat,  7 May 2016 13:05:23 +0800
Message-Id: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A user-space application will follow the V4l2 document, but I meet
a problem when I test it with Gstreamer. I look at the V4l2
document, the driver check the external setting which the
document not cover, so that is what the second patch do.

The first patch comes from chromium project, but I didn't
find it is merged, so I sent it again with new kernel API.
But I have not test it with 4.6-rc6, as I meet sysmmu problem
there.

But all those patches have been confirmed at Linux 4.1.16.


ayaka (3):
  [media] s5p-mfc: Add handling of buffer freeing reqbufs request
  [media] s5p-mfc: remove unnecessary check in try_fmt
  [media] s5p-mfc: fix a typo in s5p_mfc_dec

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 +++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

-- 
2.5.5

