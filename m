Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39184 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932243AbcKYO5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 09:57:33 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 02/10] MAINTAINERS: Add Qualcomm Camera subsystem driver
Date: Fri, 25 Nov 2016 16:57:14 +0200
Message-Id: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Qualcomm Camera subsystem driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 411e3b8..0740aee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9971,6 +9971,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
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

