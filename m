Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:24064 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753744AbdCTOm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:27 -0400
Subject: [PATCH 22/24] staging: atomisp: remove redudant condition in
 if-statement
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:42:23 +0000
Message-ID: <149002094250.17109.4699082985014190627.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daeseok Youn <daeseok.youn@gmail.com>

The V4L2_FIELD_ANY is zero, so the (!field) is same meaning
with (field == V4L2_FIELD_ANY) in if-statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 036413b..0a2df3d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -5081,7 +5081,7 @@ atomisp_try_fmt_file(struct atomisp_device *isp, struct v4l2_format *f)
 
 	depth = get_pixel_depth(pixelformat);
 
-	if (!field || field == V4L2_FIELD_ANY)
+	if (field == V4L2_FIELD_ANY)
 		field = V4L2_FIELD_NONE;
 	else if (field != V4L2_FIELD_NONE) {
 		dev_err(isp->dev, "Wrong output field\n");
