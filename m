Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63125 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbdIWTp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:45:26 -0400
Subject: [PATCH 2/3] [media] camss-csid: Reduce the scope for a variable in
 csid_set_power()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <168ff884-7ace-c548-7f90-d4f2910bb337@users.sourceforge.net>
Message-ID: <8c356ba6-62a3-033d-f3d6-75e1bab1814f@users.sourceforge.net>
Date: Sat, 23 Sep 2017 21:45:20 +0200
MIME-Version: 1.0
In-Reply-To: <168ff884-7ace-c548-7f90-d4f2910bb337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 23 Sep 2017 21:00:30 +0200

Move the definition for the local variable "dev" into an if branch
so that the corresponding setting will only be performed if it was
selected by the parameter "on" of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/qcom/camss-8x16/camss-csid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
index 92d4dc6b4a66..ffda0fbfe4d8 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
@@ -317,10 +317,10 @@ static int csid_reset(struct csid_device *csid)
 static int csid_set_power(struct v4l2_subdev *sd, int on)
 {
 	struct csid_device *csid = v4l2_get_subdevdata(sd);
-	struct device *dev = to_device_index(csid, csid->id);
 	int ret;
 
 	if (on) {
+		struct device *dev = to_device_index(csid, csid->id);
 		u32 hw_version;
 
 		ret = regulator_enable(csid->vdda);
-- 
2.14.1
