Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:60534 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbdHDKl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] media/cec.h: add CEC_CAP_DEFAULTS
Date: Fri,  4 Aug 2017 12:41:51 +0200
Message-Id: <20170804104155.37386-2-hverkuil@xs4all.nl>
In-Reply-To: <20170804104155.37386-1-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC_CAP_LOG_ADDRS, CEC_CAP_TRANSMIT, CEC_CAP_PASSTHROUGH and
CEC_CAP_RC capabilities are normally always present.

Add a CEC_CAP_DEFAULTS define that ORs these four caps to simplify
drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index 224a6e225c52..1bec7bde4792 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -31,6 +31,9 @@
 #include <media/rc-core.h>
 #include <media/cec-notifier.h>
 
+#define CEC_CAP_DEFAULTS (CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT | \
+			  CEC_CAP_PASSTHROUGH | CEC_CAP_RC)
+
 /**
  * struct cec_devnode - cec device node
  * @dev:	cec device
-- 
2.13.2
