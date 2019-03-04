Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C576CC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A03720823
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfCDU3I (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:29:08 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:49111 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDU3I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 15:29:08 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N49Qd-1h9OeE0Wgr-0103hE; Mon, 04 Mar 2019 21:28:55 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yong Zhi <yong.zhi@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging/intel-ipu3-v4l: reduce kernel stack usage
Date:   Mon,  4 Mar 2019 21:28:42 +0100
Message-Id: <20190304202852.1833000-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:DTlj0/rVijoM9kK6t0PrvaRFK2022Oky9Kc/yOJfbcKOO9qAWIJ
 X8C/zebAP/+NBSYcVXuNXlmae2mHew3qkPURCnZeC17ZscKN27HSdRRRksNIVpfySKfu0wZ
 BI+JHfA7KjS00ks99FDi+bqnLT8nIWDdmlCwTZlgFs33iLWsu+5uNNg8DAp7TdLhU8a7rod
 lUS/F9AlEZhU2fTJRYbGA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FJPIl4G3zGQ=:Pn7LpDCY6fvYgCixLCyvmj
 RxO66Kb8+ts9jJDvAAZ2IG6LveFAbawBj8H8TyOWbzlyC7BNFFXiCedHtq9ZW4fzKQY1c83iu
 JR3q4UcljTeiHz9ae/UjKTqaPdl4wyBXsCS5yd+hWMZL96B67F0B3wjS0i8xbyaegI82AMMZX
 UozwxBg5BptCFA3K5cKUaGpiz7e41/6O+B0OPm+xQTxFW4Uia3Ti8u8Oj/ZISNaSsFjjkZXkA
 ZjukGgWkAZ2Feh1ZYz5fCe3GSAHYBGgAZbFzX8R1zdXMLr3/POxZIq1wQm3eS7KaaMeQ9/5mD
 X7FCDV0+vai7Mp3Dq6I7AwaF2Hy4r64Mw2izZ6bpu/4W5HU1erHM636ZjV3CksMM0aJiDB12B
 lglPa6UmlRD+/7QAkF/JmwmMPAP09sTCbmt/xDRug4FSKCrdzF+Kkql8lkKoIM6eVHFmKhJxO
 6y3uW1OxOghYJBZW9k5s4kE8qfaUetuaI0UPyoky0KZiHOs6sqRtGwnFVgKAR/GXKJCJuuzsk
 88ipPtuZ7WhXAmJD0uVraRUrVW2RWhUpStdTjGEiSpUoP+TYjzSAu541PtbDFBV+LBAk5AHDo
 KxrlSbXHqnuoSsC+Ji3G8Qkq4vTVpJ0e9tUGHAZG1qWvENCwWVKhmVpigrY8J5vZ4g3rI7t34
 mC/QRm6sRTiCrdU96OKAJH2I3w7+SNH6mNcR7PEhB6XgxgPxRxR5pId+vPuFe4DwOOi87Yyvb
 hd0yovPsshy1rnsvlbPtINJf79DykpdJIdpEew==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The v4l2_pix_format_mplane structure is too large to be put on the kernel
stack, as we can see in 32-bit builds:

drivers/staging/media/ipu3/ipu3-v4l2.c: In function 'imgu_fmt':
drivers/staging/media/ipu3/ipu3-v4l2.c:753:1: error: the frame size of 1028 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

By dynamically allocating this array, the stack usage goes down to an
acceptable 272 bytes for the same x86-32 configuration.

Fixes: a0ca1627b450 ("media: staging/intel-ipu3: Add v4l2 driver based on media framework")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 40 ++++++++++++++++----------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 9c0352b193a7..c34b433539c4 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -664,12 +664,11 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 		    struct v4l2_format *f, bool try)
 {
 	struct device *dev = &imgu->pci_dev->dev;
-	struct v4l2_pix_format_mplane try_fmts[IPU3_CSS_QUEUES];
 	struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL };
 	struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
 	struct v4l2_mbus_framefmt pad_fmt;
 	unsigned int i, css_q;
-	int r;
+	int ret;
 	struct imgu_css_pipe *css_pipe = &imgu->css.pipes[pipe];
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 	struct imgu_v4l2_subdev *imgu_sd = &imgu_pipe->imgu_sd;
@@ -698,9 +697,13 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 			continue;
 
 		if (try) {
-			try_fmts[i] =
-				imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
-			fmts[i] = &try_fmts[i];
+			fmts[i] = kmemdup(&imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp,
+					  sizeof(struct v4l2_pix_format_mplane),
+					  GFP_KERNEL);
+			if (!fmts[i]) {
+				ret = -ENOMEM;
+				goto out;
+			}
 		} else {
 			fmts[i] = &imgu_pipe->nodes[inode].vdev_fmt.fmt.pix_mp;
 		}
@@ -730,26 +733,33 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 	 * before we return success from this function, so set it here.
 	 */
 	css_q = imgu_node_to_queue(node);
-	if (fmts[css_q])
-		*fmts[css_q] = f->fmt.pix_mp;
-	else
-		return -EINVAL;
+	if (!fmts[css_q]) {
+		ret = -EINVAL;
+		goto out;
+	}
+	*fmts[css_q] = f->fmt.pix_mp;
 
 	if (try)
-		r = imgu_css_fmt_try(&imgu->css, fmts, rects, pipe);
+		ret = imgu_css_fmt_try(&imgu->css, fmts, rects, pipe);
 	else
-		r = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
+		ret = imgu_css_fmt_set(&imgu->css, fmts, rects, pipe);
 
-	/* r is the binary number in the firmware blob */
-	if (r < 0)
-		return r;
+	/* ret is the binary number in the firmware blob */
+	if (ret < 0)
+		goto out;
 
 	if (try)
 		f->fmt.pix_mp = *fmts[css_q];
 	else
 		f->fmt = imgu_pipe->nodes[node].vdev_fmt.fmt;
 
-	return 0;
+out:
+	if (try) {
+		for (i = 0; i < IPU3_CSS_QUEUES; i++)
+			kfree(fmts[i]);
+	}
+
+	return ret;
 }
 
 static int imgu_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
-- 
2.20.0

