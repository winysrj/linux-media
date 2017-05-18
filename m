Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35934 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERIpb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 04:45:31 -0400
Received: by mail-wm0-f51.google.com with SMTP id 70so38175214wmq.1
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 01:45:30 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] cec: stih: allow to use max CEC logical addresses
Date: Thu, 18 May 2017 10:45:09 +0200
Message-Id: <1495097110-20216-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware could support up to 16 logical addresses which is more
than needed by CEC specifications.
Let use CEC_MAX_LOG_ADDRS instead of limited it on one.
stih_cec_adap_log_addr() function was alredy written to support
multiple addresses requests.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/media/platform/sti/cec/stih-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
index 65ee143..6f9f036 100644
--- a/drivers/media/platform/sti/cec/stih-cec.c
+++ b/drivers/media/platform/sti/cec/stih-cec.c
@@ -354,7 +354,7 @@ static int stih_cec_probe(struct platform_device *pdev)
 	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
 			CEC_NAME,
 			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-			CEC_CAP_TRANSMIT, 1);
+			CEC_CAP_TRANSMIT, CEC_MAX_LOG_ADDRS);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
 		return ret;
-- 
1.9.1
