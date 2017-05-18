Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755333AbdERNvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Valentin Vidic <Valentin.Vidic@CARNet.hr>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/13] staging: media: atomisp: drop unused qos variable
Date: Thu, 18 May 2017 15:50:14 +0200
Message-Id: <20170518135022.6069-6-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Valentin Vidic <Valentin.Vidic@CARNet.hr>

Fixes a sparse warning:

drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c:35:5: warning: symbol 'qos' was not declared. Should it be static?

Signed-off-by: Valentin Vidic <Valentin.Vidic@CARNet.hr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
index a6c0f5f8c3f8..b01463361943 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
@@ -32,7 +32,6 @@ static DEFINE_SPINLOCK(msgbus_lock);
 
 static struct pci_dev *pci_root;
 static struct pm_qos_request pm_qos;
-int qos;
 
 #define DW_I2C_NEED_QOS	(platform_is(INTEL_ATOM_BYT))
 
-- 
2.13.0
