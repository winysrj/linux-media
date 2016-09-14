Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37439 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760712AbcINLfF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 07:35:05 -0400
Received: by mail-wm0-f41.google.com with SMTP id k186so963320wmd.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 04:35:04 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 4/4] add maintainer for stih-cec driver
Date: Wed, 14 Sep 2016 13:34:29 +0200
Message-Id: <1473852869-17236-5-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473852869-17236-4-git-send-email-benjamin.gaignard@linaro.org>
References: <1473852869-17236-4-git-send-email-benjamin.gaignard@linaro.org>
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

