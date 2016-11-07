Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35456 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcKGRmf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:42:35 -0500
Received: by mail-wm0-f46.google.com with SMTP id a197so197507214wmd.0
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 09:42:34 -0800 (PST)
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
Subject: [PATCH v3 2/9] MAINTAINERS: Add Qualcomm Venus video accelerator driver
Date: Mon,  7 Nov 2016 19:33:56 +0200
Message-Id: <1478540043-24558-3-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Venus video encoder/decoder accelerator driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93e9f4227c53..5c2e70e83ff5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9986,6 +9986,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.g
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

