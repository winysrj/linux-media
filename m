Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:41516 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaGVLJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 07:09:57 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so8816018wes.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 04:09:54 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] si2157: Fix DVB-C bandwidth.
Date: Tue, 22 Jul 2014 12:09:48 +0100
Message-Id: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes DVB-C reception.
Without setting the bandwidth to 8MHz the received stream gets corrupted.

Regards,
Luis

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/tuners/si2157.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 6c53edb..e2de428 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -245,6 +245,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 			break;
 	case SYS_DVBC_ANNEX_A:
 			delivery_system = 0x30;
+			bandwidth = 0x08;
 			break;
 	default:
 			ret = -EINVAL;
-- 
1.9.1

