Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57761 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdGUQBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:01:06 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Shuah Khan <shuah@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dvb_frontend: initialize variable s with FE_NONE instead of 0
Date: Fri, 21 Jul 2017 17:01:00 +0100
Message-Id: <20170721160100.22617-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

In a previous commit, we added FE_NONE as an unknown fe_status.
Initialize variable s to FE_NONE instead of the more opaque value 0.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 18cc3bbc699c..114994ca0929 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -460,7 +460,7 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
 static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 {
-	enum fe_status s = 0;
+	enum fe_status s = FE_NONE;
 	int retval = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
-- 
2.11.0
