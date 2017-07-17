Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41685 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751257AbdGQIAY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 04:00:24 -0400
Date: Mon, 17 Jul 2017 10:58:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Paolo Cretaro <melko@frugalware.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] atomisp: array underflow in ioctl
Message-ID: <20170717075854.cmn2dgijylvpqdsp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noticed an array underflow in ov5693_enum_frame_size().  The code
looks like this:

	int index = fse->index;

	if (index >= N_RES)
		retur -EINVAL;

fse->index is a u32 that comes from the user.  We want negative values
to be counted as -EINVAL but they aren't.  There are several ways to fix
this but I feel like the best fix for future proofing is to change the
type of N_RES from int to unsigned long to make it the same as if we
were comparing against ARRAY_SIZE().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.h b/drivers/staging/media/atomisp/i2c/gc0310.h
index f31eb277f542..7d8a0aeecb6c 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.h
+++ b/drivers/staging/media/atomisp/i2c/gc0310.h
@@ -454,6 +454,6 @@ struct gc0310_resolution gc0310_res_video[] = {
 #define N_RES_VIDEO (ARRAY_SIZE(gc0310_res_video))
 
 static struct gc0310_resolution *gc0310_res = gc0310_res_preview;
-static int N_RES = N_RES_PREVIEW;
+static unsigned long N_RES = N_RES_PREVIEW;
 #endif
 
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index ccbc757045a5..7c3d994180cc 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -668,5 +668,5 @@ struct gc2235_resolution gc2235_res_video[] = {
 #define N_RES_VIDEO (ARRAY_SIZE(gc2235_res_video))
 
 static struct gc2235_resolution *gc2235_res = gc2235_res_preview;
-static int N_RES = N_RES_PREVIEW;
+static unsigned long N_RES = N_RES_PREVIEW;
 #endif
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index 944fe8e3bcbf..ab8907e6c9ef 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -934,7 +934,6 @@ static struct ov2680_resolution ov2680_res_video[] = {
 #define N_RES_VIDEO (ARRAY_SIZE(ov2680_res_video))
 
 static struct ov2680_resolution *ov2680_res = ov2680_res_preview;
-static int N_RES = N_RES_PREVIEW;
-
+static unsigned long N_RES = N_RES_PREVIEW;
 
 #endif
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index b0d40965d89e..73ecb1679718 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -1263,5 +1263,5 @@ struct ov2722_resolution ov2722_res_video[] = {
 #define N_RES_VIDEO (ARRAY_SIZE(ov2722_res_video))
 
 static struct ov2722_resolution *ov2722_res = ov2722_res_preview;
-static int N_RES = N_RES_PREVIEW;
+static unsigned long N_RES = N_RES_PREVIEW;
 #endif
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index d88ac1777d86..8c2e6794463b 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -1377,5 +1377,5 @@ struct ov5693_resolution ov5693_res_video[] = {
 #define N_RES_VIDEO (ARRAY_SIZE(ov5693_res_video))
 
 static struct ov5693_resolution *ov5693_res = ov5693_res_preview;
-static int N_RES = N_RES_PREVIEW;
+static unsigned long N_RES = N_RES_PREVIEW;
 #endif
