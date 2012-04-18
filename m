Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60385 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2DREdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 00:33:51 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	<linux-media@vger.kernel.org>
Subject: [PATCH 03/12] drivers: media: dvb: ddbridge: ddbridge-code: Remove unneeded include of version.h
Date: Wed, 18 Apr 2012 01:30:03 -0300
Message-Id: <1334723412-5034-4-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output of "make versioncheck" told us that the file
drivers/media/dvb/ddbridge/ddbridge-code.c has a incorrect include of
version.h:

linux/drivers/media/dvb/ddbridge/ddbridge-core.c: 34 linux/version.h not
needed.

After take a look in the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index d88c4aa..115777e 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -31,7 +31,6 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/i2c.h>
 #include <linux/swab.h>
 #include <linux/vmalloc.h>
-- 
1.7.7.6

