Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:64042 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZCCMud (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 07:50:33 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1802484yxm.1
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 04:50:30 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Mar 2009 07:50:30 -0500
Message-ID: <de8cad4d0903030450qf4063f1r9e4e53f5f83f1763@mail.gmail.com>
Subject: Possible omission in v4l2-common.c?
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I was upgrading drivers this morning to capture the latest changes for
the cx18 and I received a merge conflict in v4l2-common.c. In my
system, 1 HDPVR and 3 CX18s. The HDPVR sources are 5 weeks old from
their last sync up but contain:

case V4L2_CID_SHARPNESS:

The newer sources do not, but still have reference to sharpness at
line 420: case V4L2_CID_SHARPNESS:                return "Sharpness";

Because I don't know which way the code is going (is sharpness in or
out) I can't submit a patch, but thought I would raise here. Diff
below was pulled from clean clone of v4l-dvb tree.

Thanks,

Brandon

diff -r 91f9c6c451f7 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Mon Mar 02 09:39:13 2009 -0300
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Mar 03 07:44:58 2009 -0500
@@ -567,6 +567,7 @@
 	case V4L2_CID_CONTRAST:
 	case V4L2_CID_SATURATION:
 	case V4L2_CID_HUE:
+	case V4L2_CID_SHARPNESS:
 	case V4L2_CID_RED_BALANCE:
 	case V4L2_CID_BLUE_BALANCE:
 	case V4L2_CID_GAMMA:
