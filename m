Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37946 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdGMLec (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 07:34:32 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] drxd: make const arrays slowIncrDecLUT and fastIncrDecLUT static
Date: Thu, 13 Jul 2017 12:34:28 +0100
Message-Id: <20170713113428.31981-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays slowIncrDecLUT and fastIncrDecLUT on the stack but
instead make them static. Makes the object code smaller by over 100 bytes:

   text	   data	    bss	    dec	    hex	filename
  27776	    832	     64	  28672	   7000	drxd_hard.o

   text	   data	    bss	    dec	    hex	filename
  27530	    976	     64	  28570	   6f9a	drxd_hard.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/drxd_hard.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 17638e08835a..7d04400b18dd 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -638,8 +638,10 @@ static int SetCfgIfAgc(struct drxd_state *state, struct SCfgAgc *cfg)
 			/* == Speed == */
 			{
 				const u16 maxRur = 8;
-				const u16 slowIncrDecLUT[] = { 3, 4, 4, 5, 6 };
-				const u16 fastIncrDecLUT[] = { 14, 15, 15, 16,
+				static const u16 slowIncrDecLUT[] = {
+					3, 4, 4, 5, 6 };
+				const u16 fastIncrDecLUT[] = {
+					14, 15, 15, 16,
 					17, 18, 18, 19,
 					20, 21, 22, 23,
 					24, 26, 27, 28,
-- 
2.11.0
