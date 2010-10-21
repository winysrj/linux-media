Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:28848 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0JUHw7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 03:52:59 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH] v4l-utils: Add support for new RDS CAP bits.
Date: Thu, 21 Oct 2010 10:52:41 +0300
Message-Id: <1287647561-28386-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for V4L2_TUNER_CAP_RDS_BLOCK_IO and
V4L2_TUNER_CAP_RDS_CONTROLS tuner/modulator capability
bits.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 utils/v4l2-ctl/v4l2-ctl.cpp |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index ab9a7d1..bd971dc 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1266,6 +1266,10 @@ static std::string tcap2s(unsigned cap)
 		s += "lang2 ";
 	if (cap & V4L2_TUNER_CAP_RDS)
 		s += "rds ";
+	if (cap & V4L2_TUNER_CAP_RDS_BLOCK_IO)
+		s += "rds-block-io ";
+	if (cap & V4L2_TUNER_CAP_RDS_CONTROLS)
+		s += "rds-controls ";
 	return s;
 }
 
-- 
1.6.1.3

