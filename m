Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:62829 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdB0Ufp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 15:35:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] tw5864: handle unknown video std gracefully
Date: Mon, 27 Feb 2017 21:32:34 +0100
Message-Id: <20170227203252.3295528-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw5864_frameinterval_get() only initializes its output when it successfully
identifies the video standard in tw5864_input. We get a warning here because
gcc can't always track the state if initialized warnings across a WARN()
macro, and thinks it might get used incorrectly in tw5864_s_parm:

media/pci/tw5864/tw5864-video.c: In function 'tw5864_s_parm':
media/pci/tw5864/tw5864-video.c:816:38: error: 'time_base.numerator' may be used uninitialized in this function [-Werror=maybe-uninitialized]
media/pci/tw5864/tw5864-video.c:819:31: error: 'time_base.denominator' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This particular use happens to be ok, but we do copy the uninitialized
output of tw5864_frameinterval_get() into other memory without checking
the return code, interestingly without getting a warning here.

This initializes the output to 1/1s for the case, to make sure we do
get an intialization that doesn't cause a division-by-zero exception
in case we end up using this uninitialized data later.

This also avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/tw5864/tw5864-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 9421216bb942..a451c2081fde 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -728,6 +728,8 @@ static int tw5864_frameinterval_get(struct tw5864_input *input,
 		frameinterval->denominator = 25;
 		break;
 	default:
+		frameinterval->numerator = 1;
+		frameinterval->denominator = 1;
 		WARN(1, "tw5864_frameinterval_get requested for unknown std %d\n",
 		     input->std);
 		return -EINVAL;
-- 
2.9.0
