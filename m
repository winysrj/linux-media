Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38039 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965416AbdGTWMO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 18:12:14 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Ingo Molnar <mingo@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] dvb_frontend: ensure that inital front end status initialized
Date: Thu, 20 Jul 2017 23:12:07 +0100
Message-Id: <20170720221207.7505-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The fe_status variable s is not initialized meaning it can have any
random garbage status.  This could be problematic if fe->ops.tune is
false as s is not updated by the call to fe->ops.tune() and a
subsequent check on the change status will using a garbage value.
Fix this by adding FE_NONE to the enum fe_status and initializing
s to this.

Detected by CoverityScan, CID#112887 ("Uninitialized scalar variable")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 include/uapi/linux/dvb/frontend.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e3fff8f64d37..18cc3bbc699c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -631,7 +631,7 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend *fe = data;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	enum fe_status s;
+	enum fe_status s = FE_NONE;
 	enum dvbfe_algo algo;
 	bool re_tune = false;
 	bool semheld = false;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 00a20cd21ee2..afc3972b0879 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -127,6 +127,7 @@ enum fe_sec_mini_cmd {
  *			to reset DiSEqC, tone and parameters
  */
 enum fe_status {
+	FE_NONE			= 0x00,
 	FE_HAS_SIGNAL		= 0x01,
 	FE_HAS_CARRIER		= 0x02,
 	FE_HAS_VITERBI		= 0x04,
-- 
2.11.0
