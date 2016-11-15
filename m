Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33438 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbcKOMGb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:06:31 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] vivid: Set color_enc on HSV formats
Date: Tue, 15 Nov 2016 13:06:25 +0100
Message-Id: <20161115120625.3015-2-ricardo.ribalda@gmail.com>
In-Reply-To: <20161115120625.3015-1-ricardo.ribalda@gmail.com>
References: <20161115120625.3015-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HSV formats were missing the color encoding, which leads to an invalid
ycbcr_enc value during get_fmt and try_fmt.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 3d003fb913ed..5fc010f6ce67 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -447,6 +447,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.fourcc   = V4L2_PIX_FMT_HSV24, /* HSV 24bits */
+		.color_enc = TGP_COLOR_ENC_HSV,
 		.vdownsampling = { 1 },
 		.bit_depth = { 24 },
 		.planes   = 1,
@@ -454,6 +455,7 @@ struct vivid_fmt vivid_formats[] = {
 	},
 	{
 		.fourcc   = V4L2_PIX_FMT_HSV32, /* HSV 32bits */
+		.color_enc = TGP_COLOR_ENC_HSV,
 		.vdownsampling = { 1 },
 		.bit_depth = { 32 },
 		.planes   = 1,
-- 
2.10.2

