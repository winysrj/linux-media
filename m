Return-path: <linux-media-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:44883 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933009AbdAHXKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Jan 2017 18:10:21 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 2/2] staging/media/s5p-cec/exynos_hdmi_cecctrl.c Fixed blank line before closing brace '}'
Date: Sun,  8 Jan 2017 17:00:39 -0600
Message-Id: <1483916446-6418-2-git-send-email-scott@matheina.com>
In-Reply-To: <1483916446-6418-1-git-send-email-scott@matheina.com>
References: <1483916446-6418-1-git-send-email-scott@matheina.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed checkpatch check blank line before closing brace '}'

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
index f2b24a4..1edf667 100644
--- a/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
+++ b/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
@@ -87,7 +87,6 @@ void s5p_cec_mask_tx_interrupts(struct s5p_cec_dev *cec)
 	reg |= S5P_CEC_IRQ_TX_DONE;
 	reg |= S5P_CEC_IRQ_TX_ERROR;
 	writeb(reg, cec->reg + S5P_CEC_IRQ_MASK);
-
 }
 
 void s5p_cec_unmask_tx_interrupts(struct s5p_cec_dev *cec)
-- 
2.7.4

