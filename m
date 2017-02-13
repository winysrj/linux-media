Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36216
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753223AbdBMTJY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:09:24 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH v4 4/4] [media] s5p-mfc: Check and set 'v4l2_pix_format:field' field in try_fmt
Date: Mon, 13 Feb 2017 16:08:36 -0300
Message-Id: <20170213190836.26972-5-thibault.saunier@osg.samsung.com>
In-Reply-To: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
References: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is required by the standard that the field order is set by the
driver.

Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>

---

Changes in v4: None
Changes in v3:
- Do not check values in the g_fmt functions as Andrzej explained in previous review

Changes in v2:
- Fix a silly build error that slipped in while rebasing the patches

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 0976c3e0a5ce..c954b34cb988 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -385,6 +385,20 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	struct s5p_mfc_fmt *fmt;
+	enum v4l2_field field;
+
+	field = f->fmt.pix.field;
+	if (field == V4L2_FIELD_ANY) {
+		field = V4L2_FIELD_NONE;
+	} else if (field != V4L2_FIELD_NONE) {
+		mfc_debug(2, "Not supported field order(%d)\n", pix_mp->field);
+		return -EINVAL;
+	}
+
+	/* V4L2 specification suggests the driver corrects the format struct
+	 * if any of the dimensions is unsupported
+	 */
+	f->fmt.pix.field = field;
 
 	mfc_debug(2, "Type is %d\n", f->type);
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-- 
2.11.1
