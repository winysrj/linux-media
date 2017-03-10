Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36522 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936709AbdCJNHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:07:37 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 2/2] staging: sh_css_firmware: Remove parentheses from return arguments
Date: Fri, 10 Mar 2017 18:37:24 +0530
Message-Id: <1489151244-20714-3-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489151244-20714-1-git-send-email-singhalsimran0@gmail.com>
References: <1489151244-20714-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sematic patch used for this is:
@@
identifier i;
constant c;
@@
return
- (
    \(i\|-i\|i(...)\|c\)
- )
  ;

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index b294e6d..0d7e8cd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -74,7 +74,7 @@ static struct fw_param *fw_minibuffer;
 
 char *sh_css_get_fw_version(void)
 {
-	return(FW_rel_ver_name);
+	return FW_rel_ver_name;
 }
 
 
-- 
2.7.4
