Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:36519 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbcLORar (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:30:47 -0500
Received: by mail-wj0-f174.google.com with SMTP id tk12so72731162wjb.3
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 09:30:47 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 3/9] MAINTAINERS: Add Qualcomm Venus video accelerator driver
Date: Thu, 15 Dec 2016 19:22:18 +0200
Message-Id: <1481822544-29900-4-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1481822544-29900-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Venus video encoder/decoder accelerator driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 52cc0775a799..9528488f538e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10013,6 +10013,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.g
 S:	Supported
 F:	arch/hexagon/
 
+QUALCOMM VENUS VIDEO ACCELERATOR DRIVER
+M:	Stanimir Varbanov <stanimir.varbanov@linaro.org>
+L:	linux-media@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/platform/qcom/venus/
+
 QUALCOMM WCN36XX WIRELESS DRIVER
 M:	Eugene Krasnikov <k.eugene.e@gmail.com>
 L:	wcn36xx@lists.infradead.org
-- 
2.7.4

