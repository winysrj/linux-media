Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab1KJXfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:40 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:40 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 22/25] modified Makefile for pctv80e support
Date: Thu, 10 Nov 2011 17:31:42 -0600
Message-Id: <1320967905-7932-23-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index f639f67..4709ebc 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -11,6 +11,7 @@ au8522-objs = au8522_dig.o au8522_decoder.o
 drxd-objs = drxd_firm.o drxd_hard.o
 cxd2820r-objs = cxd2820r_core.o cxd2820r_c.o cxd2820r_t.o cxd2820r_t2.o
 drxk-objs := drxk_hard.o
+drx39xyj-objs := drx39xxj.o drx_driver.o drx39xxj_dummy.o drxj.o drx_dap_fasi.o
 
 obj-$(CONFIG_DVB_PLL) += dvb-pll.o
 obj-$(CONFIG_DVB_STV0299) += stv0299.o
@@ -86,6 +87,7 @@ obj-$(CONFIG_DVB_ISL6423) += isl6423.o
 obj-$(CONFIG_DVB_EC100) += ec100.o
 obj-$(CONFIG_DVB_DS3000) += ds3000.o
 obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
+obj-$(CONFIG_DVB_DRX39XYJ) += drx39xyj.o
 obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
 obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
 obj-$(CONFIG_DVB_STV0367) += stv0367.o
-- 
1.7.5.4

