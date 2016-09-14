Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37368 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbcINJXU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 05:23:20 -0400
Received: by mail-wm0-f42.google.com with SMTP id c131so18383156wmh.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 02:23:20 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 4/4] add maintainer for stih-cec driver
Date: Wed, 14 Sep 2016 11:22:04 +0200
Message-Id: <1473844924-13895-5-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0bbe4b1..f541117 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10281,6 +10281,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/serial/
 F:	drivers/tty/serial/
 
+STI CEC DRIVER
+M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
+L:	kernel@stlinux.com
+S:	Maintained
+F:	drivers/staging/media/st-cec/
+F:	Documentation/devicetree/bindings/media/stih-cec.txt
+
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <vireshk@kernel.org>
 M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
-- 
1.9.1

