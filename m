Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2DSAAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 20:00:03 -0400
Received: by pbcun15 with SMTP id un15so9545314pbc.19
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 17:00:02 -0700 (PDT)
Subject: patch "drivers: staging: media: easycap: easycap_ioctl: Include version.h" added to staging tree
To: marcos.souza.org@gmail.com, devel@driverdev.osuosl.org,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
From: <gregkh@linuxfoundation.org>
Date: Wed, 18 Apr 2012 16:59:34 -0700
Message-ID: <13347935741259@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    drivers: staging: media: easycap: easycap_ioctl: Include version.h

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also will be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


>From 365d47a1ea7297c37d1d707c25e3203cd51ebb15 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date: Wed, 18 Apr 2012 01:30:10 -0300
Subject: drivers: staging: media: easycap: easycap_ioctl: Include version.h
 header

The output of "make versioncheck" told us that:

drivers/staging/media/easycap/easycap_ioctl.c: 2442: need
linux/version.h

If we take a look at the code, we will see the macro KERNEL_VERSION be
used. So, we need this include.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-media@vger.kernel.org>
Cc: <devel@driverdev.osuosl.org >
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/easycap/easycap_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/easycap/easycap_ioctl.c b/drivers/staging/media/easycap/easycap_ioctl.c
index 9413b37..3cee3cd 100644
--- a/drivers/staging/media/easycap/easycap_ioctl.c
+++ b/drivers/staging/media/easycap/easycap_ioctl.c
@@ -26,6 +26,7 @@
 /*****************************************************************************/
 
 #include "easycap.h"
+#include <linux/version.h>
 
 /*--------------------------------------------------------------------------*/
 /*
-- 
1.7.10


