Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbbFELYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 07:24:47 -0400
Date: Fri, 5 Jun 2015 19:24:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: kbuild-all@01.org, Borislav Petkov <bp@suse.de>,
	Doug Thompson <dougthompson@xmission.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bp] EDAC, mce_amd_inj: inj_type can be static
Message-ID: <20150605112426.GA97073@lkp-sb04>
References: <201506051907.ofv5fD3p%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201506051907.ofv5fD3p%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mce_amd_inj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 2a0c829..46a6b0e 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -44,7 +44,7 @@ static const char * const flags_options[] = {
 };
 
 /* Set default injection to SW_INJ */
-enum injection_type inj_type = SW_INJ;
+static enum injection_type inj_type = SW_INJ;
 
 #define MCE_INJECT_SET(reg)						\
 static int inj_##reg##_set(void *data, u64 val)				\
