Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:65412 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751240AbdIPMVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 08:21:11 -0400
Subject: [PATCH 2/3] [media] WL1273: Delete an unnecessary goto statement in
 wl1273_fm_suspend()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <edf138b9-0d47-5074-3ff4-63831c44f196@users.sourceforge.net>
Message-ID: <f725171e-5bf4-a4ce-0d07-987193df2ab7@users.sourceforge.net>
Date: Sat, 16 Sep 2017 14:20:47 +0200
MIME-Version: 1.0
In-Reply-To: <edf138b9-0d47-5074-3ff4-63831c44f196@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 13:53:22 +0200

* Remove an extra goto statement.

* Delete the label "out" which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/radio-wl1273.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 020a792173f6..74dc3195ea2c 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -683,12 +683,9 @@ static int wl1273_fm_suspend(struct wl1273_device *radio)
 	else
 		r = -EINVAL;
 
-	if (r) {
+	if (r)
 		dev_err(radio->dev, "%s: POWER_SET fails: %d\n", __func__, r);
-		goto out;
-	}
 
-out:
 	return r;
 }
 
-- 
2.14.1
