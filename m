Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48563 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFIPW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 11:22:26 -0400
Date: Mon, 9 Jun 2014 18:21:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx18: remove duplicate CX18_ALSA_DBGFLG_WARN define
Message-ID: <20140609152108.GP9600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CX18_ALSA_DBGFLG_WARN is cut and pasted twice and we can delete the
second instance.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/cx18/cx18-alsa.h b/drivers/media/pci/cx18/cx18-alsa.h
index 447da37..2718be2 100644
--- a/drivers/media/pci/cx18/cx18-alsa.h
+++ b/drivers/media/pci/cx18/cx18-alsa.h
@@ -49,7 +49,6 @@ static inline void snd_cx18_unlock(struct snd_cx18_card *cxsc)
 }
 
 #define CX18_ALSA_DBGFLG_WARN  (1 << 0)
-#define CX18_ALSA_DBGFLG_WARN  (1 << 0)
 #define CX18_ALSA_DBGFLG_INFO  (1 << 1)
 
 #define CX18_ALSA_DEBUG(x, type, fmt, args...) \
