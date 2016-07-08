Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:37845 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754911AbcGHOME (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 10:12:04 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: Doc s5p-mfc add missing fields to s5p_mfc_dev structure definition
Date: Fri,  8 Jul 2016 08:12:00 -0600
Message-Id: <1467987120-5167-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing documentation for s5p_mfc_dev structure definition.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 9eb2481..1d06d6a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -291,7 +291,9 @@ struct s5p_mfc_priv_buf {
  * @warn_start:		hardware error code from which warnings start
  * @mfc_ops:		ops structure holding HW operation function pointers
  * @mfc_cmds:		cmd structure holding HW commands function pointers
+ * @mfc_regs:		structure holding MFC registers
  * @fw_ver:		loaded firmware sub-version
+ * risc_on:		flag indicates RISC is on or off
  *
  */
 struct s5p_mfc_dev {
-- 
2.7.4

