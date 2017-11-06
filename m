Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:48132 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752914AbdKFXhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 18:37:50 -0500
Subject: [PATCH 2/3] atomisp: fix vfree of bogus data on unload
From: Alan <alan@linux.intel.com>
To: vincent.hervieux@gmail.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org
Date: Mon, 06 Nov 2017 23:36:45 +0000
Message-ID: <151001140261.77201.8823780763771880199.stgit@alans-desktop>
In-Reply-To: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
References: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We load the firmware once, set pointers to it and then at some point release
it. We should not be doing a vfree() on the pointers into the firmware.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 8158ea40d069..f181bd8fcee2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -288,8 +288,6 @@ void sh_css_unload_firmware(void)
 		for (i = 0; i < sh_css_num_binaries; i++) {
 			if (fw_minibuffer[i].name)
 				kfree((void *)fw_minibuffer[i].name);
-			if (fw_minibuffer[i].buffer)
-				vfree((void *)fw_minibuffer[i].buffer);
 		}
 		kfree(fw_minibuffer);
 		fw_minibuffer = NULL;
