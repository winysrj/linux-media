Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48516 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1KQKov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:51 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAimPK023967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:50 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 14/15] davinci: vpfe: delete vpfe_types.h
Date: Thu, 17 Nov 2011 16:14:40 +0530
Message-ID: <1321526681-22574-15-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

delete vpfe_types.h as it is no longer used.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 include/media/davinci/vpfe_types.h |   51 ------------------------------------
 1 files changed, 0 insertions(+), 51 deletions(-)
 delete mode 100644 include/media/davinci/vpfe_types.h

diff --git a/include/media/davinci/vpfe_types.h b/include/media/davinci/vpfe_types.h
deleted file mode 100644
index 76fb74b..0000000
--- a/include/media/davinci/vpfe_types.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright (C) 2008-2009 Texas Instruments Inc
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option)any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-#ifndef _VPFE_TYPES_H
-#define _VPFE_TYPES_H
-
-#ifdef __KERNEL__
-
-enum vpfe_pin_pol {
-	VPFE_PINPOL_POSITIVE,
-	VPFE_PINPOL_NEGATIVE
-};
-
-enum vpfe_hw_if_type {
-	/* BT656 - 8 bit */
-	VPFE_BT656,
-	/* BT1120 - 16 bit */
-	VPFE_BT1120,
-	/* Raw Bayer */
-	VPFE_RAW_BAYER,
-	/* YCbCr - 8 bit with external sync */
-	VPFE_YCBCR_SYNC_8,
-	/* YCbCr - 16 bit with external sync */
-	VPFE_YCBCR_SYNC_16,
-	/* BT656 - 10 bit */
-	VPFE_BT656_10BIT
-};
-
-/* interface description */
-struct vpfe_hw_if_param {
-	enum vpfe_hw_if_type if_type;
-	enum vpfe_pin_pol hdpol;
-	enum vpfe_pin_pol vdpol;
-};
-
-#endif
-#endif
-- 
1.6.2.4

