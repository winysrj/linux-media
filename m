Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0116.outbound.protection.outlook.com ([104.47.42.116]:40939
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751445AbdDNC1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 22:27:32 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Hideki Nozawa <Hideki.Nozawa@sony.com>,
        "Kota Yonezawa" <Kota.Yonezawa@sony.com>,
        Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>,
        Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH v2 07/15] [media] cxd2880: Add integration layer for the driver
Date: Fri, 14 Apr 2017 11:29:59 +0900
Message-ID: <20170414022959.17596-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
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
 .../media/dvb-frontends/cxd2880/cxd2880_integ.c    | 99 ++++++++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_integ.h    | 44 ++++++++++
 2 files changed, 143 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h

diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
new file mode 100644
index 000000000000..5ad6685e2a1d
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
@@ -0,0 +1,99 @@
+/*
+ * cxd2880_integ.c
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common functions
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "cxd2880_tnrdmd.h"
+#include "cxd2880_tnrdmd_mon.h"
+#include "cxd2880_integ.h"
+
+enum cxd2880_ret cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	enum cxd2880_ret ret = CXD2880_RESULT_OK;
+	struct cxd2880_stopwatch timer;
+	u32 elapsed_time = 0;
+	u8 cpu_task_completed = 0;
+
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	ret = cxd2880_tnrdmd_init1(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	ret = cxd2880_stopwatch_start(&timer);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	while (1) {
+		ret = cxd2880_stopwatch_elapsed(&timer, &elapsed_time);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		ret =
+		    cxd2880_tnrdmd_check_internal_cpu_status(tnr_dmd,
+						     &cpu_task_completed);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+
+		if (cpu_task_completed)
+			break;
+
+		if (elapsed_time > CXD2880_TNRDMD_WAIT_INIT_TIMEOUT)
+			return CXD2880_RESULT_ERROR_TIMEOUT;
+		ret =
+		    cxd2880_stopwatch_sleep(&timer,
+					    CXD2880_TNRDMD_WAIT_INIT_INTVL);
+		if (ret != CXD2880_RESULT_OK)
+			return ret;
+	}
+
+	ret = cxd2880_tnrdmd_init2(tnr_dmd);
+	if (ret != CXD2880_RESULT_OK)
+		return ret;
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd)
+{
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	cxd2880_atomic_set(&tnr_dmd->cancel, 1);
+
+	return CXD2880_RESULT_OK;
+}
+
+enum cxd2880_ret cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
+						  *tnr_dmd)
+{
+	if (!tnr_dmd)
+		return CXD2880_RESULT_ERROR_ARG;
+
+	if (cxd2880_atomic_read(&tnr_dmd->cancel) != 0)
+		return CXD2880_RESULT_ERROR_CANCEL;
+
+	return CXD2880_RESULT_OK;
+}
diff --git a/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
new file mode 100644
index 000000000000..9cfc52dbf9d4
--- /dev/null
+++ b/drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
@@ -0,0 +1,44 @@
+/*
+ * cxd2880_integ.h
+ * Sony CXD2880 DVB-T2/T tuner + demodulator driver
+ * integration layer common interface
+ *
+ * Copyright (C) 2016, 2017 Sony Semiconductor Solutions Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
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
+enum cxd2880_ret cxd2880_integ_init(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_cancel(struct cxd2880_tnrdmd *tnr_dmd);
+
+enum cxd2880_ret cxd2880_integ_check_cancellation(struct cxd2880_tnrdmd
+						  *tnr_dmd);
+
+#endif
-- 
2.11.0
