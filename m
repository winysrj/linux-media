Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0126.outbound.protection.outlook.com ([104.47.42.126]:20025
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754847AbeARIrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 03:47:10 -0500
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v5 06/12] [media] cxd2880: Add integration layer for the driver
Date: Thu, 18 Jan 2018 17:51:10 +0900
Message-ID: <20180118085110.21374-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
References: <20180118084016.20689-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

These functions monitor the driver and watch for task completion.
This is part of the Sony CXD2880 DVB-T2/T tuner + demodulator driver.

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---

[Change list]
Changes in V5
   Using SPDX-License-Identifier
   drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
      -removed unnecessary if() 
      -changed timer function from stop_watch to ktime

Changes in V4   
   drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
      -removed unnecessary initialization at variable declaration

Changes in V3
   drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
      -changed cxd2880_atomic_read to atomic_read
      -changed cxd2880_atomic_set to atomic_set
      -modified return code
      -modified coding style of if() 
   drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
      -modified return code

 .../media/dvb-frontends/cxd2880/cxd2880_integ.c    | 72 ++++++++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_integ.h    | 27 ++++++++
 2 files changed, 99 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
new file mode 100644
index 000000000000..5302ab0964c1
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxd2880_integ.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common functions
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#include <linux/ktime.h>
+#include <linux/errno.h>
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_integ.h"
+
+int cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	int ret;
+	ktime_t start;
+	u8 cpu_task_completed = 0;
+
+	if (!tnr_dmd)
+		return -EINVAL;
+
+	ret = cxd2880_tnrdmd_init1(tnr_dmd);
+	if (ret)
+		return ret;
+
+	start = ktime_get();
+
+	while (1) {
+		ret =
+		    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
+						     &cpu_task_completed);
+		if (ret)
+			return ret;
+
+		if (cpu_task_completed)
+			break;
+
+		if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
+					CXD2880_TNRDMD_WAIT_INIT_TIMEOUT)
+			return -ETIMEDOUT;
+
+		usleep_range(CXD2880_TNRDMD_WAIT_INIT_INTVL,
+			     CXD2880_TNRDMD_WAIT_INIT_INTVL + 1000);
+	}
+
+	return cxd2880_tnrdmd_init2(tnr_dmd);
+}
+
+int cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	if (!tnr_dmd)
+		return -EINVAL;
+
+	atomic_set(&tnr_dmd->cancel, 1);
+
+	return 0;
+}
+
+int cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	if (!tnr_dmd)
+		return -EINVAL;
+
+	if (atomic_read(&tnr_dmd->cancel) != 0)
+		return -ECANCELED;
+
+	return 0;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
new file mode 100644
index 000000000000..7160225db8b9
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * cxd2880_integ.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common interface
+ *
+ * Copyright (C) 2016, 2017, 2018 Sony Semiconductor Solutions Corporation
+ */
+
+#ifndef CXD2880_INTEG_H
+#define CXD2880_INTEG_H
+
+#include "cxd2880_tnrdmd.h"
+
+#define CXD2880_TNRDMD_WAIT_INIT_TIMEOUT	500
+#define CXD2880_TNRDMD_WAIT_INIT_INTVL	10
+
+#define CXD2880_TNRDMD_WAIT_AGC_STABLE		100
+
+int cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd);
+
+int cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd);
+
+int cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
+				     *tnr_dmd);
+
+#endif
-- 
2.15.1
