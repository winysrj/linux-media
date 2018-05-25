Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935167AbeEYNM5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:12:57 -0400
Date: Fri, 25 May 2018 16:12:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] media: davinci vpbe: array underflow in
 vpbe_enum_outputs()
Message-ID: <20180525131239.45exrwgxr2f3kb57@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <054ede38-b194-d1f9-7961-851c8b1acd5f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In vpbe_enum_outputs() we check if (temp_index >= cfg->num_outputs) but
the problem is that temp_index can be negative.  I've made
cgf->num_outputs unsigned to fix this issue.

Fixes: 66715cdc3224 ("[media] davinci vpbe: VPBE display driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: fix it a different way

diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 79a566d7defd..180a05e91497 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -92,7 +92,7 @@ struct vpbe_config {
 	struct encoder_config_info *ext_encoders;
 	/* amplifier information goes here */
 	struct amp_config_info *amp;
-	int num_outputs;
+	unsigned int num_outputs;
 	/* Order is venc outputs followed by LCD and then external encoders */
 	struct vpbe_output *outputs;
 };
