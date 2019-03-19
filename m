Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC5BC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD815217F4
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfCSV54 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:57:56 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:41199 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfCSV5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:55 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id ED9DE100002;
        Tue, 19 Mar 2019 21:57:51 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 09/20] drm/client: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:14 +0100
Message-Id: <c4e7c10eb4d1441ed472ff735d0ed54ddc21262e.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we have a generic image format libary, let's convert the rest of
the DRM core to use it so that we can deprecate the old DRM one.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/drm_client.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 9df52b7fd074..a48181e18934 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -243,7 +243,7 @@ static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
-	const struct drm_format_info *info = drm_format_info(format);
+	const struct image_format_info *info = image_format_drm_lookup(format);
 	struct drm_mode_create_dumb dumb_args = { };
 	struct drm_device *dev = client->dev;
 	struct drm_client_buffer *buffer;
@@ -259,7 +259,7 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u
 
 	dumb_args.width = width;
 	dumb_args.height = height;
-	dumb_args.bpp = drm_format_plane_cpp(info, 0) * 8;
+	dumb_args.bpp = image_format_plane_cpp(info, 0) * 8;
 	ret = drm_mode_create_dumb(dev, &dumb_args, client->file);
 	if (ret)
 		goto err_delete;
@@ -319,10 +319,10 @@ static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 {
 	struct drm_client_dev *client = buffer->client;
 	struct drm_mode_fb_cmd fb_req = { };
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	int ret;
 
-	info = drm_format_info(format);
+	info = image_format_drm_lookup(format);
 	fb_req.bpp = info->cpp[0] * 8;
 	fb_req.depth = info->depth;
 	fb_req.width = width;
-- 
git-series 0.9.1
