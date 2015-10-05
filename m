Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbbJEKv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 06:51:57 -0400
Date: Mon, 5 Oct 2015 18:50:47 +0800
From: kbuild test robot <lkp@intel.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, treding@nvidia.com,
	sumit.semwal@linaro.org, tom.cooksey@arm.com,
	daniel.stone@collabora.com, linux-security-module@vger.kernel.org,
	xiaoquan.li@vivantecorp.com, tom.gall@linaro.org,
	linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [RFC PATCH] SMAF: smaf_cma can be static
Message-ID: <20151005105047.GA50465@lkp-ib03>
References: <201510051847.pHUoDbfg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444039898-7927-3-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 smaf-cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/smaf/smaf-cma.c b/drivers/smaf/smaf-cma.c
index ab38717..9fbd9b7 100644
--- a/drivers/smaf/smaf-cma.c
+++ b/drivers/smaf/smaf-cma.c
@@ -175,7 +175,7 @@ error:
 	return NULL;
 }
 
-struct smaf_allocator smaf_cma = {
+static struct smaf_allocator smaf_cma = {
 	.match = smaf_cma_match,
 	.allocate = smaf_cma_allocate,
 	.name = "smaf-cma",
