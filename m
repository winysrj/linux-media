Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:65161 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdB1VQr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 16:16:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tw5864: use dev_warn instead of WARN to shut up warning
Date: Tue, 28 Feb 2017 22:14:37 +0100
Message-Id: <20170228211453.3688400-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw5864_frameinterval_get() only initializes its output when it successfully
identifies the video standard in tw5864_input. We get a warning here because
gcc can't always track the state if initialized warnings across a WARN()
macro, and thinks it might get used incorrectly in tw5864_s_parm:

media/pci/tw5864/tw5864-video.c: In function 'tw5864_s_parm':
media/pci/tw5864/tw5864-video.c:816:38: error: 'time_base.numerator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/pci/tw5864/tw5864-video.c:819:31: error: 'time_base.denominator' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Using dev_warn() instead of WARN() avoids the __branch_check__() in
unlikely and lets the compiler see that the initialization is correct.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/tw5864/tw5864-video.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 9421216bb942..4d9994a11c22 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -717,6 +717,8 @@ static void tw5864_frame_interval_set(struct tw5864_input *input)
 static int tw5864_frameinterval_get(struct tw5864_input *input,
 				    struct v4l2_fract *frameinterval)
 {
+	struct tw5864_dev *dev = input->root;
+
 	switch (input->std) {
 	case STD_NTSC:
 		frameinterval->numerator = 1001;
@@ -728,8 +730,8 @@ static int tw5864_frameinterval_get(struct tw5864_input *input,
 		frameinterval->denominator = 25;
 		break;
 	default:
-		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
-		     input->std);
+	        dev_warn(&dev->pci->dev, "tw5864_frameinterval_get requested for unknown std %d\n",
+			 input->std);
 		return -EINVAL;
 	}
 
-- 
2.9.0
