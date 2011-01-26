Return-path: <mchehab@pedra>
Received: from utm.netup.ru ([193.203.36.250]:54656 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab1AZI4H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 03:56:07 -0500
Message-ID: <4D3FE13E.5090901@netup.ru>
Date: Wed, 26 Jan 2011 08:54:22 +0000
From: Abylay Ospan <aospan@netup.ru>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Update stv0900 status when LOCK is missed
References: <4d3f3764.857a0e0a.122c.478e@mx.google.com>
In-Reply-To: <4d3f3764.857a0e0a.122c.478e@mx.google.com>
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

