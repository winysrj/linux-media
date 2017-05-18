Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERNvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Manny Vindiola <mannyv@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/13] staging: media: atomisp: fix missing blank line coding style issue in atomisp_tpg.c
Date: Thu, 18 May 2017 15:50:21 +0200
Message-Id: <20170518135022.6069-13-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manny Vindiola <mannyv@gmail.com>

This is a patch to the atomisp_tpg.c file that fixes up a missing
blank line warning found by the checkpatch.pl tool

Signed-off-by: Manny Vindiola <mannyv@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
index 996d1bdebad4..48b96048cab4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
@@ -56,6 +56,7 @@ static int tpg_set_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *fmt = &format->format;
+
 	if (format->pad)
 		return -EINVAL;
 	/* only raw8 grbg is supported by TPG */
-- 
2.13.0
