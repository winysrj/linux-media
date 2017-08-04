Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58782 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751320AbdHDKl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] s5p-cec: use CEC_CAP_DEFAULTS
Date: Fri,  4 Aug 2017 12:41:53 +0200
Message-Id: <20170804104155.37386-4-hverkuil@xs4all.nl>
In-Reply-To: <20170804104155.37386-1-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new CEC_CAP_DEFAULTS define in the s5p-cec driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-cec/s5p_cec.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index b2a5694192fa..0347d1740c27 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -219,11 +219,8 @@ static int s5p_cec_probe(struct platform_device *pdev)
 	if (IS_ERR(cec->notifier))
 		return PTR_ERR(cec->notifier);
 
-	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
-		CEC_NAME,
-		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC |
-		(needs_hpd ? CEC_CAP_NEEDS_HPD : 0), 1);
+	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec, CEC_NAME,
+		CEC_CAP_DEFAULTS | (needs_hpd ? CEC_CAP_NEEDS_HPD : 0), 1);
 	if (IS_ERR(cec->adap))
 		return PTR_ERR(cec->adap);
 
-- 
2.13.2
