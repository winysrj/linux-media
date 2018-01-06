Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:34280 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753763AbeAFBSr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 20:18:47 -0500
Subject: [PATCH 07/18] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, alan@linux.intel.com,
        peterz@infradead.org, netdev@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        torvalds@linux-foundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-media@vger.kernel.org
Date: Fri, 05 Jan 2018 17:10:32 -0800
Message-ID: <151520103240.32271.14706852449205864676.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Static analysis reports that 'index' may be a user controlled value that
is used as a data dependency to read 'pin' from the
'selector->baSourceID' array. In order to avoid potential leaks of
kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid value of 'pin'.

Based on an original patch by Elena Reshetova.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..7442626dc20e 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/compiler.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -810,6 +811,7 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 	struct uvc_entity *iterm = NULL;
 	u32 index = input->index;
 	int pin = 0;
+	__u8 *elem;
 
 	if (selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -820,8 +822,9 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 				break;
 		}
 		pin = iterm->id;
-	} else if (index < selector->bNrInPins) {
-		pin = selector->baSourceID[index];
+	} else if ((elem = nospec_array_ptr(selector->baSourceID, index,
+					selector->bNrInPins))) {
+		pin = *elem;
 		list_for_each_entry(iterm, &chain->entities, chain) {
 			if (!UVC_ENTITY_IS_ITERM(iterm))
 				continue;
