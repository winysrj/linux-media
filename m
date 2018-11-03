Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53763 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbeKCU16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2018 16:27:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id v24-v6so4038435wmh.3
        for <linux-media@vger.kernel.org>; Sat, 03 Nov 2018 04:16:59 -0700 (PDT)
From: Irenge Jules Bashizi <jbi.octave@gmail.com>
To: linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, julia.lawall@lip6.fr,
        outreachy-kernel@googlegroups.com, jules.octave@outlook.com
Subject: [PATCH] staging:media:Add SPDX-License-Identifier
Date: Sat,  3 Nov 2018 11:16:48 +0000
Message-Id: <20181103111648.30662-1-jbi.octave@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add SPDX-License-Identifier to fix missing license tag checkpatch warning

Signed-off-by: Irenge Jules Bashizi <jbi.octave@gmail.com>
---
 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
index 7cc115c9ebe6..6d2570a63529 100644
--- a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
+++ b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Texas Instruments Inc
  *
@@ -10,9 +11,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
  * Contributors:
  *      Manjunath Hadli <manjunath.hadli@ti.com>
-- 
2.17.2
