Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2HGCrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:51 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:50 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 05/24] xc5000: properly show quality register values
Date: Mon,  6 Aug 2012 22:46:55 -0400
Message-Id: <1344307634-11673-6-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The quality register only has relevant data in bits 2-0, so discard the
other bits (which results in a value being printed that is consistent with
the expected 0-7 range).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index dcca42c..c41f2b9 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -684,7 +684,7 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 	dprintk(1, "*** Frame lines = %d\n", frame_lines);
 
 	xc_get_quality(priv,  &quality);
-	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality);
+	dprintk(1, "*** Quality (0:<8dB, 7:>56dB) = %d\n", quality & 0x07);
 }
 
 static int xc5000_set_params(struct dvb_frontend *fe)
-- 
1.7.1

