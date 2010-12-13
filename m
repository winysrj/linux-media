Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39354 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0LMCKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 21:10:35 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH] [media] s5p-fimc: fix the value of YUV422 1plane formats
Date: Mon, 13 Dec 2010 10:50:51 +0900
Message-Id: <1292205051-26707-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Some color formats are mismatched in s5p-fimc driver.
CICICTRL[1:0], order422_out, should be set 2b'00 not 2b'11 to use V4L2_PIX_FMT_YUYV.
Because in V4L2 standard V4L2_PIX_FMT_YUYV means "start + 0: Y'00 Cb00 Y'01 Cr00 Y'02 Cb01 Y'03 Cr01".
According to datasheet 2b'00 is right value for V4L2_PIX_FMT_YUYV.

================================================================
  bit |    MSB                                        LSB
================================================================
  00  |  Cr1    Y3    Cb1    Y2    Cr0    Y1    Cb0    Y0
================================================================
  01  |  Cb1    Y3    Cr1    Y2    Cb0    Y1    Cr0    Y0
================================================================
  10  |  Y3    Cr1    Y2    Cb1    Y1    Cr0    Y0    Cb0
================================================================
  11  |  Y3    Cb1    Y2    Cr1    Y1    Cb0    Y0    Cr0
================================================================

V4L2_PIX_FMT_YVYU, V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_VYUY are also mismatched with datasheet.
MSCTRL[17:16], order2p_in, is also mismatched in V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YVYU.

Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
---

I wonder why fimc_fmt struct has fourcc and color together as member of structure.
It seems that the meaning of color is the same as fourcc's meaning.

 drivers/media/video/s5p-fimc/fimc-core.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a707060..4efc1a1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -96,15 +96,15 @@ enum fimc_color_fmt {
 #define fimc_fmt_is_rgb(x) ((x) & 0x10)
 
 /* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats. */
-#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_CRYCBY
-#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_YCRYCB
-#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_CBYCRY
-#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_YCBYCR
+#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_YCBYCR
+#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_YCRYCB
+#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_CRYCBY
 
 /* Input Y/Cb/Cr components order for 1 plane YCbCr 4:2:2 color formats. */
 #define	S5P_FIMC_IN_CRYCBY	S5P_MSCTRL_ORDER422_CRYCBY
-#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_YCRYCB
-#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_CBYCRY
+#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_YCRYCB
 #define	S5P_FIMC_IN_YCBYCR	S5P_MSCTRL_ORDER422_YCBYCR
 
 /* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
-- 
1.6.2.5

