Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D8FC10F00
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62EC72085A
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="XV5Q75aT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfCRObo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:44 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCRObn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:43 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 031241232;
        Mon, 18 Mar 2019 15:31:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919497;
        bh=xVqoFozCw4tsrRAfee2lz13KhTL/fi2pYlsqHb3MaIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV5Q75aTFcOstMQkXi4HtyCglEKhsSpCzOPFM6Otk8p0otbh8PYi4PljDgCb21sj8
         /EcJBf9s3qDF5XmfF3UQiSCLl2Pz1a/0miqF8XcdpWwgId50jQ+G5uWzmEME8UpgW7
         UFSmQPshvOe8alxzvh2KB1aX6yGfGyDOtlIeEDhI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 09/18] media: vsp1: drm: Split RPF format setting to separate function
Date:   Mon, 18 Mar 2019 16:31:12 +0200
Message-Id: <20190318143121.29561-10-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The code that initializes the RPF format-related fields for display
pipelines will also be useful for the WPF to implement writeback
support. Split it from vsp1_du_atomic_update() to a new
vsp1_du_pipeline_set_rwpf_format() function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 55 ++++++++++++++++----------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index e28a742a7575..d1c88e8aee52 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -566,6 +566,36 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 	vsp1_dl_list_commit(dl, dl_flags);
 }
 
+static int vsp1_du_pipeline_set_rwpf_format(struct vsp1_device *vsp1,
+					    struct vsp1_rwpf *rwpf,
+					    u32 pixelformat, unsigned int pitch)
+{
+	const struct vsp1_format_info *fmtinfo;
+	unsigned int chroma_hsub;
+
+	fmtinfo = vsp1_get_format_info(vsp1, pixelformat);
+	if (!fmtinfo) {
+		dev_dbg(vsp1->dev, "Unsupported pixel format %08x\n",
+			pixelformat);
+		return -EINVAL;
+	}
+
+	/*
+	 * Only formats with three planes can affect the chroma planes pitch.
+	 * All formats with two planes have a horizontal subsampling value of 2,
+	 * but combine U and V in a single chroma plane, which thus results in
+	 * the luma plane and chroma plane having the same pitch.
+	 */
+	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
+
+	rwpf->fmtinfo = fmtinfo;
+	rwpf->format.num_planes = fmtinfo->planes;
+	rwpf->format.plane_fmt[0].bytesperline = pitch;
+	rwpf->format.plane_fmt[1].bytesperline = pitch / chroma_hsub;
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * DU Driver API
  */
@@ -773,9 +803,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
-	const struct vsp1_format_info *fmtinfo;
-	unsigned int chroma_hsub;
 	struct vsp1_rwpf *rpf;
+	int ret;
 
 	if (rpf_index >= vsp1->info->rpf_count)
 		return -EINVAL;
@@ -808,25 +837,11 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	 * Store the format, stride, memory buffer address, crop and compose
 	 * rectangles and Z-order position and for the input.
 	 */
-	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
-	if (!fmtinfo) {
-		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
-			cfg->pixelformat);
-		return -EINVAL;
-	}
+	ret = vsp1_du_pipeline_set_rwpf_format(vsp1, rpf, cfg->pixelformat,
+					       cfg->pitch);
+	if (ret < 0)
+		return ret;
 
-	/*
-	 * Only formats with three planes can affect the chroma planes pitch.
-	 * All formats with two planes have a horizontal subsampling value of 2,
-	 * but combine U and V in a single chroma plane, which thus results in
-	 * the luma plane and chroma plane having the same pitch.
-	 */
-	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
-
-	rpf->fmtinfo = fmtinfo;
-	rpf->format.num_planes = fmtinfo->planes;
-	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
-	rpf->format.plane_fmt[1].bytesperline = cfg->pitch / chroma_hsub;
 	rpf->alpha = cfg->alpha;
 
 	rpf->mem.addr[0] = cfg->mem[0];
-- 
Regards,

Laurent Pinchart

