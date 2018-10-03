Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39714 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeJCNyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 09:54:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id r9-v6so1125027pgv.6
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 00:07:07 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        jcliang@chromium.org, shik@chromium.org, keiichiw@chromium.org
Subject: [PATCH] media: vivid: Support 480p for webcam capture
Date: Wed,  3 Oct 2018 16:06:56 +0900
Message-Id: <20181003070656.193854-1-keiichiw@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support 640x480 as a frame size for video input devices of vivid.

Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 58e14dd1dcd3..da80bf4bc365 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -51,7 +51,7 @@ static const struct vivid_fmt formats_ovl[] = {
 };
 
 /* The number of discrete webcam framesizes */
-#define VIVID_WEBCAM_SIZES 5
+#define VIVID_WEBCAM_SIZES 6
 /* The number of discrete webcam frameintervals */
 #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
 
@@ -59,6 +59,7 @@ static const struct vivid_fmt formats_ovl[] = {
 static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
 	{  320, 180 },
 	{  640, 360 },
+	{  640, 480 },
 	{ 1280, 720 },
 	{ 1920, 1080 },
 	{ 3840, 2160 },
@@ -75,6 +76,8 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
 	{  1, 5 },
 	{  1, 10 },
 	{  1, 15 },
+	{  1, 15 },
+	{  1, 25 },
 	{  1, 25 },
 	{  1, 30 },
 	{  1, 50 },
-- 
2.19.0.605.g01d371f741-goog
