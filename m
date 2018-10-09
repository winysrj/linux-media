Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39229 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbeJIVAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 17:00:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id r9-v6so838829pgv.6
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 06:43:50 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, kieran.bingham@ideasonboard.com,
        tfiga@chromium.org, jcliang@chromium.org, shik@chromium.org,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v2] media: vivid: Support 480p for webcam capture
Date: Tue,  9 Oct 2018 22:43:39 +0900
Message-Id: <20181009134339.233238-1-keiichiw@chromium.org>
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
index 58e14dd1dcd3..6cf910a60ecf 100644
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
@@ -74,9 +75,11 @@ static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
 	{  1, 4 },
 	{  1, 5 },
 	{  1, 10 },
+	{  2, 25 },
 	{  1, 15 },
 	{  1, 25 },
 	{  1, 30 },
+	{  1, 40 },
 	{  1, 50 },
 	{  1, 60 },
 };
-- 
2.19.0.605.g01d371f741-goog
