Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57706 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbcKFVBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Nov 2016 16:01:09 -0500
Subject: [PATCH v2 17/34] [media] DaVinci-VPFE-Capture: Replace a memcpy()
 call by an assignment in vpfe_enum_input()
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <88b3de4c-5f3f-9f70-736b-039dca6b8a2e@users.sourceforge.net>
 <f214edb8-0af3-e1f5-8b45-9cfa0537f8b5@xs4all.nl>
 <6a3a4a79-d428-f5d9-87e0-97fd91b75c2a@users.sourceforge.net>
 <3c76f5d0-4469-01a4-3a7c-49401aeb84b7@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <57b1ce94-7b3c-99e2-e02e-1784cb0eef0f@users.sourceforge.net>
Date: Sun, 6 Nov 2016 22:00:53 +0100
MIME-Version: 1.0
In-Reply-To: <3c76f5d0-4469-01a4-3a7c-49401aeb84b7@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 6 Nov 2016 21:54:38 +0100

Use a direct assignment for an array element which can be set over the
pointer variable "inp" instead of calling the function "memcpy" here.

Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8314c39..5417f6b 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1091,7 +1091,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 	}
 	sdinfo = &vpfe_dev->cfg->sub_devs[subdev];
-	memcpy(inp, &sdinfo->inputs[index], sizeof(struct v4l2_input));
+	*inp = sdinfo->inputs[index];
 	return 0;
 }
 
-- 
2.10.2

