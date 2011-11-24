Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3321 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1KXMsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 07:48:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: ir-sanyo-decoder.c doesn't compile
Date: Thu, 24 Nov 2011 13:47:51 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111241347.51635.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I get this error when compiling for_v3.3:

drivers/media/rc/ir-sanyo-decoder.c:201:16: error: expected declaration specifiers or ‘...’ before string constant
drivers/media/rc/ir-sanyo-decoder.c:202:15: error: expected declaration specifiers or ‘...’ before string constant
drivers/media/rc/ir-sanyo-decoder.c:203:15: error: expected declaration specifiers or ‘...’ before string constant
drivers/media/rc/ir-sanyo-decoder.c:204:20: error: expected declaration specifiers or ‘...’ before string constant

There is a include <linux/module.h> missing.

This patch fixes this:

diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 1646730..d38fbdd 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -21,6 +21,7 @@
  * Information for this protocol is available at the Sanyo LC7461 datasheet.
  */
 
+#include <linux/module.h>
 #include <linux/bitrev.h>
 #include "rc-core-priv.h"
 
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
