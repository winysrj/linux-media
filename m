Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56055 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752167AbdFSO4r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:47 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 02/19] MAINTAINERS: Add Qualcomm Camera subsystem driver
Date: Mon, 19 Jun 2017 17:48:22 +0300
Message-Id: <1497883719-12410-3-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Qualcomm Camera subsystem driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09b5ab6..524fe09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10570,6 +10570,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
 S:	Supported
 F:	drivers/net/wireless/ath/ath10k/
 
+QUALCOMM CAMERA SUBSYSTEM DRIVER
+M:	Todor Tomov <todor.tomov@linaro.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/qcom,camss.txt
+F:	Documentation/media/v4l-drivers/qcom_camss.rst
+F:	drivers/media/platform/qcom/camss/
+
 QUALCOMM EMAC GIGABIT ETHERNET DRIVER
 M:	Timur Tabi <timur@codeaurora.org>
 L:	netdev@vger.kernel.org
-- 
1.9.1
