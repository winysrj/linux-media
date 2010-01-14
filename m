Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:59018 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755469Ab0ANTIX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 14:08:23 -0500
Message-ID: <4B4F6BA2.50402@panicking.kicks-ass.org>
Date: Thu, 14 Jan 2010 20:08:18 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	akari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [RFC PATCH] fix try_pix_parm loop
References: <4B4F0762.4040007@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com> <4B4F537B.7000708@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539065@dlee02.ent.ti.com> <4B4F56C8.7060108@panicking.kicks-ass.org>
In-Reply-To: <4B4F56C8.7060108@panicking.kicks-ass.org>
Content-Type: multipart/mixed;
 boundary="------------080407020209070305000908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080407020209070305000908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------080407020209070305000908
Content-Type: text/x-diff;
 name="dont-skip-format.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dont-skip-format.patch"

This patch fix try_pix_parm loop that try to find a suitable format for
the isp engine

Signed-off-by: Michael Trimarchi <michael@panicking.kicks-ass.org>
Cc: akari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Sergio Aguirre <saaguirre@ti.com>

---
diff --git a/drivers/media/video/omap34xxcam.c b/drivers/media/video/omap34xxcam.c
index 53b587e..bf7db71 100644
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -470,7 +470,7 @@ static int try_pix_parm(struct omap34xxcam_videodev *vdev,
 			pix_tmp_out = *wanted_pix_out;
 			rval = isp_try_fmt_cap(isp, &pix_tmp_in, &pix_tmp_out);
 			if (rval)
-				return rval;
+				continue;
 
 			dev_dbg(&vdev->vfd->dev, "this w %d\th %d\tfmt %8.8x\t"
 				"-> w %d\th %d\t fmt %8.8x"

--------------080407020209070305000908--
