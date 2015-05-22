Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55984 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757206AbbEVOAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/11] cobalt: fix sparse warnings
Date: Fri, 22 May 2015 15:59:39 +0200
Message-Id: <1432303184-8594-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cobalt/cobalt-flash.c:101:5: warning: symbol 'cobalt_flash_probe' was not declared. Should it be static?
drivers/media/pci/cobalt/cobalt-flash.c:126:6: warning: symbol 'cobalt_flash_remove' was not declared. Should it be static?
drivers/media/pci/cobalt/cobalt-cpld.c:101:6: warning: symbol 'cobalt_cpld_status' was not declared. Should it be static?
drivers/media/pci/cobalt/cobalt-cpld.c:240:6: warning: symbol 'cobalt_cpld_set_freq' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-cpld.c  | 2 +-
 drivers/media/pci/cobalt/cobalt-flash.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
index 05df458..5a28d9b2 100644
--- a/drivers/media/pci/cobalt/cobalt-cpld.c
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -20,7 +20,7 @@
 
 #include <linux/delay.h>
 
-#include "cobalt-driver.h"
+#include "cobalt-cpld.h"
 
 #define ADRS(offset) (COBALT_BUS_CPLD_BASE + offset)
 
diff --git a/drivers/media/pci/cobalt/cobalt-flash.c b/drivers/media/pci/cobalt/cobalt-flash.c
index 89fd667..04dcaf9 100644
--- a/drivers/media/pci/cobalt/cobalt-flash.c
+++ b/drivers/media/pci/cobalt/cobalt-flash.c
@@ -23,7 +23,7 @@
 #include <linux/mtd/cfi.h>
 #include <linux/time.h>
 
-#include "cobalt-driver.h"
+#include "cobalt-flash.h"
 
 #define ADRS(offset) (COBALT_BUS_FLASH_BASE + offset)
 
-- 
2.1.4

