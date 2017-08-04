Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41186 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751319AbdHDKl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] stih-cec: use CEC_CAP_DEFAULTS
Date: Fri,  4 Aug 2017 12:41:54 +0200
Message-Id: <20170804104155.37386-5-hverkuil@xs4all.nl>
In-Reply-To: <20170804104155.37386-1-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new CEC_CAP_DEFAULTS define in this driver.
This also adds the CEC_CAP_RC capability which was missing here
(and this is also the reason for this new define, to avoid missing
such capabilities).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sti/cec/stih-cec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
index ce7964c71b50..dc221527fd05 100644
--- a/drivers/media/platform/sti/cec/stih-cec.c
+++ b/drivers/media/platform/sti/cec/stih-cec.c
@@ -351,9 +351,7 @@ static int stih_cec_probe(struct platform_device *pdev)
 	}
 
 	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
-			CEC_NAME,
-			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-			CEC_CAP_TRANSMIT, CEC_MAX_LOG_ADDRS);
+			CEC_NAME, CEC_CAP_DEFAULTS, CEC_MAX_LOG_ADDRS);
 	if (IS_ERR(cec->adap))
 		return PTR_ERR(cec->adap);
 
-- 
2.13.2
