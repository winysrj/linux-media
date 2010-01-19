Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57214 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0ASWnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 17:43:53 -0500
Received: by gxk9 with SMTP id 9so5577230gxk.8
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 14:43:53 -0800 (PST)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] V4L/DVB: [Mantis] remove duplicated #include
Date: Wed, 20 Jan 2010 06:43:44 +0800
Message-Id: <1263941024-880-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove duplicated #include('s) in
  drivers/media/dvb/mantis/mantis_hif.c
  drivers/media/dvb/mantis/mantis_pci.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/dvb/mantis/mantis_hif.c |    2 --
 drivers/media/dvb/mantis/mantis_pci.c |    5 -----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_hif.c b/drivers/media/dvb/mantis/mantis_hif.c
index 7477dac..5772ebb 100644
--- a/drivers/media/dvb/mantis/mantis_hif.c
+++ b/drivers/media/dvb/mantis/mantis_hif.c
@@ -22,8 +22,6 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 
-#include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 #include "dmxdev.h"
diff --git a/drivers/media/dvb/mantis/mantis_pci.c b/drivers/media/dvb/mantis/mantis_pci.c
index 6c7534a..59feeb8 100644
--- a/drivers/media/dvb/mantis/mantis_pci.c
+++ b/drivers/media/dvb/mantis/mantis_pci.c
@@ -41,11 +41,6 @@
 #include "dvb_frontend.h"
 #include "dvb_net.h"
 
-#include <asm/irq.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-
 #include "mantis_common.h"
 #include "mantis_reg.h"
 #include "mantis_pci.h"
-- 
1.6.1.3

