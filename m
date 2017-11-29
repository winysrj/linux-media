Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46903 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754416AbdK2Kqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:49 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Daniel Scheller <d.scheller@gmx.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 07/12] media: dvb_frontend fix kernel_doc markups
Date: Wed, 29 Nov 2017 05:46:28 -0500
Message-Id: <771a0997ef305cd4a763877a9fd2caa6d4a4276f.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were some troubles there:
	drivers/media/dvb-core/dvb_frontend.c:379: warning: No description found for parameter 'fe'
	drivers/media/dvb-core/dvb_frontend.c:379: warning: No description found for parameter 'check_wrapped'
	drivers/media/dvb-core/dvb_frontend.c:1265: warning: No description found for parameter 'p_out'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3ad83359098b..2afaa8226342 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -369,11 +369,14 @@ static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepr
 }
 
 /**
- * Performs automatic twiddling of frontend parameters.
+ * dvb_frontend_swzigzag_autotune - Performs automatic twiddling of frontend
+ *	parameters.
  *
- * @param fe The frontend concerned.
- * @param check_wrapped Checks if an iteration has completed. DO NOT SET ON THE FIRST ATTEMPT
- * @returns Number of complete iterations that have been performed.
+ * @fe: The frontend concerned.
+ * @check_wrapped: Checks if an iteration has completed.
+ *		   DO NOT SET ON THE FIRST ATTEMPT.
+ *
+ * return: Number of complete iterations that have been performed.
  */
 static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wrapped)
 {
@@ -1253,7 +1256,7 @@ dtv_property_legacy_params_sync(struct dvb_frontend *fe,
  * dtv_get_frontend - calls a callback for retrieving DTV parameters
  * @fe:		struct dvb_frontend pointer
  * @c:		struct dtv_frontend_properties pointer (DVBv5 cache)
- * @p_out	struct dvb_frontend_parameters pointer (DVBv3 FE struct)
+ * @p_out:	struct dvb_frontend_parameters pointer (DVBv3 FE struct)
  *
  * This routine calls either the DVBv3 or DVBv5 get_frontend call.
  * If c is not null, it will update the DVBv5 cache struct pointed by it.
-- 
2.14.3
