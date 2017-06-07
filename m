Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44169 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751514AbdFGOqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>, devicetree@vger.kernel.org
Subject: [PATCH 8/9] s5p_cec: set the CEC_CAP_NEEDS_HPD flag if needed
Date: Wed,  7 Jun 2017 16:46:15 +0200
Message-Id: <20170607144616.15247-9-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the needs-hpd DT property to determine if the CEC_CAP_NEEDS_HPD
should be set.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: devicetree@vger.kernel.org
---
 drivers/media/platform/s5p-cec/s5p_cec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 65a223e578ed..8e06071a7977 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -173,6 +173,7 @@ static int s5p_cec_probe(struct platform_device *pdev)
 	struct platform_device *hdmi_dev;
 	struct resource *res;
 	struct s5p_cec_dev *cec;
+	bool needs_hpd = of_property_read_bool(pdev->dev.of_node, "needs-hpd");
 	int ret;
 
 	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
@@ -221,7 +222,8 @@ static int s5p_cec_probe(struct platform_device *pdev)
 	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
 		CEC_NAME,
 		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC |
+		(needs_hpd ? CEC_CAP_NEEDS_HPD : 0), 1);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
 		return ret;
-- 
2.11.0
