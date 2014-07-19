Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36200 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbaGSAz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:55:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] v4l2-ctl: print SDR FMT buffer size
Date: Sat, 19 Jul 2014 03:55:16 +0300
Message-Id: <1405731316-12337-2-git-send-email-crope@iki.fi>
In-Reply-To: <1405731316-12337-1-git-send-email-crope@iki.fi>
References: <1405731316-12337-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 79930b1..fa44697 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -522,6 +522,7 @@ void printfmt(const struct v4l2_format &vfmt)
 		break;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 		printf("\tSample Format   : %s\n", fcc2s(vfmt.fmt.sdr.pixelformat).c_str());
+		printf("\tBuffer Size     : %u\n", vfmt.fmt.sdr.buffersize);
 		break;
 	}
 }
-- 
1.9.3

