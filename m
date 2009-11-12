Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34931 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZKLNYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 08:24:48 -0500
Received: by pzk1 with SMTP id 1so529015pzk.33
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 05:24:54 -0800 (PST)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] V4L/DVB: pt1: remove duplicated #include
Date: Thu, 12 Nov 2009 21:16:09 +0800
Message-Id: <1258031769-2700-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove duplicated #include('s) in
  drivers/media/dvb/pt1/pt1.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/dvb/pt1/pt1.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index 1fd8306..81e623a 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <linux/vmalloc.h>
 
 #include "dvbdev.h"
 #include "dvb_demux.h"
-- 
1.6.1.3

