Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0064.outbound.protection.outlook.com ([104.47.34.64]:52992
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753925AbcLPEvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 23:51:22 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <hverkuil@xs4all.nl>, <mchehab@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Chris Kohn <ckohn@xilinx.com>, <kuldeepd@xilinx.com>,
        <radheys@xilinx.com>,
        "Soren Brinkmann" <soren.brinkmann@xilinx.com>
Subject: [PATCH] vivid: Enable 4k resolution for webcam capture device
Date: Thu, 15 Dec 2016 17:17:57 -0800
Message-ID: <20161216011757.27079-1-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add 3840x2160 as valid resolution for the webcam capture input and
adjust the webcam intervals accordingly.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

we'd like to use the vivid webcam capture device with a 4k resolution. This
basically seems to do the trick, though, I'm not sure if there is a particular
system in choosing values for the 'intervals' array.

	Sören

 drivers/media/platform/vivid/vivid-vid-cap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index c52dd8787794..a18e6fec219b 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -63,7 +63,7 @@ static const struct vivid_fmt formats_ovl[] = {
 };
 
 /* The number of discrete webcam framesizes */
-#define VIVID_WEBCAM_SIZES 4
+#define VIVID_WEBCAM_SIZES 5
 /* The number of discrete webcam frameintervals */
 #define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
 
@@ -73,6 +73,7 @@ static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
 	{  640, 360 },
 	{ 1280, 720 },
 	{ 1920, 1080 },
+	{ 3840, 2160 },
 };
 
 /*
@@ -80,7 +81,9 @@ static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
  * elements in this array as there are in webcam_sizes.
  */
 static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
+	{  1, 1 },
 	{  1, 2 },
+	{  1, 4 },
 	{  1, 5 },
 	{  1, 10 },
 	{  1, 15 },
-- 
2.11.0.3.g119133d

