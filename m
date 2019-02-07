Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE7AC282CC
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 115802147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfBGJNm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53847 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726615AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP4B; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4/6] vsp1: fix smatch warning
Date:   Thu,  7 Feb 2019 10:13:36 +0100
Message-Id: <20190207091338.55705-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAjd/7ltqEPSxaBb9dbLcekKaGTns7bLf0arAdM6etvugChb7Cwt41l1ho9UHofXm/ORxKFn//31Cpi41SRvi2NGHGUnVF0c8EW+5JyyjkhbwTr/bo5x
 3Wj5TNqIrlGBCf3NY6XnuQdmjhystB1yegIy3mMXL5Cn23q3VFm0Z0aSGtzK2cNmmv96Sdvgv5gB0SvA8GSRGKo2rKizXO/ndmFUJCiT4FCx5aBmLQGAgjJw
 meAiiX5Vz3UbZ5kQTKx8OHjpzp3nwptH5NJA3vYcfGjx90+GSol5zaG4JW2FcVqsPayIXo+UNbuJKuvUab8Xcitw8Ib+N2FMJ/vb5LrB8AQOffZVum5W3giY
 6X3+mqJjdPwykfCKHEYFfRmGXuF5CjMHM7r2bJEPn2wG0QgtqqB27bBM7RcPsEzRl3WV906I
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/media/platform/vsp1/vsp1_drm.c: drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx() error: we previously assumed 'pipe->brx' could be null (see line 244)

smatch missed that if pipe->brx was NULL, then later on it will be
set with a non-NULL value. But it is easier to just use the brx pointer
so smatch doesn't get confused.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 8d86f618ec77..84895385d2e5 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -333,19 +333,19 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
 	 * on the BRx sink pad 0 and propagated inside the entity, not on the
 	 * source pad.
 	 */
-	format.pad = pipe->brx->source_pad;
+	format.pad = brx->source_pad;
 	format.format.width = drm_pipe->width;
 	format.format.height = drm_pipe->height;
 	format.format.field = V4L2_FIELD_NONE;
 
-	ret = v4l2_subdev_call(&pipe->brx->subdev, pad, set_fmt, NULL,
+	ret = v4l2_subdev_call(&brx->subdev, pad, set_fmt, NULL,
 			       &format);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
 		__func__, format.format.width, format.format.height,
-		format.format.code, BRX_NAME(pipe->brx), pipe->brx->source_pad);
+		format.format.code, BRX_NAME(brx), brx->source_pad);
 
 	if (format.format.width != drm_pipe->width ||
 	    format.format.height != drm_pipe->height) {
-- 
2.20.1

