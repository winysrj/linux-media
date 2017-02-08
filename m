Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35846 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753604AbdBHMBD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 07:01:03 -0500
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        thaissa.falbo@gmail.com, janani.rvchndrn@gmail.com,
        aryasaatvik@gmail.com, gnudevliz@gmail.com, arnd@arndb.de,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
From: Avraham Shukron <avraham.shukron@gmail.com>
Subject: [PATCH] staging: davinci_vpfe: fix multiline comment style
In-Reply-To: 
Message-ID: <31df68a2-87f4-a7ad-d7c6-2f481b3b6d42@gmail.com>
Date: Wed, 8 Feb 2017 13:52:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>

---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 5fbc2d4..857b0e8 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1133,9 +1133,9 @@ void vpfe_resizer_buffer_isr(struct vpfe_resizer_device *resizer)
                }
        } else if (fid == 0) {
                /*
-               * out of sync. Recover from any hardware out-of-sync.
-               * May loose one frame
-               */
+                * out of sync. Recover from any hardware out-of-sync.
+                * May loose one frame
+                */
                video_out->field_id = fid;
        }
 }
-- 
2.7.4
