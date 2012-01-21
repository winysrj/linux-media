Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4hoZ023673
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/35] [media] az6007: Replace the comments at the beginning of the driver
Date: Sat, 21 Jan 2012 14:04:11 -0200
Message-Id: <1327161877-16784-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-9-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments there is wrong.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 1791cb0..f946b1b 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -1,6 +1,23 @@
-/* DVB USB compliant Linux driver for the AzureWave 6017 USB2.0 DVB-S
- * receiver.
- * see Documentation/dvb/README.dvb-usb for more information
+/*
+ * Driver for AzureWave 6007 DVB-C/T USB2.0 and clones
+ *
+ * Copyright (c) Henry Wang <Henry.wang@AzureWave.com>
+ *
+ * This driver was made publicly available by Terratec, at:
+ *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
+ * The original driver's license is GPL, as declared with MODULE_LICENSE()
+ *
+ *  Driver modifiyed by Mauro Carvalho Chehab <mchehab@redhat.com> in order
+ * 	to work with upstream drxk driver, and to fix some bugs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 #include "drxk.h"
-- 
1.7.8

