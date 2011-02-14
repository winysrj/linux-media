Return-path: <mchehab@pedra>
Received: from utm.netup.ru ([193.203.36.250]:39822 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1BNTHE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 14:07:04 -0500
Message-ID: <4D597C71.5040100@netup.ru>
Date: Mon, 14 Feb 2011 22:03:13 +0300
From: Abylay Ospan <aospan@netup.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: [PATCH 1/1] Update stv0900 status when LOCK is missed
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Update stv0900 status when LOCK is missed

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
  drivers/media/dvb/frontends/stv0900_core.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0900_core.c 
b/drivers/media/dvb/frontends/stv0900_core.c
index 4f5e7d3..34afcc6 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1660,8 +1660,10 @@ static int stv0900_read_status(struct 
dvb_frontend *fe, enum fe_status *status)
                         | FE_HAS_VITERBI
                         | FE_HAS_SYNC
                         | FE_HAS_LOCK;
-       } else
+       } else {
+               *status = 0;
                 dprintk("DEMOD LOCK FAIL\n");
+       }

         return 0;
  }
-- 
1.7.2.1.95.g3d045

-- 
Abylai Ospan<aospan@netup.ru>
NetUP Inc.

