Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47884 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2993737AbdDYVc2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 17:32:28 -0400
From: Colin King <colin.king@canonical.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx18: fix spelling mistake: "demodualtor" -> "demodulator"
Date: Tue, 25 Apr 2017 22:32:23 +0100
Message-Id: <20170425213223.20390-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake and add in a white space in
a CX18_ERR error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cx18/cx18-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index d130d65828b0..53f4d6bf81fb 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -151,7 +151,7 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
 	}
 
 	if (ret) {
-		CX18_ERR("The MPC718 board variant with the MT352 DVB-Tdemodualtor will not work without it\n");
+		CX18_ERR("The MPC718 board variant with the MT352 DVB-T demodulator will not work without it\n");
 		CX18_ERR("Run 'linux/Documentation/dvb/get_dvb_firmware mpc718' if you need the firmware\n");
 	}
 	return ret;
-- 
2.11.0
