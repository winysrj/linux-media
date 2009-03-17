Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:2317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZCQVHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 17:07:30 -0400
Received: by fg-out-1718.google.com with SMTP id 13so17043fge.17
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 14:07:27 -0700 (PDT)
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] radio-mr800.c: Missing mutex include
Date: Tue, 17 Mar 2009 22:00:18 +0100
Message-Id: <1237323618-6464-1-git-send-email-abogani@texware.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
pulled in indirectly by one of the headers it already includes, the
right thing is to include it directly.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/media/radio/radio-mr800.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index fdfc7bf..4d91148 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -58,6 +58,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
+#include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
-- 
1.6.0.4

