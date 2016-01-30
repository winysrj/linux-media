Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:40699 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbcA3TEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2016 14:04:14 -0500
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com,
	linux-arm-kernel@lists.infradead.org, ayaka <ayaka@soulik.info>
Subject: [PATCH 0/4] [media] s5p-mfc: remove a few little bugs in driver
Date: Sun, 31 Jan 2016 02:53:33 +0800
Message-Id: <1454180017-29071-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank for review the previous patches, but the current driver still
need the patches below to make it work. I have used gstreamer
to test those patches, it works fine at exynos4412 platform.
As I don't have further platform, I am sure whether it will works
on exynos7, but I think it would be.

The s5p-mfc: Add handling of buffer freeing reqbufs request
comes from chromium project, a developer from that project told me
that he will send this patch to upstream, but I found it not
be merged into mainline, so I send it.

ayaka (4):
  [media] s5p-mfc: Add handling of buffer freeing reqbufs request
  [media] s5p-mfc: remove unnecessary check in try_fmt
  [media] s5p-mfc: don't close instance after free OUTPUT buffers
  [media] s5p-mfc: fix a typo in s5p_mfc_dec

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |  3 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 +++---------
 2 files changed, 4 insertions(+), 11 deletions(-)

-- 
2.5.0

