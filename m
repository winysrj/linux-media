Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2DSAAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 20:00:09 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so9545314pbc.19
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 17:00:09 -0700 (PDT)
Subject: patch "drivers: staging: media: as102: as102_usb_drv.h: Remove include of" added to staging tree
To: marcos.souza.org@gmail.com, devel@driverdev.osuosl.org,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
From: <gregkh@linuxfoundation.org>
Date: Wed, 18 Apr 2012 16:59:35 -0700
Message-ID: <13347935753591@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    drivers: staging: media: as102: as102_usb_drv.h: Remove include of

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also will be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


>From 72b9b8c847c3590172a8caa718582370f8925137 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date: Wed, 18 Apr 2012 01:30:09 -0300
Subject: drivers: staging: media: as102: as102_usb_drv.h: Remove include of
 version.h

The output of "make versioncheck" told us that:

drivers/staging/media/as102/as102_usb_drv.h: 20 linux/version.h not
needed.

If we take a look at the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-media@vger.kernel.org>
Cc: <devel@driverdev.osuosl.org >
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/as102/as102_usb_drv.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
index fc2884a..1ad1ec5 100644
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ b/drivers/staging/media/as102/as102_usb_drv.h
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include <linux/version.h>
-
 #ifndef _AS102_USB_DRV_H_
 #define _AS102_USB_DRV_H_
 
-- 
1.7.10


