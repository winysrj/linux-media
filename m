Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.222.116]:40449 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaGWQPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 12:15:33 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] correct formats info in s5p-mfc encoder
Date: Thu, 24 Jul 2014 00:15:03 +0800
Message-Id: <1406132104-6430-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have tested it in exynos 4412.
I enable MFC and with 64MB buffer in echo bank.

ayaka (1):
  s5p-mfc: correct the formats info for encoder

 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.9.3

