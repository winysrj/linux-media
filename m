Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D3FC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCEE22147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfBGJNn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:43 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60343 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP4J; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5/6] omap3isp: fix sparse warning
Date:   Thu,  7 Feb 2019 10:13:37 +0100
Message-Id: <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
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

drivers/media/platform/omap3isp/ispvideo.c:1013:15: warning: unknown expression (4 0)

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/omap3isp/ispvideo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 078d64114b24..911dfad90d32 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -974,6 +974,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	struct media_entity *source = NULL;
 	struct media_entity *sink;
 	struct v4l2_subdev_format fmt;
+	struct v4l2_subdev *sd;
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
 	unsigned int i;
@@ -1010,8 +1011,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 
 	fmt.pad = source_pad->index;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
-			       pad, get_fmt, NULL, &fmt);
+	sd = media_entity_to_v4l2_subdev(sink);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (unlikely(ret < 0)) {
 		dev_warn(isp->dev, "get_fmt returned null!\n");
 		return ret;
-- 
2.20.1

