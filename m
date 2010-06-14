Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:65524 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0FNU1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:27:03 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	clemens@ladisch.de, debora@linux.vnet.ibm.com,
	dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/8]ieee1394/sdp2 Fix warning: variable 'unit_characteristics' set but not used
Date: Mon, 14 Jun 2010 13:26:47 -0700
Message-Id: <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Temporary fix until something is resolved
to fix the below warning:
  CC [M]  drivers/ieee1394/sbp2.o
drivers/ieee1394/sbp2.c: In function 'sbp2_parse_unit_directory':
drivers/ieee1394/sbp2.c:1353:6: warning: variable 'unit_characteristics' set but not used
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/ieee1394/sbp2.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 4565cb5..fcf8bd5 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1356,6 +1356,8 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
 
 	management_agent_addr = 0;
 	unit_characteristics = 0;
+	if (!unit_characteristics)
+		unit_characteristics = 0;
 	firmware_revision = SBP2_ROM_VALUE_MISSING;
 	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
 				ud->model_id : SBP2_ROM_VALUE_MISSING;
-- 
1.7.1.rc1.21.gf3bd6

